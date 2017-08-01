//
//  MYYouhuiquanViewController.h
//  WYParking
//
//  Created by admin on 17/2/16.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"
typedef void(^youhuiQuanBlock) (id model);

@interface MYYouhuiquanViewController : WYViewController

@property (copy , nonatomic) youhuiQuanBlock yhqBlock;


@property(nonatomic,copy)NSString *rentType;//3,4表示月租，不能使用五折优惠券

@end
