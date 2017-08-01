//
//  wyFuJinCheWei.m
//  WYParking
//
//  Created by glavesoft on 17/2/28.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "wyFuJinCheWei.h"
#import "WYSearchTop.h"
#import "WYModelFuJin.h"
#import "WYNearCell.h"
#import "WYCarDetaiInfo.h"
#import "wyNavVC.h"
#import "WYSiLiaoVCViewController.h"
#import "wyModelHistory.h"
#import "WYUserDetailinfoVC.h"
#import "WYBlueStarView.h"

#import "wyUserAnnotation.h"
#import "CustomAnnotationView.h"
#import "WYFuJinBottomView.h"

#import "wyParkAnnotation.h"

#import "RCDCustomerServiceViewController.h"
//#define CUSTOMEID @"KEFU148825322585191"//开发环境
#define CUSTOMEID @"KEFU148939802457289"//生产环境


//static const CGFloat cellHeight = 205;
static const CGFloat cellHeight = 280;

static const CGFloat interIntemSpace = 10;

//static const CGFloat lineSpace = 8;
static const CGFloat lineSpace = 20;

@interface wyFuJinCheWei ()<AMapLocationManagerDelegate,UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout,MAMapViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>{
        long selectAnn;//选择的锚点
      NSString *city;//某个城市的park
    
   
    BOOL isFirst;//是不是第一次进入此页面，第一次就走接口，不是第一次（比如从上个页面返回的，就直接渲染）
}
@property (weak, nonatomic) IBOutlet UIView *topSearchViewContainer;
@property (weak , nonatomic)  WYSearchTop *searchBtn1;
@property (nonatomic, strong) AMapLocationReGeocode *regecode;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIView *mapContainer;

@property (weak, nonatomic) IBOutlet UIButton *btnLieBiao;
@property (weak, nonatomic) IBOutlet UIButton *btnMpa;
@property (strong , nonatomic) NSMutableArray *FuJinCheWeiDataSource;
@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property (weak, nonatomic) IBOutlet WYFuJinBottomView *bottomV;

@property (weak , nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *bottomContainer;
@property (nonatomic, strong) AMapSearchAPI *search;//搜索对象

@property (assign , nonatomic) CGFloat itemW;//线宽

@property (weak, nonatomic) IBOutlet UIView *line;


////
@property (weak, nonatomic) IBOutlet MAMapView *mapView;

@property (nonatomic, strong) NSMutableArray *annotations;//放置车位的数组annotaton

@property (strong , nonatomic) NSMutableArray<wyModelPark_map *> *parkArr;//停车场数组

@property (nonatomic, strong) NSMutableArray *tips;//搜索的,TextField数据源

@property (weak, nonatomic) IBOutlet UITableView *tbSearch;

@property (strong , nonatomic)WYModelFuJin* selectModel;//纪录选择的model

@property (assign , nonatomic) BOOL isSearch;//是否是搜索

@property (copy , nonatomic) NSString *address;//如果是搜索 ， 就有值，否则没有

@property (assign , nonatomic) NSInteger  index;

@property (assign , nonatomic) BOOL atMapView;

@end

@implementation wyFuJinCheWei

/**
 lazy
 
 @return 停车场数据，不是车位数据
 */
- (NSMutableArray *)parkArr{
    if (_parkArr == nil) {
        _parkArr = [NSMutableArray array];
    }
    return _parkArr;
}

- (NSMutableArray *)tips{
    if (_tips == nil) {
        _tips = [NSMutableArray array];
    }
    return _tips;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.atMapView = NO;
    isFirst = YES;
    self.topSearchViewContainer.userInteractionEnabled = YES;
    self.tbSearch.delegate = self;
    self.tbSearch.dataSource = self;
    
    self.search=[[AMapSearchAPI alloc]init];
    self.search.delegate=self;
    selectAnn=100000;
    self.annotations=[[NSMutableArray alloc]init];
    
    WYSearchTop *searchView = WYSearchTop.new;
    [self.topSearchViewContainer addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchView.superview);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    self.searchBtn1 = searchView;
    // Do any additional setup after loading the view from its nib.
    
    [self.btnLieBiao setTitleColor:RGBACOLOR(122, 144, 190, 1) forState:UIControlStateNormal];
     [self.btnLieBiao setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
     [self.btnMpa setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.btnMpa setTitleColor:RGBACOLOR(122, 144, 190, 1) forState:UIControlStateNormal];
    self.btnLieBiao.selected = YES;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,0,0) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.collectionViewLayout = flowLayout;
    collectionView.pagingEnabled = NO;
    [self.bodyView addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor clearColor];
    //注册cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WYNearCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WYNearCell class])];
    
    [self initMapView];
    
    self.mapContainer.hidden = YES;
    @weakify(self);
    [[self.searchBtn1.TFAddress.rac_textSignal skip:1] subscribeNext:^(NSString * x) {
         @strongify(self);
        if (x.length > 0) {
            self.tbSearch.hidden = NO;
            [self searchActionWithText:x];
        }else{
            self.tbSearch.hidden = YES;
        }
        
    }];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    collectionView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpRefresh)];
    footer.automaticallyRefresh = NO;
    self.collectionView.mj_footer = footer;
    
    self.collectionView = collectionView;
    [self.collectionView.mj_header beginRefreshing];
    
}

