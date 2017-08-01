//
//  WYBindPhoneVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/24.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYBindPhoneVC.h"
#import "WYLogInToastView.h"
#import "WYOldUserSetPwdVC.h"
#import <RongIMKit/RongIMKit.h>//融云
#import "WYCompleteVC.h"
//友盟
#import "UMMobClick/MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>


@interface WYBindPhoneVC (){
    dispatch_source_t _timer;
@public NSInteger lengthtmp;
}
@property (weak, nonatomic) IBOutlet UITextField *TFPhone;
@property (weak, nonatomic) IBOutlet UITextField *TFCode;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnSendMwg;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoneCorrect;
@property (assign , nonatomic) BOOL flag;
- (IBAction)hide_keyboard:(id)sender;

@end

@implementation WYBindPhoneVC

//NSInteger lengthtmp;//存放临时的手机号长度
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    lengthtmp = 0;
    [self.TFPhone addTarget:self action:@selector(FOrmattfPhone:) forControlEvents:UIControlEventEditingChanged];
    self.TFCode.inputAccessoryView = [self addToolbar];
    self.TFPhone.inputAccessoryView = [self addToolbar];
    __weak typeof(self) weakSelf = self;
    self.TFPhone.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.TFCode.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.TFPhone.rac_textSignal subscribeNext:^(NSString * x) {
        if (x.length == 13) {
            weakSelf.imageViewPhoneCorrect.hidden = NO;
        }else{
            weakSelf.imageViewPhoneCorrect.hidden = YES;
        }
    }];
    self.btnNext.layer.cornerRadius = 25.0f;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
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


- (IBAction)btnSendMsgClick:(id)sender {
    
    if (self.TFPhone.text.length!=13) {
        [self showError:@"请输入手机号" hidden:YES];
        return;
    }
    else{
        self.btnSendMwg.enabled = NO;
#pragma mark - 刷短信验证码借口
        [self FetchYanZhengMa];
    }
    
}


#pragma mark - 下一步
- (IBAction)nextClick:(id)sender {
    if (self.imageViewPhoneCorrect.hidden) {
        [self showError:@"手机号" hidden:NO];
        return;
    }
    if (self.TFCode.text.length == 0) {
        NSString *str = @"验证码";
        [self showError:str hidden:NO];
        return;
    }
#pragma mark - 刷绑定手机号接口
    [self bindPhone];
    
}

