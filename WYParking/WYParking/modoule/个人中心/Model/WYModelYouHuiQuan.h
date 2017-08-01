//
//  WYModelYouHuiQuan.h
//  WYParking
//
//  Created by glavesoft on 17/3/18.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYModelYouHuiQuan : NSObject
//"id": "9",
@property (copy , nonatomic) NSString *ID;
//"coupon_id": 17,
@property (copy , nonatomic) NSString *coupon_id;//优惠券识别标识（旧传回参数）
//"phone": "15850551450",
@property (copy , nonatomic) NSString *phone;//用户识别标识
//"coupon_number": "1489745683782035",
@property (copy , nonatomic) NSString *coupon_number;//新传回参数
//"discount_margin": "9.5",
@property (copy , nonatomic) NSString *discount_margin;
//"start_date": "2017-03-18",
@property (copy , nonatomic) NSString *start_date;
//"end_date": "2017-04-17",
@property (copy , nonatomic) NSString *end_date;
//"created_at": 1489748161,
@property (copy , nonatomic) NSString *created_at;
//"is_check": 0,
@property (copy , nonatomic) NSString *is_check;
//"is_del": 0,
@property (copy , nonatomic) NSString *is_del;
//"type": 1
@property (copy , nonatomic) NSString *type;//获得方式，0分享所得，1领取所得
@property (copy , nonatomic) NSString *is_use;
@property (copy , nonatomic) NSString *coupon_type;//优惠券类型，0折扣券 1代金券
@property (copy , nonatomic) NSString *min_consumption;//使用条件，满**元使用
@property (copy , nonatomic) NSString *create_date;//获得优惠券的时间
@property (copy , nonatomic) NSString *distribute_type;//领取所得优惠券的途径，1活动所得 2新用户 3全员发送 4支付完成
@property (copy , nonatomic) NSString *parklot;//适用停车场（目前为全部）





@end
