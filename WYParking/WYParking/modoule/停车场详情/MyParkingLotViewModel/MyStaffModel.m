//
//  MyStaffModel.m
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/20.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import "MyStaffModel.h"

@implementation MyStaffModel

- (id)initWithEmployeeName:(NSString *)employeeName imageUrl:(NSString *)imageUrl isInEditState:(NSString *)isInEditState sex:(NSString *)sex lotUser_id:(NSString *)lotuser_id
{
    if (self = [super init]) {
        
        self.employeeName = employeeName;
        self.imageUrl = imageUrl;
        self.isInEditState = isInEditState;
        self.sex = sex;
        self.lotuser_id = lotuser_id;
        
    }
    return self;
}

@end
