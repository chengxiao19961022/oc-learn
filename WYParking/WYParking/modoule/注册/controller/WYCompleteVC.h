//
//  WYCompleteVC.h
//  WYParking
//
//  Created by glavesoft on 17/2/14.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"

@interface WYCompleteVC : WYViewController

@property (copy, nonatomic) NSString *phone;

- (void)renderWith_isNewUser_NOPwd:(BOOL)isNewUser_NOPwd userInfo:(id)model withQQ:(BOOL)flag withPhone:(NSString *)phone;

@end
