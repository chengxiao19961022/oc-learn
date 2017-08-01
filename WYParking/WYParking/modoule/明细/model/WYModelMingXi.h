//
//  WYModelMingXi.h
//  WYParking
//
//  Created by glavesoft on 17/3/16.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYModelDetail : NSObject
//"account_in" = "-3.00";
//"created_at" = "2017-03-16 18:05:58";
//"date_time" = "2017\U5e7403\U6708";
//"order_code" = 2017031698555054;
//"order_id" = 3043;
//"sale_type" = 0;
//"sale_type_name" = "";
//"status_code" = 200;
//"status_out_name" = "\U5f85\U786e\U8ba4";
//type = 3;
//username = Leon;
//value = "\U652f\U4ed8";

@property (copy,nonatomic) NSString *account_in;
@property (copy,nonatomic) NSString *order_code;
@property (copy,nonatomic) NSString *status_code;
@property (copy,nonatomic) NSString *status_out_name;
@property (copy,nonatomic) NSString *order_id;
@property (copy,nonatomic) NSString *type;
@property (copy,nonatomic) NSString *value;
@property (copy,nonatomic) NSString *username;
@property (copy,nonatomic) NSString *sale_type;
@property (copy,nonatomic) NSString *created_at;
@property (copy,nonatomic) NSString *sale_type_name;
@property (copy,nonatomic) NSString *style;

@end

@interface WYModelMingXi : NSObject

@property (strong , nonatomic) NSMutableArray *data;

@property (copy , nonatomic) NSString *month;


@end
