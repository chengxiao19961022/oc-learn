//
//  WYPersonalInfoVC.m
//  WYParking
//
//  Created by glavesoft on 17/3/8.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYPersonalInfoVC.h"
#import <AVFoundation/AVFoundation.h>
#import "WYQiChePinPaiVC.h"

#import "CarBrandsViewController.h"

@interface WYPersonalInfoVC ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,CarBrandsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserlogo;
@property (weak, nonatomic) IBOutlet UIView *UserLogoView;
@property (weak, nonatomic) IBOutlet UITextField *TFNickName;
@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *labSex;
@property (weak, nonatomic) IBOutlet UITextField *TFRecommend;
@property (weak, nonatomic) IBOutlet UITextField *TFPhone;
@property (weak, nonatomic) IBOutlet UIView *QiChePinPaiView;
@property (weak, nonatomic) IBOutlet UITextField *TFChePai;
@property (weak, nonatomic) IBOutlet UILabel *labQiChePinPai;
@property (copy , nonatomic) NSString *imageUrl;//服务器返回的imageUrl
@property (copy , nonatomic) NSString *brand_id;

@end

@implementation WYPersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.brand_id = [wyLogInCenter shareInstance].sessionInfo.brand_id;
    if ([wyLogInCenter shareInstance].sessionInfo.isLatest) {
        [self renderViewWithUserInfo];
    }else{
        [[wyLogInCenter shareInstance] upDateUserInfo];
        [self renderViewWithUserInfo];
    }
    
    @weakify(self);
    [self.sexView bk_whenTapped:^{
        
        @strongify(self);
        [self allTextFieldResign];
#pragma mark - 点击性别
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        
        [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:^{
            
        }];
        NSArray<NSString *> *datasource = @[
                                            @"男",
                                            @"女"
                                            ];
        [datasource enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [actionSheet bk_addButtonWithTitle:obj handler:^{
                self.labSex.text = obj;
            }];
        }];
        [actionSheet showInView:self.view];
    }];
    self.TFPhone.enabled = NO;
}

- (void)renderViewWithUserInfo{
    [self.imageViewUserlogo setImageWithURL:[NSURL URLWithString:[wyLogInCenter shareInstance].sessionInfo.logo] options:YYWebImageOptionSetImageWithFadeAnimation];
    self.TFNickName.text = [wyLogInCenter shareInstance].sessionInfo.username;
    if ([[wyLogInCenter shareInstance].sessionInfo.sex isEqualToString:@"1"]) {
        self.labSex.text = @"男";
    }else{
        self.labSex.text = @"女";
    }
    NSString *recommend_code = @"";
    recommend_code = [wyLogInCenter shareInstance].sessionInfo.recommend_code;
    
    if ([recommend_code isEqualToString:@""]||recommend_code == nil || [recommend_code isEqualToString:@"0"]) {
        self.TFRecommend.text = @"";
        self.TFRecommend.enabled = YES;
    }else{
        self.TFRecommend.text = recommend_code;
        self.TFRecommend.enabled = NO;
    }
    self.TFPhone.text = [wyLogInCenter shareInstance].sessionInfo.phone;
    self.labQiChePinPai.text = [wyLogInCenter shareInstance].sessionInfo.brand_name;
    self.TFChePai.text = [wyLogInCenter shareInstance].sessionInfo.plate_nu;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault]; //设置为白色
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak typeof(self) weakSelf = self;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"个人资料";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 点击汽车品牌
- (IBAction)btnQiChePinPaiClick:(id)sender {
    [self allTextFieldResign];
//    WYQiChePinPaiVC *Vc = WYQiChePinPaiVC.new;
//    [self.navigationController pushViewController:Vc animated:YES];
    
    CarBrandsViewController *CarBrandsVC = [[CarBrandsViewController alloc]init];
    CarBrandsVC.delegate = self;
    [self.navigationController pushViewController:CarBrandsVC animated:YES];
}

