//
//  WYModelMYOrder.h
//  WYParking
//
//  Created by glavesoft on 17/3/1.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYModelProcess : NSObject

@property (copy , nonatomic) NSString *order_id;
@property (copy , nonatomic) NSString *pro_time;
@property (copy , nonatomic) NSString *status_name;

@end

@interface WYModelMYOrder : NSObject

//"order_time": "2017-01-23 13:36:58",
@property (copy , nonatomic) NSString *order_time;
//"order_code": "2017012397505748",
@property (copy , nonatomic) NSString *order_code;
//"order_id": "2765",
@property (copy , nonatomic) NSString *order_id;
//"is_paid": "1",
@property (copy , nonatomic) NSString *is_paid;
//"plate_nu": "苏F88888",
@property (copy , nonatomic) NSString *plate_nu;
//"type": "5",
@property (copy , nonatomic) NSString *type;
//"out": "0",
@property (copy , nonatomic) NSString *Out;
//"user_id": "185",
@property (copy , nonatomic) NSString *user_id;
//"buser_id": "329",
@property (copy , nonatomic) NSString *buser_id;
//"status_code": "300",
@property (copy , nonatomic) NSString *status_code;
//"sale_status_code": "300",
@property (copy , nonatomic) NSString *sale_status_code;
//"username": "Leon",
@property (copy , nonatomic) NSString *username;
//"logo": "http://pnparkdev.iwocar.com/parking/api/web/images/logo/1484722986364269.jpg",
@property (copy , nonatomic) NSString *logo;
//"park_price": "12.00",
@property (copy , nonatomic) NSString *park_price;
//"total_price": "1.00",
@property (copy , nonatomic) NSString *total_price;
//"is_del": "0",
@property (copy , nonatomic) NSString *is_del;
//"address": "江苏省常州市钟楼区北港街道星港花苑北区44栋星港花苑小区北区",
@property (copy , nonatomic) NSString *address;
//"pic": "http://pnparkdev.iwocar.com/parking/api/web/images/logo/1485084760414863.jpg",
@property (copy , nonatomic) NSString *pic;
//"park_title": "名，你哦",
@property (copy , nonatomic) NSString *park_title;
//"sale_type": "0",
@property (copy , nonatomic) NSString *sale_type;
//"park_building": "",
@property (copy , nonatomic) NSString *park_building;
//"lnt": "119.893755",
@property (copy , nonatomic) NSString *lnt;
//"lat": "31.810087",
@property (copy , nonatomic) NSString *lat;
//"park_id": "2648",
@property (copy , nonatomic) NSString *park_id;
//"sale_type_name": "日租",
@property (copy , nonatomic) NSString *sale_type_name;
//"building": "",
@property (copy , nonatomic) NSString *building;
//"is_me": "1",
@property (copy , nonatomic) NSString *is_me;
//"status_name": "已拒绝",
//@property (copy , nonatomic) NSString *status_name;
//"all_date":"2017-01-26;2017-01-27"]
@property (copy , nonatomic) NSString *all_date;
//"start_date": "2017-01-26",
@property (copy , nonatomic) NSString *start_date;
//"end_date": "2017-01-26",
@property (copy , nonatomic) NSString *end_date;
//"start_time": "03:00:00",
@property (copy , nonatomic) NSString *start_time;
//"end_time": "05:00:00",
@property (copy , nonatomic) NSString *end_time;
//"sum": "1"
@property (copy , nonatomic) NSString *sum;

@property (copy , nonatomic) NSString *status_out_name;

@property (strong , nonatomic) NSArray *process;

@property (copy , nonatomic) NSString *saletimes_id;

@property (copy , nonatomic) NSString *pay_price;

@property (copy , nonatomic) NSString *money;

@property (copy , nonatomic) NSString *tui_price;//退款成功情况下 ，返回的价格


//"status_out_name" = "\U5f85\U786e\U8ba4";
//"total_price" = "100.00";
//type = 5;
//"user_id" = 185;
//username = "\U7b11\U5bf9\U4eba\U751f\U311f";

@end
