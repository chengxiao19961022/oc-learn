//
//  wyTiJIaoDingDanViewModel.h
//  WYParking
//
//  Created by glavesoft on 17/3/9.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^tiJiaoDingDanBlock)(BOOL flag,id model);

@interface wyTiJIaoDingDanViewModel : NSObject


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

//保存周租信息
- (void)SaveZhouZuInfoWithToken:(NSString *)token park_id:(NSString *)park_id start_date:(NSString *)start_date end_date:(NSString *)end_date start_time:(NSString *)start_time end_time:(NSString *)end_time saletimes_id:(NSString *)saletimes_id plate_nu:(NSString *)plate_nu brand_id:(NSString *)brand_id jsonstr:(NSString *)jsonstr sale_type:(NSString *)sale_type coupon_number:(NSString *)coupon_number;


//保存日租信息
- (void)saveRiZuOrderWithToken:(NSString *)token park_id:(NSString *)park_id start_date:(NSString *)start_date end_date:(NSString *)end_date start_time:(NSString *)start_time end_time:(NSString *)end_time saletimes_id:(NSString *)saletimes_id plate_nu:(NSString *)plate_nu brand_id:(NSString *)brand_id jsonstr:(NSString *)jsonstr sale_type:(NSString *)sale_type coupon_number:(NSString *)coupon_number;





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
//提交周租月租订单
- (void)submitZhouZUYueZuOrdersuccess:(tiJiaoDingDanBlock)tiJIaoBlock;

- (void)submitRiZUOrdersuccess:(tiJiaoDingDanBlock)tiJIaoBlock;
@end
