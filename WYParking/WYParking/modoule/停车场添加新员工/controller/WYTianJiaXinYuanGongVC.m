//
//  WYTianJiaXinYuanGongVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/23.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYTianJiaXinYuanGongVC.h"
#import "WYTianJiaYuanGongCell.h"
#import "WYSearchModel.h"

//高德地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

typedef void(^tianJiaSuccess)(BOOL isSuccess);

@interface WYTianJiaXinYuanGongVC ()<UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (strong , nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITextField *TFUserName;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (strong , nonatomic) CLLocation *location;
@end

@implementation WYTianJiaXinYuanGongVC

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchView.layer.cornerRadius = 20.0f;
    self.searchView.layer.masksToBounds = YES;
    self.searchView.layer.borderColor = RGBACOLOR(241, 242, 243, 1.0).CGColor;
    self.searchView.layer.borderWidth = 1;
    [self configAMap];

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
    WYTianJiaYuanGongCell *cell = [WYTianJiaYuanGongCell cellWithTableView:tableView indexPath:indexPath];
    [cell.btnAddWorker addTarget:self action:@selector(btnAddWorkerClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnAddWorker.tag = indexPath.row;
    if (self.dataSource.count > indexPath.row) {
    [cell renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)btnAddWorkerClick:(UIButton *)sender{
    WYSearchModel *m = [self.dataSource objectAtIndex:sender.tag];
    @weakify(self);
    [self addWorkerWithUserId:m.user_id withSuccess:^(BOOL isSuccess) {
        if (isSuccess) {
            @strongify(self);
            [self.view makeToast:@"添加成功"];
        }
    }];
}


- (void)addWorkerWithUserId:(NSString *)userID withSuccess:(tianJiaSuccess)successblock{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parklot/staffadd", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:userID forKey:@"user_id"];
    [paramsDict setObject:self.parklot_id forKey:@"parklot_id"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            successblock(YES);
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
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
    
}


/**
 搜索 刷接口

 @param sender
 */
- (IBAction)btnCancelClick:(id)sender {
    
    if ([self.TFUserName.text isEqualToString:@""]) {
        [self.dataSource removeAllObjects];
        [self.tbView reloadData];
        return;
    }
    
    [self requestWithText:self.TFUserName.text];
}

#pragma mark - 查找
- (void)requestWithText:(NSString *)str{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parklot/searchemployeelist", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
//    token	是	string	用户凭证
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];

//    page	是	int	页数 默认1
    [paramsDict setObject:@"1" forKey:@"page"];
//    limit	是	int	限制 默认10
//    username	是	int	传来的用户名
        [paramsDict setObject:@"10" forKey:@"limit"];
    [paramsDict setObject:str forKey:@"phone"];
     [paramsDict setObject:[NSString stringWithFormat:@"%f",_location.coordinate.latitude] forKey:@"lat"];
     [paramsDict setObject:[NSString stringWithFormat:@"%f",_location.coordinate.longitude] forKey:@"lnt"];

    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.tbView animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            self.dataSource = [WYSearchModel mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            if (self.dataSource.count == 0) {
                [MBProgressHUD showMessage:@"暂没找到该员工"];
            }
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
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.tbView animated:YES];
        
    }];
}


/**
 dismiss vc

 @param sender 
 */
- (IBAction)btnGuanBiClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

#pragma mark - 初始化地图
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
        
        NSString * c =regeocode.city;
        if ([c isEqualToString:@""]||!c) {
            c = regeocode.province;
        }
//        [self requestWithText:@""];
        WYLog(@"adfas");
        WYLog(@"添加新员工");
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
