//
//  WYShuLiangVC.h
//  WYParking
//
//  Created by glavesoft on 17/2/20.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYModelPush.h"
#import "WYViewController.h"

@interface WYShuLiangVC : WYViewController

@property (strong , nonatomic) WYModelPush *push;
@property(nonatomic, strong) wyModelSaletimes *saletimes;

@end
