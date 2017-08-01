//
//  MyParkingLot.m
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/16.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import "MyParkingLot.h"
#import "MyParkingLotCollDelegate.h"
#import "MyParkingLotCollDataSource.h"
#import "MyParkingLotVM.h"

#import "MyParkingLotTblDelegate.h"
#import "MyParkingLotTblDataSource.h"
#import "WYTianJiaXinYuanGongVC.h"

#import "MBProgressHUD.h"

#import "MyStaffModel.h"
#import "WYModelParkDetailInfo.h"
#import "MyStaffModel.h"

//高德地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>



typedef void(^fetchParkInfoBlock)(WYModelParkDetailInfo *model,BOOL issuccess);
typedef void (^ParkLotCompleteBlock)(CLLocation *location , BOOL issuccess);

@interface MyParkingLot ()<AMapLocationManagerDelegate>
{
    UICollectionView * staffColl;
    MyParkingLotCollDelegate *collDeledate;
    MyParkingLotCollDataSource *collDataSource;
    
    MyParkingLotTblDelegate *tblDeledate;
    MyParkingLotTblDataSource *tblDataSource;
    
    MyParkingLotVM *collVM;

}
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBuilding;
@property (weak, nonatomic) IBOutlet UILabel *labParkTItle;
@property (assign , nonatomic) NSInteger staffCount;
@property (strong , nonatomic) WYModelParkDetailInfo *detailInfo;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (strong , nonatomic) CLLocation *location;

@property (strong , nonatomic) NSMutableArray *staffSourceArr;
@property (strong , nonatomic) NSMutableArray *tingchechangSource;//缓存


- (IBAction)btnBackClick:(id)sender;

@end

@implementation MyParkingLot


- (NSMutableArray *)staffSourceArr{
    if (_staffSourceArr == nil) {
        return  _staffSourceArr;
    }
    return _staffSourceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configAMap];
    
    //初始化列表
    tblDeledate = [[MyParkingLotTblDelegate alloc]init];
    tblDataSource = [[MyParkingLotTblDataSource alloc]init];
    self.myTableView.delegate = tblDeledate;
    self.myTableView.dataSource = tblDataSource;
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    [self initCollectionView];
    collVM = [[MyParkingLotVM alloc]init];
    
    self.imageViewBuilding.layer.cornerRadius = 34.0f;
    self.imageViewBuilding.layer.masksToBounds = YES;
    
    //获取停车场信息
    @weakify(self);
    [self fetchParkInfoWithSuccess:^(WYModelParkDetailInfo *model, BOOL issuccess) {
        @strongify(self);
        if (issuccess) {
          
            self.labAddress.text = model.address;
            self.labParkTItle.text = model.building;
            [self.imageViewBuilding setImageWithURL:[NSURL URLWithString:[wyLogInCenter shareInstance].sessionInfo.logo] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                ;
            }];
            self.detailInfo = model;
        }
        //获取员工列表
        [self getStaffData];
    }];
    
 
    
    
    //添加手势
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionOne)];
    self.labMyStaff.userInteractionEnabled = YES;
    [self.labMyStaff addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTwo)];
    self.labRelationLot.userInteractionEnabled = YES;
    [self.labRelationLot addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionThree)];
    self.labGoOutVoucher.userInteractionEnabled = YES;
    [self.labGoOutVoucher addGestureRecognizer:tap3];
    
    
    //添加collectionView长按手势
    UILongPressGestureRecognizer *tap4 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(actionFour:)];
    tap4.minimumPressDuration = 1.0;
    [staffColl addGestureRecognizer:tap4];
    
    //添加取消编辑模式tap手势
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionFive)];
    [_headView addGestureRecognizer:tap5];
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - 获取已创建停车场的停车场
- (void)fetchParkInfoWithSuccess:(fetchParkInfoBlock)successBolock{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
   
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parklot/parklotlist", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:self.parklot_id forKey:@"parklot_id"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            
            self.tingchechangSource = [WYModelParkDetailInfo mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            //NSMutableDictionary *tempdict=[[NSMutableDictionary alloc]init];
            //[tempdict setValue:self.tingchechangSource forKey:@"key"];
            for (int i=0; i<self.tingchechangSource.count; i++) {
                
                WYModelParkDetailInfo *tempmodel = [self.tingchechangSource objectAtIndex:i];
                if(tempmodel.parklot_id == self.parklot_id){
                    WYModelParkDetailInfo *model = [WYModelParkDetailInfo mj_objectWithKeyValues:tempmodel];//这个data因为是添加多个变成了多个数据，但只能取一个！！
                    successBolock(model,YES);
                }
            }
            
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

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)actionOne
{
    staffColl.hidden = NO;
    _bottomView1.hidden = NO;
    _bottomView2.hidden = YES;
    _bottomView3.hidden = YES;
    [self getStaffData];
}

- (void)actionTwo
{
    if (self.location == nil) {
        [self.view makeToast:@"定位中，请稍等片刻"];
        return;
    }
    staffColl.hidden = YES;
    _bottomView1.hidden = YES;
    _bottomView2.hidden = NO;
    _bottomView3.hidden = YES;
    if (self.location == nil) {
        
    }else{
        [self getRelationLotData];
    }
    
    
}

- (void)actionThree
{
    staffColl.hidden = YES;
    _bottomView1.hidden = YES;
    _bottomView2.hidden = YES;
    _bottomView3.hidden = NO;
    [self getGoOutVoucherData];
    
}



- (void)actionFour:(UILongPressGestureRecognizer *)sender
{
  
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        for (MyStaffModel *mdl in collDeledate.array) {
            
            mdl.isInEditState = @"1";
            
        }
        [staffColl reloadData];

        
    }
    
    
}

