//
//  WYChuangJianTingCheChangVC.h
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"

typedef NS_ENUM(NSInteger , vctype) {
    vctypeCreate = 0,
    vctypeEdit
};

typedef void(^chuangJianTingCheChangNeedRefreshBlock)(BOOL isNeedRefresh);

@interface WYChuangJianTingCheChangVC : WYViewController



@property (copy , nonatomic) chuangJianTingCheChangNeedRefreshBlock refreshBlock;

- (void)renderWithType:(vctype)t model:(id)model;




@end
