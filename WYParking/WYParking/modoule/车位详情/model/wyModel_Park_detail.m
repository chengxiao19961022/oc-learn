//
//  wyModel_Park_detail.m
//  WYParking
//
//  Created by glavesoft on 17/3/1.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "wyModel_Park_detail.h"

@implementation wyModelJudge

@end

@implementation wyModelSaleType

@end

@implementation wyMOdelTime

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"saletype_list":@"wyModelSaleType"
             };
}
@end

@implementation wyModel_Park_detail

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"comment":@"wyModelJudge",
             @"time_quantum":@"wyMOdelTime"
             };
}

@end
