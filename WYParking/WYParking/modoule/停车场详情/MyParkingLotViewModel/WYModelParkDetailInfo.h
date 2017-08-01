//
//  WYModelParkDetailInfo.h
//  WYParking
//
//  Created by glavesoft on 17/3/7.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYModelParkDetailInfo : NSObject
//
//"parklot_id": "82",
@property (copy , nonatomic) NSString *parklot_id;
//"user_id": "367",
@property (copy , nonatomic) NSString *user_id;
//"district_id": "0",
@property (copy , nonatomic) NSString *district_id;
//"address": "一个人123",
@property (copy , nonatomic) NSString *address;
//"lat": "31.808331",
@property (copy , nonatomic) NSString *lat;
//"lnt": "119.894332",
@property (copy , nonatomic) NSString *lnt;
//"building": "一个人",
@property (copy , nonatomic) NSString *building;
//"type": "0",
@property (copy , nonatomic) NSString *type;
//"business_license_pic": "http://101.200.122.47/parking/api/web/images/logo/1462527170557154.jpg",
@property (copy , nonatomic) NSString *business_license_pic;
//"fee_standard_pic": "",
@property (copy , nonatomic) NSString *fee_standard_pic;
//"realname": "yigeren",
@property (copy , nonatomic) NSString *yigeren;
//"phone": "",
@property (copy , nonatomic) NSString *phone;
//"email": "",
@property (copy , nonatomic) NSString *email;
//"identification": "341222199204049553",
@property (copy , nonatomic) NSString *identification;
//"identification_pic": "http://101.200.122.47/parking/api/web/images/logo/1462527212243676.jpg",
@property (copy , nonatomic) NSString *identification_pic;
//"status": "1",
@property (copy , nonatomic) NSString *status;
//"bill": "0",
@property (copy , nonatomic) NSString *bill;
//"recommend": "0",
@property (copy , nonatomic) NSString *recommend;
//"created_at": "1488765496",
@property (copy , nonatomic) NSString *created_at;
//"updated_at": "1488765496",
@property (copy , nonatomic) NSString *updated_at;
//"is_del": "0"
@property (copy , nonatomic) NSString *is_del;

@end
