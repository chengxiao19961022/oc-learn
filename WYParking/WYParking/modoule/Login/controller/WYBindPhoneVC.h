//
//  WYBindPhoneVC.h
//  WYParking
//
//  Created by glavesoft on 17/2/24.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"

//分享
#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface WYBindPhoneVC : WYViewController

@property (strong , nonatomic) SSDKUser *user;

@property (copy , nonatomic) NSString *type;

@end
