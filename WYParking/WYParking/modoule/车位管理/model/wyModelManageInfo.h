//
//  wyModelManageInfo.h
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/13.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wyModelManageInfo : NSObject
//
//"addr_note" = "";
//address = "\U6c5f\U82cf\U7701\U6cf0\U5dde\U5e02\U9756\U6c5f\U5e02\U65b0\U6865\U9547\U6cbf\U6c5f\U8def";
//"is_pass" = 1;
//"is_success" = 1;
//"park_id" = 2251;
//"park_title" = "\U54e6\U54e6\U54e6";
//"park_type" = 1;
//pic = "http://pnparkdev.iwocar.com/parking/api/web/images/logo/1484294557255912.jpg";

@property (copy , nonatomic) NSString *addr_note;

@property (copy , nonatomic) NSString *address;

@property (copy , nonatomic) NSString *is_pass;

@property (copy , nonatomic) NSString *is_success;

@property (copy , nonatomic) NSString *park_id;

@property (copy , nonatomic) NSString *park_title;

@property (copy , nonatomic) NSString *park_type; //1 表示需要 2 表示不需要停车场

@property (copy , nonatomic) NSString *pic;

@property (copy , nonatomic) NSString *lat;

@property (copy , nonatomic) NSString *lnt;

@property (copy , nonatomic) NSString  *parklot_id;





@end
