//
//  WYChuangJianTingCheChangVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYChuangJianTingCheChangVC.h"
#import <AVFoundation/AVFoundation.h>
#import "WYSwitch.h"
#import "PresentLocationViewController.h"
#import "WYModelPark_info.h"
#import "WYMqdShiJianVC.h"
typedef NS_ENUM(NSInteger , picType) {
    picTypeYingYeZhiZhao = 0,
    picTypeShenFenZheng
};

@interface WYChuangJianTingCheChangVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
// ,PassTimelineDelegate
//@interface WYChuangJianTingCheChangVC ()<UITableViewDelegate , UITableViewDataSource>
{
    NSString *mqdtimeline;// 免确认时间段显示
    NSArray *timeline;// 接收免确认开始、结束时间
    UIImageView *navBarHairlineImageView;
}

@property (weak, nonatomic) IBOutlet UITextField *TFBuilding;
@property (weak, nonatomic) IBOutlet UITextField *TFRealName;
@property (weak, nonatomic) IBOutlet UITextField *TFIdentification;

@property (copy , nonatomic) NSString *business_license_pic;//营业执照
@property (copy , nonatomic) NSString *identification_pic;//身份证
@property (weak, nonatomic) IBOutlet UIView *faPiaoView;
@property (weak, nonatomic) WYSwitch *isNeedFaPiao ;
@property (weak, nonatomic) IBOutlet UITextField *TFDetailAddress;
@property(copy , nonatomic) NSString *lnt; //详细地址的经纬度
@property(copy , nonatomic) NSString *lat; //详细地址的经纬度
@property(assign , nonatomic) picType pictype;

@property (weak, nonatomic) IBOutlet UITextField *tfYingYeZhiZhao;

@property (weak, nonatomic) IBOutlet UITextField *tfShenFenZheng;
//required 必须使用
@property (assign , nonatomic) vctype type;

@property (strong , nonatomic) WYModelPark_info *park_info;

// 免确认
@property (weak, nonatomic) IBOutlet UIView *MqrView;
// 是否开启免确认
@property (weak, nonatomic) WYSwitch *SwitchMqd;
// 免确认时间段显示
@property (weak, nonatomic) IBOutlet UIButton *MqrShiJian;
// 免确认开始时间
@property(nonatomic, strong) NSString *start_time;
// 免确认结束时间
@property(nonatomic, strong) NSString *end_time;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *MqrTimeView;


@end

@implementation WYChuangJianTingCheChangVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.showsVerticalScrollIndicator = FALSE;
    self.scrollView.showsHorizontalScrollIndicator = FALSE;
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.hidden = NO;
    [navBarHairlineImageView setBackgroundColor:[UIColor blackColor]];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Getmqd:) name:@"PassMqd" object:nil];
//    mqdtimeline = [self.start_time stringByAppendingFormat:@" 至 %@", self.end_time];
//    [self.MqrShiJian setTitle:mqdtimeline forState:UIControlStateNormal];
    self.MqrShiJian.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
