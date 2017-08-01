//
//  WYGuanZhuVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYGuanZhuVC.h"
#import "NaviView.h"
#import "WYGuanZhuCell.h"
#import "WYTopView.h"
#import "wyModelGuanZhu.h"

#import "WYUserDetailinfoVC.h"

//高德地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface WYGuanZhuVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AMapLocationManagerDelegate>{
    NaviView* naviView;
}

@property (strong , nonatomic) NSMutableArray *dataSource;

@property (weak, nonatomic)  UICollectionView *collectionView;

@property (weak , nonatomic) WYTopView *topView;

@property (assign , nonatomic) CGFloat itemW;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (strong , nonatomic) CLLocation *location;


@end

@implementation WYGuanZhuVC

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    WYTopView *topView = WYTopView.new;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
    }];
    topView.layer.masksToBounds = YES;
    self.topView = topView;
    @weakify(self);
    [RACObserve(topView, type) subscribeNext:^(NSString * x) {
        NSInteger type = [x integerValue];
        @strongify(self);
        if (type == typeWoGuanZhuDe) {
            //关注我的
            WYLog(@"我关注的");
            if (_location != nil) {
                [self fetchWoGuanZhudeData];
            }
            
            
        }else{
            //我关注的
             WYLog(@"关注我的");
            if (_location != nil) {
                [self fetchGuanZhuWodeData];
            }
        }
        [self.collectionView reloadData];
    }];
    
    [self SetNaviBar];
    
    //2. delegate
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(topView.mas_bottom);
    }];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.collectionViewLayout = flowLayout;
    collectionView.showsHorizontalScrollIndicator = NO;
    //注册cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WYGuanZhuCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WYGuanZhuCell class])];
    self.collectionView = collectionView;

    self.itemW = kScreenWidth / 4.0;
    [self.collectionView reloadData];
    [self configAMap];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark - 关注我的
- (void)fetchGuanZhuWodeData{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@friend/henotice", KSERVERADDRESS];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中";

    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:@"2"  forKey:@"type"];
     [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.user_id  forKey:@"user_id"];
    [paramsDict setObject:@"lat"  forKey: [NSString stringWithFormat:@"%f",self.location.coordinate.latitude]];
    [paramsDict setObject:@"lnt"  forKey: [NSString stringWithFormat:@"%f",self.location.coordinate.longitude]];
    [paramsDict setObject:@"1"  forKey:@"page"];
    [paramsDict setObject:@"100000"  forKey:@"limit"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [MBProgressHUD hideHUDForView:self.collectionView animated:YES];

        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            self.dataSource = [wyModelGuanZhu mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
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
        [MBProgressHUD hideHUDForView:self.collectionView animated:YES];
        [keyWindow makeToast:@"请检查网络"];
    }];

}

#pragma mark - 我关注的
- (void)fetchWoGuanZhudeData{

        NSString * urlString = [[NSString alloc] initWithFormat:@"%@friend/henotice", KSERVERADDRESS];
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中";
        [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
        [paramsDict setObject:@"1"  forKey:@"type"];
     [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.user_id  forKey:@"user_id"];
        [paramsDict setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.latitude] forKey:@"lat"  ];
        [paramsDict setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.longitude]  forKey:@"lnt" ];
        [paramsDict setObject:@"1"  forKey:@"page"];
        [paramsDict setObject:@"1000"  forKey:@"limit"];
        [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
            [MBProgressHUD hideHUDForView:self.collectionView animated:YES];
            NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
            
            if ([paramsDict[@"status"] isEqualToString:@"200"]) {
                self.dataSource = [wyModelGuanZhu mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
                [self.collectionView reloadData];
            }
            else if([paramsDict[@"status"] isEqualToString:@"104"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
            }
            else
            {
                [self.view makeToast:paramsDict[@"message"]];
            }
            
        } failuer:^(NSError *error) {
             [MBProgressHUD hideHUDForView:self.collectionView animated:YES];
            [self.view makeToast:@"请检查网络"];
        }];
}



- (void)SetNaviBar
{
    naviView = [[NaviView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    [self.view addSubview:naviView];
    
    [naviView.leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    naviView.titleLab.text = @"我的关注";
    naviView.titleLab.textColor = [UIColor whiteColor];
    
    [naviView.leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - collectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataSource.count;
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
    if (self.dataSource.count > indexPath.row) {
        [cell renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //跳转用户详情
    WYLog(@"跳转用户详情");
    WYUserDetailinfoVC *vc = WYUserDetailinfoVC.new;
    
    wyModelGuanZhu *m = (wyModelGuanZhu *)[self.dataSource objectAtIndex:indexPath.row];
    vc.user_id =  m.user_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(self.itemW, 100);
    return size;
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
        [self fetchWoGuanZhudeData];
        WYLog(@"adfas");
        WYLog(@"我的关注-GuanZhuVC");
    }];
    
    
}



@end
