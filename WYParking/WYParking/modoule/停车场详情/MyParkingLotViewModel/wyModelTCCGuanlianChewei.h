//
//  wyModelTCCGuanlianChewei.h
//  WYParking
//
//  Created by glavesoft on 17/3/7.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wyModelTCCGuanlianChewei : NSObject
//"pic": "http://101.200.122.47/parking/api/web/images/logo/1476960033930547.jpg",
@property (copy , nonatomic) NSString *pic;
//"park_title": "gsgsgsg",
@property (copy , nonatomic) NSString *park_title;
//"address": "江苏省常州市新北区三井街道创意路",
@property (copy , nonatomic) NSString *address;
//"distance": "9.2km"
@property (copy , nonatomic) NSString *distance;

@end
