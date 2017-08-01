//
//  wyTiJIaoDingDanViewModel.m
//  WYParking
//
//  Created by glavesoft on 17/3/9.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "wyTiJIaoDingDanViewModel.h"
#import "WYModelOrderPay.h"

@interface wyTiJIaoDingDanViewModel ()

@property (strong , nonatomic) WYModelOrderPay *payInfo;

@property (strong , nonatomic) NSDictionary *payInfoDic;

@end

@implementation wyTiJIaoDingDanViewModel


//提交日租订单
- (void)submitRiZUOrdersuccess:(tiJiaoDingDanBlock)tiJIaoBlock{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        NSString * urlString = [[NSString alloc] initWithFormat:@"%@order/dateorders", KSERVERADDRESS];
    //token	是	string	用户凭证
    //park_id	是	int	车位ID
    //start_date	是	int	开始日期 如2015-04-13
    //end_date	是	int	结束日期 如2015-04-27
    //start_time	是	int	开始时间
    //end_time	是	int	结束时间
    //saletimes_id	是	int	时间段id
    //plate_nu	是	string	车牌号
    //brand_id	是	string	汽车品牌
    //jsonstr	是	json	json格式日期数组
    //sale_type	是	string	租用类型
        [wyApiManager sendApi:urlString parameters:self.payInfoDic success:^(id obj) {
            
            [MBProgressHUD hideHUDForView:keyWindow animated:YES];
            NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
            
            if ([paramsDict[@"status"] isEqualToString:@"200"]) {
                NSLog(@"fsadfa");
                self.payInfo = [WYModelOrderPay mj_objectWithKeyValues:paramsDict[@"data"]];
                 tiJIaoBlock(YES ,_payInfo);
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


//保存日租信息
- (void)saveRiZuOrderWithToken:(NSString *)token park_id:(NSString *)park_id start_date:(NSString *)start_date end_date:(NSString *)end_date start_time:(NSString *)start_time end_time:(NSString *)end_time saletimes_id:(NSString *)saletimes_id plate_nu:(NSString *)plate_nu brand_id:(NSString *)brand_id jsonstr:(NSString *)jsonstr sale_type:(NSString *)sale_type coupon_number:(NSString *)coupon_number{
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    //token	是	string	用户凭证
    //park_id	是	int	车位ID
    //start_date	是	int	开始日期 如2015-04-13
    //end_date	是	int	结束日期 如2015-04-27
    //start_time	是	int	开始时间
    //end_time	是	int	结束时间
    //saletimes_id	是	int	时间段id
    //plate_nu	是	string	车牌号
    //brand_id	是	string	汽车品牌
    //jsonstr	是	json	json格式日期数组
    //sale_type	是	string	租用类型
    [paramsDict setObject:token forKey:@"token"];
    [paramsDict setObject:park_id forKey:@"park_id"];
    [paramsDict setObject:start_date forKey:@"start_date"];
    [paramsDict setObject:end_date forKey:@"end_date"];
    [paramsDict setObject:start_time forKey:@"start_time"];
    [paramsDict setObject:end_time forKey:@"end_time"];
    [paramsDict setObject:saletimes_id forKey:@"saletimes_id"];
    [paramsDict setObject:plate_nu forKey:@"plate_nu"];
    [paramsDict setObject:brand_id forKey:@"brand_id"];
    [paramsDict setObject:jsonstr forKey:@"jsonstr"];
    [paramsDict setObject:sale_type forKey:@"sale_type"];
    if (!(coupon_number == nil || [coupon_number isEqualToString:@""])) {
        [paramsDict setObject:coupon_number forKey:@"coupon_number"];
    }
    
    self.payInfoDic = paramsDict.copy;
}


//提交周租／月租订单
- (void)submitZhouZUYueZuOrdersuccess:(tiJiaoDingDanBlock)tiJIaoBlock{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@order/insert", KSERVERADDRESS];
       
    
    [wyApiManager sendApi:urlString parameters:self.payInfoDic success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSLog(@"fsadfa");
            self.payInfo = [WYModelOrderPay mj_objectWithKeyValues:paramsDict[@"data"]];
            tiJIaoBlock(YES ,_payInfo);
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


//保存周租信息
- (void)SaveZhouZuInfoWithToken:(NSString *)token park_id:(NSString *)park_id start_date:(NSString *)start_date end_date:(NSString *)end_date start_time:(NSString *)start_time end_time:(NSString *)end_time saletimes_id:(NSString *)saletimes_id plate_nu:(NSString *)plate_nu brand_id:(NSString *)brand_id jsonstr:(NSString *)jsonstr sale_type:(NSString *)sale_type coupon_number:(NSString *)coupon_number{
     NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:token forKey:@"token"];
    [paramsDict setObject:park_id forKey:@"park_id"];
    [paramsDict setObject:start_date forKey:@"start_date"];
    [paramsDict setObject:end_date forKey:@"end_date"];
    [paramsDict setObject:start_time forKey:@"start_time"];
    [paramsDict setObject:end_time forKey:@"end_time"];
    [paramsDict setObject:saletimes_id forKey:@"saletimes_id"];
    [paramsDict setObject:plate_nu forKey:@"plate_nu"];
    [paramsDict setObject:brand_id forKey:@"brand_id"];
    [paramsDict setObject:jsonstr forKey:@"jsonstr"];
    [paramsDict setObject:sale_type forKey:@"sale_type"];
    if (!(coupon_number == nil || [coupon_number isEqualToString:@""])) {
        [paramsDict setObject:coupon_number forKey:@"coupon_number"];
    }
    self.payInfoDic = paramsDict.copy;
}

@end
