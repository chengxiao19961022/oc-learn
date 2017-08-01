//
//  WYModelOrderPay.h
//  WYParking
//
//  Created by glavesoft on 17/3/10.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYModelOrderPay : NSObject

//buliding = "";
@property (copy , nonatomic) NSString *buliding;
//day = 3;
@property (copy , nonatomic) NSString *day;
//"end_date" = "2017-3-24";
@property (copy , nonatomic) NSString *end_date;
//"order_code" = 2017031052995256;
@property (copy , nonatomic) NSString *order_code;
//"park_title" = "\U8981\U597d\U597d"
@property (copy , nonatomic) NSString *park_title;;
//"sale_type" = 5;
@property (copy , nonatomic) NSString *sale_type;
//"sale_type_name" = "\U65e5\U79df";
@property (copy , nonatomic) NSString *sale_type_name;
//"start_date" = "2017-3-15";
@property (copy , nonatomic) NSString *start_date;
//"total_price" = 300;
@property (copy , nonatomic) NSString *total_price;
@property (copy , nonatomic) NSString *pay_price;
@property (copy , nonatomic) NSString *saletimes_id;//自己赋值
@property (copy , nonatomic) NSString *park_id;//自己赋值
@property (copy , nonatomic) NSString *order_id;//自己赋值
@property (copy , nonatomic) NSString *money;//自己赋值

//"park_id": "2510",
//"order_id": "3227",
//"saletimes_id": "3250",
//"park_title": "中关村停车场",
//"start_date": "2017-03-22",
//"end_date": "2017-03-25",
//"day": "1",
//"order_code": "2017032052974899",
//"buliding": "",
//"sale_type": "6",
//"sale_type_name": "日租（节假日不租）",
//"total_price": 25,
//"pay_price": 23.75

@end
