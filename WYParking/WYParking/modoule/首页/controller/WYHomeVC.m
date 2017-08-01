//
//  WYHomeVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/8.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYHomeVC.h"
#import "WYSearchBtn.h"
#import "WYHomeOrderView.h"
#import "WYHomeTypeView.h"
#import "WYSearchVC.h"
#import "WYOrderInfoVC.h"
#import "WYCarDetaiInfo.h"
#import "WYUserDetailinfoVC.h"
#import "WYFuJInDeRenVC.h"
#import "WYModelFuJin.h"
#import "wyModelHomeTop.h"
#import "wyModelNearUser.h"
#import "wyFuJinCheWei.h"
#import "WYLatestActionVC.h"
#import "wyModelActivity.h"
#import "XZMRefresh.h"

// 实现collection的横向刷新和加载数据
#import "UIScrollView+PSRefresh.h"

#import "WYChatListVCViewController.h"

//高德地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>



#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

@interface WYHomeVC ()<AMapLocationManagerDelegate>

@property (strong , nonatomic) NSMutableArray<WYHomeTypeView*> *viewArr;

@property (weak , nonatomic)  WYSearchBtn *searchBtn1;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) AMapLocationReGeocode *regecode;

//@property (strong , nonatomic) NSMutableArray *FuJinCheWeiDataSource;
//
//@property (strong , nonatomic) NSMutableArray *FuJinHaoYouDataSource;

@property (weak , nonatomic) UIScrollView *scrollView;

@property (weak , nonatomic)WYHomeOrderView *orderView;

@end

@implementation WYHomeVC
{
    // 记录三个homeview的页面索引
    NSInteger _RemenIndex;
    NSInteger _FujinCheweiIndex;
    NSInteger _FujinRenIndex;
    
    // 存放三个homeview的数据
    NSMutableArray *_FuJinCheWeiDataSource;
    NSMutableArray *_FuJinHaoYouDataSource;
}


#pragma mark - lazy
- (NSMutableArray *)FuJinCheWeiDataSource{
    if (_FuJinCheWeiDataSource) {
        _FuJinCheWeiDataSource = [NSMutableArray array];
    }
    return _FuJinCheWeiDataSource;
}

- (NSMutableArray *)FuJinHaoYouDataSource{
    if (_FuJinHaoYouDataSource) {
        _FuJinHaoYouDataSource = [NSMutableArray array];
    }
    return _FuJinHaoYouDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 索引初始化为1
    _RemenIndex = _FujinCheweiIndex = _FujinRenIndex = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCar:) name:@"GuidanceToCar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoUser:) name:@"GuidanceToUser" object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupStyle];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([wyLogInCenter shareInstance].loginstate == wyLogInStateSuccess) {
                [self.orderView fetchData];
        }
        [self.viewArr enumerateObjectsUsingBlock:^(WYHomeTypeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.rightBtn.tag == homeViewTypeAction) {
                [obj fetchActivityData];
            }
        }];
        [self configAMap:nil];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:WYHomeVCNeedReFresh object:nil];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.scrollView.mj_header = header;
    [self.scrollView.mj_header beginRefreshing];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCar:) name:@"GuidanceToCar" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoUser:) name:@"GuidanceToUser" object:nil];
}

// 转到车位详情
-(void)gotoCar:(NSNotification*)aNotification{
//    NSArray *CarDetail = [aNotification object];
//    WYCarDetaiInfo *parkDetail = WYCarDetaiInfo.new;
//    parkDetail.park_id = CarDetail[1];
//    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:parkDetail];
//    parkDetail.isPresent = YES;
//    UIViewController *rootVc = CarDetail[2];
//    [rootVc.navigationController presentViewController:nav animated:YES completion:^{
//        ;
//    }];
    
    WYCarDetaiInfo *vc = WYCarDetaiInfo.new;
//    wyModelNearUser *m = (wyModelNearUser *)model;
    //        vc.isPresent = NO;
    vc.park_id =  [aNotification object][1];
    [self.navigationController pushViewController:vc animated:YES];
}

