//
//  WYForgetPwdVC.m
//  WYParking
//
//  Created by glavesoft on 17/3/7.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYForgetPwdVC.h"
#import "WYLogInToastView.h"

@interface WYForgetPwdVC (){
    dispatch_source_t _timer;
    NSInteger lengthtmp;//存放临时的手机号长度
    NSMutableString *pnsend;
    
}
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSendMsg;
@property (weak, nonatomic) IBOutlet UITextField *TFPhone;
@property (weak, nonatomic) IBOutlet UITextField *TFYZM;
@property (weak, nonatomic) IBOutlet UITextField *TFPwd;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoneCorrect;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *btnEye;

//private
@property(assign , nonatomic) forgetPwdType type;

@end

@implementation WYForgetPwdVC


- (void)viewDidLoad {
    [super viewDidLoad];
    lengthtmp=0;
    // Do any additional setup after loading the view from its nib.
    [self.btnEye setBackgroundImage:[UIImage imageNamed:@"dl_mm_eye"] forState:UIControlStateNormal];
    [self.btnEye setBackgroundImage:[UIImage imageNamed:@"dl_mm_noeye"] forState:UIControlStateSelected];
    self.btnNext.layer.cornerRadius = 25.0f;
    self.TFPhone.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.TFYZM.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.TFPwd.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.btnNext.layer.masksToBounds = YES;
    [self.TFPhone addTarget:self action:@selector(FormattfPhone:) forControlEvents:UIControlEventEditingChanged];
    @weakify(self);
    [self.TFPhone.rac_textSignal subscribeNext:^(NSString * x) {
        @strongify(self);
        if (pnsend.length == 11) {
            self.imageViewPhoneCorrect.hidden = NO;
            [self.TFPhone resignFirstResponder];
        }else{
            self.imageViewPhoneCorrect.hidden = YES;
        }
        if (pnsend.length > 11) {
            [self.view makeToast:@"输入手机号长度超过11位"];
        }
    
    }];

    self.TFYZM.inputAccessoryView = [self addToolbar];
    self.TFPhone.inputAccessoryView = [self addToolbar];
    self.TFPwd.inputAccessoryView = [self addToolbar];
    self.imageViewPhoneCorrect.hidden = YES;
    if (self.type == forgetPwdTypePayPwd) {
        self.labTitle.text = @"重置支付密码验证";
    }
}

- (void)renderViewWithType:(forgetPwdType)type{
    self.type = type;
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
- (IBAction)btnBackClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

#pragma mark - 获取验证码
- (IBAction)btnSendMsgClick:(id)sender {
    [self.TFPhone resignFirstResponder];
    if (self.imageViewPhoneCorrect.hidden == NO) {
        //手机号正确
#pragma mark - 刷接口
        [self FetchYanZhengMa];
        
    }else{
        [self showError:@"手机号" hidden:NO];
    }
}

- (void)FetchYanZhengMa{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@user/smser", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
//    NSString *pnsend = [[NSString alloc] initWithString:self.TFPhone.text];
//    pnsend = [pnsend  stringByReplacingOccurrencesOfString:@" " withString:@""];
    [paramsDict setObject:pnsend forKey:@"account"];
    self.btnSendMsg.enabled = NO;
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.btnSendMsg.enabled = YES;
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
        self.btnSendMsg.enabled = YES;
    }];
    
    
}

#pragma mark - 下一步
- (IBAction)btnNextClick:(id)sender {
        if (self.imageViewPhoneCorrect.hidden == YES) {
            [self showError:@"手机号" hidden:NO];
            return;
        }
        if (self.TFYZM.text.length == 0) {
            [self showError:@"验证码" hidden:NO];
            return;
        }
        if (self.type == forgetPwdTypePayPwd) {
            if (self.TFPwd.text.length != 6) {
                [self showError:@"请输入6位数字的支付密码" hidden:YES];
                return;
            }
//            NSString *pnsend = [[NSString alloc] initWithString:self.TFPhone.text];
//            pnsend = [pnsend  stringByReplacingOccurrencesOfString:@" " withString:@""];
            [self resetPayPwd:self.TFPwd.text Phone:pnsend code:self.TFYZM.text];
        }else{
            if (!([Utils verifyPwd:self.TFPwd.text])) {
                [self showError:@"密码必须6～12位,只含数字和密码" hidden:YES];
                return;
            }
#pragma mark - 刷设置新密码接口
            @weakify(self);
//            NSString *pnsend = [[NSString alloc] initWithString:self.TFPhone.text];
//            pnsend = [pnsend  stringByReplacingOccurrencesOfString:@" " withString:@""];
            [[wyLogInCenter shareInstance] findPwdWithPhone:pnsend password:self.TFPwd.text code:self.TFYZM.text registerID:nil isSuccess:^(BOOL isSuccess, NSString *errorMes) {
                @strongify(self);
                if (isSuccess) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        ;
                    }];
                }else{
                    [self showError:errorMes hidden:YES];
                }
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
                [self.btnSendMsg setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.btnSendMsg.userInteractionEnabled = YES;
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
                [self.btnSendMsg setImage:nil forState:UIControlStateNormal];
                [self.btnSendMsg setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                self.btnSendMsg.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (IBAction)btnEyeClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.TFPwd.secureTextEntry = YES;
    }else{
        self.TFPwd.secureTextEntry = NO;
    }
}

- (void)resetPayPwd:(NSString *)payPwd Phone:(NSString *)phone code:(NSString *)code {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@set/findpwd", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
//    account	是	string	手机号
//    code	否	string	验证码
//    pwd	否	string	密码
      [paramsDict setObject:phone forKey:@"account"];
      [paramsDict setObject:code forKey:@"code"];
      [paramsDict setObject:payPwd forKey:@"pwd"];
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
            [keyWindow makeToast:paramsDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

#pragma mark - 手机账号按照344格式显示，即*** **** ****
-(void)FormattfPhone:(UITextField *)tfphone{
    if (tfphone == self.TFPhone) {
        if (tfphone.text.length > lengthtmp) {
            if (tfphone.text.length == 4 || tfphone.text.length == 9 ) {//输入
                NSMutableString * str = [[NSMutableString alloc ] initWithString:tfphone.text];
                [str insertString:@" " atIndex:(tfphone.text.length-1)];
                tfphone.text = (NSString*)str;
            }
//            if (pnsend.length >= 13 ) {//输入完成
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
    [self.TFYZM resignFirstResponder];
    [self.TFPwd resignFirstResponder];
    [self.TFPhone resignFirstResponder];
}

@end
