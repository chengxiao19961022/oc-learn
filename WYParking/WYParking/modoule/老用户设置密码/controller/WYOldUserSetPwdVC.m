//
//  WYOldUserSetPwdVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/24.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYOldUserSetPwdVC.h"
#import "WYLogInToastView.h"
#import "WYCompleteVC.h"
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

@interface WYOldUserSetPwdVC (){
    oldUserPwdType _type;
}
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet UIButton *btnEye;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (assign, nonatomic) BOOL isNewUser_NOPwd;//是否要跳完善信息页面

@property (strong , nonatomic) SSDKUser *user;

@property (assign , nonatomic) BOOL isFromQQ;

@property (copy , nonatomic) NSString * phone;
@property (weak, nonatomic) IBOutlet UILabel *labPwdD;



@end

@implementation WYOldUserSetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
     self.btnNext.layer.cornerRadius = 25.0;
    [self.btnEye setBackgroundImage:[UIImage imageNamed:@"dl_mm_eye"] forState:UIControlStateNormal];
    [self.btnEye setBackgroundImage:[UIImage imageNamed:@"dl_mm_noeye"] forState:UIControlStateSelected];
    if (_type == oldUserPwdTypePayPwd) {
        self.labTitle.text = @"请设置一个支付密码";
        self.labPwdD.text = @"支付密码";
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];;
        [self.navigationController.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:UIImage.new];
        @weakify(self);
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain handler:^(id sender) {
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:^{
                ;
            }];
        }];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)renderWith_isNewUser_NOPwd:(BOOL)isNewUser_NOPwd userInfo:(id)model withQQ:(BOOL)flag phone:(NSString *)phone{
    self.isNewUser_NOPwd = isNewUser_NOPwd;
    self.user = model;
    self.isFromQQ = flag;
    self.phone = phone;
}

- (void)renderWith:(oldUserPwdType)type{
    _type = type;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnEyeClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.tfPwd.secureTextEntry = YES;
    }else{
        self.tfPwd.secureTextEntry = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 下一步
- (IBAction)btnNextClick:(id)sender {
    if (_type == oldUserPwdTypePayPwd) {
        if (self.tfPwd.text.length != 6) {
            [self showError:@"请输入6位数字密码" hidden:YES];
            return;
        }
        
        [self setPayPwd:self.tfPwd.text];
    }else{
        if (self.tfPwd.text.length == 0) {
            [self showError:@"请输入密码" hidden:YES];
            return;
        }
        if (![Utils verifyPwd:self.tfPwd.text]) {
            [self showError:@"密码必须6～12位,只含数字和密码" hidden:YES];
            return;
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        NSString *urlString = [NSString stringWithFormat:@"%@user/setpassword",KSERVERADDRESS];
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
        [paramsDict setObject:self.tfPwd.text forKey:@"password"];
        
        
        [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
        [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
            
            if ([paramsDict[@"status"] isEqualToString:@"200"]) {
                NSDictionary *dic = paramsDict[@"data"];
                //登录的时候 没密码 ，是否有信息
                if (self.isNewUser_NOPwd) {
                    //没密码没信息
                     WYCompleteVC *vc = WYCompleteVC.new;
                    [wyLogInCenter shareInstance].sessionInfo.token = dic[@"token"];
                    [vc renderWith_isNewUser_NOPwd:YES userInfo:self.user withQQ:self.isFromQQ withPhone:@""];
                     [self.navigationController pushViewController:vc  animated:YES];
                }else{
                    //老用户设置了密码 － 》登录
//                    没密码有信息
                    [wyLogInCenter shareInstance].sessionInfo = [wyModelLogin mj_objectWithKeyValues:paramsDict[@"data"]];
                    [wyLogInCenter shareInstance].loginstate = wyLogInStateSuccess;
                    [self getToken];
                    AppDelegate *app = KappDelegate;
                    [app setTabBarAsRootVC];
                    // 登录，请将示例中的userid-safei替换成用户登录的ID。
                    [MobClick event:@"__login" attributes:@{@"userid":paramsDict[@"data"][@"user_id"]}];
                }
                
//                if (self.isNewUser_NOPwd) {
//                    //新用户没设密码
//                    WYCompleteVC *vc = WYCompleteVC.new;
//                    [vc renderWith_isNewUser_NOPwd:YES userInfo:self.user withQQ:self.isFromQQ withPhone:self.phone];
//                    [self.navigationController pushViewController:vc  animated:YES];
//                }else{
//                    //老用户设置了密码 － 》登录
//                    [wyLogInCenter shareInstance].sessionInfo = [wyModelLogin mj_objectWithKeyValues:paramsDict[@"data"]];
//                    [wyLogInCenter shareInstance].loginstate = wyLogInStateSuccess;
//                    [self getToken];
//                    AppDelegate *app = KappDelegate;
//                    [app setTabBarAsRootVC];
//                }
            }
            else if([paramsDict[@"status"] isEqualToString:@"104"])
            {
                [self.view makeToast:paramsDict[@"message"]];
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

- (void)setPayPwd:(NSString *)pwd{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@set/pwd", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:pwd forKey:@"pwd"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
           [self dismissViewControllerAnimated:YES completion:^{
               ;
           }];
        }
        else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            [self showError:paramsDict[@"message"] hidden:YES];
        }
        
    } failuer:^(NSError *error) {
        [self.view makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}



@end
