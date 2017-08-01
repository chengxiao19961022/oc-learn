//
//  WYCarDetaiInfo.h
//  WYParking
//
//  Created by glavesoft on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"

@interface WYCarDetaiInfo : WYViewController

@property (assign , nonatomic) BOOL isMe;

@property (assign , nonatomic) BOOL isPresent;

@property (assign , nonatomic) BOOL from_mdl;

//必须
@property (copy , nonatomic) NSString *park_id;

@end