#pragma mark － CarBrandsViewControllerDelegate
-(void)chooseCarBrandsId:(NSString *)brandId brandName:(NSString *)name{
    self.labQiChePinPai.text = name;
    self.brand_id = brandId;
}

#pragma mark - 下一步
- (IBAction)btnNextClick:(id)sender {
    if (![Utils verifyNick:self.TFNickName.text]) {
        [self.view makeToast:@"请输入正确昵称格式"];
        return;
    }
    if (![Utils verifyPhone:self.TFPhone.text]) {
        [self.view makeToast:@"请输入正确手机号"];
        return;
    }
    if (![Utils verifyChePaiHao:self.TFChePai.text]) {
        [self.view makeToast:@"请输入正确车牌"];
        return;
    }
    
    NSString *recommend_code;
    if (self.TFRecommend.enabled) {
        if (!([self.TFRecommend.text isEqualToString:@""]||self.TFRecommend.text == nil)) {
            if (![Utils verifyRecommendCode:self.TFRecommend.text]) {
                [self.view makeToast:@"请输入正确推荐码"];
                return;
            }else{
                recommend_code = self.TFRecommend.text;
            }
        }
    }else{
        recommend_code = @"";
    }
   
   
    
    
    
    NSString *logo ;
    if ([self.imageUrl isEqualToString:@""]||self.imageUrl == nil) {
        logo = [wyLogInCenter shareInstance].sessionInfo.logo;
    }else{
        logo = self.imageUrl;
    }
    
    
    @weakify(self);
    [[wyLogInCenter shareInstance] editUserInfoWithUserLogo:logo NickName:self.TFNickName.text sex:self.labSex.text recommend_code:recommend_code phone:self.TFPhone.text pinPai:self.brand_id ChePai:self.TFChePai.text isSuccess:^(BOOL isSuccess, NSString *errorMes) {
        @strongify(self);
        if (isSuccess){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.view makeToast:errorMes];
        }
        
    }];
}

#pragma mark - 点击头像
- (IBAction)btnTouXiangClick:(id)sender {
    [self allTextFieldResign];
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    NSArray<NSString *> *dataSource = @[
                                        @"拍照",
                                        @"从相册选取"
                                        ];
    [dataSource enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [sheet bk_addButtonWithTitle:obj handler:^{
            if ([obj isEqualToString:@"拍照"]) {
                
                NSString *mediaType = AVMediaTypeVideo;
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                    [self.view makeToast:@"请到设置中允许车位分享使用相机"];
                    return;
                }
                
                [self addCarema];
            }else{
                [self openPicLibrary];
            }
        }];
    }];
    [sheet bk_setCancelButtonWithTitle:@"取消" handler:^{
        ;
    }];
    [sheet showInView:self.view];
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
#pragma mark - 相册
-(void)openPicLibrary{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"daohanglanW"] forBarMetrics:UIBarMetricsDefault];
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }
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
    [SVProgressHUD showWithStatus:@"上传图片中"];
    
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
        [SVProgressHUD dismiss];
        NSMutableDictionary* paramsDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString *status=[NSString stringWithFormat:@"%@",paramsDict[@"status"]];
        
        if ([status isEqualToString:@"200"]) {
            
            self.imageUrl = paramsDict[@"data"][@"logo"];
            [self.imageViewUserlogo setImageWithURL:[NSURL URLWithString:self.imageUrl] options:YYWebImageOptionShowNetworkActivity];
            
            self.imageViewUserlogo.layer.cornerRadius = self.imageViewUserlogo.width / 2.0 ;
            self.imageViewUserlogo.layer.masksToBounds = YES;
            
        }else
        {
            [self.view makeToast:paramsDict[@"message"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"上传失败"];
    }];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)allTextFieldResign{
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            [obj resignFirstResponder];
        }
    }];
}



@end
