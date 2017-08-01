//
//  WYLinkVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/24.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYLinkVC.h"
#import "WYLinkCell.h"
#import "WYModelGuanLianCheWei.h"
#import "wyAddTimeAndPriceVC.h"
#import "RelateViewController.h"

#import "PresentLocationViewController.h"
#import "wyParkInfoSettingVC.h"
//高德地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface WYLinkVC ()<UITableViewDelegate , UITableViewDataSource,AMapLocationManagerDelegate,UIViewPassValueDelegate>
{
 // CLLocationCoordinate2D *selectcenter;
}
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (strong , nonatomic) NSMutableArray *dataSource;
@property (strong , nonatomic) CLLocation *location;
//@property (strong , nonatomic) CLLocationCoordinate2D *selectcenter;
@property (copy , nonatomic) NSString *lat;
@property (copy , nonatomic) NSString *lnt;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation WYLinkVC

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault]; //设置为白色
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak typeof(self) weakSelf = self;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"关联停车场";
    
    [self fetchDataWithCoordinate:self.location];
    @weakify(self);
    self.tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        
        [self fetchDataWithCoordinate:self.location];
    }];
    
    
    //[self configAMap];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)passValuelat:(NSString*)lat passValuelnt:(NSString*)lnt{

    self.lat = lat;
    self.lnt = lnt;
    NSLog(@"get center!!");

}
- (void)fetchDataWithCoordinate:(CLLocation *)location{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parkspot/lotadmins", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:[NSString stringWithFormat:@"%@",self.lat] forKey:@"lat"];
    [paramsDict setObject:[NSString stringWithFormat:@"%@",self.lnt]  forKey:@"lnt"];
    //[paramsDict setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"lat"];
    //[paramsDict setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude]  forKey:@"lnt"];
    [paramsDict setObject:@"1" forKey:@"page"];
    [paramsDict setObject:@"10000" forKey:@"limit"];
//    token	是	string	用户名凭证
//    lat	是	string	经纬度
//    lnt	否	string	经纬度
//    limit	否	string	个数
//    page	否	string	页数
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [self.tbView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
           
            self.dataSource = [WYModelGuanLianCheWei mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            [self.tbView reloadData];
            
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
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
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
    WYLinkCell *cell = [WYLinkCell cellWithTableView:tableView indexPath:indexPath];
    
    if (self.dataSource.count > indexPath.row) {
        [cell renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
    }
    @weakify(self);
    cell.block = ^(WYModelGuanLianCheWei *model){
        @strongify(self);
        self.push.parklot_id = model.parklot_id;
        wyAddTimeAndPriceVC *vc = wyAddTimeAndPriceVC.new;
        vc.push = self.push;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
    
}

#pragma mark - 以上都不是
- (IBAction)btnYiShangDouBUShiClick:(id)sender {
//    NSArray<UIViewController *> *arr = self.navigationController.childViewControllers.copy;
//    @weakify(self);
//    [arr enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        @strongify(self);
//        if ([obj isKindOfClass:NSClassFromString(@"wyParkInfoSettingVC")]) {
//    
//            [Utils setNavigationControllerPopWithAnimation:self timingFunction:KYNaviAnimationTimingFunctionEaseInEaseOut type:KYNaviAnimationTypeRipple subType:KYNaviAnimationDirectionFromLeft duration:0.38 target:obj];
//        }
//    }];
    RelateViewController *vc = RelateViewController.new;
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
        WYLog(@"关联停车场-WYLinkVC");
    }];
    
    
}



@end