// 转到用户详情
-(void)gotoUser:(NSNotification*)aNotification{
//    NSArray *UserDetails = [aNotification object];
//    WYUserDetailinfoVC *userDetail = WYUserDetailinfoVC.new;
//    userDetail.user_id = UserDetails[1];
//    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:userDetail];
//    userDetail.isPresent = YES;
//    UIViewController *rootVc = UserDetails[2];
//    [rootVc.navigationController presentViewController:nav animated:YES completion:^{
//        ;
//    }];
    
    WYUserDetailinfoVC *vc = WYUserDetailinfoVC.new;
    //    wyModelNearUser *m = (wyModelNearUser *)model;
    //        vc.isPresent = NO;
    vc.user_id =  [aNotification object][1];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)refresh{
    [self.scrollView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.rdv_tabBarController.navigationController.navigationItem setHidesBackButton:YES];
    [self.rdv_tabBarController.navigationItem setHidesBackButton:YES];
//    [self.rdv_tabBarController.navigationController.navigationBar.backItem setHidesBackButton:YES];
//    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    
    [self.rdv_tabBarController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jbbg"] forBarMetrics:UIBarMetricsDefault];
    
    self.rdv_tabBarController.navigationController.navigationBar.contentMode = UIViewContentModeScaleAspectFill;
    if (self.searchBtn1) {
        self.rdv_tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBtn1];;
    }else{
        WYSearchBtn *searchBtn1 = WYSearchBtn.new;
        searchBtn1.backgroundColor = RGBACOLOR(1, 107, 201, 1);
        CGSize s = [searchBtn1 systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        searchBtn1.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 2 * 20, s.height);
        self.searchBtn1 = searchBtn1;
        self.searchBtn1.labAddress.text = [NSString stringWithFormat:@"当前地点·%@",self.regecode.street];
#pragma mark - 头部点击-搜索
        [searchBtn1 bk_addEventHandler:^(id sender) {
            WYSearchVC *vc = WYSearchVC.new;
            vc.isFormHome = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        self.rdv_tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn1];
    }

  
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCar:) name:@"GuidanceToCar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoUser:) name:@"GuidanceToUser" object:nil];

}

- (void)viewWillDisappear:(BOOL)animated{
    self.rdv_tabBarController.navigationItem.rightBarButtonItem = nil;
    self.rdv_tabBarController.navigationController.navigationBar.hidden = NO;
}


- (void)configAMap:(WYHomeTypeView *)homeView{
    //带逆地理信息的一次定位（返回坐标和地址信息）
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    @weakify(self);
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self);
        self.regecode = regeocode;
        NSString *address = @"";
        if (!([regeocode.street isEqualToString:@""]||regeocode.street == nil || [regeocode.street isEqualToString:@"(null)"])) {
            address =regeocode.street;
        }
        self.searchBtn1.labAddress.text = [NSString stringWithFormat:@"当前地点·%@",address] ;
        //热门活动不需要lat，lnt，在view 中请求就好了
        [self fetchFuJinCheWeiWithCoordinate:location hometypeview:homeView];
        [self fetchFuJinHaoYouWithCoordinate:location hometypeview:homeView];
        WYLog(@"adfas");
        WYLog(@"WYHomeVC");
    }];
}