- (void)actionFive
{
    for (MyStaffModel *mdl in collDeledate.array) {
        
        mdl.isInEditState = @"0";
        
    }
    [staffColl reloadData];
    
}

#pragma mark
#pragma mark 获取所有员工列表

- (void)getStaffData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    collDeledate.array = nil;
    collDataSource.array = nil;
    [staffColl reloadData];

    __weak typeof(self) weakSelf = self;
    [collVM sendMyStaffRequestWithsendMyStaffRequestWithparkLotId:self.detailInfo.parklot_id Callback:^(NSArray *array) {
        weakSelf.staffSourceArr = [array mutableCopy];
        collDeledate.array = array;
        collDataSource.array = array;
        [staffColl reloadData];
        weakSelf.staffCount = array.count;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    
}

#pragma mark
#pragma mark 获取关联车位列表


- (void)getRelationLotData
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    tblDeledate.array = nil;
    tblDataSource.array = nil;
    [_myTableView reloadData];
    
    if (self.location != nil) {
        [collVM sendRelationLotRequestWithParkLotid:self.detailInfo.parklot_id lat:[NSString stringWithFormat:@"%f",self.location.coordinate.latitude] lnt:[NSString stringWithFormat:@"%f",self.location.coordinate.longitude] Callback:^(NSArray *array) {
            tblDeledate.type = @"1";
            tblDataSource.type = @"1";
            tblDeledate.array = array;
            tblDataSource.array = array;
            [_myTableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else{
        [self.view makeToast:@"请先开启定位"];
    }
    

    
    
}

#pragma mark
#pragma mark 获取出门条列表

- (void)getGoOutVoucherData
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    tblDeledate.array = nil;
    tblDataSource.array = nil;
    [_myTableView reloadData];
    
    [collVM sendGoOutVoucherRequestWithParkLot_id:self.detailInfo.parklot_id Callback:^(NSArray *array) {
        tblDeledate.type = @"2";
        tblDataSource.type = @"2";
        tblDeledate.array = array;
        tblDataSource.array = array;
        [_myTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    

}




#pragma mark
#pragma mark 初始化collectionView

- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((kScreenWidth - 5 * 8)/4, 80);
    
    staffColl = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 240, kScreenWidth, kScreenHeight-240) collectionViewLayout:layout];
    
    staffColl.backgroundColor = [UIColor whiteColor];
    
    
    collDeledate = [[MyParkingLotCollDelegate alloc]init];
    collDataSource = [[MyParkingLotCollDataSource alloc]init];
    staffColl.delegate = collDeledate;
    staffColl.dataSource = collDataSource;
    
    staffColl.showsHorizontalScrollIndicator = NO;
    staffColl.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:staffColl];
    

    //item点击事件
    __weak typeof(self) weakSelf = self;
    @weakify(self);
    collDeledate.valueBlock = ^(NSIndexPath *indexPath){
        if (weakSelf.staffCount == indexPath.row) {
            WYLog(@"点击添加");
            WYTianJiaXinYuanGongVC *vc = WYTianJiaXinYuanGongVC.new;
            vc.parklot_id = weakSelf.detailInfo.parklot_id;
            [weakSelf.navigationController presentViewController:vc animated:YES completion:^{
                ;
            }];
        }else{
            MyStaffModel *m = [weakSelf.staffSourceArr objectAtIndex:indexPath.row];
            @strongify(self);
            if ([m.isInEditState isEqualToString:@"1"]) {
#pragma mark - 刷删除接口
                [self deleteParklotUer:m.lotuser_id indexPath:indexPath];
            }else{
                
            } 
        }
        
        
        
        NSLog(@"你点击了第%ld个",(long)indexPath.row);
    };
    
}

- (void)deleteParklotUer:(NSString *)lotUser_id indexPath:(NSIndexPath *)indexPath{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parklot/staffdel", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:lotUser_id forKey:@"lotuser_id"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            [self.view makeToast:@"删除成功"];
            [self.staffSourceArr removeObjectAtIndex:indexPath.row];
              self.staffCount = self.staffSourceArr.count;
            collDataSource.array = self.staffSourceArr;
            collDeledate.array = self.staffSourceArr;
            [staffColl reloadData];
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
       WYLog(@"我的停车场-MyParkingLot");
       WYLog(@"adfas");
    }];
}

//返回
- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
