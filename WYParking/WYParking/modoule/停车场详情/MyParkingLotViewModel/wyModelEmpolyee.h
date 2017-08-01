//
//  wyModelEmpolyee.h
//  WYParking
//
//  Created by glavesoft on 17/3/7.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wyModelEmpolyee : NSObject
//"lotuser_id": "225",
@property (copy , nonatomic) NSString *lotuser_id;
//"name": "一个人",
@property (copy , nonatomic) NSString *name;
//"pic": "http://pnparkdev.iwocar.com/parking/api/web/images/logo/1487226647586094.jpg",
@property (copy , nonatomic) NSString *pic;
//"phone": "17756035793",
@property (copy , nonatomic) NSString *phone;
//"sex": "1"
@property (copy , nonatomic) NSString *sex;

@end
