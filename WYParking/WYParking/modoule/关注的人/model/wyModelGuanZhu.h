//
//  wyModelGuanZhu.h
//  WYParking
//
//  Created by glavesoft on 17/3/3.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wyModelGuanZhu : NSObject

//"username": "我是谁",
@property (copy , nonatomic) NSString *username;
//"user_id": "6",
@property (copy , nonatomic) NSString *user_id;
//"sex": "1",
@property (copy , nonatomic) NSString *sex;
//"brand_name": "奔驰",
@property (copy , nonatomic) NSString *brand_name;
//"brand_logo": "http://localhost/parking/admin/web/brand/m_2_100.imageset/m_2_100.png",
@property (copy , nonatomic) NSString *brand_logo;
//"sex_name": "男",
@property (copy , nonatomic) NSString *sex_name;
//"park_id": "17",
@property (copy , nonatomic) NSString *park_id;
//"address": "中科创业中心",
@property (copy , nonatomic) NSString *address;
//"building": "哦了",
@property (copy , nonatomic) NSString *building;
//"sale_type": "1",
@property (copy , nonatomic) NSString *sale_type;
//"distance": "12819.8km",
@property (copy , nonatomic) NSString *distance;
//"sale_type_name": "周租"
@property (copy , nonatomic) NSString *sale_type_name;
@property (copy , nonatomic) NSString *logo;

@end
