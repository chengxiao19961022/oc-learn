//
//  WYLoginStep2VC.m
//  WYParking
//
//  Created by glavesoft on 17/2/7.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYLoginStep2VC.h"
#import "WYButton.h"
#import "WYSetPwdVC.h"
#import "wyTabBarController.h"
#import "WYOldUserSetPwdVC.h"
#import "WYLogInToastView.h"
#import "WYForgetPwdVC.h"//忘记密码
#import "WYCompleteVC.h"
#import <RongIMKit/RongIMKit.h>//融云
//友盟
#import "UMMobClick/MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>



@interface WYLoginStep2VC (){
    dispatch_source_t _timer;
    NSInteger lengthtmp;//存放临时的手机号长度
    NSMutableString *pnsend;//发给服务器的号码
}
@property (weak, nonatomic) IBOutlet UILabel *labTitle2;
@property (weak, nonatomic) IBOutlet UITextField *TFPhone;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoneCorrect;
- (IBAction)btnEyeClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnEye;
@property (weak, nonatomic) IBOutlet UILabel *labMethodTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSendMwg;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
- (IBAction)hide_keyboard:(id)sender;

@end

@implementation WYLoginStep2VC

//NSInteger lengthtmp;//存放临时的手机号长度
- (void)viewDidLoad {
    [super viewDidLoad];
    lengthtmp = 0;
    NSInteger i = 2;
    //i = i/0;
    self.TFPhone.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.tfPwd.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.TFPhone addTarget:self action:@selector(FOrmattfPhone:) forControlEvents:UIControlEventEditingChanged];
    self.TFPhone.inputAccessoryView = [self addToolbar];
    self.tfPwd.inputAccessoryView = [self addToolbar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.btnEye setBackgroundImage:[UIImage imageNamed:@"dl_mm_eye"] forState:UIControlStateNormal];
    [self.btnEye setBackgroundImage:[UIImage imageNamed:@"dl_mm_noeye"] forState:UIControlStateSelected];
    self.btnEye.hidden = YES;
    self.imageViewPhoneCorrect.hidden = YES;
    self.btnNext.layer.cornerRadius = 25.0;
    [self.btnNext setHighlighted:NO];
    
    WYButton *btn = WYButton.new;
    [self.view addSubview:btn];
    btn.LabTitle.textColor = [UIColor whiteColor];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-20);
    }];
    btn.LabTitle.font = [UIFont systemFontOfSize:15];
    btn.LabTitle.textColor = [UIColor whiteColor];
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.cornerRadius = 10;
    [btn renderWithNormalTitle:@"密码登录" SelectedTitle:@"短信验证登录" normalImage:nil SelectedImage:nil];
    btn.selected = YES;
    @weakify(self);
    [btn bk_addEventHandler:^(id sender) {
        btn.selected = !btn.selected;
        @strongify(self);
        if (btn.selected) {
            //密码登录
            self.tfPwd.keyboardType= UIKeyboardTypeDefault;
            self.labMethodTitle.text = @"密码";
            self.btnEye.hidden = NO;
            self.btnSendMwg.hidden = YES;
            self.labTitle2.text = @"登录";
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"忘记密码 " style:UIBarButtonItemStylePlain handler:^(id sender) {
                WYForgetPwdVC *vc = WYForgetPwdVC.new;
                [self.navigationController presentViewController:vc animated:YES completion:^{
                    
                }];
            }];
            self.tfPwd.text = @"";
        }else{
            //短信验证码登录
            self.tfPwd.keyboardType= UIKeyboardTypeNumberPad;
            self.tfPwd.secureTextEntry = NO;
             self.labMethodTitle.text = @"短信验证码";
            self.btnEye.hidden = YES;
            self.btnSendMwg.hidden = NO;
            self.labTitle2.text = @"短信验证登录";
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"" style:UIBarButtonItemStylePlain handler:^(id sender) {
                
            }];
            self.tfPwd.text = @"";
        }
    } forControlEvents:UIControlEventTouchUpInside];
    btn.selected = NO;
    if (btn.selected) {
        //密码登录
        self.labMethodTitle.text = @"密码";
        self.btnEye.hidden = NO;
        self.btnSendMwg.hidden = YES;
        self.labTitle2.text = @"登录";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"忘记密码 " style:UIBarButtonItemStylePlain handler:^(id sender) {
            WYForgetPwdVC *vc = WYForgetPwdVC.new;
            [self.navigationController presentViewController:vc animated:YES completion:^{
                
            }];
        }];
        self.tfPwd.text = @"";
    }else{
        //短信验证码登录
        self.tfPwd.secureTextEntry = NO;
        self.labMethodTitle.text = @"短信验证码";
        self.btnEye.hidden = YES;
        self.btnSendMwg.hidden = NO;
        self.labTitle2.text = @"短信验证登录";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"" style:UIBarButtonItemStylePlain handler:^(id sender) {
            
        }];
        self.tfPwd.text = @"";
    }
    __weak typeof(self) weakSelf = self;
    [self.TFPhone.rac_textSignal subscribeNext:^(NSString * x) {
        if (pnsend.length == 11) {
            weakSelf.imageViewPhoneCorrect.hidden = NO;
            [self.TFPhone resignFirstResponder];
        }else{
            weakSelf.imageViewPhoneCorrect.hidden = YES;
        }
    }];

    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
    __weak typeof(self) weakSelf = self;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    
}



