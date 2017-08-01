//
//  WYFuJInDeRenVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/22.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYFuJInDeRenVC.h"
#import "WYFuJinCheYOuCell.h"
#import "wyModelNearUser.h"
#import "WYSiLiaoVCViewController.h"
#import "WYUserDetailinfoVC.h"

//高德地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface WYFuJInDeRenVC ()<UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (strong , nonatomic) NSMutableArray *dataSource;
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (strong , nonatomic) CLLocation *location;

@property (assign , nonatomic) NSInteger pageIndex;

@end

@implementation WYFuJInDeRenVC

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 1;
    // Do any additional setup after loading the view from its nib.
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    self.title = @"附近的人";
    @weakify(self);
    self.tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
         [self fetchFuJinHaoYouWithCoordinate:self.location];
    }];
    [self configAMap];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault]; //设置为白色
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak typeof(self) weakSelf = self;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - 附近好友
- (void)fetchFuJinHaoYouWithCoordinate:(CLLocation *)location{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@index/nears", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"lat"];
    [paramsDict setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude]  forKey:@"lnt"];
    [paramsDict setObject:[NSString stringWithFormat:@"%d",self.pageIndex]   forKey:@"page"];
    [paramsDict setObject:@"1000"  forKey:@"limit"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [self.tbView.mj_header endRefreshing];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            self.dataSource = [wyModelNearUser mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            NSIndexSet *indexset = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, 1)];
            [self.tbView reloadSections:indexset withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            [keyWindow makeToast:paramsDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [self.tbView.mj_header endRefreshing];
        [keyWindow makeToast:@"请检查网络"];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYFuJinCheYOuCell *cell = [WYFuJinCheYOuCell cellWithTableView:tableView indexPath:indexPath];
    cell.btnSendMsg.tag = indexPath.row;
    [cell.btnSendMsg addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.dataSource.count > indexPath.row) {
        [cell renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)btnClick:(UIButton *)sender{
    NSInteger index = sender.tag;
    wyModelNearUser *m = [self.dataSource objectAtIndex:index];
    WYSiLiaoVCViewController *vc = [[WYSiLiaoVCViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:m.user_id];
    vc.title = m.username;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WYUserDetailinfoVC *vc = WYUserDetailinfoVC.new;
    wyModelNearUser *user = [_dataSource objectAtIndex:indexPath.row];
    vc.user_id = user.user_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configAMap{
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    @weakify(self);
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self);
        self.location = location;
        [self.tbView.mj_header beginRefreshing];
        WYLog(@"adfas");
        WYLog(@"附近的人-FuJinDeRenVC");
    }];
    
       
}

@end
