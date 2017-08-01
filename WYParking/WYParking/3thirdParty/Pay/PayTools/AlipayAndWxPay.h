//
//  AlipayAndWxPay.h
//  TheGenericVersion
//
//  Created by liuqiang on 16/5/25.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "WXApi.h"
#import "payRequsestHandler.h"

@interface AlipayAndWxPay : NSObject
/**
 *  支付宝
 */
+(void)payTHeMoneyUseAliPayWithOrderId:(NSString *)orderId totalMoney:(NSString *)totalMoney payTitle:(NSString *)payTitle type:(int)payTypeID;
/**
 *  微信
 */
+ (void)payTheMoneyUseWeChatPayWithPrepay_id:(NSString *)prepay_id nonce_str:(NSString *)nonce_str dic:(NSMutableDictionary *)dic;
@end
