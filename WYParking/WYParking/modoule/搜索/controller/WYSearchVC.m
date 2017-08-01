//
//  WYSearchVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/10.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYSearchVC.h"
#import "WYSearchBtn.h"
#import "WYSearchTop.h"
#import "wyFuJinCheWei.h"
#import "wyModelHistory.h"

//高德地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface WYSearchVC ()<AMapLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>{
          NSString *city;//某个城市
    BOOL isClickBackGround;//为解决点击背景，tableview显示出了
}

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UITableView *tbViewHistory;
@property (nonatomic, strong) AMapLocationReGeocode *regecode;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;

@property (weak , nonatomic)  WYSearchTop *searchBtn1;

@property (strong , nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tbSearch;

@property (nonatomic, strong) AMapSearchAPI *search;//搜索对象

@property (nonatomic, strong) NSMutableArray *tips;//搜索的数据源

@end

@implementation WYSearchVC

#pragma mark - lazy
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)tips{
    if (_tips == nil) {
        _tips = [NSMutableArray array];
    }
    return _tips;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tbSearch.delegate = self;
    self.tbSearch.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
      self.search=[[AMapSearchAPI alloc]init];//初始化搜索对象
    self.search.delegate=self;
    [self setNavigationBarRightView];//导航栏右边view
    [self configAMap];//初始化高德，请求地址
    self.tbViewHistory.delegate = self;
    self.tbViewHistory.backgroundColor = [UIColor clearColor];
    self.tbViewHistory.dataSource = self;
    self.tbViewHistory.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbViewHistory reloadData];
    //[self requestHistory];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tbSearch.hidden = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    if (self.isFormHome) {
        // 导航栏的显示
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jbbg"] forBarMetrics:UIBarMetricsDefault];
        // 左边的返回按钮
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"tc_gb"] style:UIBarButtonItemStylePlain handler:^(id sender) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        [self.rdv_tabBarController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jbbg"] forBarMetrics:UIBarMetricsDefault];
        self.rdv_tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"tc_gb"] style:UIBarButtonItemStylePlain handler:^(id sender) {
            self.rdv_tabBarController.selectedIndex = 0;
            
        }];
        if (self.rdv_tabBarController.navigationItem.rightBarButtonItem == nil) {
            [self setNavigationBarRightView];
        }
        [self requestHistory];
        [self requestForAddress];
    }
    @weakify(self);
    [[[self.searchBtn1.TFAddress.rac_textSignal distinctUntilChanged] skip:1] subscribeNext:^(NSString * x) {
        @strongify(self);
        if (x.length > 0) {
            if (!isClickBackGround) {
                self.tbSearch.hidden = NO;
                [self searchActionWithText:x];
            }
            isClickBackGround = NO;
            
        }else{
            self.tbSearch.hidden = YES;
        }
        WYLog(@"%@",x);
    }];
    self.tbViewHistory.showsVerticalScrollIndicator = NO;
    self.tbViewHistory.scrollEnabled = NO;
}



- (void)viewWillDisappear:(BOOL)animated{
    if (!self.isFormHome) {
        self.rdv_tabBarController.navigationItem.leftBarButtonItem = nil;
        self.rdv_tabBarController.navigationItem.rightBarButtonItem = nil;
        [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    }
    self.tbSearch.hidden = YES;
}


- (void)requestHistory{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@index/historyrecord", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    if([wyLogInCenter shareInstance].loginstate == wyLogInStateSuccess){
        [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    }
    [paramsDict setObject:@"1" forKey:@"page"];
    [paramsDict setObject:@"5" forKey:@"limit"];
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            self.dataSource = [wyModelHistory mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            [self.tbViewHistory reloadData];
        }
        else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            [self.view makeToast:paramsDict[@"msg"]];
        }
        
    } failuer:^(NSError *error) {
        
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    

}

//请求地址
- (void)requestForAddress{
    [self.searchBtn1.TFAddress becomeFirstResponder];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        self.regecode = regeocode;
        self.searchBtn1.TFAddress.text = [NSString stringWithFormat:@"%@",regeocode.street];
        self.labAddress.text = [NSString stringWithFormat:@"%@%@%@",[self toCity],self.regecode.district,self.regecode.street];
        WYLog(@"搜索");
        [self.searchBtn1.TFAddress becomeFirstResponder];
        city=regeocode.city;
        if ([city isEqualToString:@""]||!city) {
            city = regeocode.province;
        }
    }];
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
    
    if (self.isFormHome) {
        [self requestHistory];
        [self requestForAddress];
        
    }
    
}

- (NSString *)toCity{
    NSString *city1=self.regecode.city;
    if ([city1 isEqualToString:@""]||!city1) {
        city1 = self.regecode.province;
    }
    return city1;

}


- (void)setNavigationBarRightView{
    UIView *rightView = UIView.new;
    //搜索地址View
    WYSearchTop *rightSearchView = WYSearchTop.new;
    rightSearchView.backgroundColor = RGBACOLOR(1, 107, 201, 1);
    [rightView addSubview:rightSearchView];
    [rightSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.height.mas_equalTo(38);
        make.right.mas_equalTo(-10);
    }];
    self.searchBtn1 = rightSearchView;
    rightView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    CGSize s = [rightView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    rightView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 60, s.height);
    if (self.isFormHome) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    }else{
        self.rdv_tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [self cleanUpAction];
    
}
- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return self.dataSource.count;
    }else if(tableView.tag == 101){
        return self.tips.count;
    }else{
        return 0;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag  == 100) {
        //历史纪录
        NSString *ReuseID = @"wysearchHistoryCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseID];
        if (cell == nil) {
            cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataSource.count > indexPath.row) {
            wyModelHistory *m = [_dataSource objectAtIndex:indexPath.row];
            cell.textLabel.text = m.address;
        }
        return cell;
    }else{
        NSString *ReuseID = @"searchCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseID];
        if (cell == nil) {
            cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.tips.count > indexPath.row) {
            AMapTip *obj = [self.tips objectAtIndex:indexPath.row];
            cell.textLabel.text = obj.name;
        }
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


#pragma mark - 搜索高德
- (void)searchActionWithText:(NSString *)text{
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = text;
    tips.city     = city?city:@"北京";
    [self.search AMapInputTipsSearch:tips];
}

#pragma mark - 输入提示回调

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    //上面搜索框调用的poi
    [self.tips setArray:response.tips];
    [self.tbSearch reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 101) {
        wyFuJinCheWei *vc = wyFuJinCheWei.new;
        vc.tip = [self.tips objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [vc RenderWithIsSearch:YES withAddress:cell.textLabel.text];
        vc.tip = [self.tips objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc  animated:YES];
    }else if(tableView.tag == 100){
        wyFuJinCheWei *vc = wyFuJinCheWei.new;
        vc.history = [self.dataSource objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc  animated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBtn1.TFAddress resignFirstResponder];
}
//当前位置 跳转
- (IBAction)btnCurrentClick:(id)sender {
    wyFuJinCheWei *vc = wyFuJinCheWei.new;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