//    self.MqrShiJian.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 18);// 上左下右且为正
    
    WYSwitch *isNeedFaPiao = [[WYSwitch alloc] init];
    WYSwitch *SwitchMqd = [[WYSwitch alloc] init];
    isNeedFaPiao.selected = YES;
    SwitchMqd.selected = NO;
    [self.faPiaoView addSubview:isNeedFaPiao];
    [self.MqrView addSubview:SwitchMqd];
    [isNeedFaPiao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.equalTo(isNeedFaPiao.superview);
    }];
    [SwitchMqd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.equalTo(SwitchMqd.superview);
    }];
    [isNeedFaPiao bk_addEventHandler:^(id sender) {
        isNeedFaPiao.selected = !isNeedFaPiao.selected;
    } forControlEvents:UIControlEventTouchUpInside];
    [SwitchMqd bk_addEventHandler:^(id sender) {
        SwitchMqd.selected = !self.SwitchMqd.selected;
        if (self.SwitchMqd.selected == NO)
        {
//            [self.MqrShiJian setUserInteractionEnabled:NO];
            self.MqrTimeView.hidden = YES;
        }else{
//            [self.MqrShiJian setUserInteractionEnabled:YES];
            self.MqrTimeView.hidden = NO;
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.isNeedFaPiao = isNeedFaPiao;
    self.SwitchMqd = SwitchMqd;
    if (self.type == vctypeCreate) {
        //创建停车场
        self.title = @"创建停车场";
    }else if (self.type == vctypeEdit){
        //修改停车场
        self.title = @"修改停车场";
        self.TFBuilding.text = self.park_info.building;
        self.TFDetailAddress.text = self.park_info.address;
        self.lat = self.park_info.lat;
        self.lnt = self.park_info.lnt;
        self.business_license_pic = self.park_info.business_license_pic;
        self.identification_pic = self.park_info.identification_pic;
        if (!([self.park_info.business_license_pic isEqualToString:@""]||self.park_info.business_license_pic == nil)) {
            self.tfYingYeZhiZhao.text = @"已上传";
        }
        if ([self.park_info.bill isEqualToString:@"0"]) {
            self.isNeedFaPiao.selected = NO;
        }else{
            self.isNeedFaPiao.selected = YES;
        }
        // 免确定时间段
//        if ([self.park_info])
        self.start_time = self.park_info.auto_agree_start;
        self.end_time = self.park_info.auto_agree_end;
        mqdtimeline = [self.start_time stringByAppendingFormat:@" 至 %@", self.end_time];
        [self.MqrShiJian setTitle:mqdtimeline forState:UIControlStateNormal];
        if ([self.park_info.is_auto isEqualToString:@"0"]) {
            self.SwitchMqd.selected = NO;
        }else{
            self.SwitchMqd.selected = YES;
        }
        self.TFRealName.text = self.park_info.realname;
        if (!([self.park_info.identification_pic isEqualToString:@""]||self.park_info.identification_pic == nil)) {
            self.tfShenFenZheng.text = @"已上传";
        }
        self.TFIdentification.text = self.park_info.identification;
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Getmqd:) name:@"PassMqd" object:nil];
    if (self.SwitchMqd.selected == NO)
    {
//        [self.MqrShiJian setUserInteractionEnabled:NO];
        self.MqrTimeView.hidden = YES;
    }else{
//        [self.MqrShiJian setUserInteractionEnabled:YES];
        self.MqrTimeView.hidden = NO;
    }
    mqdtimeline = [self.start_time stringByAppendingFormat:@" 至 %@", self.end_time];
    [self.MqrShiJian setTitle:mqdtimeline forState:UIControlStateNormal];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault]; //设置为白色
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak typeof(self) weakSelf = self;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
  
    
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


-(void)Getmqd:(NSNotification*)timeArray{
    timeline = [timeArray object];
    self.start_time = [timeline objectAtIndex:0];
    self.end_time = [timeline objectAtIndex:1];
//    mqdtimeline = timeline;
    mqdtimeline = [self.start_time stringByAppendingFormat:@" 至 %@", self.end_time];
    [self.MqrShiJian setTitle:mqdtimeline forState:UIControlStateNormal];
}

//- (void)returnSTime:(NSString *)start_time returnETime:(NSString *)end_time
//{
//    self.start_time = start_time;
//    self.end_time = end_time;
//    NSLog(@"代理收到时间  %@ - %@", start_time, end_time);
//}

- (void)renderWithType:(vctype)t model:(id)model{
    self.type = t;
    self.park_info = model;
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.refreshBlock) {
        self.refreshBlock(YES);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [self.MqrShiJian setTitle:mqdtimeline forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 停车场地址
- (IBAction)btnSelctAddressClick:(id)sender {
    [self.TFBuilding resignFirstResponder];
    [self.TFIdentification resignFirstResponder];
    [self.TFRealName resignFirstResponder];

    PresentLocationViewController * locationVc = [[PresentLocationViewController alloc]init];
    
    __weak typeof(PresentLocationViewController)*weakLocationVc = locationVc;
    __weak typeof(self) weakSelf = self;
    [locationVc setSelectAddressCompleteBlock:^{
        
        if (weakLocationVc.selectedAddress.length == 0) {
            return;
        }
        NSLog(@"%@ %@ %@",weakLocationVc.selectedAddress,weakLocationVc.selectedLatitude,weakLocationVc.selectedLongitude);
        weakSelf.TFDetailAddress.text = weakLocationVc.selectedAddress;
        weakSelf.lnt = weakLocationVc.selectedLongitude;
        weakSelf.lat = weakLocationVc.selectedLatitude;
        }];
    
    [self.navigationController pushViewController:locationVc animated:YES];
}

#pragma mark - 选择营业执照
- (IBAction)btnSelectYingYeZhiZhaoClick:(id)sender {
    [self.TFBuilding resignFirstResponder];
    [self.TFIdentification resignFirstResponder];
    [self.TFRealName resignFirstResponder];
    [self SelectPicWithType:picTypeYingYeZhiZhao];
}

#pragma mark - 手持身份证照片
- (IBAction)btnidentification_picClick:(id)sender {
    [self.TFBuilding resignFirstResponder];
    [self.TFIdentification resignFirstResponder];
    [self.TFRealName resignFirstResponder];
    [self SelectPicWithType:picTypeShenFenZheng];
}

- (NSString *)SelectPicWithType:(picType)type{
    self.pictype = type;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:^{
        
    }];
    NSArray<NSString *> *datasource = @[
                                        @"从相册选择",
                                        @"拍照"
                                        ];
    @weakify(self);
    [datasource enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [actionSheet bk_addButtonWithTitle:obj handler:^{
            @strongify(self);
            if ([obj isEqualToString:@"拍照"]) {
                //拍照
                NSString *mediaType = AVMediaTypeVideo;
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                    [self.view makeToast:@"请到设置中允许车位分享使用相机"];
                    return;
                }
                        [self addCarema];
            }else{
                //相册选择
                 [self openPicLibrary];
            }
        }];
    }];
    [actionSheet showInView:self.view];
    
    return @"";
}