- (void)pullDownToRefresh{
    self.index = 1;
    if (self.tip == nil&&self.history == nil) {
        [self configAMap];
    }else{
        [self UpDateUI];
    }
}

- (void)pullUpRefresh{
    self.index = self.index + 1;
    if (self.tip == nil&&self.history == nil) {
        [self configAMap];
    }else{
        [self UpDateUI];
    }

}



//从搜索页面进来，UITextField高德搜索后
- (void)UpDateUI{
    if (self.tip) {
        self.searchBtn1.TFAddress.text = self.tip.name;
        CLLocationCoordinate2D center=CLLocationCoordinate2DMake(self.tip.location.latitude, self.tip.location.longitude);
        self.mapView.centerCoordinate=center;
        [self searchReGeocodeWithCoordinate:center];//异步
    }else{
        self.searchBtn1.TFAddress.text = self.history.address;
        CLLocationCoordinate2D center=CLLocationCoordinate2DMake([self.history.lat doubleValue], [self.history.lnt doubleValue]);
        self.mapView.centerCoordinate=center;
        [self searchReGeocodeWithCoordinate:center];//异步
    }
    
}

- (void)RenderWithIsSearch:(BOOL)isSearch withAddress:(NSString *)address;{
    self.isSearch = isSearch;
    self.address = address;
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configAMap{
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    if (self.locationManager == nil) {
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
        
        [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    }
   
    @weakify(self);
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self);
        self.regecode = regeocode;
        NSString * c =regeocode.city;
        if ([c isEqualToString:@""]||!c) {
            c = regeocode.province;
        }
        [self doActionWithCity:c Title:regeocode.street cllocation:location];
        WYLog(@"adfas");
        WYLog(@"附近车位-FuJinCheWei");

    }];

}



#pragma  mark - 高德逆地理编码
//逆地理编码
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
    self.search.delegate = self;
}

#pragma mark - AMapSearchDelegate

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        
        city=response.regeocode.addressComponent.city;
        if ([city isEqualToString:@""]||!city) {
            city = response.regeocode.addressComponent.province;
        }
        CLLocation *location;
        NSString *title;
        if (_tip) {
             location = [[CLLocation alloc] initWithLatitude:_tip.location.latitude longitude:_tip.location.longitude];
            title = _tip.name;
        }else{
             location = [[CLLocation alloc] initWithLatitude:[_history.lat doubleValue] longitude:[_history.lnt doubleValue]];
            title = _history.address;
        }
       
#pragma mark -  数据接口
        [self doActionWithCity:city Title:title cllocation:location];
    }
}

