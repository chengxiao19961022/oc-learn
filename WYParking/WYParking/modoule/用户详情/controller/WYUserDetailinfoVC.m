//
//  WYUserDetailinfoVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/22.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYNavigationController.h"
#import "wyTabBarController.h"
#import "WYUserDetailinfoVC.h"
#import "WYYongHuCheWeiCell.h"
#import "WYGuanZhuCell.h"
#import "WYCarDetaiInfo.h"//车位详情
#import "WYModelCheWei.h"
#import "wyModelNearUser.h"
#import "wyModelGuanZhu.h"
//#import "SiLiaoViewController.h"
#import "WYSiLiaoVCViewController.h"

//友盟
#import "UMMobClick/MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//高德地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface WYUserDetailinfoVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AMapLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *line;

@property (strong , nonatomic) NSMutableArray *dataSource;//车位数据源
@property (strong , nonatomic) NSMutableArray *dataSourceGuanZhu;//关注数据源


@property (weak, nonatomic) IBOutlet UIButton *btnGuanZhu;
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (weak, nonatomic) IBOutlet UIButton *btnCheWei;
@property (weak, nonatomic) IBOutlet UIButton *btnGuanZhuTaDe;
@property (weak, nonatomic) IBOutlet UIButton *btnTaGuanZhuDe;
@property (weak, nonatomic)  UICollectionView *collectionView;
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (assign , nonatomic) CGFloat itemW;
@property (strong , nonatomic) CLLocation *location;

@property (strong , nonatomic) wyModelNearUser *infoModel;
@property (weak, nonatomic) IBOutlet UILabel *labUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSex;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewChePai;

//头部信息
@property (weak, nonatomic) IBOutlet UIButton *imageViewUserLogo;

@end

@implementation WYUserDetailinfoVC

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)dataSourceGuanZhu{
    if (_dataSourceGuanZhu == nil) {
        _dataSourceGuanZhu = [NSMutableArray array];
    }
    return _dataSourceGuanZhu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imageViewUserLogo.layer.cornerRadius = 35.0f;
    self.imageViewUserLogo.layer.masksToBounds = YES;
    self.tbView.dataSource = self;
    self.tbView.delegate = self;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    __weak typeof(WYUserDetailinfoVC *) weakSelf = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        if (weakSelf.isPresent) {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                ;
            }];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];

    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.alpha = 0;
    }];
    [self configCollectionView];
    [self configAMap];
    
    @weakify(self);
    [self.btnGuanZhu bk_addEventHandler:^(id sender) {
        if ([wyLogInCenter shareInstance].loginstate == wyLogInStateNotLogin) {
            //        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            //        [keyWindow makeToast:@"您还未登录，即将跳转到登录页面！"];
            [NSThread sleepForTimeInterval:1];
            NSArray *isfromgrzx = @[@"4", self.user_id];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToAPP" object:isfromgrzx];
            return;
        }
        @strongify(self);
        if (self.infoModel != nil) {
            if ([_btnGuanZhu.titleLabel.text isEqualToString:@"关注TA"]) {
                //未关注
                [self guanZhuAction];
            }else{
                //取消关注
                [self quxiaoGuanZhu];
            }
        }
    } forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 取消关注
- (void)quxiaoGuanZhu{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@friend/del", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:self.infoModel.user_id forKey:@"fid"];
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            [self.btnGuanZhu setTitle:@"关注TA" forState:UIControlStateNormal];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

#pragma mark - 关注
- (void)guanZhuAction{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@friend/add", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:self.infoModel.user_id forKey:@"fid"];
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            [self.btnGuanZhu setTitle:@"取消关注" forState:UIControlStateNormal];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

- (void)configCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, kScreenHeight - 220 - 45) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.collectionViewLayout = flowLayout;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WYGuanZhuCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WYGuanZhuCell class])];
    self.collectionView = collectionView;
    [self.collectionView reloadData];
    self.itemW = kScreenWidth / 4.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.alpha = 1.0;
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.alpha = 0;
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.alpha = 1;
    }];
}


