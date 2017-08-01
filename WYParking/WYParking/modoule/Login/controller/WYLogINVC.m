//
//  WYLogINVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/7.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYLogINVC.h"
#import "WYLoginBottomView.h"
#import "WYLoginStep2VC.h"
#import "wyLogInCenter.h"
#import "WYRegisterVC.h"
#import "WYBindPhoneVC.h"
#import "WYOldUserSetPwdVC.h"
#import <RongIMKit/RongIMKit.h>//融云
#import "UserAgreementViewController.h"
#import "WYCompleteVC.h"
//友盟
#import "UMMobClick/MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>



@interface WYLogINVC ()
@property (weak, nonatomic) IBOutlet UIButton *btnLogIn;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@end

@implementation WYLogINVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self SetNaviBar];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.navigationController.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
    __weak typeof(self) weakSelf = self;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain handler:^(id sender) {
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    }];
    
    //登录按钮属性
    self.btnLogIn.layer.cornerRadius = 15.0f;
    [self.btnLogIn bk_addEventHandler:^(id sender) {
        WYLog(@"点击登陆");
        NSString *str = @"\"asdfasfasfasdf哈哈\"";
        WYLog(@"%@",str);
        WYLoginStep2VC *vc = WYLoginStep2VC.new;
        vc.From = self.From;
        [self.navigationController pushViewController:vc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    //注册按钮属性
    self.btnRegister.layer.borderWidth = 1.0f;
    self.btnRegister.layer.cornerRadius = 15.0f;
    self.btnRegister.layer.borderColor = [UIColor whiteColor].CGColor;
    @weakify(self);
    [self.btnRegister bk_addEventHandler:^(id sender) {
        WYLog(@"点击注册");
        WYRegisterVC *vc = WYRegisterVC.new;
        @strongify(self);
        [self.navigationController pushViewController:vc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    //用户协议
    WYLoginBottomView *bottomV = WYLoginBottomView.new;
    [self.view addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.centerX.equalTo(bottomV.superview);
    }];
    
    [bottomV bk_whenTapped:^{
//        @strongify(self);

        UserAgreementViewController *vc = UserAgreementViewController.new;
        vc.isPresent = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:^{
            ;
        }];
    }];
}
//- (void)SetNaviBar
//{
//    self.navigationController.navigationBarHidden = NO;
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     
//     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
//       
//       NSForegroundColorAttributeName:[UIColor blackColor]}];
//    
//    
//    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    
//    
//    self.title = @"登录";
//    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 27, 27)];
//    [btn setImage:[UIImage imageNamed:@"back3"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = leftItem;
//}
//
//- (void)Back
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [wyLogInCenter shareInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - QQ登录
- (IBAction)btnqqClick:(id)sender {
    //例如QQ的登录
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"授权中...";
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"--------uid=%@",user.uid);
             NSLog(@"--------%@",user.credential);
             NSLog(@"--------token=%@",user.credential.token);
             NSLog(@"--------nickname=%@",user.nickname);
             [self verifyWithAccess_token:user.uid SSDKUser:(SSDKUser *)user withType:@"1"];
             
         }else if(state ==SSDKResponseStateCancel)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [MBProgressHUD showError:@"您已取消授权"];
            
         }else if(state == SSDKResponseStateFail){
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [MBProgressHUD showError:@"授权不成功"];
         }
         
     }];

}



#pragma mark - 微信登录
- (IBAction)btnWechatClick:(id)sender {
    //例如WeChat的登录
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"授权中...";
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSLog(@"微信－－－－嘎嘎嘎uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"头像%@",user.icon);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
            [self verifyWithAccess_token:user.uid SSDKUser:(SSDKUser *)user withType:@"2"];
         }else if(state ==SSDKResponseStateCancel)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [MBProgressHUD showError:@"您已取消授权"];
         }else if(state == SSDKResponseStateFail){
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [MBProgressHUD showError:@"授权不成功"];
         }
         
     }];

}


