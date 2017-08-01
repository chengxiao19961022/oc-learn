//
//  wyModelNearUser.h
//  WYParking
//
//  Created by glavesoft on 17/3/1.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wyModelNearUser : NSObject

//"sex": "2",
@property (copy , nonatomic) NSString *sex;
//"logo": "http://pnparkdev.iwocar.com/parking/api/web/images/logo/1484884168782140.jpg",
@property (copy , nonatomic) NSString *logo;
//"user_id": "75",
@property (copy , nonatomic) NSString *user_id;
//"username": "双人余",
@property (copy , nonatomic) NSString *username;
//"brand_name": "宝骏",
@property (copy , nonatomic) NSString *brand_name;
//"brand_logo": "http://localhost/parking/admin/web/brand/m_157_100.imageset/m_157_100.png",
@property (copy , nonatomic) NSString *brand_logo;
//"sex_name": "女",
@property (copy , nonatomic) NSString *sex_name;
//"park_id": "",
@property (copy , nonatomic) NSString *park_id;
//"distance": "22m",
@property (copy , nonatomic) NSString *distance;
//"is_friend": "",
@property (copy , nonatomic) NSString *is_friend;
//"remark": ""
@property (copy , nonatomic) NSString *remark;
//friend
@property (copy , nonatomic) NSString *Friend;



@end
