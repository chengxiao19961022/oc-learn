//
//  WYEditPwdVC.h
//  WYParking
//
//  Created by glavesoft on 17/3/7.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"
typedef NS_ENUM(NSInteger , editPwdType) {
    editPwdTypeLoginPwd = 0,
    editPwdTypePayPwd
};

@interface WYEditPwdVC : WYViewController

- (void)renderViewWithType:(editPwdType)type;

@end
