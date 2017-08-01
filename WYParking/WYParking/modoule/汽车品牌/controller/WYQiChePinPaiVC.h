//
//  WYQiChePinPaiVC.h
//  WYParking
//
//  Created by glavesoft on 17/2/23.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"

@interface WYQiChePinPaiVC : WYViewController

@property (nonatomic, copy)void(^selectCarCompleteBlock)(void);

@property (copy,nonatomic) NSString *brand_id;
@property (copy,nonatomic) NSString *brand_name;

@end
