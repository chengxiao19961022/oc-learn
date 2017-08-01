//
//  MyStaffModel.h
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/20.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyStaffModel : NSObject

//"lotuser_id": "225",
//"name": "一个人",
//"pic": "http://pnparkdev.iwocar.com/parking/api/web/images/logo/1487226647586094.jpg",
//"phone": "17756035793",
//"sex": "1"

@property (copy,nonatomic) NSString *employeeName;
@property (copy,nonatomic) NSString *imageUrl;
@property (copy,nonatomic) NSString *isInEditState;//0-->未编辑状态  1-->编辑状态
@property (copy,nonatomic) NSString *sex; //0-->男  1-->女
@property (copy , nonatomic) NSString *lotuser_id;

- (id)initWithEmployeeName:(NSString *)employeeName imageUrl:(NSString *)imageUrl isInEditState:(NSString *)isInEditState sex:(NSString *)sex lotUser_id:(NSString *)lotuser_id;

@end
