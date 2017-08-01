//
//  CalendarModel.h
//  TheGenericVersion
//
//  Created by liuqiang on 16/5/4.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarModel : NSObject


@property(nonatomic,copy)NSString * date;

@property(nonatomic,copy)NSString * day;

@property(nonatomic,copy)NSString * is_buy;

@property(nonatomic,copy)NSString * is_end;

@property(nonatomic,copy)NSString * is_me;

@property(nonatomic,copy)NSString * is_start;

@property(nonatomic,copy)NSString * is_weekend;

@property(nonatomic,copy)NSString * is_holiday;

@property(nonatomic,copy)NSString * month;

@property(nonatomic,copy)NSString * year;

@property(nonatomic,copy)NSString * is_choose;

@property (nonatomic , copy) NSString *can_sale_num;

@end
