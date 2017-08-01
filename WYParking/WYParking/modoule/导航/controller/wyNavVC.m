//
//  wyNavVC.m
//  TheGenericVersion
//
//  Created by glavesoft on 16/11/22.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "wyNavVC.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import "SpeechSynthesizer.h"



#define kRoutePlanInfoViewHeight 0.3 * [UIScreen mainScreen].bounds.size.height

@interface wyNavVC ()<AMapNaviDriveManagerDelegate,AMapNaviDriveViewDelegate,MAMapViewDelegate>

@property ( nonatomic , strong) AMapNaviPoint *startPoint;//起点
//
@property ( nonatomic , strong) AMapNaviPoint *endPoint;//终点

@property ( nonatomic , strong) AMapNaviDriveManager *driveManager;

@property ( nonatomic , strong) AMapNaviDriveView  *driveView;

@property (nonatomic, strong) IBOutlet MAMapView *mapView;//为了定位用户当前位置


@end

@implementation wyNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    __weak typeof(self) weakSelf = self;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
    
}

//当前位置
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    //取出当前位置的坐标
    NSLog(@"定位 latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    self.mapView.showsUserLocation=NO;
    
    //初始化 起点终点lng lat
    //起点
    self.startPoint = [AMapNaviPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    //终点 ， 从上个页面传过来的
    self.endPoint = [AMapNaviPoint locationWithLatitude:self.endLocationCoordinate2D.latitude longitude:self.endLocationCoordinate2D.longitude];
    
    //初始化 AMapNaviDriveManager。
    [self initDriveManager];
    
    //driver view
    [self initDriveView];
    
    [self configDriveNavi];
    
    [self calculateRoute];
    
    
}

- (void)initDriveView
{
    if (self.driveView == nil)
    {
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.driveView setDelegate:self];
        
    }
}

- (void)calculateRoute
{
    [self.driveManager calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                endPoints:@[self.endPoint]
                                                wayPoints:nil
                                          drivingStrategy:AMapNaviDrivingStrategySingleDefault];
    
}

//将 AMapNaviDriveView 与 AMapNaviManager 关联起来，并将 AManNaviDriveView 显示出来。
- (void)configDriveNavi
{
    [self.driveManager addDataRepresentative:self.driveView];
    [self.view addSubview:self.driveView];
}



//初始化 AMapNaviDriveManager。
- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
    }

}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后开始GPS导航
    [self.driveManager startGPSNavi];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView{
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    [self.mapView removeFromSuperview];

}

@end
