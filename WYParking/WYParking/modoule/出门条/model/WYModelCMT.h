//
//  WYModelCMT.h
//  WYParking
//
//  Created by glavesoft on 17/3/13.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYModelCMT : NSObject
//"order_id": "3",
@property (copy , nonatomic) NSString *order_id;
//"order_code": "2016042157571025",
@property (copy , nonatomic) NSString *order_code;
//"username": "大神强",
@property (copy , nonatomic) NSString *username;
//"plate_nu": "苏B21345",
@property (copy , nonatomic) NSString *plate_nu;
//"start_date": "2016-04-21",
@property (copy , nonatomic) NSString *start_date;
//"end_date": "2016-04-27",
@property (copy , nonatomic) NSString *end_date;
//"start_time": "04:00:00",
@property (copy , nonatomic) NSString *start_time;
//"end_time": "12:00:00",
@property (copy , nonatomic) NSString *end_time;
//"address": "",
@property (copy , nonatomic) NSString *address;
//"province_name": "",
@property (copy , nonatomic) NSString *province_name;
//"city_name": "",
@property (copy , nonatomic) NSString *city_name;
//"district_name": "",
@property (copy , nonatomic) NSString *district_name;
//"time_code": "1",
@property (copy , nonatomic) NSString *time_code;
//"code_name": "超时"
@property (copy , nonatomic) NSString *code_name;
//   "type": "日租",
@property (copy , nonatomic) NSString *type;
@property (copy , nonatomic) NSString *building;
@property (copy , nonatomic) NSString *park_title;


@end