#pragma mark - 下一步
- (IBAction)btnNextClick:(id)sender {
    if (self.imageViewPhoneCorrect.hidden) {
        [self showError:@"手机号" hidden:NO];
        return;
    }
    if (self.tfPwd.text.length == 0) {
        NSString *str;
        if (self.btnSendMwg.hidden) {
            str = @"密码";
        }else{
            str = @"验证码";
        }
        [self showError:str hidden:NO];
        return;
    }
    
    if (self.btnSendMwg.hidden) {
        //验证码
    }
    
#pragma mark - 刷登录接口
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString *urlString = @"";
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    if (self.btnSendMwg.hidden == NO) {
        //验证码
         urlString = [[NSString alloc] initWithFormat:@"%@user/login", KSERVERADDRESS];
        [paramsDict setObject:self.tfPwd.text forKey:@"code"];
    }else{
        //密码
        urlString = [[NSString alloc] initWithFormat:@"%@user/password", KSERVERADDRESS];
        [paramsDict setObject:self.tfPwd.text forKey:@"password"];
    }
//    NSString *pnsend = [[NSString alloc] initWithString:self.TFPhone.text];
//    pnsend = [pnsend  stringByReplacingOccurrencesOfString:@" " withString:@""];
    [paramsDict setObject:pnsend forKey:@"account"];
    NSString *registerStr = [Utils getRegisterID];
    if (![registerStr isEqualToString:@""]) {
        [paramsDict setObject:registerStr forKey:@"registerid"];
    }
    
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        // obj存放收到的来自服务器的用户信息报文，id类似auto
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            // dic存放用户的数据（userid、是否有密码、是否有信息等）
            NSDictionary *dic = paramsDict[@"data"];
            if ([dic containsObjectForKey:@"is_password"]&&[dic containsObjectForKey:@"is_info"]) {
                //用户注册到一半杀掉app,没密码，没信息
                WYOldUserSetPwdVC *vc = WYOldUserSetPwdVC.new;
                [wyLogInCenter shareInstance].sessionInfo.token = dic[@"token"];
            
                [vc renderWith_isNewUser_NOPwd:YES userInfo:nil withQQ:NO phone:@""];
                [self.navigationController pushViewController:vc animated:YES];
            }else if(![dic containsObjectForKey:@"is_password"]&&![dic containsObjectForKey:@"is_info"]){
                //老用户，有密码－》首页，有密码，有信息
                // 登录成功 进入首页
                // logincenter管理用户的信息以及用户的登录状态等
                [wyLogInCenter shareInstance].sessionInfo = [wyModelLogin mj_objectWithKeyValues:paramsDict[@"data"]];
//                [wyLogInCenter shareInstance].sessionInfo = [wyModelLogin mj_objectWithKeyValues:nil];
                [wyLogInCenter shareInstance].loginstate = wyLogInStateSuccess;
                AppDelegate *appdelegate = KappDelegate;
                appdelegate.From = self.From;
                [self getToken];
                [appdelegate setTabBarAsRootVC];
                // 登录，请将示例中的userid-safei替换成用户登录的ID。
                [MobClick event:@"__login" attributes:@{@"userid":dic[@"user_id"]}];
            }
            if ([dic containsObjectForKey:@"is_password"]&&![dic containsObjectForKey:@"is_info"]) {
                //没密码，有信息，老用户
                WYOldUserSetPwdVC *vc = WYOldUserSetPwdVC.new;
                [wyLogInCenter shareInstance].sessionInfo.token = dic[@"token"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (![dic containsObjectForKey:@"is_password"]&&[dic containsObjectForKey:@"is_info"]) {
                //有密码 没信息
                WYCompleteVC *vc = [[WYCompleteVC alloc] init];
                [wyLogInCenter shareInstance].sessionInfo.token = dic[@"token"];
                vc.phone = self.TFPhone.text;
                 [self.navigationController pushViewController:vc animated:YES];
                
            }
            
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

#pragma mark - 发送验证码
- (IBAction)btnSendmsgClick:(id)sender {
    [self.TFPhone resignFirstResponder];
    if (pnsend.length != 11) {
        [self showError:@"请输入手机号" hidden:YES];
        return;
    }
    else{
        self.btnSendMwg.enabled = NO;
#pragma mark - 刷短信验证码借口
        [self FetchYanZhengMa];
    }
    

}

- (void)FetchYanZhengMa{
    if (self.imageViewPhoneCorrect.hidden == YES) {
        self.view.backgroundColor = RGBACOLOR(240, 107, 109, 1);
        [self.view makeToast:@"请先输入正确手机号"];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@user/smser", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
//    NSString *pnsend = [[NSString alloc] initWithString:self.TFPhone.text];
//    pnsend = [pnsend  stringByReplacingOccurrencesOfString:@" " withString:@""];
    [paramsDict setObject:pnsend forKey:@"account"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.btnSendMwg.enabled = YES;
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            [self.view makeToast:@"发送成功"];
            [self beginCountDown:60];
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
         self.btnSendMwg.enabled = YES;
    }];
    

}

//发送验证码按钮倒计时
-(void)beginCountDown:(int)timeOut{
    __block int timeout=timeOut; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout==0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.btnSendMwg setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.btnSendMwg.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            if (seconds==0) {
                seconds=60;
            }
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.btnSendMwg setImage:nil forState:UIControlStateNormal];
                [self.btnSendMwg setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                self.btnSendMwg.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**
 点击BtnEye

 @param sender <#sender description#>
 */
- (IBAction)btnEyeClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.tfPwd.secureTextEntry = YES;
    }else{
        self.tfPwd.secureTextEntry = NO;
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
    
    NSLog(@"user_id === %@",[wyLogInCenter shareInstance].sessionInfo.user_id);

    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        NSMutableDictionary* paramsDict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingMutableContainers error:nil];
        NSString *status=[NSString stringWithFormat:@"%@",paramsDict[@"data"][@"code"]];
        if ([status isEqualToString:@"200"]) {
            NSLog(@"%@",paramsDict[@"data"][@"errorMessage"]);
            [[RCIM sharedRCIM] connectWithToken:paramsDict[@"data"][@"token"] success:^(NSString *userId) {
                // Connect 成功
                NSLog(@"Connect 成功");
//                [[RCIM sharedRCIM] setUserInfoDataSource:self];
                /****未读消息****/
                int unReadNum = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
                NSLog(@"未读消息数%d",unReadNum);
                if (unReadNum > 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:UNREADMESSAGE object:nil];
                }
                
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

#pragma mark - 手机账号按照344格式显示，即*** **** ****
-(void)FOrmattfPhone:(UITextField *)tfphone{
    if (tfphone == self.TFPhone) {
        if (tfphone.text.length > lengthtmp) {
            if (tfphone.text.length == 4 || tfphone.text.length == 9 ) {//输入
                NSMutableString * str = [[NSMutableString alloc ] initWithString:tfphone.text];
                [str insertString:@" " atIndex:(tfphone.text.length-1)];
                tfphone.text = (NSString*)str;
            }
//            if (tfphone.text.length >= 13 ) {//输入完成
//                tfphone.text = [tfphone.text substringToIndex:13];
//                [tfphone resignFirstResponder];
//            }
            lengthtmp = tfphone.text.length;
            
        }else if (tfphone.text.length < lengthtmp){//删除
            if (tfphone.text.length == 4 || tfphone.text.length == 9) {
                tfphone.text = [NSString stringWithFormat:@"%@",tfphone.text];
                tfphone.text = [tfphone.text substringToIndex:(tfphone.text.length-1)];
            }
            lengthtmp = tfphone.text.length;
        }
    }
    pnsend = [tfphone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - 隐藏键盘
- (IBAction)hide_keyboard:(id)sender {
}
- (UIToolbar *)addToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 33)];
    toolbar.tintColor = [UIColor blackColor];
    toolbar.backgroundColor = [UIColor lightGrayColor];
    //    UIBarButtonItem *prevItem = [[UIBarButtonItem alloc] initWithTitle:@"  <  " style:UIBarButtonItemStylePlain target:self action:@selector(prevTextField:)];
    //    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"  >  " style:UIBarButtonItemStylePlain target:self action:@selector(nextTextField:)];
    UIBarButtonItem *flbSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(textFieldDone:)];
    toolbar.items = @[flbSpace, doneItem];
    //toolbar.items = @[prevItem,nextItem,flbSpace, doneItem];
    return toolbar;
}
-(void)textFieldDone:(UIControl*)sender{
    [self.tfPwd resignFirstResponder];
    [self.TFPhone resignFirstResponder];
}
//-(void)prevTextField:(UIControl*)sender{
//    [self.tfPwd resignFirstResponder];
//    [self.TFPhone resignFirstResponder];
//}
//-(void)nextTextField:(UIControl*)sender{
//    [self.tfPwd resignFirstResponder];
//    [self.TFPhone resignFirstResponder];
//}
@end