#pragma mark -  数据接口
- (void)doActionWithCity:(NSString *)c Title:(NSString *)title cllocation:(CLLocation *)location{
    city = c;
    self.searchBtn1.TFAddress.text = title;
    [self.mapView setZoomLevel:10 animated:YES];
    [self.mapView setCenterCoordinate:location.coordinate];
    [self fetchFuJinCheWeiWithCoordinate:location];
    [self fetchDataWithParameters:nil];
}

#pragma mark - 附近车位数据
- (void)fetchFuJinCheWeiWithCoordinate:(CLLocation *)location{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中";
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@index/wherepark", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"lat"];
    [paramsDict setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude]  forKey:@"lnt"];
     [paramsDict setObject:@"10"  forKey:@"limit"];
     [paramsDict setObject:[NSString stringWithFormat:@"%d",self.index]  forKey:@"page"];
    if (self.isSearch) {
         [paramsDict setObject:[NSString stringWithFormat:@"2"]  forKey:@"type"];
        [paramsDict setObject:self.address forKey:@"address"];

    }else{
          [paramsDict setObject:[NSString stringWithFormat:@"1"]  forKey:@"type"];
    }
         [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        self.collectionView.hidden = NO;
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView.mj_header endRefreshing];
            NSArray *sourceArr  = [WYModelFuJin mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            if (sourceArr.count > 0) {
                
                if (self.index == 1) {
                    //下拉刷新
                    self.FuJinCheWeiDataSource = sourceArr.mutableCopy;

                }else{
                    //上拉加载
                    [self.FuJinCheWeiDataSource addObjectsFromArray: sourceArr.mutableCopy];

                }
            }else{
                [self.view makeToast:@"没有了,亲"];
            }
           
              self.selectModel = self.FuJinCheWeiDataSource.firstObject;
            //在地图页面 刷新
            if (self.atMapView) {
                [self.collectionView reloadData];
                self.collectionView.hidden = YES;
                self.mapContainer.hidden = NO;
            }else{
                [self.collectionView reloadData];
            }
            
            //移除所有 annotation
            NSArray<MAPointAnnotation *> *temptArr = self.mapView.annotations.copy;
            [temptArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![obj isKindOfClass:[wyUserAnnotation class]]) {
                    [_mapView removeAnnotation:obj];
                }
            }];
            [self.FuJinCheWeiDataSource enumerateObjectsUsingBlock:^(WYModelFuJin * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.ID = [NSString stringWithFormat:@"%u",(idx + 1)];
            }];
            
            for (int i=0;i<self.FuJinCheWeiDataSource.count;i++) {
                
                WYModelFuJin * infoModel = self.FuJinCheWeiDataSource[i];
                
                MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
                pointAnnotation.coordinate = CLLocationCoordinate2DMake(infoModel.lat.floatValue, infoModel.lnt.floatValue);
                //把索引记下来
                pointAnnotation.title = [NSString stringWithFormat:@"%d",i];
                
                [self.mapView addAnnotation:pointAnnotation];
            }
            if (self.bottomV == nil) {
                WYFuJinBottomView *v = WYFuJinBottomView.new;
                [self.bottomContainer addSubview:v];
                [v mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
                }];
                @weakify(self);
                v.blockIndex = ^(NSString *str){
                    @strongify(self);
                    if ([str isEqualToString:@"下一页"]) {
#pragma mark - 请求下一页数据
                        [self.collectionView.mj_footer beginRefreshing];
                        self.atMapView = YES;
                    }else{
#pragma mark - 请求上一页数据
                          WYLog(@"上一页");
                         self.atMapView = YES;
                        [self.collectionView.mj_header beginRefreshing];
                    }
                };
                v.fujinBottomblock = ^(clicktype type,WYModelFuJin *model){
                    @strongify(self);
                    if (type == clicktypeFaXiaoXi) {
                        //发消息
                        WYLog(@"发消息");
//                        WYSiLiaoVCViewController *vc = [[WYSiLiaoVCViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.user_id];
//                        vc.title = model.username;
//                        [self.navigationController pushViewController:vc animated:YES];
                        
                        RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
                        chatService.userName = @"客服";
                        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
                        chatService.targetId = CUSTOMEID;
                        chatService.title = chatService.userName;
                        chatService.parktitle = model.park_title;
                        [self.navigationController pushViewController :chatService animated:YES];

                    }else if(type == clicktypeXiangQing){
                        //详情
                        WYCarDetaiInfo *vc = WYCarDetaiInfo.new;
                        vc.park_id = model.park_id;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        //用户详情
                        WYUserDetailinfoVC *vc = WYUserDetailinfoVC.new;
                        vc.user_id = model.user_id;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                };
                self.bottomV = v;
            }
            [self.bottomV renderViewWithArr:self.FuJinCheWeiDataSource];
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
         [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [keyWindow makeToast:@"请检查网络"];
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

#pragma mark - 在viewwilldisappear里面调用，解决内存不释放的问题
- (void)clearMapView{
    [self.mapView removeAnnotations:self.annotations];
    [self.mapView removeAnnotations:self.parkArr];
    [self.mapView removeAllSubviews];
    [self.mapView removeFromSuperview];
    [self.bottomContainer removeAllSubviews];
    self.mapView = nil;
}

#pragma mark - 刷新mapView，在willappear里面调用
- (void)reloadMapView{
    //在地图页面 刷新
    if (self.atMapView) {
        [self.collectionView reloadData];
        self.collectionView.hidden = YES;
        self.mapContainer.hidden = NO;
    }else{
        [self.collectionView reloadData];
    }
    [self initMapView];
    [self.FuJinCheWeiDataSource enumerateObjectsUsingBlock:^(WYModelFuJin * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.ID = [NSString stringWithFormat:@"%u",(idx + 1)];
    }];
    
    for (int i=0;i<self.FuJinCheWeiDataSource.count;i++) {
        
        WYModelFuJin * infoModel = self.FuJinCheWeiDataSource[i];
        
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(infoModel.lat.floatValue, infoModel.lnt.floatValue);
        //把索引记下来
        pointAnnotation.title = [NSString stringWithFormat:@"%d",i];
        
        [_mapView addAnnotation:pointAnnotation];
        
        
        
        
    }
    if (self.bottomV == nil) {
        WYFuJinBottomView *v = WYFuJinBottomView.new;
        [self.bottomContainer addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        @weakify(self);
        v.blockIndex = ^(NSString *str){
            @strongify(self);
            if ([str isEqualToString:@"下一页"]) {
#pragma mark - 请求下一页数据
                [self.collectionView.mj_footer beginRefreshing];
                self.atMapView = YES;
            }else{
#pragma mark - 请求上一页数据
                WYLog(@"上一页");
                self.atMapView = YES;
                [self.collectionView.mj_header beginRefreshing];
            }
        };
        v.fujinBottomblock = ^(clicktype type,WYModelFuJin *model){
            @strongify(self);
            if (type == clicktypeFaXiaoXi) {
                //发消息
                WYLog(@"发消息");
//                WYSiLiaoVCViewController *vc = [[WYSiLiaoVCViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.user_id];
//                vc.title = model.username;
//                [self.navigationController pushViewController:vc animated:YES];
                
                RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
                chatService.userName = @"客服";
                chatService.conversationType = ConversationType_CUSTOMERSERVICE;
                chatService.targetId = CUSTOMEID;
                chatService.title = chatService.userName;
                chatService.parktitle = model.park_title;
                [self.navigationController pushViewController :chatService animated:YES];
                
            }else if(type == clicktypeXiangQing){
                //详情
                WYCarDetaiInfo *vc = WYCarDetaiInfo.new;
                vc.park_id = model.park_id;
                [self.navigationController pushViewController:vc animated:YES];
            }else if(type == clicktypeTouXiang){
                //用户详情
                WYUserDetailinfoVC *vc = WYUserDetailinfoVC.new;
                vc.user_id = model.user_id;
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        self.bottomV = v;
    }
    [self.bottomV renderViewWithArr:self.FuJinCheWeiDataSource];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  - 列表
- (IBAction)btnLieBiao:(id)sender {
    self.atMapView = NO;
    self.btnLieBiao.selected = YES;
    self.btnMpa.selected = NO;
    self.line.centerX = self.btnLieBiao.centerX;
    self.mapContainer.hidden = YES;
    self.collectionView.hidden = NO;
}

#pragma mark - 地图
- (IBAction)btnAmap:(id)sender {
    self.atMapView = YES;
    self.btnMpa.selected = YES;
    self.btnLieBiao.selected = NO;
    self.line.centerX = self.btnMpa.centerX;
    self.collectionView.hidden = YES;
    self.mapContainer.hidden = NO;
}

#pragma mark - collectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.FuJinCheWeiDataSource.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return lineSpace;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return interIntemSpace;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tip = [self.tips objectAtIndex:indexPath.row];
    self.tbSearch.hidden = YES;
    [self UpDateUI];
}




- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WYNearCell *cell = [WYNearCell cellWithCollectionView:collectionView indexPath:indexPath];
    if (self.FuJinCheWeiDataSource.count > indexPath.row) {
    [cell renderViewWithModel:[self.FuJinCheWeiDataSource objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //CGSize size = CGSizeMake(((KscreenWidth - 2 * 10) - interIntemSpace) / 2.0, cellHeight);
    CGSize size = CGSizeMake((KscreenWidth - 2 * 20), cellHeight);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WYCarDetaiInfo *vc = [[WYCarDetaiInfo alloc] init];
    WYModelFuJin *m = [self.FuJinCheWeiDataSource objectAtIndex:indexPath.row];
    vc.park_id = m.park_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView Delegate，datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
}


- (void)initMapView
{
    
    //[MAMapServices sharedServices].apiKey = GaoDeKey;
    
    self.mapView.showsCompass=YES;
    self.mapView.delegate = self;
    self.mapView.showsScale=NO;
    self.mapView.userTrackingMode = MAUserTrackingModeNone ;
    
    self.mapView.scaleOrigin=CGPointMake(10, 0);
    
    self.mapView.showsUserLocation=YES;
    
}


#pragma mark - 自定义锚点

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:reuseIndetifier];
        }
        
        if (self.FuJinCheWeiDataSource.count==0) {
            return nil;
        }
        
        
        
        MAPointAnnotation *tmpAnno=(MAPointAnnotation *)annotation;
        
        int i=tmpAnno.title.intValue;
        if (i<self.FuJinCheWeiDataSource.count) {
            annotationView.fjModel=self.FuJinCheWeiDataSource[i];
        }else
        {
            return nil;
        }
        
        
        
        annotationView.frame=CGRectMake(0, 0, 30, 40);
        
        annotationView.bgImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
        
        if (i==selectAnn) {
            
            annotationView.bgImgV.image=[UIImage imageNamed:@"map_dwp"];
            
            selectAnn=10000;
            
        }else
        {
            annotationView.bgImgV.image=[UIImage imageNamed:@"map_dwb"];
            
        }
        
        [annotationView addSubview:annotationView.bgImgV];
        
        UIImageView *headView=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 26, 26)];
        [headView setImageWithURL:[NSURL URLWithString:annotationView.fjModel.logo] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            ;
        }];
        headView.layer.cornerRadius=13;
        headView.clipsToBounds=YES;
        [annotationView addSubview:headView];
        
        annotationView.canShowCallout = NO;
        
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -20);
        
        annotationView.tag=i;
        
        
        
        //        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAnn:)];
        //        [annotationView addGestureRecognizer:tap];
        
        [self.annotations addObject:annotation];
        
        
        return annotationView;
    }
    if ([annotation isKindOfClass:[wyUserAnnotation class]])
    {
        static NSString *reuseIndetifier2 = @"annotationReuseIndetifier211";
        wyParkAnnotation *parkAnnotationView = (wyParkAnnotation *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier2];
        if (parkAnnotationView == nil){
            parkAnnotationView = [[wyParkAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier2];
        }
        parkAnnotationView.image = [UIImage imageNamed:@"tcs"];
        
        // 设置为NO，用以调用自定义的calloutView
        parkAnnotationView.canShowCallout = NO;
        wyUserAnnotation *anno = (wyUserAnnotation *)annotation;
        
        parkAnnotationView.park_model = anno.model;
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        parkAnnotationView.centerOffset = CGPointMake(0, -18);
        return parkAnnotationView;
    }
    
    return nil;
    
    //----------------
    
}


