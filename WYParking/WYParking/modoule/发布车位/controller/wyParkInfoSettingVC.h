//
//  wyParkInfoSettingVC.h
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/6.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYModelPush.h"
#import "WYViewController.h"

@protocol UIViewPassValueDelegate

@required
-(void)passValuelat:(NSString*)lat passValuelnt:(NSString*)lnt;

@end

@interface wyParkInfoSettingVC : WYViewController


@property (assign , nonatomic) BOOL isFromMineSpotVC;

@property (strong , nonatomic) WYModelPush *push;



@end