#pragma mark - 附近车位数据
- (void)fetchFuJinCheWeiWithCoordinate:(CLLocation *)location hometypeview:(WYHomeTypeView *)homeview{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@index/wherepark", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    if ([wyLogInCenter shareInstance].loginstate == wyLogInStateSuccess) {
        [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    }
    
    [paramsDict setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"lat"];
    [paramsDict setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude]  forKey:@"lnt"];
    [paramsDict setObject:@"1"  forKey:@"page"];
    [paramsDict setObject:@"10"  forKey:@"limit"];
    //    [paramsDict setObject:@"10"  forKey:@"limit"];
    //    [paramsDict setObject:[NSString stringWithFormat:@"%ld",_FujinCheweiIndex]  forKey:@"page"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        if (homeview){
            [homeview.collectionView endRefreshing];
        }
        [self.scrollView.mj_header endRefreshing];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSArray *sourceArr  = [WYModelFuJin mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            if (sourceArr.count > 0) {
                
                if (_FujinCheweiIndex == 1) {
                    //下拉刷新
                    _FuJinCheWeiDataSource = sourceArr.mutableCopy;
                    
                }else{
                    //上拉加载
                    [_FuJinCheWeiDataSource addObjectsFromArray: sourceArr.mutableCopy];
                    
                }
                [homeview.collectionView reloadData];
            }else{
                [self.view makeToast:@"没有了,亲"];
            }
            //            self.FuJinCheWeiDataSource = [WYModelFuJin mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            [self.viewArr enumerateObjectsUsingBlock:^(WYHomeTypeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                // 此时的obj已经带有了type等属性，就差collection里datasource的更新
                if (obj.rightBtn.tag == homeViewTypeNearSpot) {
                    // 更新collection的datasource并reload一遍collection，目的是显示正确的视图
                    [obj renderViewWithArr:_FuJinCheWeiDataSource];
                }
            }];
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
        [self.scrollView.mj_header endRefreshing];
        if (homeview){
            [homeview.collectionView endRefreshing];
        }
        [keyWindow makeToast:@"请检查网络"];
    }];
}



#pragma mark - 附近好友
- (void)fetchFuJinHaoYouWithCoordinate:(CLLocation *)location hometypeview:(WYHomeTypeView *)homeview{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@index/nears", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    if ([wyLogInCenter shareInstance].loginstate == wyLogInStateSuccess) {
        [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    }
    [paramsDict setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"lat"];
    [paramsDict setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude]  forKey:@"lnt"];
    [paramsDict setObject:@"1"  forKey:@"page"];
    [paramsDict setObject:@"10"  forKey:@"limit"];
    //    [paramsDict setObject:@"10"  forKey:@"limit"];
    //    [paramsDict setObject:[NSString stringWithFormat:@"%ld",_FujinRenIndex]  forKey:@"page"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [self.scrollView.mj_header endRefreshing];
        if (homeview){
            [homeview.collectionView endRefreshing];
        }
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            //            self.FuJinHaoYouDataSource = [wyModelNearUser mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            NSArray *sourceArr  = [wyModelNearUser mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            //            NSMutableArray *FuJinHaoYouDataSourcetmp = [[NSMutableArray alloc] init];
            if (sourceArr.count > 0) {
                
                if (_FujinRenIndex == 1) {
                    //下拉刷新
                    _FuJinHaoYouDataSource = sourceArr.mutableCopy;
                    
                }else{
                    //上拉加载
                    [_FuJinHaoYouDataSource addObjectsFromArray: sourceArr.mutableCopy];
                    
                }
                [homeview.collectionView reloadData];
            }else{
                [self.view makeToast:@"没有了,亲"];
            }
            [self.viewArr enumerateObjectsUsingBlock:^(WYHomeTypeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.rightBtn.tag == homeViewTypeFriend) {
                    [obj renderViewWithArr:_FuJinHaoYouDataSource];
                }
            }];
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
        [self.scrollView.mj_header endRefreshing];
        if (homeview){
            [homeview.collectionView endRefreshing];
        }
        [keyWindow makeToast:@"请检查网络"];
    }];
    
}




- (void)setupStyle{
    
    //导航栏上的View
    WYSearchBtn *searchBtn1 = WYSearchBtn.new;
    searchBtn1.backgroundColor = RGBACOLOR(1, 107, 201, 1);
    CGSize s = [searchBtn1 systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    searchBtn1.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 2 * 20, s.height);
    self.searchBtn1 = searchBtn1;
#pragma mark - 头部点击-搜索
    [searchBtn1 bk_addEventHandler:^(id sender) {
        WYSearchVC *vc = WYSearchVC.new;
        vc.isFormHome = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    self.rdv_tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn1];
    
    //body
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview: scrollView];
//  scrollView.layer.contents = (id)
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView = scrollView;
    
    UIView *containerView = UIView.new;
    [scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.equalTo(containerView.superview);
    }];
    containerView.backgroundColor = [UIColor whiteColor];
        
    //有订单的时候的页面

    WYHomeOrderView *orderView = WYHomeOrderView.new;
    [containerView addSubview:orderView];
    [orderView mas_makeConstraints:^    (MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(200);
        }];
    if ([wyLogInCenter shareInstance].loginstate == wyLogInStateSuccess) {
    orderView.block = ^(WYModelMYOrder * model){
        WYOrderInfoVC *infoVC = WYOrderInfoVC.new;
        infoVC.myorder = model;
        [self.navigationController pushViewController:infoVC animated:YES];
        };
        self.orderView = orderView;
    }else{
        orderView.block = nil;
        orderView.hidden = YES;
    }
   //热门专题 ， 附近的车位 ， 附近的人
    NSArray *titleArr = @[
                          @"热门专题",
                          @"附近的车位",
                          @"附近的人",
                          ];
    NSInteger count = 3;
    NSMutableArray<WYHomeTypeView *> *ViewArr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        WYHomeTypeView *v = WYHomeTypeView.new;
        
