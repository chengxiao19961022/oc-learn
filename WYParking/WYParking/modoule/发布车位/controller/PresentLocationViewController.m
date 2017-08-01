//
//  PresentLocationViewController.m
//  TheGenericVersion
//
//  Created by Glavesoft on 16/1/6.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "PresentLocationViewController.h"
#import "PresentLocationTableViewCell.h"
#import "centerView.h"



@interface PresentLocationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL firstGetUserLocation;
    UIView *popView;
    NSString *city;
    UIImageView *popAni;
    UILabel *addressLab;
    UIImage *imgBg;
    UIImageView *addressLabBG;
    
    
}

@property (nonatomic, strong) NSMutableArray *tips;

@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *locationTableView;
@property (weak, nonatomic) centerView *v;

@end

@implementation PresentLocationViewController



- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchAction) name:UITextFieldTextDidChangeNotification object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mapView setZoomLevel:14 animated:YES];
    });
    [self.view bringSubviewToFront:self.locationTableView];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)searchAction
{
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = self.searchText.text;
    tips.city     = city?city:@"北京";
    [self.search AMapInputTipsSearch:tips];
    
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if([self.searchText.text isEqualToString:@""])
    {
        self.locationTableView.hidden = YES;
    }else
    {
        self.locationTableView.hidden = NO;
    }
    [self.tips setArray:response.tips];
    [_locationTableView reloadData];

}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.locationTableView.hidden = YES;
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    


    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tips=[[NSMutableArray alloc]init];
    
    firstGetUserLocation=YES;

    
    self.locationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
     [self initMapView];
    __weak typeof(self) weakSelf = self;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault]; //设置为白色
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"选择地址";
    
    // Do any additional setup after loading the view from its nib.
}

- (void)initMapView
{
    
    //[MAMapServices sharedServices].apiKey = GaoDeKey;

    self.mapView.showsCompass=YES;
    self.mapView.delegate = self;
    self.mapView.showsScale=YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    self.mapView.scaleOrigin=CGPointMake(10, 0);//设置比例尺
    
    self.mapView.showsUserLocation=YES;
    
    
    self.search=[[AMapSearchAPI alloc]init];
    self.search.delegate=self;
    
    centerView *v = centerView.new;
    [self.mapBottomView insertSubview:v atIndex:1];
    UIView *temp = self.mapView;
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(v.superview);
        make.bottom.equalTo(temp.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(100);
    }];
    v.backgroundColor = [UIColor clearColor];
    self.v = v;

    
}


-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    //取出当前位置的坐标
    //NSLog(@"定位 latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    
    if(updatingLocation && firstGetUserLocation)
    {
        self.mapView.centerCoordinate=userLocation.coordinate;
        firstGetUserLocation=NO;
        [self searchReGeocodeWithCoordinate:userLocation.coordinate];
    }
    
}
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D center=mapView.centerCoordinate;
    
    
    NSLog(@"拖动 latitude : %f,longitude: %f",center.latitude,center.longitude);
      
    [self searchReGeocodeWithCoordinate:center];
    
   
}
//逆地理编码
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
    
    //存储经纬度
    self.selectedLatitude=[NSString stringWithFormat:@"%f",coordinate.latitude];
    self.selectedLongitude=[NSString stringWithFormat:@"%f",coordinate.longitude];
}
#pragma mark - AMapSearchDelegate

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        
        city=response.regeocode.addressComponent.city;

        self.v.labTitle.text = response.regeocode.formattedAddress;
        //存储地址
        self.selectedAddress=response.regeocode.formattedAddress;
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tips.count?self.tips.count:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString*ID = @"PresentLocationTableViewCell";
    PresentLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:ID owner:nil options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.tips.count==0) {
        return cell;
    }
    
    AMapTip *tip = self.tips[indexPath.row];
    
    cell.label1.text = tip.name;
    cell.label2.text = tip.district;

    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PresentLocationTableViewCell * cell = [_locationTableView cellForRowAtIndexPath:indexPath];
    self.searchText.text = cell.label1.text;

    if(self.tips.count==0)
    {
        return;
    }
    
    self.locationTableView.hidden = YES;

    AMapTip *tip = self.tips[indexPath.row];
    CLLocationCoordinate2D center=CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
    self.mapView.centerCoordinate=center;
    
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 完成
- (IBAction)btnWanChengClick:(id)sender {
    //通知传值参数
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"bool"] = @"YES";
    
    //通知传值 传回字典dict
    [[NSNotificationCenter defaultCenter] postNotificationName:@"send" object:dict];
    if (self.selectAddressCompleteBlock) {
        self.selectAddressCompleteBlock();
    }
    self.mapView.delegate = nil;
    [self.mapView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
