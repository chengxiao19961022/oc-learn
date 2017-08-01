//
//  WYModelMineSpot.h
//  WYParking
//
//  Created by glavesoft on 17/3/3.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYModelMineSpot : NSObject

//"park_title": "来了",
@property (copy , nonatomic) NSString *park_title;
//"is_success": "1",
@property (copy , nonatomic) NSString *is_success;
//"is_pass": "1",
@property (copy , nonatomic) NSString *is_pass;
//"park_id": "2306",
@property (copy , nonatomic) NSString *park_id;
//"address": "江苏省常州市钟楼区新闸街道常州市新闸中学",
@property (copy , nonatomic) NSString *address;
//"park_type": "1",
@property (copy , nonatomic) NSString *park_type;
//"pic": "http://pnparkdev.iwocar.com/parking/api/web/images/logo/1484641861543615.jpg",
@property (copy , nonatomic) NSString *pic;
//"addr_note": "测得的",
@property (copy , nonatomic) NSString *addr_note;
//"spot_name": "12"
@property (copy , nonatomic) NSString *spot_name;

@end
