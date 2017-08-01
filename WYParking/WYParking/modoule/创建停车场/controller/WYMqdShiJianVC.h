//
//  WYShiJianDuanVC.h
//  WYParking
//
//  Created by glavesoft on 17/2/20.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYModelPush.h"
#import "WYViewController.h"

//@protocol PassTimelineDelegate
//
//- (void)returnSTime:(NSString *)start_time returnETime:(NSString *)end_time;
//
//@end

@interface WYMqdShiJianVC : WYViewController

//@property (strong , nonatomic) WYModelPush *push;

//@property(nonatomic, strong) wyModelSaletimes *saletimes;

// 免确认开始时间
@property(nonatomic, strong) NSString *start_time;

// 免确认结束时间
@property(nonatomic, strong) NSString *end_time;

//@property (nonatomic, retain) id <PassTimelineDelegate> delegate;

@end
