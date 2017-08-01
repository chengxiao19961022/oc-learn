//
//  WYOldUserSetPwdVC.h
//  WYParking
//
//  Created by glavesoft on 17/2/24.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"
typedef NS_ENUM(NSInteger,oldUserPwdType) {
    oldUserPwdTypePwd = 0,
    oldUserPwdTypePayPwd
};

@interface WYOldUserSetPwdVC : WYViewController

- (void)renderWith:(oldUserPwdType)type;

- (void)renderWith_isNewUser_NOPwd:(BOOL)isNewUser_NOPwd userInfo:(id)model withQQ:(BOOL)flag phone:(NSString *)phone;


@end
