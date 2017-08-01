//
//  wyModelLogin.h
//  WYParking
//
//  Created by glavesoft on 17/2/7.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "wyModeBase.h"

@interface wyModelLogin : wyModeBase

//"user_id": "202",
//"username": "sdhfdshhdfg",
//"sex": "2",
//"logo": "1234563",
//"type": "1", 1->男 2->女
//"plate_nu": "苏F95483",
//"brand_id": "18",
//"recommend_code": "123456",
//"recommend_id": "0",


//user_id": "1",
@property (copy , nonatomic) NSString *user_id;
//"username": "",
@property (copy , nonatomic) NSString *username;
//"sex": "0",
@property (copy , nonatomic) NSString *sex;
//"logo": "",
@property (copy , nonatomic) NSString *logo;
//"type": "1",
@property (copy , nonatomic) NSString *type;
//"plate_nu": "",
@property (copy , nonatomic) NSString *plate_nu;
//"brand_id": "0",
@property (copy , nonatomic) NSString *brand_id;
//"token": "_RBgwT0lskvbFny_PRLRFkdCgbHkV6ZG",
@property (copy , nonatomic) NSString *token;
//"phone": "18915037775",
@property (copy , nonatomic) NSString *phone;
//"brand_name": "",
@property (copy , nonatomic) NSString *brand_name;
//"brand_logo": "",
@property (copy , nonatomic) NSString *brand_logo;
//"user_type": "普通用户"
@property (copy , nonatomic) NSString *user_type;

@property (copy , nonatomic) NSString *pwd;
@property (copy , nonatomic) NSString *recommend_code;

@property (assign , nonatomic) BOOL isLatest;//判断用户信息是否是最新的


@end
