//
//  WYChongZhiFangShiVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYChongZhiFangShiVC.h"
#import "AlipayAndWxPay.h"

@interface WYChongZhiFangShiVC (){
    
    __weak IBOutlet UITextField *mTextField;
    __weak IBOutlet UIView *mWXbgView;//微信
    __weak IBOutlet UIView *mAlibgView;//支付宝
    
    __weak IBOutlet UIImageView *mWXimgView;
    __weak IBOutlet UIImageView *mAliimgView;
    
    __weak IBOutlet UIButton *mRechargeBtn;//充值按钮
    int mPayWay;/*
                 0 未选择
                 1 微信
                 2 支付宝
                 */
}

@end

@implementation WYChongZhiFangShiVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initialization];
    
    
    //充值成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AliPaySuccess) name:@"czKpaySuccess" object:nil];

    
    //充值成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AliPayFailure) name:@"czKpayFail" object:nil];
    
}
//czKpayFail

#pragma mark 支付宝充值成功
-(void)AliPaySuccess{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow makeToast:@"充值成功"];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] animated:YES];
    });
    
    
}
#pragma mark 支付宝充值失败
-(void)AliPayFailure{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow makeToast:@"充值失败"];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault]; //设置为白色
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    __weak typeof(self) weakSelf = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"充值";
}

-(void)initialization{
    
    mTextField.borderStyle = UITextBorderStyleNone;
    mTextField.keyboardType = UIKeyboardTypeNumberPad;
    mTextField.placeholder = @"0.00";
    [mTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];


    mPayWay = 0;
    mWXimgView.image = [UIImage imageNamed:@"sz_tcs"];
    mAliimgView.image = [UIImage imageNamed:@"sz_tcs"];

    mWXbgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *wxRecoginzer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WXPay)];
    [mWXbgView addGestureRecognizer:wxRecoginzer];
    
    mAlibgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *aliPayRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AliPay)];
    
    [mAlibgView addGestureRecognizer:aliPayRecognizer];
}


#pragma mark
- (void)textFieldDidChange:(UITextField *) textField{
    NSLog(@"text=======%@",textField.text);

    
}


#pragma mark 选择微信
-(void)WXPay{
    mWXimgView.image = [UIImage imageNamed:@"sz_tcsxx"];
    mAliimgView.image = [UIImage imageNamed:@"sz_tcs"];
    mPayWay = 1;
}

#pragma mark 选择支付宝
-(void)AliPay{
    mWXimgView.image = [UIImage imageNamed:@"sz_tcs"];
    mAliimgView.image = [UIImage imageNamed:@"sz_tcsxx"];
    mPayWay = 2;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 下一步

- (IBAction)btnNextClick:(id)sender {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([mTextField.text isEqualToString:@""]) {
        [keyWindow makeToast:@"请输入充值金额"];
        return;
    }
    if (mPayWay == 0) {
        [keyWindow makeToast:@"请选择充值方式"];
        return;
    }else{
        
        AppDelegate *delegate = KappDelegate;
        delegate.pageType = 10001;
        
        
        mRechargeBtn.userInteractionEnabled = NO;

        [self getOrderCode];
    }

    
}
-(void)getOrderCode{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.requestSerializer.timeoutInterval = 10.0f;
    
    NSMutableDictionary * parameDict = [NSMutableDictionary dictionary];
    [parameDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
        [parameDict setObject:mTextField.text forKey:@"money"];
//    [parameDict setObject:@"0.01" forKey:@"money"];
    
    
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@recharge/order", KSERVERADDRESS];
    
    [manager POST:urlString parameters:parameDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        mRechargeBtn.userInteractionEnabled = YES;
        
        //            NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
        NSString * result = [responseObject objectForKey:@"status"];
        NSString * message = [responseObject objectForKey:@"message"];
        NSLog(@"message = %@",message);
        
        if ([result isEqualToString:@"200"]){
            
            NSString *orderCode = [[responseObject objectForKey:@"data"] objectForKey:@"recharge_code"];
            
            if (mPayWay == 1){
                
                //微信
                [self WXpayFunc:orderCode];
                
            }else{
                //支付宝
                [AlipayAndWxPay payTHeMoneyUseAliPayWithOrderId:orderCode totalMoney:mTextField.text payTitle:@"车位分享" type:2];
//                [AlipayAndWxPay payTHeMoneyUseAliPayWithOrderId:orderCode totalMoney:@"0.01" payTitle:@"车位分享" type:2];

            }
            
        } else if([result isEqualToString:@"104"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }else{
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        mRechargeBtn.userInteractionEnabled = YES;
        
    }];
    
    
}

#pragma mark - 微信支付
//微信支付
-(void)WXpayFunc:(NSString*)rechargecode
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@recharge/new-wxpay", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    
    [paramsDict setObject:rechargecode forKey:@"order_code"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *tempDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        NSLog(@"%@",paramsDict);
        if ([tempDict[@"status"] isEqualToString:@"200"]) {
            
            NSDictionary * orderInfoDict = tempDict[@"data"];
            [AlipayAndWxPay payTheMoneyUseWeChatPayWithPrepay_id:orderInfoDict[@"prepay_id"] nonce_str:orderInfoDict[@"nonce_str"] dic:tempDict[@"data"]];
        }
        else if ([tempDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }else
        {
            [self.view makeToast:tempDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [self.view makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
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
