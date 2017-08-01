//
//  WYModelMYOrder.m
//  WYParking
//
//  Created by glavesoft on 17/3/1.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYModelMYOrder.h"

@implementation WYModelProcess

@end

@implementation WYModelMYOrder
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{
              @"Out":@"out"
              };
};


+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"process":@"WYModelProcess"
             };
}

@end



