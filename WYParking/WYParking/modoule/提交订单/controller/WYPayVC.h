//
//  WYPayVC.h
//  WYParking
//
//  Created by glavesoft on 17/2/27.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"
@class WYModelOrderPay;

@interface WYPayVC : WYViewController

- (void)renderViewWithPayOrder:(WYModelOrderPay *)model;

@end
