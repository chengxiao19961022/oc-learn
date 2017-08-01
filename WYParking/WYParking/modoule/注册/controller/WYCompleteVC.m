//
//  WYCompleteVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/14.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYCompleteVC.h"
#import <AVFoundation/AVFoundation.h>
#import "WYLogInToastView.h"
#import <RongIMKit/RongIMKit.h>//融云
//友盟
#import "UMMobClick/MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//分享
#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface WYCompleteVC ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate>
@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *labSex;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewNickCorrect;
@property (weak, nonatomic) IBOutlet UITextField *TFNickName;//昵称
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UITextField *tfReCommend;
@property (copy , nonatomic) NSString *imageUrl;//服务器返回的imageUrl
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (assign, nonatomic) BOOL isNewUser_NOPwd;

@property (strong , nonatomic) SSDKUser *user;

@property (assign , nonatomic) BOOL isformQQ;
- (IBAction)hide_keyboard:(id)sender;

@end

@implementation WYCompleteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnNext.layer.cornerRadius = 25.0;
    self.btnNext.layer.masksToBounds = YES;
    @weakify(self);
    [self.sexView bk_whenTapped:^{
        @strongify(self);
        [self.tfReCommend resignFirstResponder];
        [self.TFNickName resignFirstResponder];
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
    __weak typeof(self) weakSelf = self;
    [self.TFNickName.rac_textSignal subscribeNext:^(NSString * x) {
        if (x.length > 0) {
            weakSelf.imageViewNickCorrect.hidden = NO;
        }else{
            weakSelf.imageViewNickCorrect.hidden = YES;
        }
    }];
    
    if (self.isNewUser_NOPwd) {
        self.TFNickName.text = self.user.nickname;
        if (self.user.gender == SSDKGenderMale) {
             self.labSex.text = @"男";
        }else{
            self.labSex.text = @"女";
        }
        
        if (self.isformQQ) {
             self.imageUrl = self.user.rawData[@"figureurl_qq_2"];
        }else{
            self.imageUrl = self.user.icon;
        }
       [self.btnCamera setBackgroundImageWithURL:[NSURL URLWithString:self.imageUrl] forState:UIControlStateNormal options:YYWebImageOptionShowNetworkActivity];
       
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)renderWith_isNewUser_NOPwd:(BOOL)isNewUser_NOPwd userInfo:(id)model withQQ:(BOOL)flag withPhone:(NSString *)phone{
    self.isformQQ = flag;
    self.isNewUser_NOPwd = isNewUser_NOPwd;
    self.user = model;
    self.phone = phone;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击拍摄照相机
- (IBAction)btnCameraClick:(id)sender {
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
            [self.btnCamera setBackgroundImageWithURL:[NSURL URLWithString:self.imageUrl] forState:UIControlStateNormal options:YYWebImageOptionShowNetworkActivity];
            self.btnCamera.layer.cornerRadius = self.btnCamera.width / 2.0 ;
            self.btnCamera.layer.masksToBounds = YES;
            
        }else
        {
            [self.view makeToast:paramsDict[@"message"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"上传失败"];
    }];
    
    
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

#pragma mark - 下一步
- (IBAction)btnNextClick:(id)sender {
    
    if (self.TFNickName.text.length <= 0) {
        self.view.backgroundColor = RGBACOLOR(240, 107, 109, 1);
         [self showError:@"昵称不能为空" hidden:YES];
        return;
    }
    if ([self.labSex.text isEqualToString:@"选择"]) {
        [self showError:@"性别不能为空" hidden:YES];
        return;
    }
//    if (self.tfReCommend.text.length !=0 ) {
//        if (self.tfReCommend.text.length != 6) {
//            [self showError:@"验证码必须未6位数字" hidden:YES];
//        }
//       
//        return;
//    }
    if (self.imageUrl.length == 0 || self.imageUrl == nil) {
        [self showError:@"头像不能为空" hidden:YES];
        return;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@user/updateinfo", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:self.TFNickName.text forKey:@"username"];
    if ([self.labSex.text isEqualToString:@"女"]) {
        [paramsDict setObject:@"2" forKey:@"sex"];
    }else{
        [paramsDict setObject:@"1" forKey:@"sex"];
    }
    [paramsDict setObject:self.imageUrl forKey:@"logo"];
//    [paramsDict setObject:self.phone forKey:@"account"];
    
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    NSString *recommend_code = self.tfReCommend.text;
    if (!([recommend_code isEqualToString:@""] || recommend_code == nil)) {
        [paramsDict setObject:self.tfReCommend.text forKey:@"recommend_code"];
    }
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            [wyLogInCenter shareInstance].sessionInfo = [wyModelLogin mj_objectWithKeyValues:paramsDict[@"data"]];
            [wyLogInCenter shareInstance].loginstate = wyLogInStateSuccess;
            [self getToken];
            AppDelegate *app = KappDelegate;
            [app setTabBarAsRootVC];
            // 注册，请将示例中的lixiaoming替换成用户注册的ID。
            [MobClick event:@"__register" attributes:@{@"userid":paramsDict[@"data"][@"user_id"]}];
                                                       

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
        [self.view makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    
    
}

- (void)showError:(NSString *)text hidden:(BOOL)hidden{
    self.view.backgroundColor = kErrorBackGroundColor;
    __block WYLogInToastView *toastView = WYLogInToastView.new;
    [toastView renderWithErrorText:text Hidden:hidden];
    [self.view addSubview:toastView];
    toastView.alpha = 0;
    CGFloat left = self.lineView.left;
    CGFloat right = -20;
    CGFloat top = self.lineView.bottom + 2;
    [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(right);
        make.top.mas_equalTo(top);
    }];
    POPSpringAnimation *errorAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    errorAnimation.toValue = @1.0f;
    errorAnimation.completionBlock = ^(POPAnimation *anim,BOOL isCoplete){
        if (isCoplete) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [toastView removeFromSuperview];
            });
        }
    };
    [toastView pop_addAnimation:errorAnimation forKey:@"errorAnimation"];
}

-(void)getToken{
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@user/rytoken", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.user_id forKey:@"user_id"];
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        NSMutableDictionary* paramsDict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingMutableContainers error:nil];
        NSString *status=[NSString stringWithFormat:@"%@",paramsDict[@"data"][@"code"]];
        if ([status isEqualToString:@"200"]) {
            NSLog(@"%@",paramsDict[@"data"][@"errorMessage"]);
            [[RCIM sharedRCIM] connectWithToken:paramsDict[@"data"][@"token"] success:^(NSString *userId) {
                // Connect 成功
                NSLog(@"Connect 成功");
            }
                                          error:^(RCConnectErrorCode status) {
                                              // Connect 失败
                                              NSLog(@"Connect 失败");
                                          }
                                 tokenIncorrect:^() {
                                     // Token 失效的状态处理
                                 }];
        }else{
            //            [self.view makeToast:paramsDict[@"message"]];
            NSLog(@"%@",paramsDict[@"data"][@"errorMessage"]);
        }
        
    } failuer:^(NSError *error) {
        ;
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)hide_keyboard:(id)sender {
}
@end
