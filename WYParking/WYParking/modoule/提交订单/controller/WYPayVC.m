//
//  WYPayVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/27.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYPayVC.h"
#import "WYModelOrderPay.h"
#import "UIImage+ImageEffects.h"
#import "wyPayShareView.h"
#import "AlipayAndWxPay.h"
#import "WYOldUserSetPwdVC.h"
#import "WYChongZhiFangShiVC.h"
#import "WYModelYouHuiQuan.h"
#import "MYYouhuiquanViewController.h"
#import "wyModel_Park_detail.h"
#import "wyTiJIaoDingDanViewModel.h"
//友盟
#import "UMMobClick/MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>


//ShareSDK
//#import <ShareSDK/ShareSDK.h>


typedef NS_ENUM(NSInteger , payType) {
    payTypeYUE = 0,
    payTypeWX,
    payTypezhiFuBao
};

@interface WYPayVC ()<UITextFieldDelegate>{
        UIView * blurView;
        UIView * toastView;
        UIImageView *digitImageViews[6];
        int index;//1->支付成功 2->余额不足
}
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (strong, nonatomic) IBOutlet UIView *tbHeaderView;
@property (weak, nonatomic) IBOutlet UIView *yuEView;
@property (weak, nonatomic) IBOutlet UIView *WXView;
@property (weak, nonatomic) IBOutlet UIImageView *zhiFuBaoImageView;
@property (weak, nonatomic) IBOutlet UIView *zhiFuBaoView;
@property (weak, nonatomic) IBOutlet UIImageView *yuEImageView;
@property (weak, nonatomic) IBOutlet UIImageView *WXImageView;
@property (weak, nonatomic) IBOutlet UILabel *labYouHuiQuan;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (assign , nonatomic) payType paytype;
@property (weak, nonatomic) IBOutlet UILabel *labYuE;

//private
@property (strong , nonatomic) WYModelOrderPay *payOrder;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (nonatomic,strong) UITextField* passwordTextField;


@property (strong , nonatomic) wyTiJIaoDingDanViewModel *orderVM;

@property (strong , nonatomic) wyModel_Park_detail *park_detail_model;//从payVC传过来

@end

@implementation WYPayVC

- (WYModelOrderPay *)payOrder{
    if (_payOrder == nil) {
        _payOrder = [[WYModelOrderPay alloc] init];
    }
    return _payOrder;
}