- (void)bindPhone{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString *urlString = @"";
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    urlString = [[NSString alloc] initWithFormat:@"%@user/bindphone", KSERVERADDRESS];
    NSString *pnsend = [[NSString alloc] initWithString:self.TFPhone.text];
    pnsend = [pnsend  stringByReplacingOccurrencesOfString:@" " withString:@""];
    [paramsDict setObject:pnsend forKey:@"account"];
    [paramsDict setObject:self.TFCode.text forKey:@"code"];
    
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            WYLog(@"fsafa");
            NSDictionary *dic = paramsDict[@"data"];
           
            if ([dic containsObjectForKey:@"first"]) {
                NSString *str = dic[@"first"];
                if ([str isEqualToString:@"1"]) {
                     //旧用户 1
                    [self upLoadUserInfoIsOld:YES];
                }else{
                   //新用户 0
                    [self upLoadUserInfoIsOld:NO];
                }
            }
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

- (void)upLoadUserInfoIsOld:(BOOL)flag{
    self.flag = flag;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString *urlString = @"";
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    urlString = [[NSString alloc] initWithFormat:@"%@user/thirdregister", KSERVERADDRESS];
    //    access_token	是	string	第三方登录唯一标识
    //    account	是	string	绑定的手机号
    //    logo	是	string	头像
    //    username	是	string	昵称
    //    type	是	string	类型 1QQ 2微信
    //    registerid	是	string	registerid
    //    code
    [paramsDict setObject:self.user.uid forKey:@"access_token"];
    NSString *pnsend = [[NSString alloc] initWithString:self.TFPhone.text];
    pnsend = [pnsend  stringByReplacingOccurrencesOfString:@" " withString:@""];
    [paramsDict setObject:pnsend forKey:@"account"];
    [paramsDict setObject:self.user.icon forKey:@"logo"];
    [paramsDict setObject:self.user.nickname forKey:@"username"];
    [paramsDict setObject:self.type forKey:@"type"];
    NSString *strRE = [Utils getRegisterID];
    if (!([strRE isEqualToString:@""] || strRE == nil)) {
        [paramsDict setObject:strRE forKey:@"registerid"];
    }
    [paramsDict setObject:self.TFCode.text forKey:@"code"];
    
    
    [paramsDict setObject:pnsend forKey:@"account"];
    NSString *registerStr = [Utils getRegisterID];
    if (![registerStr isEqualToString:@""]) {
        [paramsDict setObject:registerStr forKey:@"registerid"];
    }
    
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSDictionary *dic = paramsDict[@"data"];
            //是否是老用户
            if (self.flag) {
                //老用户
                if ([dic containsObjectForKey:@"is_password"]&&[dic containsObjectForKey:@"is_info"]) {
                    //用户注册到一半杀掉app,没密码，没信息
                    WYOldUserSetPwdVC *vc = WYOldUserSetPwdVC.new;
                    [wyLogInCenter shareInstance].sessionInfo.token = dic[@"token"];
                    BOOL isFormQQ = NO;
                    if ([self.type isEqualToString:@"1"]) {
                        isFormQQ = YES;
                    }else{
                        isFormQQ = NO;
                    }
                    [vc renderWith_isNewUser_NOPwd:YES userInfo:self.user withQQ:isFormQQ phone:@""];
                    [self.navigationController pushViewController:vc animated:YES];
                }else if(![dic containsObjectForKey:@"is_password"]&&![dic containsObjectForKey:@"is_info"]){
                    //老用户，有密码－》首页，有密码，有信息
                    [wyLogInCenter shareInstance].sessionInfo = [wyModelLogin mj_objectWithKeyValues:paramsDict[@"data"]];
                    [wyLogInCenter shareInstance].loginstate = wyLogInStateSuccess;
                    AppDelegate *appdelegate = KappDelegate;
                    [self getToken];
                    [appdelegate setTabBarAsRootVC];
                    // 登录，请将示例中的userid-safei替换成用户登录的ID。
                    [MobClick event:@"__login" attributes:@{@"userid":dic[@"user_id"]}];
                }
                if ([dic containsObjectForKey:@"is_password"]&&![dic containsObjectForKey:@"is_info"]) {
                    //没密码，有信息，老用户
                    WYOldUserSetPwdVC *vc = WYOldUserSetPwdVC.new;
                    [wyLogInCenter shareInstance].sessionInfo.token = dic[@"token"];
                    BOOL isFormQQ = NO;
                    if ([self.type isEqualToString:@"1"]) {
                        isFormQQ = YES;
                    }else{
                        isFormQQ = NO;
                    }

                    [vc renderWith_isNewUser_NOPwd:NO userInfo:self.user withQQ:isFormQQ phone:@""];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                if (![dic containsObjectForKey:@"is_password"]&&[dic containsObjectForKey:@"is_info"]) {
                    //有密码 没信息
                    WYCompleteVC *vc = [[WYCompleteVC alloc] init];
                    [wyLogInCenter shareInstance].sessionInfo.token = dic[@"token"];
                    vc.phone = self.TFPhone.text;
                    BOOL isFormQQ = NO;
                    if ([self.type isEqualToString:@"1"]) {
                        isFormQQ = YES;
                    }else{
                        isFormQQ = NO;
                    }
                    [vc renderWith_isNewUser_NOPwd:YES userInfo:self.user withQQ:isFormQQ withPhone:@""];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
//                老
                //是否设置密码
                if ([dic containsObjectForKey:@"is_password"]) {
                    //没设置过
                    if ([dic[@"is_password"] isEqualToString:@"0"]) {
                        [wyLogInCenter shareInstance].sessionInfo.token = dic[@"token"];
                        WYOldUserSetPwdVC *vc = WYOldUserSetPwdVC.new;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }else{
                    //设置过
                    [wyLogInCenter shareInstance].sessionInfo = [wyModelLogin mj_objectWithKeyValues:paramsDict[@"data"]];
                    [wyLogInCenter shareInstance].loginstate = wyLogInStateSuccess;
                    [self getToken];
                    AppDelegate *app = KappDelegate;
                    [app setTabBarAsRootVC];
                    // 登录，请将示例中的userid-safei替换成用户登录的ID。
                    [MobClick event:@"__login" attributes:@{@"userid":dic[@"user_id"]}];
                }
            }else{
//                新用户
                [wyLogInCenter shareInstance].sessionInfo.token = dic[@"token"];
                WYOldUserSetPwdVC *vc = WYOldUserSetPwdVC.new;
                BOOL result ;
                if ([self.type isEqualToString:@"1"]) {
                    result = YES;
                }else{
                    result = NO;
                }
                [vc renderWith_isNewUser_NOPwd:YES userInfo:self.user withQQ:result phone:self.TFPhone.text];
                [self.navigationController pushViewController:vc animated:YES];
            }
            

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
    NSString *pnsend = [[NSString alloc] initWithString:self.TFPhone.text];
    pnsend = [pnsend  stringByReplacingOccurrencesOfString:@" " withString:@""];
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


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - 手机账号按照344格式显示，即*** **** ****
-(void)FOrmattfPhone:(UITextField *)tfphone{
    if (tfphone == self.TFPhone) {
        if (tfphone.text.length > lengthtmp) {
            if (tfphone.text.length == 4 || tfphone.text.length == 9 ) {//输入
                NSMutableString * str = [[NSMutableString alloc ] initWithString:tfphone.text];
                [str insertString:@" " atIndex:(tfphone.text.length-1)];
                tfphone.text = (NSString*)str;
            }
            if (tfphone.text.length >= 13 ) {//输入完成
                tfphone.text = [tfphone.text substringToIndex:13];
                [tfphone resignFirstResponder];
            }
            lengthtmp = tfphone.text.length;
            
        }else if (tfphone.text.length < lengthtmp){//删除
            if (tfphone.text.length == 4 || tfphone.text.length == 9) {
                tfphone.text = [NSString stringWithFormat:@"%@",tfphone.text];
                tfphone.text = [tfphone.text substringToIndex:(tfphone.text.length-1)];
            }
            lengthtmp = tfphone.text.length;
        }
    }
}

#pragma mark - 隐藏键盘
- (IBAction)hide_keyboard:(id)sender {
}

//- (UIToolbar *)addToolbar {
//    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
//    toolbar.tintColor = [UIColor blackColor];
//    toolbar.backgroundColor = [UIColor lightGrayColor];
////    UIBarButtonItem *prevItem = [[UIBarButtonItem alloc] initWithTitle:@"  <  " style:UIBarButtonItemStylePlain target:self action:@selector(prevTextField:)];
////    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"  >  " style:UIBarButtonItemStylePlain target:self action:@selector(nextTextField:)];
//    UIBarButtonItem *flbSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成",nil) style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone:)];
//    //toolbar.items = @[prevItem,nextItem,flbSpace, doneItem];
//    toolbar.items = @[flbSpace, doneItem];
//    return toolbar;
//}
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
    [self.TFCode resignFirstResponder];
    [self.TFPhone resignFirstResponder];
}
//-(void)prevTextField:(UIControl*)sender{
//    [self.TFCode resignFirstResponder];
//    [self.TFPhone resignFirstResponder];
//}
//-(void)nextTextField:(UIControl*)sender{
//    [self.TFCode resignFirstResponder];
//    [self.TFPhone resignFirstResponder];
//}
@end
