//
//  AlipayAndWxPay.m
//  TheGenericVersion
//
//  Created by liuqiang on 16/5/25.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "AlipayAndWxPay.h"

@implementation AlipayAndWxPay
//支付宝支付
+(void)payTHeMoneyUseAliPayWithOrderId:(NSString *)orderId totalMoney:(NSString *)totalMoney payTitle:(NSString *)payTitle type:(int)payTypeID
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
//    老的
//    NSString *partner = @"2088221665700593";
//    NSString *seller = @"cowinsmart002@163.com";
//    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKQM35CrFUTfwMpD2LtuqliQR/rJn6+DyimSwIfVSEieV6YrWnwLUMFccyMp8hZZMumfKvp2c0ufUBqEta8WTDIg0qClZBXhdF9v+NC5qNp6NF+UwG1Y/fRAC3uiLAbSXPXHkZE0H/Fqo/mRuz2NJr4v25ktRH6A+DeI9mD2Gr2rAgMBAAECgYBKgHorljbTj5ZbhVJxVMHR9LxrvZNiv0RZewcq6QapzBdcJMY0HWNwXQ8BAjSqR5oilSGMm6yixFg5otlsCYFSbHgBR942KH1X2Mmo16QjlZxleuqUEWqSvQutyUth8ojbC3py9W/Hl7byb2E6n1yA6G4G7DA7cigGE3djhpBhyQJBANJanf0fs492jRAoqdWhFHWVsmMd5sLHKvRfLdnNnLRWeaxRlnb3m7VznKP9n2lBgKGIIpO4qz6sdp7WEAeQ4fUCQQDHpgm6iDJEeXz2X8vpkdtIVoCcWbl/cN6UFWvr/DqR8k9O3t4AxBHDERZjAT/mRCUK+fSOHR8KogomeAYD2D0fAkEAnZiefSHfGUCsdsrAUvkXpvC8cV3ZoVwuZl9YrrFJEiMnjV6i6AaiddNkK8i8QdN9V4fyv9G/GnmDdYTTBZgacQJAV9K9QtW4rxB2HPbk/1kPChIrPxvlEp92+dM2hzeMGDlsE7jMFbAqVBHHNEQPdN6TIPH1VzKOPiIrruJrWvObZwJACZJZ7JOYyg12SN7jj7myr1Z+/gjRPGeKM0ZTLLe2P1ison4dKD22dySlYtFDmWqnTxMftZGFtLWWqqP3Q7IQdA==";
    NSString *partner = @"2088521415334842";
    NSString *seller = @"admin@pnpark.cn";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALJ7VroiJH6fgLw5Bsz1fufFm5G/zpGkJBKexhycU2qAoCjFYykTq6AftaytyvkRdqQ8APodcbEYQXkogZ7nM3SridZSXLJlOT6xhy37ie0McS1LFNZl+cwn886DVQgFFtu0y2j+NQyH86Q6RUJBH1Pfa7u5IZ5HziTeOsHj8DmpAgMBAAECgYBosSRcJi7V/2WaArFUhCQee7EXOzVGBMwMCAoZOjFL5YsMn0vdCma/lBoS4haPJok7KN9B1webY6j0EqiFtwRczXsFEZFinjaG+H6vMpjXrRnTpwinj/2xc8Eh3LeigViKWNI2VEOs0VSZJrFjVMQMcZxEi4wByuBtb9jHxaIByQJBAOoiSUdSIlVqatUXhbgVxMKGT2BWLqPxBqIieMZZoEjU3MNBmw8WvUIT2ldM9MJq4cwVMbmpo1/Vja4qPJqi2PcCQQDDJoMCm4J3SX+00KxYBISFhbFHscI+ouMANpmclLIxrrE+/xvECDu23HSqHzF/dHDdpTZDmpLGLgzNz4A/xHpfAkBeMZkFhneloYCFZkc3vhpAoERC36k373nZtMCeG+SuKGUAcN5u/Zj6gn4u7RjzNojM0CIHLcY6gfHUBc4H8EgVAkEArkJAcF6exJf8EmDX1IzMLVKxeByyIC5hV3pp9tkMubKNkXxJteXINMRs5NCP6Yj3k+QILZvkflT2l/03PznaLwJARFvNrpLL6ReXHQRjgYQUCyQbRnIoD0WHhzVQrn+LxKPd2vGkTcQYxxt6rOUcvAsJnlmVMYmuNgYvHGiZ4uEOiA==";    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    //    order.outTradeNO = orderId; //订单ID（由商家自行制定）
    order.outTradeNO = orderId;
    order.subject = payTitle; //商品标题
    order.body = @"车位分享"; //商品描述
