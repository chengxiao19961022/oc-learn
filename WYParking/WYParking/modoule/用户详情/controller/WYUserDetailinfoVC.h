//
//  WYUserDetailinfoVC.h
//  WYParking
//
//  Created by glavesoft on 17/2/22.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"

@interface WYUserDetailinfoVC : WYViewController

@property (copy , nonatomic) NSString *user_id;

@property (assign , nonatomic) BOOL isPresent;

@property (assign , nonatomic) BOOL from_mdl;

@end
