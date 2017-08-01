//
//  WYSearchModel.h
//  WYParking
//
//  Created by glavesoft on 17/3/6.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYSearchModel : NSObject

//"user_id": "65",
@property (copy , nonatomic) NSString *user_id;
//"username": "停车啊",
@property (copy , nonatomic) NSString *username;
//"sex": "1",
@property (copy , nonatomic) NSString *sex;
//"logo": "http://101.200.122.47/parking/api/web/images/logo/1472056902744324.jpg",
@property (copy , nonatomic) NSString *logo;
//"type": "3",
@property (copy , nonatomic) NSString *type;
//"plate_nu": "甘U111AA",
@property (copy , nonatomic) NSString *plate_nu;
//"registerid": "",
@property (copy , nonatomic) NSString *registerid;
//"brand_id": "18",
@property (copy , nonatomic) NSString *brand_id;
//"recommend_code": "111111",
@property (copy , nonatomic) NSString *recommend_code;
//"is_recommend": "0",
@property (copy , nonatomic) NSString *is_recommend;
//"recommend_id": "64",
@property (copy , nonatomic) NSString *recommend_id;
//"address": "",
@property (copy , nonatomic) NSString *address;
//"lnt": "119.992406",
@property (copy , nonatomic) NSString *lnt;
//"lat": "31.810255",
@property (copy , nonatomic) NSString *lat;
//"paypwd": "e10adc3949ba59abbe56e057f20f883e",
@property (copy , nonatomic) NSString *paypwd;
//"order_status": "0",
@property (copy , nonatomic) NSString *order_status;
//"created_at": "1462523354",
@property (copy , nonatomic) NSString *created_at;
//"updated_at": "1482304202",
@property (copy , nonatomic) NSString *updated_at;
//"is_del": "0"
@property (copy , nonatomic) NSString *is_del;

@property (copy , nonatomic) NSString *distance;

@end