//        //左边刷新更新
//        __weak typeof(v) weakself = v;
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        [v.collectionView xzm_addNormalHeaderWithCallback:^{
//        
//
//            // 模拟延迟加载数据，因此2秒后才调用）
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakself.collectionView reloadData];
//                // 结束刷新
//                [weakself.collectionView.xzm_header endRefreshing];
//            });
//        
//        }];
//        [weakself.collectionView.xzm_header beginRefreshing];
        

        
        
        // 更新v这个对象的type（专题、车位、人）
        [v renderViewWithleftTitle:[titleArr objectAtIndex:i] rightTitle:@"" type:i];
        v.rightBtn.tag = i;
        @weakify(self);
        // 设置collection里面block的跳转
        v.block = ^(homeViewType type, id model,NSIndexPath *indexPath){
            @strongify(self);
            [self doActionWithType:type model:(id)model indexPath:indexPath];
        };
        if (i == 0) {
            v.imageView.hidden = v.rightBtn.hidden = YES;
            //v.backgroundColor = [UIColor yellowColor];
        }
        [v.rightBtn bk_addEventHandler:^(UIButton * sender) {
            @strongify(self);
            [self doLookMoreAction:sender.tag];
        } forControlEvents:UIControlEventTouchUpInside];
        
        // collection横向向右滑动刷新
        [v.collectionView addRefreshHeaderWithClosure:^{
            // 模拟延迟加载数据，因此2秒后才调用）
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                [v.collectionView reloadData];
            //                // 结束刷新
            //                [v.collectionView endRefreshing];
            //            });
            switch (i) {
                case 0:
                    _RemenIndex = 1;
                    v.RemenIndex = _RemenIndex;
                    [v fetchActivityData];
                    break;
                case 1:
                    _FujinCheweiIndex = 1;
                    [self configAMap:v];
                    break;
                case 2:
                    _FujinRenIndex = 1;
                    [self configAMap:v];
                    break;
                default:
                    break;
            }
            
        }];
        
        
        // collection横向向左滑动增加数据
        [v.collectionView addRefreshFooterWithClosure:^{
            // 模拟延迟加载数据，因此2秒后才调用）
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [v.collectionView reloadData];
//                // 结束刷新
//                [v.collectionView endRefreshing];
//            });
            switch (i) {
                case 0:
                    _RemenIndex += 1;
                    v.RemenIndex = _RemenIndex;
                    [v fetchActivityData];
                    break;
                case 1:
                    _FujinCheweiIndex += 1;
                    [self configAMap:v];
                    break;
                case 2:
                    _FujinRenIndex += 1;
                    [self configAMap:v];
                    break;
                default:
                    break;
            }
            
        }];
        
        [containerView addSubview:v];
        [ViewArr addObject:v];
    }
    self.viewArr = ViewArr;
    __block MASConstraint *constraintHasOrder = nil;
    __block MASConstraint *constraintNoOrder = nil;
    [ViewArr.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        //make.height.mas_equalTo(325);
        int rm_width = [UIScreen mainScreen].bounds.size.width/2 - 25;
        make.height.mas_equalTo(rm_width * 2);
        
        //宽度
        //make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width/2 - 20);
        constraintNoOrder = make.top.mas_equalTo(20).with.priority(999);
        constraintHasOrder = make.top.equalTo(orderView.mas_bottom).with.offset(20);
        make.right.mas_equalTo(-20);
    }];
    [constraintNoOrder uninstall];
    [constraintHasOrder uninstall];
    [RACObserve(orderView, hidden) subscribeNext:^(NSNumber *hidden) {
        if (hidden.boolValue) {
            [constraintHasOrder uninstall];
            [constraintNoOrder install];
        }else{
            [constraintNoOrder uninstall];
            [constraintHasOrder install];
        }
    }];
    
    [ViewArr enumerateObjectsUsingBlock:^(WYHomeTypeView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            WYHomeTypeView *pre = [ViewArr objectAtIndex:idx - 1];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(pre);
                //make.height.equalTo(pre);
                make.height.mas_equalTo(230);
                make.top.equalTo(pre.mas_bottom).with.offset(40);
            }];
        }
    }];
    
    [ViewArr.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(200);
    }];
    
    
}