//vm
- (wyTiJIaoDingDanViewModel *)orderVM{
    if (_orderVM == nil) {
        _orderVM = [[wyTiJIaoDingDanViewModel alloc] init];
    }
    return _orderVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.paytype = payTypeYUE;
    // Do any additional setup after loading the view from its nib.
    self.tbView.tableHeaderView = self.tbHeaderView;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    @weakify(self);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    self.title = @"支付";

    [self.yuEView bk_whenTapped:^{
        @strongify(self);
        self.paytype = payTypeYUE;
        self.yuEImageView.image = [UIImage imageNamed:@"sz_tcsxx"];
         self.WXImageView.image = [UIImage imageNamed:@"sz_tcs"];
         self.zhiFuBaoImageView.image = [UIImage imageNamed:@"sz_tcs"];
    }];
    
    
    [self.WXView bk_whenTapped:^{
        @strongify(self);
        self.paytype = payTypeWX;
        self.yuEImageView.image = [UIImage imageNamed:@"sz_tcs"];
        self.WXImageView.image = [UIImage imageNamed:@"sz_tcsxx"];
        self.zhiFuBaoImageView.image = [UIImage imageNamed:@"sz_tcs"];
    }];
    [self.zhiFuBaoView bk_whenTapped:^{
        @strongify(self);
        self.paytype = payTypezhiFuBao;
        self.yuEImageView.image = [UIImage imageNamed:@"sz_tcs"];
        self.WXImageView.image = [UIImage imageNamed:@"sz_tcs"];
        self.zhiFuBaoImageView.image = [UIImage imageNamed:@"sz_tcsxx"];
    }];
    
    [_passwordTextField addTarget:self action:@selector(passcodeChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.labTitle.text = [NSString stringWithFormat:@"订单总额%@元,您还需支付%@元",self.payOrder.total_price,self.payOrder.pay_price];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"zfKpaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailure) name:@"zfKpayFail" object:nil];
    
    self.labYuE.text = [NSString stringWithFormat:@"余额支付（当前余额，%@）",self.payOrder.money];
//    if (self.payOrder.park_id == nil) {
//        [self fetchFenXiangInfo];
//    }
    
}

//- (void)fetchFenXiangInfo{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    NSString * urlString = [[NSString alloc] initWithFormat:@"%@order/checkoutsuccess", KSERVERADDRESS];
//    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
//    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
//    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
//        
//        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
//        
//        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
//        
//        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
//            self.dataSource = [wyModelHomeTop mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
//            [self.collectionView reloadData];
//            if (self.dataSource.count == 0) {
//                self.hidden = YES;
//            }
//        }
//        else if([paramsDict[@"status"] isEqualToString:@"104"])
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
//        }
//        else
//        {
//            [keyWindow makeToast:paramsDict[@"message"]];
//        }
//        
//    } failuer:^(NSError *error) {
//        [keyWindow makeToast:@"请检查网络"];
//        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
//        
//    }];
//}

- (void)payFailure{
    [self.view makeToast:@"支付失败,可到我的订单中查看"];
}

- (void)paySuccess{
    index = 1;
    [self clickBlur];
}

//- (void)fetchYouHuiQuan

- (void)renderViewWithPayOrder:(WYModelOrderPay *)model{
    self.payOrder = model;
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
- (IBAction)payAciton:(id)sender {
    //开始付费，请将示例中的lixiaoming替换成用户的用户id；请将1000556789替换成流水号，如订单号或时间戳;请将” 新手礼包”替换成用户准备购买的装备名称或购买的实际内容park_id?；请将180替换成购买的金额。
    [MobClick event:@"__submit_payment" attributes:@{@"userid":[wyLogInCenter shareInstance].sessionInfo.user_id,@"orderid":self.payOrder.order_id,@"item":self.payOrder.park_title,@"amount":self.payOrder.total_price}];
    
    if (self.paytype == payTypezhiFuBao) {
        WYLog(@"支付宝");
        AppDelegate *app = KappDelegate;
        app.pageType = 10000;
        [AlipayAndWxPay payTHeMoneyUseAliPayWithOrderId:self.payOrder.order_code totalMoney:self.payOrder.pay_price payTitle:@"车位分享" type:1];
    }else if (self.paytype == payTypeWX){
         WYLog(@"微信");
        [self WXpayFunc:self.payOrder.order_code];
    }
    else if (self.paytype == payTypeYUE){
         WYLog(@"余额支付");
        [self checkPwd];
    }
    WYLog(@"支付完成");
    
}

#pragma mark - 微信支付
//微信支付
-(void)WXpayFunc:(NSString*)rechargecode
{
    self.payBtn.userInteractionEnabled = YES;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@order/new-wxpay", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    
    [paramsDict setObject:rechargecode forKey:@"order_code"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *tempDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        NSLog(@"%@",paramsDict);
        if ([tempDict[@"status"] isEqualToString:@"200"]) {
            
            NSDictionary * orderInfoDict = tempDict[@"data"];
            AppDelegate *app = KappDelegate;
            app.pageType = 10000;
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



#pragma mark - 余额支付
-(void)pocketPayMethod:(NSString * )pwdStr
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@order/cashpay", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:self.payOrder.order_code forKey:@"order_code"];
    [paramsDict setObject:pwdStr forKey:@"pwd"];
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSMutableDictionary *tempDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        NSLog(@"%@",paramsDict);
        if ([tempDict[@"status"] isEqualToString:@"200"]) {
            index = 1;
            [self clickBlur];
        }
        else if ([tempDict[@"status"] isEqualToString:@"401"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }else if ([tempDict[@"status"] isEqualToString:@"300"])
        {
            [self.view makeToast:@"订单不存在"];
        }else if ([tempDict[@"status"] isEqualToString:@"301"])
        {
            index = 2;
            [self clickBlur];
        }else if ([tempDict[@"status"] isEqualToString:@"302"])
        {
            [self.view makeToast:@"内部服务出错"];
        }else if ([tempDict[@"status"] isEqualToString:@"305"])
        {
//            self.passwordTextField.text = @"";
//            pwdErrAlert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                     message:@"支付密码错误" delegate:self
//                                           cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            pwdErrAlert.tag = 1002;
//            [pwdErrAlert show];
            UIAlertView *Alert = [[UIAlertView alloc] bk_initWithTitle:@"提示" message:@"支付密码错误"];
            [Alert bk_addButtonWithTitle:@"确定" handler:^{
                WYLog(@"支付密码错误");
                [self clickBlur];
            }];
            [Alert show];
        }
        
        
        
    } failuer:^(NSError *error) {
        [self.view makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}



#pragma mark - 检查是否设置密码
-(void)checkPwd
{
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@set/checkpwd", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        NSMutableDictionary *tempDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        NSLog(@"%@",paramsDict);
        if ([tempDict[@"status"] isEqualToString:@"200"]) {
            
            [self setToast:self.payOrder.pay_price];
            [UIView animateWithDuration:0.3 animations:^{
                blurView.frame = [UIScreen mainScreen].bounds;
                [_passwordTextField becomeFirstResponder];
            }];
            
        }
        else if ([tempDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }else if ([tempDict[@"status"] isEqualToString:@"101"])
        {
            
            UIAlertView *setPwdAlert = [[UIAlertView alloc] bk_initWithTitle:@"提示" message:@"尚未设置支付密码，请到‘个人中心’设置支付密码"];
            [setPwdAlert bk_addButtonWithTitle:@"确定" handler:^{
                WYOldUserSetPwdVC *vc = WYOldUserSetPwdVC.new;
                [vc renderWith:oldUserPwdTypePayPwd];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self.navigationController presentViewController:nav animated:YES completion:^{
                    ;
                }];
            }];
           [setPwdAlert bk_setCancelButtonWithTitle:@"取消" handler:^{
               [self clickBlur];
           }];
            [setPwdAlert show];
            
        }
        else
        {
            
            [self.view makeToast:tempDict[@"message"]];
            
        }
        
    } failuer:^(NSError *error) {
        [self.view makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    
}

//设置支付毛玻璃界面
-(void)setToast:(NSString *)moneyStr
{
    blurView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    [self.view addSubview:blurView];
    
    UIImage * blurIMG = [Utils getImage:self.view.size view:self.view];
    UIImageView * bgImgView = [[UIImageView alloc]initWithImage:blurIMG];
    bgImgView.frame = blurView.frame;
    [bgImgView setImage:[blurIMG applyBlurWithRadius:5 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil]];
    blurView.layer.contents = (id)bgImgView.image.CGImage;
    
    //提示
    toastView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/6, kScreenHeight/2.5, kScreenWidth*2/3, kScreenHeight/4+8)];
    toastView.backgroundColor = [UIColor whiteColor];
    
    
    //提示文字
    UILabel * toastTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, toastView.width, 30)];
    toastTitle.backgroundColor = kNavigationBarBackGroundColor;
    toastTitle.text = @"请输入支付密码";
    toastTitle.textColor = [UIColor whiteColor];
    toastTitle.font = [UIFont systemFontOfSize:13];
    [toastTitle setTextAlignment:NSTextAlignmentCenter];
    
    //关闭按钮
    UIButton * closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    closeBtn.backgroundColor =kNavigationBarBackGroundColor;
    [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [closeBtn addTarget:self action:@selector(clickBlur) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * fukuan = [[UILabel alloc]initWithFrame:CGRectMake(0, toastTitle.bottom+20, toastView.width, 20)];
    fukuan.text = @"付款";
    fukuan.textAlignment = NSTextAlignmentCenter;
    //    fukuan.textColor = [UIColor whiteColor];
    fukuan.font = [UIFont systemFontOfSize:13];
    
    UILabel * money = [[UILabel alloc]initWithFrame:CGRectMake(0, fukuan.bottom+8, toastView.width, 20)];
    money.text = [NSString stringWithFormat:@"%@",moneyStr];
    money.textAlignment = NSTextAlignmentCenter;
    money.textColor = RGBACOLOR(112, 212, 245, 1);
    money.font = [UIFont systemFontOfSize:15];
    
    //输入框框
    
    //添加到toastView
    [toastView addSubview:toastTitle];
    [toastView addSubview:closeBtn];
    [toastView addSubview:fukuan];
    [toastView addSubview:money];
    
    
    
    UIImageView* imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(8, money.bottom+30, toastView.width-16, 30)];
    [imageview1 setImage:[UIImage imageNamed:@"kuang4"]];
    imageview1.userInteractionEnabled = YES;
    [toastView addSubview:imageview1];
    _passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, toastView.width, 45)];
    _passwordTextField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTextField.tintColor = [UIColor clearColor];
    _passwordTextField.textColor = [UIColor clearColor];
    _passwordTextField.delegate = self;
    [_passwordTextField addTarget:self action:@selector(passcodeChanged:) forControlEvents:UIControlEventEditingChanged];
    [imageview1 addSubview:_passwordTextField];
    
    for(int i = 0;i < 6; i++)
    {
        digitImageViews[i] = [[UIImageView alloc]initWithFrame:CGRectMake(toastView.width/6*i, 4, 25, 25)];
        [digitImageViews[i] setImage:[UIImage imageNamed:@"dian1"]];
        digitImageViews[i].autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [imageview1 addSubview:digitImageViews[i]];
        [digitImageViews[i] setHidden:YES];
    }
    
    
    
    [blurView addSubview:toastView];
    
    UITapGestureRecognizer * blurTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBlur)];
    [blurView addGestureRecognizer:blurTap];
}

//点击隐藏毛玻璃
-(void)clickBlur
{
    [UIView animateKeyframesWithDuration:0.1 delay:0 options:0 animations:^{
        [_passwordTextField resignFirstResponder];
        blurView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        
        self.payBtn.userInteractionEnabled = YES;
        
        //支付成功显示红包分享界面
        if (index == 1) {
            wyPayShareView *successView = [wyPayShareView view];
            successView.frame = CGRectMake(0, 0, 300, 350);
            successView.layer.contents = (id)[UIImage imageNamed:@"hb"].CGImage;
            successView.btnShareToFriend.layer.cornerRadius = 5.0f;
            successView.btnCancle.layer.cornerRadius = 5.0f;
            successView.btnCancle.layer.masksToBounds = successView.btnShareToFriend.layer.masksToBounds = YES;
            KLCPopup *popup = [KLCPopup popupWithContentView:successView showType:KLCPopupShowTypeFadeIn dismissType:KLCPopupDismissTypeFadeOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
            KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter);
            [popup showWithLayout:layout];
            @weakify(self);
            [successView.btnCancle bk_addEventHandler:^(id sender) {
                //取消——点击“不了”
                [popup dismiss:YES];
                @strongify(self);
                [[NSNotificationCenter defaultCenter] postNotificationName:WYHomeVCNeedReFresh object:@""];
                [self.navigationController popToRootViewControllerAnimated:NO];
            } forControlEvents:UIControlEventTouchUpInside];
            [successView.btnShareToFriend bk_addEventHandler:^(id sender) {
                //分享——点击“分享给好友”
                [popup dismiss:YES];
                @strongify(self);
                [self.navigationController popToRootViewControllerAnimated:NO];
                [self postOrderID:self.payOrder.order_id];
            } forControlEvents:UIControlEventTouchUpInside];
            
            //付费成功，请将示例中的lixiaoming替换成用户的用户id；请将1000556789替换成流水号，如订单号或时间戳;请将” 新手礼包”替换成用户准备购买的装备名称或购买的实际内容；请将180替换成购买的金额。
            [MobClick event:@"__finish_payment" attributes:@{@"userid":[wyLogInCenter shareInstance].sessionInfo.user_id,@"orderid":self.payOrder.order_id,@"item":self.payOrder.park_title,@"amount":self.payOrder.total_price}];
            
        }else if(index == 2){

            UIAlertView *setPwdAlert = [[UIAlertView alloc] bk_initWithTitle:@"提示" message:@"当前余额不足，请先充值"];
            [setPwdAlert bk_addButtonWithTitle:@"去充值" handler:^{
                WYChongZhiFangShiVC *vc = WYChongZhiFangShiVC.new;
                [self.navigationController pushViewController:vc animated:YES];
                
            }];
             @weakify(self);
            [setPwdAlert bk_addButtonWithTitle:@"取消" handler:^{
                [_passwordTextField resignFirstResponder];
            }];
            
            [setPwdAlert show];
        }
    }];
    
}

- (void)postOrderID:(NSString *)order_id{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@order/sharecoupon", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:order_id forKey:@"order_id"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSDictionary *dic = paramsDict[@"data"];
            if ([dic containsObjectForKey:@"coupon_number"]) {
                NSString *couponNum = dic[@"coupon_number"];
                [self doShareActionWithCoupon:couponNum];
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


- (void)doShareActionWithCoupon:(NSString *)coupon{
    
    //标题
    WYLog(@"分享好友，领停车红包|车位分享");
    NSString *titleStr = @"分享好友，领停车红包|车位分享";
    
    
    //内容
    NSMutableString * textStr = [NSMutableString stringWithFormat:@"%@喊你来停车。PnPark车位分享特供，手慢无~",[wyLogInCenter shareInstance].sessionInfo.username];
    
    //分享参数
    NSString *str = [NSString stringWithFormat:@"%@parking/home/web/index.php/wx/infocode",apiHosr];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?sale_type=%@&saletimes_id=%@&user_id=%@&park_id=%@&order_id=%@&coupon_number=%@",str,self.payOrder.sale_type,self.payOrder.saletimes_id,[wyLogInCenter shareInstance].sessionInfo.user_id,self.payOrder.park_id,self.payOrder.order_id,coupon];
    NSArray* imageArray = @[[UIImage imageNamed:@"icon120"]];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:textStr
                                     images:imageArray
                                        url:[NSURL URLWithString:urlStr]
                                      title:titleStr
                                       type:SSDKContentTypeAuto];
    
    [shareParams SSDKEnableUseClientShare];
    
    
    
    SSDKPlatformType platFormType = SSDKPlatformSubTypeWechatSession;
  
    [ShareSDK share: platFormType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"                                                         message:nil                                                               delegate:nil                                                       cancelButtonTitle:@"确定"                                                      otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"                                                              message:[NSString stringWithFormat:@"%@",error]                                                   delegate:nil                               cancelButtonTitle:@"OK"                                                  otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            default:
                break;
        }
    }];
    
    
}

- (void)passcodeChanged:(id)sender
{
    NSString* text = _passwordTextField.text;
    if ([text length] > 6) {
        text = [text substringToIndex:6];
    }
    for (int i=0;i<6;i++) {
        digitImageViews[i].hidden = i >= [text length];
    }
    if ([text length] == 6)
    {
        //        [self.view endEditing:YES];
        _passwordTextField.enabled = NO;
        //判断密码对错
        /**
         *  返回密码 进行支付操作
         */
        [self pocketPayMethod:_passwordTextField.text];
        
    }
}


@end
