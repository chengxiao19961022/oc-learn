//
//  AppDelegate.h
//  WYParking
//
//  Created by glavesoft on 17/2/6.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) int pageType;//支付是否成功

@property (nonatomic , copy) NSArray *From;
// 前一位为标志位
// 0:个人中心
// 1:订单
// 2:消息
// 3:车场
// 4:附近的人
// 5:主页
// 其他

- (void)changeRootController:(UIViewController *)controller animated:(BOOL)animated;

- (void)setTabBarAsRootVC;

- (void)loginAction;

@end

