//
//  WYYongHuFanKui.m
//  WYParking
//
//  Created by glavesoft on 17/2/23.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYYongHuFanKui.h"

@interface WYYongHuFanKui ()
@property (weak, nonatomic) IBOutlet UITextView *TVFanKui;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交按钮

@end

@implementation WYYongHuFanKui
{
    BOOL _wasKeyboardManagerEnabled;
}

- (wyModelLogin *)sessionInfo{
    if (_sessionInfo == nil) {
        _sessionInfo = [[wyModelLogin alloc] init];
    }
    return _sessionInfo;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    __weak typeof(self) weakSelf = self;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault]; //设置为白色
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"用户反馈";
    self.TVFanKui.placeholder = @"请为我们提供宝贵意见";
    self.TVFanKui.inputAccessoryView = [self addToolbar];
    self.TVFanKui.layer.borderWidth = 0.7;
    self.TVFanKui.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击提交
- (IBAction)btnCommitClick:(id)sender {
    
    if ([self.TVFanKui.text isEqualToString:@""]) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        [keyWindow makeToast:@"请输入反馈信息"];
        return;
    }
    
    [self submit];
}

-(void)submit{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.requestSerializer.timeoutInterval = 10.0f;
    
    NSMutableDictionary * parameDict = [NSMutableDictionary dictionary];
    [parameDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [parameDict setObject:self.TVFanKui.text forKey:@"content"];
    
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@feedback/submit", KSERVERADDRESS];
    
    [manager POST:urlString parameters:parameDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //            NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
        NSString * result = [responseObject objectForKey:@"status"];
        NSString * message = [responseObject objectForKey:@"message"];
        NSLog(@"message = %@",message);
        
        if ([result isEqualToString:@"200"]){
            
            self.submitBtn.userInteractionEnabled = NO;
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow makeToast:@"发送成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] animated:YES];
                        });
            
        } else if([result isEqualToString:@"104"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }else{
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        
    }];
    
    
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
}-(void)textFieldDone:(UIControl*)sender{
    [self.TVFanKui resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
