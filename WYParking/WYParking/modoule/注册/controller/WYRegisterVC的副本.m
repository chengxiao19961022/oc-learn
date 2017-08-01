//
//  WYRegisterVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/14.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYRegisterVC.h"
#import "WYCompleteVC.h"
#import "wyLogInCenter.h"
#import "WYLogInToastView.h"

@interface WYRegisterVC (){
    dispatch_source_t _timer;
}

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoneCorrect;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;
@property (weak, nonatomic) IBOutlet UITextField *tfRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnSendMwg;

@property (weak, nonatomic) IBOutlet UIButton *btnEye;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
- (IBAction)HideKeyboard:(id)sender;




@end

@implementation WYRegisterVC

NSInteger lengthtmp;//存放临时的手机号长度
- (void)viewDidLoad {
    [super viewDidLoad];
    lengthtmp=0;
    [self.btnEye setBackgroundImage:[UIImage imageNamed:@"dl_mm_eye"] forState:UIControlStateNormal];
    [self.btnEye setBackgroundImage:[UIImage imageNamed:@"dl_mm_noeye"] forState:UIControlStateSelected];
    self.btnNext.layer.cornerRadius = 25.0;
    [self.tfPhone.rac_textSignal subscribeNext:^(NSString * x) {
        if (x.length == 13) {
            self.imageViewPhoneCorrect.hidden = NO;
        }else{
            self.imageViewPhoneCorrect.hidden = YES;
        }
        if (x.length > 13) {
            [self.view makeToast:@"输入手机号长度超过11位"];
        }
    }];
    [self.tfPhone addTarget:self action:@selector(FormattfPhone:) forControlEvents:UIControlEventEditingChanged];
    self.imageViewPhoneCorrect.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    __weak typeof(self) weakSelf = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];

}




- (IBAction)btnEyeClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.tfPwd.secureTextEntry = YES;
    }else{
        self.tfPwd.secureTextEntry = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 点击获取验证码
- (IBAction)btnRegisterClick:(id)sender {
    
    
    if (self.tfPhone.text.length!=13) {
        [self.view makeToast:@"请输入正确手机号码"];
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
    NSString *pnsend = [[NSString alloc] initWithString:self.tfPhone.text];
    pnsend = [pnsend  stringByReplacingOccurrencesOfString:@" " withString:@""];
    [paramsDict setObject:pnsend forKey:@"account"];
//    [pnsend release];
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

#pragma mark - 下一步
- (IBAction)btnNextClick:(id)sender {
    
    if (self.imageViewPhoneCorrect.hidden == YES) {
        [self showError:@"手机号" hidden:NO];
        return;
    }
    
    if (self.tfRegister.text.length == 0) {
         [self showError:@"验证码" hidden:NO];
        return;
    }
    if (self.tfPwd.text.length == 0) {
        [self showError:@"密码" hidden:NO];
        return;
    }
    if (self.tfPwd.text.length < 6 || self.tfPwd.text.length > 12) {
        [self showError:@"登录密码长度限制为6~12位" hidden:YES];
        return;
    }
    
//    account	是	string	手机号
//    code	是	string	验证码
//    password	否	string	密码
//    registerid
    @weakify(self);
    [[wyLogInCenter shareInstance] signUpAccount:self.tfPhone.text code:self.tfRegister.text pwd:self.tfPwd.text Result:^(BOOL isSuccess) {
        @strongify(self);
        if (isSuccess) {
            WYCompleteVC *vc =WYCompleteVC.new;
            vc.phone = self.tfPhone.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
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


#pragma mark - 手机账号按照344格式显示，即*** **** ****
-(void)FormattfPhone:(UITextField *)tfphone{
    if (tfphone == self.tfPhone) {
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
//- (void)FormattfPhone:(UITextField*)tfphone{
//    NSString *tempStr = [NSMutableString new];
//    int spaceCount = 0;
//    if (self.tfPhone.text.length <3 && self.tfPhone.text.length>-1){
//        spaceCount = 0;
//    }else if(self.tfPhone.text.length <7 && self.tfPhone.text.length>2){
//        spaceCount = 1;
//    }else if(self.tfPhone.text.length <12 && self.tfPhone.text.length>6){
//        spaceCount = 2;
//    }
//
//    for(int i = 0; i< spaceCount; i++){
//        if(i==0){
//            [tempStr stringByAppendingFormat:@"%@%@",[self.tfPhone.text substringWithRange:NSMakeRange(0,3)],@" "];
//        }else if(i == 1){
//            [tempStr stringByAppendingFormat:@"%@%@",[self.tfPhone.text substringWithRange:NSMakeRange(3,4)],@" "];
//        }else if(i == 2){
//            [tempStr stringByAppendingFormat:@"%@%@",[self.tfPhone.text substringWithRange:NSMakeRange(7,4)],@" "];
//        }
//    }
//    tfphone.text = tempStr;
//}

- (IBAction)HideKeyboard:(id)sender {
    //self.btnDone.enabled = NO;
    [self.tfPwd resignFirstResponder];
    [self.tfRegister resignFirstResponder];
}
@end
