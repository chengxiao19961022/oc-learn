//
//  WYTiXianVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYTiXianVC.h"

#import "BoundZfbViewController.h"

@interface WYTiXianVC ()<UIAlertViewDelegate>{
    
    __weak IBOutlet UILabel *mTitleLab;//标题
    __weak IBOutlet UITextField *mTextField;
    
    
    __weak IBOutlet UITextField *mZfbAccountTextField;//支付宝账号
    
    __weak IBOutlet UITextField *mZfbNameTextField;//支付宝姓名
    
    BOOL firstIn;//第一次进入
}


@end

@implementation WYTiXianVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initialization];
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault]; //设置为白色
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    __weak typeof(self) weakSelf = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"提现";
    
    
    [self getBoundZfb];//是否绑定


}

-(void)initialization{
    
    firstIn = YES;

    mTextField.keyboardType = UIKeyboardTypeNumberPad;

    mZfbAccountTextField.enabled = NO;
    mZfbNameTextField.enabled = NO;
    
    mTitleLab.text = [NSString stringWithFormat:@"您要提现的金额（当前余额¥%@）",self
                      .balance];
}

#pragma mark 提现
- (IBAction)ClickWithdrawBtn:(id)sender {
    
    if ([mTextField.text isEqualToString:@""]) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow makeToast:@"请输入提现金额"];
    }else{
        
        //先去判断有没有绑定
        [self nextGetBoundZfb];
        
        
    }

}

#pragma mark 提现接口
-(void)withdraw{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.requestSerializer.timeoutInterval = 10.0f;
    
    NSMutableDictionary * parameDict = [NSMutableDictionary dictionary];
    [parameDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [parameDict setObject:mTextField.text forKey:@"money"];

    NSString * urlString = [[NSString alloc] initWithFormat:@"%@order/withdraw", KSERVERADDRESS];
    
    [manager POST:urlString parameters:parameDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //            NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
        NSString * result = [responseObject objectForKey:@"status"];
        NSString * message = [responseObject objectForKey:@"message"];
        NSLog(@"message = %@",message);
        
        if ([result isEqualToString:@"200"]){
            
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow makeToast:@"提现成功"];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] animated:YES];
            });
            
        } else if([result isEqualToString:@"104"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }else{
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow makeToast:message];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        
    }];
    
    
}



#pragma mark 获取绑定的支付宝信息
-(void)getBoundZfb{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.requestSerializer.timeoutInterval = 10.0f;
    
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
                
                //第一次进入
                if (firstIn) {
                    firstIn = NO;
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"还未绑定账号" message:@"前去绑定" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.delegate = self;
                    [alert show];
                }
                
             
                
            }else{
                mZfbAccountTextField.text = account;
                mZfbNameTextField.text = realname;
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


#pragma mark 获取绑定的支付宝信息
-(void)nextGetBoundZfb{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.requestSerializer.timeoutInterval = 10.0f;
    
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
                
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"还未绑定账号" message:@"前去绑定" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.delegate = self;
                    [alert show];
                
            }else{
                
                //前去提现
                [self withdraw];
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



#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] animated:YES];
//    
//    //前往绑定支付宝
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"GOTOBOUND" object:nil];
    

    BoundZfbViewController *boundVC = [[BoundZfbViewController alloc]init];
    [self.navigationController pushViewController:boundVC animated:YES];
    
    
        
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