#pragma mark - 相册
-(void)openPicLibrary{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }
}

#pragma mark - 相机
-(void)addCarema{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的设备没有相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 图片存到本地
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //    self.locationImgView.hidden = NO;
    //    self.locationImgView.image=editImage;
    //
    //    self.locationImgView.userInteractionEnabled = YES;
    //    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewSingleTap:)];
    //    [self.locationImgView addGestureRecognizer:singleTap];
    
    
    // 把头像图片存到本地
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"locationImg.jpg"]];   // 保存文件的名称
    NSData *imageData = UIImageJPEGRepresentation(editImage, 0.5);
    [imageData writeToFile:filePath atomically:YES];
    
    [self uploadPic];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

- (void)uploadPic{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@user/updatelogo", KSERVERADDRESS];
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];; //path数组里貌似只有一个元素
    NSString *filestr = @"/locationImg.jpg";
    NSString *newstr = [documentsDirectory stringByAppendingString:filestr];
    NSData *dd = [NSData dataWithContentsOfFile:newstr];
    
    
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        
        [formData appendPartWithFileData:dd name:@"logo" fileName:[NSString stringWithFormat:@"%@.jpg",fileName] mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary* paramsDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString *status=[NSString stringWithFormat:@"%@",paramsDict[@"status"]];
        
        if ([status isEqualToString:@"200"]) {
            if (self.pictype == picTypeYingYeZhiZhao) {
                self.business_license_pic = paramsDict[@"data"][@"logo"];
                self.tfYingYeZhiZhao.text = @"已上传";
            }else{
                self.identification_pic = paramsDict[@"data"][@"logo"];
                 self.tfShenFenZheng.text = @"已上传";
            }
    
        }else
        {
            [self.view makeToast:paramsDict[@"message"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:@"上传失败"];
    }];
    
    
}

- (void)postData{
    if (self.TFBuilding.text.length == 0 || self.lat.length == 0||self.lnt.length == 0 || self.TFDetailAddress.text == 0 || self.business_license_pic.length == 0 || self.TFIdentification.text == 0 || self.identification_pic.length == 0) {
        [self.view makeToast:@"请先完善信息"];
        return;
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];

    NSString * urlString;
    if (self.type == vctypeCreate) {
        //创建停车场
        urlString = [[NSString alloc] initWithFormat:@"%@parklot/company", KSERVERADDRESS];
    }else if (self.type == vctypeEdit){
        //修改停车场
        urlString = [[NSString alloc] initWithFormat:@"%@parklot/editparklot", KSERVERADDRESS];
        [paramsDict setObject:self.park_info.parklot_id forKey:@"parklot_id"];
    }

    
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:self.lat forKey:@"lat"];
    [paramsDict setObject:self.lnt forKey:@"lnt"];
    [paramsDict setObject:self.TFBuilding.text forKey:@"building"];
    [paramsDict setObject:self.TFDetailAddress.text forKey:@"address"];
    [paramsDict setObject:self.business_license_pic forKey:@"business_license_pic"];
    
    [paramsDict setObject:self.TFIdentification.text forKey:@"identification"];
    [paramsDict setObject:self.identification_pic forKey:@"identification_pic"];
    
    [paramsDict setObject:self.TFRealName.text forKey:@"realname"];
    //设置免确定时间段
    [paramsDict setObject:self.start_time forKey:@"auto_agree_start"];
    [paramsDict setObject:self.end_time forKey:@"auto_agree_end"];
//    token	是	string	用户凭证
//    lat	是	int	经度
//    lnt	是	int	维度[self.navigationController pushViewController:vc animated:YES];
//    building	是	string	停车场名称
//    address	是	string	地址
//    type	是	int	0住宅 1商用 2办公(pictype?)
//    business_license_pic	是	string	营业执照
//    bill	是	string	0不可以提供发票 1可以提供发票
//    identification	是	string	身份证号
//    identification_pic	是	string	身份证图片
//    realname	是	string	真实姓名
    if (self.isNeedFaPiao.selected) {
        [paramsDict setObject:@"1" forKey:@"bill"];
    }else{
        [paramsDict setObject:@"0" forKey:@"bill"];
    }
    
    if (self.SwitchMqd.selected) {
        [paramsDict setObject:@"1" forKey:@"is_auto"];
    }else{
        [paramsDict setObject:@"0" forKey:@"is_auto"];
    }
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            WYLog(@"as");
            WYLog(@"创建/修改停车场");
            [self.navigationController popViewControllerAnimated:YES];
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
- (IBAction)btnDoneClick:(id)sender {
    [self postData];
}

- (IBAction)xuanzeshijian:(id)sender {
    WYMqdShiJianVC *vc = WYMqdShiJianVC.new;
    vc.start_time = self.start_time;
    vc.end_time = self.end_time;
    [self.navigationController pushViewController:vc animated:YES];
}





@end