#pragma 点击附近车位，附近号由跳转
- (void)doActionWithType:(homeViewType )type model:(id)model indexPath:(NSIndexPath *)indexPath{
    if (type == homeViewTypeAction) {
        //跳转活动链接
        WYLog(@"跳转活动链接");
        WYLatestActionVC *vc = [[WYLatestActionVC alloc] init];
        wyModelActivity *m  = (wyModelActivity *)model;
        [vc renderWithUrl:m.url title:m.title];
        
//        // 带动画跳转，也可以pop，亲测可行
//        [Utils setNavigationControllerPushWithAnimation:self timingFunction:KYNaviAnimationTimingFunctionEaseInEaseOut type:KYNaviAnimationTypeReveal subType:KYNaviAnimationDirectionDefault duration:0.38 target:vc];
        
        [self.navigationController pushViewController:vc  animated:YES];

    }else if (type == homeViewTypeFriend){
        //跳转用户详情
        WYLog(@"跳转用户详情");
        WYUserDetailinfoVC *vc = WYUserDetailinfoVC.new;
        wyModelNearUser *m = (wyModelNearUser *)model;
//        vc.isPresent = NO;
        vc.user_id =  m.user_id;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == homeViewTypeNearSpot){
        //跳转车位详情
        WYCarDetaiInfo *vc = WYCarDetaiInfo.new;
        WYModelFuJin *m = (WYModelFuJin *)model;
        vc.park_id = m.park_id;
        // present方法跳转
//        vc.isPresent = YES;
//        [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//        [self.navigationController presentViewController:vc animated:YES completion:^{
//            WYLog(@"%@",@"点开车位详情");
//        }];
        
//        AppDelegate *app = KappDelegate;
//        UIViewController *rootVc = (UINavigationController*)app.window.rootViewController;
//        UIViewController *currentVc = rootVc.childViewControllers.lastObject;
//        [currentVc.navigationController pushViewController:vc animated:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 查看全部
- (void)doLookMoreAction:(NSInteger)viewType{
    if (viewType == homeViewTypeAction) {
        //最近活动
        WYLog(@"热门专题");
    }else {
        if ([wyLogInCenter shareInstance].loginstate == wyLogInStateNotLogin) {
            //        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            //        [keyWindow makeToast:@"您还未登录，即将跳转到登录页面！"];
                [NSThread sleepForTimeInterval:1];
                NSArray *isfromgrzx = @[@"5", @""];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToAPP" object:isfromgrzx];
            }
        if (viewType == homeViewTypeNearSpot){
            //附近车位
             WYLog(@"附近的车位");
            wyFuJinCheWei *vc = wyFuJinCheWei.new;
             [self.navigationController pushViewController:vc animated:YES];
        }else{
            //附近好友
            WYFuJInDeRenVC *vc = WYFuJInDeRenVC.new;
            [self.navigationController pushViewController:vc animated:YES];
             WYLog(@"附近的人");
        }
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}




- (void)dealloc
{
    [self cleanUpAction];
//    [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"GuidanceToCar" object:nil];
//    [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"GuidanceToUser" object:nil];
}

- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
    
}

@end
