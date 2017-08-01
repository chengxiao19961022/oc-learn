//
//  WYEditPwdVC.m
//  WYParking
//
//  Created by glavesoft on 17/3/7.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYEditPwdVC.h"
#import "WYLogInToastView.h"

@interface WYEditPwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *TFOldpwd;
@property (weak, nonatomic) IBOutlet UITextField *TFNewPwd;
@property (weak, nonatomic) IBOutlet UIImageView *ImageViewPwdCorrect;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnEye;


- (IBAction)hide_keyboard:(id)sender;
//private
@property(assign , nonatomic) editPwdType type;

@end

@implementation WYEditPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.btnEye setBackgroundImage:[UIImage imageNamed:@"dl_mm_eye"] forState:UIControlStateNormal];
    [self.btnEye setBackgroundImage:[UIImage imageNamed:@"dl_mm_noeye"] forState:UIControlStateSelected];
    self.btnNext.layer.cornerRadius = 25.0f;
    self.btnNext.layer.masksToBounds = YES;
    self.TFOldpwd.secureTextEntry = YES;
    self.TFOldpwd.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.TFNewPwd.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.TFOldpwd.inputAccessoryView = [self addToolbar];
    self.TFNewPwd.inputAccessoryView = [self addToolbar];
    @weakify(self);
    [self.TFOldpwd.rac_textSignal subscribeNext:^(NSString * x) {
         @strongify(self);
        if ([Utils verifyPwd:x]) {
            self.ImageViewPwdCorrect.hidden = NO;
        }else{
            self.ImageViewPwdCorrect.hidden = YES;
        }
    }];
    
    if (self.type == editPwdTypePayPwd) {
        self.labTitle.text = @"修改支付密码";
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)renderViewWithType:(editPwdType)type{
    self.type = type;
}


- (IBAction)btnNextClick:(id)sender {
    if (self.type == editPwdTypePayPwd) {
        [self modifyPayPwd];
    }else{
        if ([Utils verifyPwd:self.TFNewPwd.text] == NO) {
            [self showError:@"输入长度在6~12由英文数字组成的密码" hidden:YES];
            return;
        }
        @weakify(self);
        [[wyLogInCenter shareInstance]  editPwdWithOld:self.TFOldpwd.text New:self.TFNewPwd.text isSuccess:^(BOOL isSuccess,NSString *err) {
            @strongify(self);
            if (isSuccess) {
                AppDelegate *app = KappDelegate;
                [app loginAction];
            }else{
                [self showError:err hidden:YES];
            }
        }];
    }
    
}

#pragma mark - 支付密码
- (void)modifyPayPwd{
    if (self.TFOldpwd.text == nil || self.TFNewPwd.text == nil || self.TFOldpwd.text.length != 6 || self.TFOldpwd.text.length !=6 ) {
        [self showError:@"支付密码为6位数字" hidden:YES];
        return;
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@set/updatepwd", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
//    oldpwd	是	string	旧密码
//    newpwd
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:self.TFNewPwd.text forKey:@"newpwd"];
    [paramsDict setObject:self.TFOldpwd.text forKey:@"oldpwd"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
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
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
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
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

/**
 点击BtnEye
 
 @param sender <#sender description#>
 */
- (IBAction)btnEyeClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.TFNewPwd.secureTextEntry = YES;
    }else{
        self.TFNewPwd.secureTextEntry = NO;
    }
}

#pragma mark -  隐藏键盘
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
    [self.TFNewPwd resignFirstResponder];
    [self.TFOldpwd resignFirstResponder];
}
@end
