//
//  WYModelPush.m
//  WYParking
//
//  Created by glavesoft on 17/2/26.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYModelPush.h"

@implementation wyModelTypePrice

@end

@implementation wyModelSaletimes

- (NSMutableArray *)json_saletype{
    if (_json_saletype == nil) {
        _json_saletype = [NSMutableArray array];
    }
    return _json_saletype;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"json_saletype":@"wyModelTypePrice"
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
              @"json_saletype":@"saletype_list"
              };
   
}

@end

@implementation WYModelPush
- (NSMutableArray *)json_saletimes{
    if (_json_saletimes == nil) {
        _json_saletimes = [NSMutableArray array];
    }
    return _json_saletimes;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"json_saletimes":@"wyModelSaletimes"
             };
}




@end