//    order.totalFee = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.totalFee = totalMoney;
    if (payTypeID == 1) {
        order.notifyURL = [[NSString alloc] initWithFormat:@"%@order/new-alipay", KSERVERADDRESS]; //回调URl
    }else if (payTypeID == 2){
        //充值

        order.notifyURL = [[NSString alloc] initWithFormat:@"%@recharge/new-alipay", KSERVERADDRESS]; //回调URL
        
    }
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            //            int stateid = [resultDic[@"resultStatus"] intValue];
            //            9000 订单支付成功
            //            8000 正在处理中
            //            4000 订单支付失败
            //            6001 用户中途取消
            //            6002 网络连接出错
            //            if (stateid == 9000) {
            NSLog(@"reslut = %@",resultDic);
            
            AppDelegate *appDelegate=KappDelegate;
            int typeID = appDelegate.pageType;
            
            if ([[resultDic objectForKey:@"resultStatus"] isEqual:@"9000"]) {
                //支付成功
                if(typeID == 10000){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"zfKpaySuccess" object:nil];
                    
                }else if (typeID == 10001)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"czKpaySuccess" object:nil];
                }
                
            }else{
                if(typeID == 10000){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"zfKpayFail" object:nil];
                }else if (typeID == 10001)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"czKpayFail" object:nil];
                }

            }
        }];
    }
    
}


/**
 *  微信支付
 */
+ (void)payTheMoneyUseWeChatPayWithPrepay_id:(NSString *)prepay_id nonce_str:(NSString *)nonce_str  dic:(NSMutableDictionary *)dic
{
    if (WXApi.isWXAppInstalled) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSLog(@"%@",str);
        //调起微信支付···
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = APP_ID;//必须写
        req.partnerId           = MCH_ID;
        req.prepayId            = [NSString stringWithFormat:@"%@",prepay_id];
        req.nonceStr            = [NSString stringWithFormat:@"%@",nonce_str];
        req.timeStamp           = [str intValue];
        req.package             = @"Sign=WXpay";
        //创建支付签名对象
        payRequsestHandler *req1 =[[payRequsestHandler alloc] init];
        //初始化支付签名对象
        [req1 init:APP_ID mch_id:MCH_ID];
        //设置密钥
        [req1 setKey:PARTNER_ID];
        //第二次签名参数列表
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject: APP_ID        forKey:@"appid"];
        [signParams setObject: [NSString stringWithFormat:@"%@",nonce_str]   forKey:@"noncestr"];
        [signParams setObject: @"Sign=WXpay"      forKey:@"package"];
        [signParams setObject: MCH_ID        forKey:@"partnerid"];
        [signParams setObject: [NSString stringWithFormat:@"%d",str.intValue]   forKey:@"timestamp"];
        [signParams setObject: [NSString stringWithFormat:@"%@",prepay_id]     forKey:@"prepayid"];
        //生成签名
        NSString *signStr  = [req1 createMd5Sign:signParams];
        NSLog(@"%@",signStr);
        req.sign                =signStr;
        NSLog(@"%@",req);
        [WXApi sendReq:req];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
}

@end
