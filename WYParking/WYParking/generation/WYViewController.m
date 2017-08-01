//
//  WYViewController.m
//  WYParking
//
//  Created by 程潇 on 2017/7/24.
//  Copyright © 2017年 glavesoft. All rights reserved.
// 继承自基类viewcontroller

#import "WYViewController.h"
//友盟
#import "UMMobClick/MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

@interface WYViewController()


@end

@implementation WYViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick setEncryptEnabled:YES];
    NSString *selfClass = NSStringFromClass([self class]);
    WYLog(@"class name>> %@",selfClass);
    [MobClick beginLogPageView:selfClass];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSString *selfClass = NSStringFromClass([self class]);
    WYLog(@"class name>> %@",selfClass);
    [MobClick endLogPageView:selfClass];
}









@end