#pragma mark - UITablViewDelegate UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYYongHuCheWeiCell *cell = [WYYongHuCheWeiCell cellWithTableView:tableView indexPath:indexPath];
    
    if (self.dataSource.count > indexPath.row) {
        [cell renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WYCarDetaiInfo *vc = WYCarDetaiInfo.new;
    WYModelCheWei *m = [self.dataSource objectAtIndex:indexPath.row];
    vc.park_id = m.park_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    wyModelGuanZhu *m = [self.dataSourceGuanZhu objectAtIndex:indexPath.row];
    self.user_id = m.user_id;
    self.line.centerX = self.btnCheWei.centerX;
    [self fetchCheWeiData];
    self.tbView.tableHeaderView = nil;
    self.tbView.tableFooterView = nil;
    [self.tbView reloadData];
}

#pragma mark - 车位
- (IBAction)btnCheWeiClick:(id)sender {
     self.line.centerX = self.btnCheWei.centerX;
    [self fetchCheWeiData];
    self.tbView.tableHeaderView = nil;
    self.tbView.tableFooterView = nil;
    [self.tbView reloadData];
}

#pragma mark - 车关注TA的
- (IBAction)btnGuanZhuTaDeClick:(id)sender {
    self.line.centerX = self.btnGuanZhuTaDe.centerX;
//    UIView *header = UIView.new;
    self.tbView.tableHeaderView = nil;
    self.tbView.tableFooterView = nil;
    if (self.collectionView == nil) {
        [self configCollectionView];
        self.tbView.tableHeaderView = self.collectionView;
    }else{
        self.tbView.tableHeaderView = self.collectionView;
        
    }
    [self.collectionView reloadData];
    [self fetchGuanZhuTaDe];
    [self.dataSource removeAllObjects];
    [self.tbView reloadData];
}

#pragma mark - 车TA关注的
- (IBAction)btnTaGuanZhuDe:(id)sender {
    self.line.centerX = self.btnTaGuanZhuDe.centerX;
    self.tbView.tableHeaderView = nil;
    self.tbView.tableFooterView = nil;
    [self.collectionView reloadData];
    if (self.collectionView == nil) {
        [self configCollectionView];
         self.tbView.tableHeaderView = self.collectionView;
    }else{
        self.tbView.tableHeaderView = self.collectionView;
    }
    [self.collectionView reloadData];
    [self.dataSource removeAllObjects];
    [self fetchTaGuanZhuDe];
    [self.tbView reloadData];
}


- (IBAction)back:(id)sender {
    __weak typeof(WYUserDetailinfoVC *) weakSelf = self;
    if (weakSelf.from_mdl) {
        wyTabBarController *rootVC = [[wyTabBarController alloc] init];
        //                WYNavigationController *nav = [[WYNavigationController alloc] initWithRootViewController:rootVC];
        //                [self changeRootController:nav animated:YES];
        
//        [self.navigationController pushViewController:rootVC animated:YES];
//        return;
        AppDelegate *app = KappDelegate;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
        app.window.rootViewController = nav;
    }else{
        if (weakSelf.isPresent) {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                ;
            }];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeRootController:(UIViewController *)controller animated:(BOOL)animated{
    CGFloat duration = 0.5;
    CATransition *transition = [CATransition animation];
    transition.duration = animated?duration:0;
    transition.type = kCATransitionFade;
    [[UIApplication sharedApplication].windows lastObject].rootViewController = controller;
    [[[UIApplication sharedApplication].windows lastObject].layer addAnimation:transition forKey:@"rootViewControllerAnimation"];
}

#pragma mark - collectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataSourceGuanZhu.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}





- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WYGuanZhuCell *cell = [WYGuanZhuCell cellWithCollectionView:collectionView indexPath:indexPath];
    if (self.dataSourceGuanZhu.count > indexPath.row) {
    [cell renderViewWithModel:[self.dataSourceGuanZhu objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(self.itemW, 100);
    return size;
}

#pragma mark - 车位数据
- (void)fetchCheWeiData{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parkspot/heparklists", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tbView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中";
    if ([wyLogInCenter shareInstance].loginstate == wyLogInStateSuccess) {
        [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    }
    [paramsDict setObject:self.user_id  forKey:@"user_id"];
    [paramsDict setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.latitude]  forKey:@"lat" ];
    [paramsDict setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.longitude]  forKey:@"lnt" ];
    [paramsDict setObject:@"1"  forKey:@"page"];
    [paramsDict setObject:@"1000"  forKey:@"limit"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [MBProgressHUD hideHUDForView:self.tbView animated:YES];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSDictionary *dic = paramsDict[@"data"];
           
            self.dataSource = [WYModelCheWei mj_objectArrayWithKeyValuesArray:dic[@"park"]];
            if (self.dataSource.count == 0) {
                [self.view makeToast:@"暂无车位数据"];
            }
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
            [self.tbView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
            self.infoModel = [wyModelNearUser mj_objectWithKeyValues:dic[@"info"]];
            [self renderViewWithModel:self.infoModel];
            if ([self.infoModel.Friend isEqualToString:@"1"]) {
                [self.btnGuanZhu setTitle:@"关注TA" forState:UIControlStateNormal];
            }else{
                [self.btnGuanZhu setTitle:@"取消关注" forState:UIControlStateNormal];
            }
            WYLog(@"as");
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
        [MBProgressHUD hideHUDForView:self.tbView animated:YES];
        [keyWindow makeToast:@"请检查网络"];
    }];
}



#pragma mark - 关注TA的
- (void)fetchGuanZhuTaDe{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@friend/othernotice", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中";
    if ([wyLogInCenter shareInstance].loginstate == wyLogInStateSuccess) {
        [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    }
    [paramsDict setObject:@"2"  forKey:@"type"];
    [paramsDict setObject:self.user_id  forKey:@"user_id"];
    [paramsDict setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.latitude] forKey:@"lat"  ];
    [paramsDict setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.longitude]  forKey:@"lnt" ];
    [paramsDict setObject:@"1"  forKey:@"page"];
    [paramsDict setObject:@"1000"  forKey:@"limit"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            self.dataSourceGuanZhu = [wyModelGuanZhu mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            [self.collectionView reloadData];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [keyWindow makeToast:@"请检查网络"];
    }];
}
#pragma mark - TA关注的
- (void)fetchTaGuanZhuDe{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@friend/othernotice", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中";
    if ([wyLogInCenter shareInstance].loginstate == wyLogInStateSuccess) {
        [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    }
    [paramsDict setObject:@"1"  forKey:@"type"];
    [paramsDict setObject:self.user_id  forKey:@"user_id"];
    [paramsDict setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.latitude] forKey:@"lat"  ];
    [paramsDict setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.longitude]  forKey:@"lnt" ];
    [paramsDict setObject:@"1"  forKey:@"page"];
    [paramsDict setObject:@"1000"  forKey:@"limit"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            self.dataSourceGuanZhu = [wyModelGuanZhu mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            [self.collectionView reloadData];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [keyWindow makeToast:@"请检查网络"];
    }];
}

#pragma mark - 头部数据
- (void)renderViewWithModel:(wyModelNearUser *)m{
    self.labUserName.text = m.username;
    [self.imageViewUserLogo setBackgroundImageWithURL:[NSURL URLWithString:m.logo] forState:UIControlStateNormal options:YYWebImageOptionSetImageWithFadeAnimation];
    if ([m.sex_name isEqualToString:@"女"]) {
        self.imageViewSex.image = [UIImage imageNamed:@"yhxq_woman"];
    }else{
         self.imageViewSex.image = [UIImage imageNamed:@"yhxq_man"];
    }
    [self.imageViewChePai setImageWithURL:[NSURL URLWithString:m.brand_logo] placeholder:UIImage.new options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
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
    @weakify(self);
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self);
        self.location = location;
        [self fetchCheWeiData];
        WYLog(@"adfas");
        WYLog(@"用户详细信息-UserDetailinfo");

    }];
    
    
}

- (IBAction)btnSendMsgClick:(id)sender {
    if ([self.infoModel.user_id isEqualToString:@""]||self.infoModel.user_id == nil) {
        [self.view makeToast:@"此用户失效"];
        return;
    }
    if ([wyLogInCenter shareInstance].loginstate == wyLogInStateNotLogin) {
        //        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        //        [keyWindow makeToast:@"您还未登录，即将跳转到登录页面！"];
        [NSThread sleepForTimeInterval:1];
        NSArray *isfromgrzx = @[@"4", self.user_id];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToAPP" object:isfromgrzx];
    }
    WYSiLiaoVCViewController *vc = [[WYSiLiaoVCViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:self.infoModel.user_id];
    vc.title = self.infoModel.username;
    [self.navigationController pushViewController:vc animated:YES];
    //统计个人信息详情页用户点击发消息
    [MobClick event:@"__userSend_click"];
    
}


@end
