//
//  WYModelYouHuiQuan.m
//  WYParking
//
//  Created by glavesoft on 17/3/18.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYModelYouHuiQuan.h"

@implementation WYModelYouHuiQuan

//id是Objective-C里的关键字，我们一般用大写的ID替换，但是往往服务器给我们的数据是小写的id，这个时候就可以用MJExtension框架里的方法转换一下：
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID":@"id"
             };
}

@end
