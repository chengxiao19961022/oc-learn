//
//  BoundZfbViewController.m
//  WYParking
//
//  Created by glavesoft on 17/3/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "BoundZfbViewController.h"

@interface BoundZfbViewController (){
    
    
    __weak IBOutlet UITextField *mZfbAccountTextField;//支付宝账号
    __weak IBOutlet UITextField *mzfbNameTextField;//支付宝姓名
    __weak IBOutlet UILabel *mReminderLab;//提示文字
    __weak IBOutlet UIButton *mBoundBtn;//绑定按钮
    
    BOOL ifBound;//是否绑定
    
    BOOL ifModifier;//是否修改绑定
}

@end

@implementation BoundZfbViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault]; //设置为白色
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    __weak typeof(self) weakSelf = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"绑定支付宝";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initialization];
    
    [self getBoundZfb];//获取绑定信息
}


-(void)initialization{

    ifBound = NO;
    ifModifier = NO;
    
    NSString *reminderStr = @"请确保支付宝实名和支付宝账户填写准确无误，否则将无法正常提现。";
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:reminderStr];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    
    //设置行间距
    [paragraphStyle1 setLineSpacing:5.f];
    
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [reminderStr length])];
    
    [mReminderLab setAttributedText:attributedString1];
    
}

#pragma mark 点击确定按钮
- (IBAction)clickSureBtn:(id)sender {
    
    if (!ifBound) {
        if ([mZfbAccountTextField.text isEqualToString:@""]) {
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow makeToast:@"请输入支付宝账号"];
            return;
        }else if ([mzfbNameTextField.text isEqualToString:@""]) {
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow makeToast:@"请输入支付宝姓名"];
            return;
        }else{
            
            [self boundZfb];//绑定支付宝
            
        }
    }else{
        
        ifBound = NO;
        ifModifier = YES;
        
        mZfbAccountTextField.text = @"";
        mzfbNameTextField.text = @"";
        
//        mZfbAccountTextField.enabled = YES;
//        mzfbNameTextField.enabled = YES;
        
        
        [mBoundBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
        
    }
    
   
}

#pragma mark 绑定支付宝
-(void)boundZfb{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.requestSerializer.timeoutInterval = 10.0f;
    
    NSMutableDictionary * parameDict = [NSMutableDictionary dictionary];
    [parameDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [parameDict setObject:mZfbAccountTextField.text forKey:@"account"];
    [parameDict setObject:mzfbNameTextField.text forKey:@"realname"];

    NSString * urlString = @"";
    if (ifModifier) {
        urlString = [[NSString alloc] initWithFormat:@"%@account/update", KSERVERADDRESS];
    }else{
        urlString = [[NSString alloc] initWithFormat:@"%@account/bound", KSERVERADDRESS];
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [manager POST:urlString parameters:parameDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        //            NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
        NSString * result = [responseObject objectForKey:@"status"];
        NSString * message = [responseObject objectForKey:@"message"];
        NSLog(@"message = %@",message);
        
        if ([result isEqualToString:@"200"]){
                        
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow makeToast:@"绑定成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] animated:YES];
            });
            
            
        } else if([result isEqualToString:@"104"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }else{
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        
    }];
    
    
}



#pragma mark 获取绑定的支付宝信息
-(void)getBoundZfb{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary * parameDict = [NSMutableDictionary dictionary];
    [parameDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@account/accountlist", KSERVERADDRESS];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:urlString parameters:parameDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //            NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
        NSString * result = [responseObject objectForKey:@"status"];
        NSString * message = [responseObject objectForKey:@"message"];
        NSLog(@"message = %@",message);
        
        if ([result isEqualToString:@"200"]){
            
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            
            NSString *account = dict[@"account"];
            NSString *realname = dict[@"realname"];
            
            //未绑定
            if ([account isEqualToString:@"0"]) {
                ifBound = NO;
                
//                mZfbAccountTextField.enabled = NO;
//                mzfbNameTextField.enabled = NO;

                [mBoundBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
                
            }else{
                //已绑定
                ifBound = YES;

                mZfbAccountTextField.text = account;
                mzfbNameTextField.text = realname;
                
//                mZfbAccountTextField.enabled = NO;
//                mzfbNameTextField.enabled = NO;

                [mBoundBtn setTitle:@"修改绑定" forState:UIControlStateNormal];

            }
            
            
        } else if([result isEqualToString:@"104"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }else{
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
    
    
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

@end
