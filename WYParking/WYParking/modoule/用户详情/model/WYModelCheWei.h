//
//  WYModelCheWei.h
//  WYParking
//
//  Created by glavesoft on 17/3/3.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYModelCheWei : NSObject

//"park_title": "想边伯贤边伯贤吧",
@property (copy , nonatomic) NSString *park_title;
//"pic": "http://pnparkdev.iwocar.com/parking/api/web/images/logo/1485167698530471.jpg",
@property (copy , nonatomic) NSString *pic;
//"sale_type": "0",
@property (copy , nonatomic) NSString *sale_type;
//"is_success": "1",
@property (copy , nonatomic) NSString *is_success;
//"park_id": "2675",
@property (copy , nonatomic) NSString *park_id;
//"start_time": "00:00:00",
@property (copy , nonatomic) NSString *start_time;
//"end_time": "00:00:00",
@property (copy , nonatomic) NSString *end_time;
//"address": "江苏省常州市钟楼区北港街道星港花苑北区44栋星港花苑小区北区",
@property (copy , nonatomic) NSString *address;
//"sale_type_name": "",
@property (copy , nonatomic) NSString *sale_type_name;
//"distance": "137.4639652075526",
@property (copy , nonatomic) NSString *distance;
//"province_name": "",
@property (copy , nonatomic) NSString *province_name;
//"city_name": "",
@property (copy , nonatomic) NSString *city_name;
//"district_name": ""
@property (copy , nonatomic) NSString *district_name;


@end