/**
 点击mapview上的点

 @param mapView <#mapView description#>
 @param view    <#view description#>
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]]) {
        MAAnnotationView *tapView=view;
        selectAnn=tapView.tag;
        
        CustomAnnotationView *annotationView = (CustomAnnotationView *)view;
        
        annotationView.bgImgV.image = [UIImage imageNamed:@"map_dwp"];
        //下方view滚动到指定位置
        __block NSUInteger toIndex = 0;
        WYModelFuJin* model=self.FuJinCheWeiDataSource[tapView.tag];
        self.selectModel = model;
        [self.FuJinCheWeiDataSource enumerateObjectsUsingBlock:^(WYModelFuJin *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.park_id isEqualToString:obj.park_id]) {
                toIndex = idx;
            }
        }];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:toIndex inSection:0];
        [self.bottomV.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    if ([view.annotation isKindOfClass:[wyUserAnnotation class]]) {
        wyUserAnnotation *userAnno = (wyUserAnnotation *)view.annotation;
        wyParkAnnotation *v = (wyParkAnnotation *)view;
        v.park_model = userAnno.model;
        v.selected = YES;
    }
    
    
    
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]]) {
        CustomAnnotationView *annotationView = (CustomAnnotationView *)view;
        
        annotationView.bgImgV.image = [UIImage imageNamed:@"map_dwb"];
    }
    if ([view.annotation isKindOfClass:[wyUserAnnotation class]]) {
        view.image = [UIImage imageNamed:@"tcs"];
    }
    
    
}

#pragma mark - 附近搜索POI（停车场数据）
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
        [self.parkArr removeAllObjects];
        NSArray<MAPointAnnotation *> *temptArr = _mapView.annotations;
        //wyUserAnnotation 是停车场annotation（自定义）
        [temptArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[wyUserAnnotation class]]) {
                [_mapView removeAnnotation:obj];
            }
        }];
        [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            wyModelPark_map *model_1 = wyModelPark_map.new;
            model_1.building = obj.name;
            model_1.address = obj.address;
            model_1.lat = [NSString stringWithFormat:@"%f",obj.location.latitude];
            model_1.lnt = [NSString stringWithFormat:@"%f",obj.location.longitude];
            [self.parkArr addObject:model_1];
//            self.isParkPoiSear = NO;
        }];
        [self.parkArr enumerateObjectsUsingBlock:^(wyModelPark_map * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            wyUserAnnotation *pointAnnotation = [[wyUserAnnotation alloc] init];
            CGFloat lat = [obj.lat doubleValue];
            CGFloat lnt = [obj.lnt doubleValue];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lnt);
            pointAnnotation.model = obj;
            [_mapView addAnnotation:pointAnnotation];
        }];

}


/**
 调用高德api 搜索信息 停车场
 
 @param dic nil
 */
- (void)fetchDataWithParameters:(NSDictionary *)dic{
    
    //调用高德api
//    self.isParkPoiSear = YES;
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords            = @"停车场";
    request.city                = city?:@"北京";
    request.requireExtension    = YES;
    [self.search AMapPOIKeywordsSearch:request];
}


/**
 导航

 @param sender <#sender description#>
 */
- (IBAction)btnNavClick:(id)sender {
    if (self.FuJinCheWeiDataSource.count > 0) {
        wyNavVC *vc = wyNavVC.new;
        CGFloat lat = [self.selectModel.lat floatValue];
        CGFloat lnt = [self.selectModel.lnt floatValue];
        
        CLLocationCoordinate2D coordinate =CLLocationCoordinate2DMake(lat, lnt);
        vc.endLocationCoordinate2D = coordinate;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.view makeToast:@"附近暂无车位"];
    }
   
}

#pragma mark - 搜索高德,头部Textfield
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

- (void)dealloc{
    WYLog(@"------dealloc");
}



@end
