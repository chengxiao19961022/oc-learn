//
//  WYJiaGeVC.h
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYModelPush.h"
#import "WYViewController.h"

@interface WYJiaGeVC : WYViewController

@property (strong , nonatomic) WYModelPush *push;

@property(nonatomic, strong) wyModelSaletimes *saletimes;

@end