#pragma mark - 第三方登录验证数据库中是否有这个数据
- (void)verifyWithAccess_token:(NSString *)token SSDKUser:(SSDKUser *)user withType:(NSString *)type{
   
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@user/thirdlogin", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:token forKey:@"access_token"];
    NSString *str = [Utils getRegisterID];
    if (!([str isEqualToString:@""]||str == nil)) {
        [paramsDict setObject:str forKey:@"registerid"];
    }
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        NSDictionary* paramsDict = [NSJSONSerialization JSONObjectWithData:obj options:0 error:nil];
        NSString *status=[NSString stringWithFormat:@"%@",paramsDict[@"status"]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([status isEqualToString:@"110"]) {
            //未绑定过
            WYBindPhoneVC *vc = WYBindPhoneVC.new;
            vc.type = type;
            vc.user = user;
            [wyLogInCenter shareInstance].sessionInfo.token = paramsDict[@"token"];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([status isEqualToString:@"200"]){
            //已经绑定
            
            NSDictionary *dic = paramsDict[@"data"];
            if ([dic containsObjectForKey:@"is_password"]&&[dic containsObjectForKey:@"is_info"]) {
                //用户注册到一半杀掉app,没密码，没信息
                WYOldUserSetPwdVC *vc = WYOldUserSetPwdVC.new;
                [wyLogInCenter shareInstance].sessionInfo.token = dic[@"token"];
                BOOL isFormQQ = NO;
                if ([type isEqualToString:@"1"]) {
                    isFormQQ = YES;
                }else{
                    isFormQQ = NO;
                }
                [vc renderWith_isNewUser_NOPwd:YES userInfo:user withQQ:isFormQQ phone:@""];
                [self.navigationController pushViewController:vc animated:YES];
            }else if(![dic containsObjectForKey:@"is_password"]&&![dic containsObjectForKey:@"is_info"]){
                //老用户，有密码－》首页，有密码，有信息则登陆成功
                [wyLogInCenter shareInstance].sessionInfo = [wyModelLogin mj_objectWithKeyValues:paramsDict[@"data"]];
                [wyLogInCenter shareInstance].loginstate = wyLogInStateSuccess;
                AppDelegate *appdelegate = KappDelegate;
                [self getToken];
                [appdelegate setTabBarAsRootVC];
                // 登录，请将示例中的userid-safei替换成用户登录的ID。
                [MobClick event:@"__login" attributes:@{@"userid":dic[@"user_id"]}];
                
            }
            if ([dic containsObjectForKey:@"is_password"]&&![dic containsObjectForKey:@"is_info"]) {
                //没密码，有信息，老用户则进入老用户设置密码页面
                WYOldUserSetPwdVC *vc = WYOldUserSetPwdVC.new;
                [wyLogInCenter shareInstance].sessionInfo.token = dic[@"token"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (![dic containsObjectForKey:@"is_password"]&&[dic containsObjectForKey:@"is_info"]) {
                //有密码 没信息则进入完善个人信息页面
                WYCompleteVC *vc = [[WYCompleteVC alloc] init];
                [wyLogInCenter shareInstance].sessionInfo.token = dic[@"token"];
//                vc.phone = self.TFPhone.text;
                BOOL isFormQQ = NO;
                if ([type isEqualToString:@"1"]) {
                    isFormQQ = YES;
                }else{
                    isFormQQ = NO;
                }
                [vc renderWith_isNewUser_NOPwd:YES userInfo:user withQQ:isFormQQ withPhone:@""];
                [self.navigationController pushViewController:vc animated:YES];
                
            }

//            NSDictionary *dic = paramsDict[@"data"];
//            if ([dic containsObjectForKey:@"is_password"]) {
//                //没设置用户密码
//                [wyLogInCenter shareInstance].sessionInfo.token = dic[@"token"];
//                WYOldUserSetPwdVC *vc = [[WYOldUserSetPwdVC alloc] init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }else{
//                //设置了用户密码
//                [wyLogInCenter shareInstance].sessionInfo = [wyModelLogin mj_objectWithKeyValues:paramsDict[@"data"]];
//                [wyLogInCenter shareInstance].loginstate = wyLogInStateSuccess;
//                [self getToken];
//                AppDelegate *appdelegate = KappDelegate;
//                [appdelegate setTabBarAsRootVC];
//            }
//            
            
        }
        
    } failuer:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"网络异常"];
    }];
    
    
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
            }error:^(RCConnectErrorCode status) {
                // Connect 失败
                NSLog(@"Connect 失败");
            }tokenIncorrect:^() {
                // Token 失效的状态处理
            }];
        }else{
            //[self.view makeToast:paramsDict[@"message"]];
            NSLog(@"%@",paramsDict[@"data"][@"errorMessage"]);
        }
        
    } failuer:^(NSError *error) {
        ;
    }];
    
}



@end
