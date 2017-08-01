//
//  WYModelPark_info.h
//  WYParking
//
//  Created by glavesoft on 17/3/17.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYModelPark_info : NSObject
//address = "\U6c5f\U82cf\U7701\U5e38\U5dde\U5e02\U949f\U697c\U533a\U5317\U6e2f\U8857\U9053\U7389\U9f99\U5357\U8def";
@property (copy , nonatomic) NSString*address;
//bill = 1;
@property (copy , nonatomic) NSString*bill;
//mqd = 1;
@property (copy , nonatomic) NSString*is_auto;
//building = "\U5362\U505c\U8f66\U573a";
@property (copy , nonatomic) NSString*building;
//"business_license_pic" = "http://pnparkdev.iwocar.com/parking/api/web/images/logo/1489729637949118.jpg";
@property (copy , nonatomic) NSString*business_license_pic;
//"created_at" = 1489729661;
@property (copy , nonatomic) NSString*created_at;
//"district_id" = 0;
@property (copy , nonatomic) NSString*district_id;
//email = "";
@property (copy , nonatomic) NSString*email;
//"fee_standard_pic" = "";
@property (copy , nonatomic) NSString*fee_standard_pic;
//identification = 321086545677877776;
@property (copy , nonatomic) NSString*identification;
//"identification_pic" = "http://pnparkdev.iwocar.com/parking/api/web/images/logo/1489729658269251.jpg";
@property (copy , nonatomic) NSString*identification_pic;
//"is_del" = 0;
@property (copy , nonatomic) NSString*is_del;
//"is_employe" = 2;
@property (copy , nonatomic) NSString*is_employe;
//lat = "31.808210";
@property (copy , nonatomic) NSString*lat;
//lnt = "119.894357";
@property (copy , nonatomic) NSString*lnt;
//"parklot_id" = 100;
@property (copy , nonatomic) NSString*parklot_id;
//phone = "";
@property (copy , nonatomic) NSString*phone;
//realname = "\U5362";
@property (copy , nonatomic) NSString*realname;
//recommend = 0;
@property (copy , nonatomic) NSString*recommend;
//status = 3;
@property (copy , nonatomic) NSString*status;
//type = 0;
@property (copy , nonatomic) NSString*type;
//"updated_at" = 1489729661;
@property (copy , nonatomic) NSString*updated_at;
//"user_id" = 451;
@property (copy , nonatomic) NSString*user_id;

@property (copy , nonatomic) NSString*auto_agree_start;

@property (copy , nonatomic) NSString*auto_agree_end;

@end
