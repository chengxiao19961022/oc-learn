//
//  WYWMVC.h
//  WYParking
//
//  Created by glavesoft on 17/3/10.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYWMVC : UIViewController

@property (nonatomic, copy) void(^wmBlock)(NSString *wmInfo,NSString *endDate);


-(void)initWithparkID:(NSString*)parkIdStr parkType:(NSString*)parkType saleTimesid:(NSString *)saletimes_id;

@end
