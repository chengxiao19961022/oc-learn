//
//  AppDelegate.m
//  WYParking
//
//  Created by Leon on 17/2/6.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "AppDelegate.h"
#import "GuidanceViewController.h"

#import "wyLogInCenter.h"
#import "WYLogINVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import "wyTabBarController.h"
#import "WYNavigationController.h"
#import "UIImage+ImageEffects.h"
#import "WYXitongXiaoXiVC.h"
#import "WYCarDetaiInfo.h"
#import "WYUserDetailinfoVC.h"
#import "WYMingXiVC.h"
#import "MyOrderViewController.h"
#import "WYOrderInfoVC.h"

#import "ActiveViewController.h"


// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

//高德
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>//地图SDK头文件
//#import <AMapLocationKit/AMapLocationKit.h>//定位SDK头文件

#import "Crasheye.h"

//友盟
#import "UMMobClick/MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

#import <RongIMKit/RongIMKit.h>//融云

#import <AlipaySDK/AlipaySDK.h>

//智齿
#import <SobotKit/SobotKit.h>
#import <UserNotifications/UserNotifications.h>
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#import "WYRendoutVC.h"


@interface AppDelegate ()<JPUSHRegisterDelegate,RCIMUserInfoDataSource,RCIMReceiveMessageDelegate,UIApplicationDelegate,UNUserNotificationCenterDelegate>{
    NSString *currentVersion;
    NSString * tipStr;
    UIView * blurView;
    NSString *_park_id;
    UIView * toastView;
    
    NSString *actionTitle;
    NSString *actionUrl;
    
}


@property (assign , nonatomic) BOOL isExpired;//推送过来的信息，车位是否过期
@property (assign , nonatomic) BOOL isGreeting;//是否是问候语

@property(assign,nonatomic)BOOL isZhuanTi;//是否是专题

@property (strong , nonatomic) wyTabBarController *rootVC;

@end

@implementation AppDelegate

#pragma mark - 程序入口
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //版本更新
    [self initVersionUpdate];

    
    UIWindow *rootWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    rootWindow.backgroundColor = [UIColor whiteColor];
    self.window = rootWindow;
    [self initShareSDK];
    [self initRM];
    
    
    
    
    
    NSString *versionKeyGuide = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:versionKeyGuide];
    // 当前app的版本号（从Info.plist中获得）
    NSString *currentVersionGuide = [NSBundle mainBundle].infoDictionary[versionKeyGuide];
    if ([lastVersion isEqualToString:currentVersionGuide]) {
//        [self setTabBarAsRootVC];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToHome" object:nil];
        //[self loginApp:nil];
        [wyLogInCenter shareInstance].loginstate = wyLogInStateNotLogin;
        [self miandenglu];
    } else {
        self.window.rootViewController = [[GuidanceViewController alloc] init];// 版本不同的话先进引导页
        [[NSUserDefaults standardUserDefaults] setObject:currentVersionGuide forKey:versionKeyGuide];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }


    //引导页结束进入APP
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginApp:) name:@"GuidanceToAPP" object:nil];
    
    //引导页结束进入Home   setTabbar
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginApp:) name:@"GuidanceToHome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(miandenglu) name:@"GuidanceToHome" object:nil];
    
    
    [self.window makeKeyAndVisible];
    [self initIQKeyBoard];
    [self initJpushWithLanchOptions:launchOptions];//初始化极光推送jpush
    [self initAMap];
    [self initCrashEye];
    [self initUMeng];
   
    //NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
    //挤号通知
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(loginAction)
                                                 name: @"Kloginexpired"
                                               object: nil];
    //[[FLEXManager sharedManager] showExplorer];
    
    
    
    //要监听消息接收，自己修改角标。(限于本地通知)
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveMessageNotification:)name:RCKitDispatchMessageNotification object:nil];
   
    return YES;
}

//-(void)dealloc{
//  [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"GuidanceToAPP" object:nil];
//}


- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    NSNumber *left = [notification.userInfo objectForKey:@"left"];
    
    if ([RCIMClient sharedRCIMClient].sdkRunningMode == RCSDKRunningMode_Backgroud && 0 == left.integerValue) {
        
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                             @(ConversationType_PRIVATE),
                                                                             @(ConversationType_DISCUSSION),
                                                                             @(ConversationType_APPSERVICE),
                                                                             @(ConversationType_PUBLICSERVICE),
                                                                             @(ConversationType_GROUP)
                                                                             ]];
                [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
        
    }
    
}

#pragma mark 进入APP
-(void)loginApp:(NSNotification*)aNotification{
    if ([wyLogInCenter shareInstance].loginstate == wyLogInStateSuccess) {
        wyTabBarController *rootVC = [[wyTabBarController alloc] init];
        WYNavigationController *nav = [[WYNavigationController alloc] initWithRootViewController:rootVC];
        self.rootVC = rootVC;
        self.window.rootViewController = nav;
        [self judgesmsg];
        [self getToken];
        
        [self getZC:[UIApplication sharedApplication]];
    }else{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        // 转到登录页面的一套方法
        WYLogINVC *vc = [[WYLogINVC alloc] init];
        // 设置跳转动画
//        [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        vc.From = [aNotification object];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
        if (vc.From){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [keyWindow makeToast:@"您还未登录，请先登录！"];
            });
        }
    }
}

#pragma mark 注册智齿
-(void)getZC:(UIApplication *)application{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    
    
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10")) {
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        center.delegate = self;
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert |UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (!error) {
                
                [[UIApplication sharedApplication] registerForRemoteNotifications];
                
            }
            
        }];
        
    }else{
        
        [self registerPush:application];
        
    }
    
    [[ZCLibClient getZCLibClient].libInitInfo setAppKey:@"fe98493d12154daa8db5916456b7b7b7"];
    
    // 设置推送是否是测试环境，测试环境将使用开发证书
    
//    [[ZCLibClient getZCLibClient] setIsDebugMode:YES];
    
    // 错误日志收集
    
    [ZCLibClient setZCLibUncaughtExceptionHandler];
    
    
    
    
    // 是否自动提醒
    
    [[ZCLibClient getZCLibClient] setAutoNotification:YES];
    
    
    
    // 关闭推送
    
//    [[ZCLibClient getZCLibClient] removePush:^(NSString *uid, NSData *token, NSError *error) {
//        
//        if((uid==nil &&  token==nil) || error!=nil){
//            
//            // 移除失败，可设置uid或token(uid可不设置)后再调用
//            
//        }else{
//            
//            // 移除成功
//        }
//    }];
    
}





-(void)registerPush:(UIApplication *)application{
    
    // ios8后，需要添加这个注册，才能得到授权
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        //IOS8
        
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        
        [application registerUserNotificationSettings:notiSettings];
        
    } else{ // ios7
        
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge                                       |UIRemoteNotificationTypeSound                                      |UIRemoteNotificationTypeAlert)];
        
    }
    
}

#pragma mark 查看系统消息是否有未读
-(void)judgesmsg{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.requestSerializer.timeoutInterval = 10.0f;
    
    NSMutableDictionary * parameDict = [NSMutableDictionary dictionary];
    
    [parameDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];

    [parameDict setObject:@"1" forKey:@"page"];
    [parameDict setObject:@"10" forKey:@"limit"];
    
    
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@smsg/judgesmsg", KSERVERADDRESS];
    
    [manager POST:urlString parameters:parameDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * result = [responseObject objectForKey:@"status"];
        NSString * message = [responseObject objectForKey:@"message"];
        NSLog(@"message = %@",message);
        
        if ([result isEqualToString:@"200"]){
            
            NSArray *arr = [responseObject objectForKey:@"data"];
            if (arr.count > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:UNREADMESSAGE object:nil];

                
            }
            
        } else if([result isEqualToString:@"104"]){
            

        }else{
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        
    }];
}


#pragma mark - 挤号弹出LoginVC
- (void)loginAction
{
    [wyLogInCenter shareInstance].loginstate = wyLogInStateNotLogin;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UINavigationController *oldRootVCNav = (UINavigationController *)self.window.rootViewController;
    UIViewController *oldCurrentVC = (UIViewController *)oldRootVCNav.childViewControllers.firstObject;
    if (![oldCurrentVC isKindOfClass:[WYLogINVC class]]) {
        WYLogINVC *vc = [[WYLogINVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [keyWindow makeToast:@"您的帐号在别的地方登录 ， 请重新登陆"];
        });
    }
}

#pragma mark - 切换根控制器
- (void)changeRootController:(UIViewController *)controller animated:(BOOL)animated{
    CGFloat duration = 0.5;
    CATransition *transition = [CATransition animation];
    transition.duration = animated?duration:0;
    transition.type = kCATransitionFade;
    self.window.rootViewController = controller;
    [self.window.layer addAnimation:transition forKey:@"rootViewControllerAnimation"];
}

#pragma mark - 初始化高德
- (void)initAMap{
    //初始化高德SDK bf354f87f56dd54593a84229c3e6394b //上架
    [AMapServices sharedServices].apiKey =@"bf354f87f56dd54593a84229c3e6394b";
    [AMapServices sharedServices].enableHTTPS = NO;
}

                 
#pragma mark - 初始化Jpush
- (void)initJpushWithLanchOptions:(NSDictionary *)lanchOptions{
    
    static NSString *appKey = @"0dc7b4852d740aaa2e6efef4";
    static NSString *channel = @"Publish channel";
    static BOOL isProduction = TRUE;
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:lanchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    //添加通知
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];//注册通知
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    

}

#pragma mark - crashEye
- (void)initCrashEye{
    //crashEye
    [Crasheye initWithAppKey:@"d2a20a20"];
}

#pragma mark - 初始化友盟
- (void)initUMeng{
    UMConfigInstance.appKey = @"57e1d83467e58ee90600069b";
    UMConfigInstance.channelId = @"App Store";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //[MobClick setLogEnabled:YES];//打开调试模式，注意Release发布时需要注释掉此行,减少io消耗

}


#pragma mark - 初始化融云
- (void)initRM{
    [[RCIM sharedRCIM] initWithAppKey:@"kj7swf8o70r02"];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
}

#pragma mark - 初始化分享，第三方登录
- (void)initShareSDK{
    //简洁版
    [ShareSDK registerApp:@"11df4fcb3fbea"  //d36c5e5501e0 a39fe4774944
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeTencentWeibo), @(SSDKPlatformTypeFacebook), @(SSDKPlatformTypeTwitter), @(SSDKPlatformTypeQQ),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformTypeWechat),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformTypeTencentWeibo)]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      //                      1784464127
                      //                      44883c289790b2e2bdfda900cfdb712a
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"1784464127"
                                                appSecret:@"44883c289790b2e2bdfda900cfdb712a"
                                              redirectUri:@"http://open.weibo.com/apps/1784464127/info/advanced"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                      
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1105343556" //
                                           appKey:@"zBYiRmh4Iq6q5oRD" //SkIcHPvUhC7NRzn2
                                         authType:SSDKAuthTypeBoth];
                      break;
                      
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx46be1d3a86a5937e"
                                            appSecret:@"bfa33fc8163e6e211f6efc88bd4653dc "];
                      
                      break;
                      
                  case SSDKPlatformTypeSMS:
                      [appInfo SSDKSetupSMSParamsByText:@"1234" title:@"2234" images:nil attachments:nil recipients:nil type:SSDKContentTypeText];
                  default:
                      break;
              }
              
          }];

}

#pragma mark - 版本更新
- (void)initVersionUpdate{
    NSDictionary *appInfoDic = [[NSBundle mainBundle] infoDictionary];
    currentVersion = [appInfoDic objectForKey:@"CFBundleShortVersionString"];
    [self checkUpdateWithAPPID:@"1105329125"];

}


- (void)checkUpdateWithAPPID:(NSString *)APPID
{
    NSString *updateUrlString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",APPID];
    [wyApiManager sendApi:updateUrlString parameters:nil success:^(id obj) {
       
        NSError *error = nil;
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        if (!error) {
            if (paramsDict != nil) {
                long resultCount = [[paramsDict objectForKey:@"resultCount"] integerValue];
                if (resultCount == 1) {
                    NSArray *resultArray = [paramsDict objectForKey:@"results"];
                    NSDictionary *resultDict = [resultArray objectAtIndex:0];
                    NSString *newVersion = [resultDict objectForKey:@"version"];//服务器
                    
                    
                    NSString *value1=[newVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
                    NSString *value2=[currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
                    
                    if (value1.length!=value2.length) {
                        if (value1.length > value2.length) {
                            NSInteger newAddressLengthCount = value1.length;
                            NSInteger oldAddressLengthCount = value2.length;
                            for (int i = 0; i < newAddressLengthCount - oldAddressLengthCount; i++) {
                                value2 = [value2 stringByAppendingString:@"0"];
                            }
                            
                        }
                        if (value2.length > value1.length) {
                            NSInteger newAddressLengthCount = value1.length;
                            NSInteger oldAddressLengthCount = value2.length;
                            for (int i = 0; i < newAddressLengthCount - oldAddressLengthCount; i++) {
                                value1 = [value1 stringByAppendingString:@"0"];
                            }
                            
                        }
                    }
                    
                    if ([value1 doubleValue] > [value2 doubleValue]) {
                        
                        NSString *msg = [NSString stringWithFormat:@"最新版本为%@,是否更新？",newVersion];
                        NSString* newVersionURlString = [[resultDict objectForKey:@"trackViewUrl"] copy];
                        UIAlertView *alertV = [[UIAlertView alloc] bk_initWithTitle:@"提示" message:msg];
                        [alertV bk_setCancelButtonWithTitle:@"取消" handler:^{
                            ;
                        }];
                        [alertV bk_addButtonWithTitle:@"立即更新" handler:^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newVersionURlString]];
                        }];
                        [alertV show];
                        
                    }
                }
            }
        }else
        {
            NSLog(@"error is %@",[error debugDescription]);
        }
    } failuer:^(NSError *error) {

    }];
    
    
}

#pragma mark - iqkeyboard
- (void)initIQKeyBoard{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:20];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    
    //融云
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    if([wyLogInCenter shareInstance].loginstate == wyLogInStateSuccess){
        [[RCIMClient sharedRCIMClient] setDeviceToken:token];}
    
    
    //智齿
    [[ZCLibClient getZCLibClient] setToken:deviceToken];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate 获取 APNs（通知） 推送内容
// 当程序在前台时, 收到推送弹出的通知
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSLog(@"jpush-----iOS 10将显示极光推送）））））））））））））");
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self handleJupushDic:userInfo];
        
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    
    NSString *message = [userInfo[@"aps"] objectForKey:@"alert"];
    //优惠券,请将示例中的100替换为优惠券类型
    [self judgeMessage:message];
    
}
// 程序关闭后, 通过点击推送弹出的通知
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSLog(@"jpush-----iOS 10将接收极光推送）））））））））））））");

    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self handleJupushDic:userInfo];
        
    }
    completionHandler();  // 系统要求执行这个方法
    
    //NSString *message = [NSString stringWithFormat:@"发送给友盟统计：%@", [userInfo[@"aps"] objectForKey:@"alert"]];
    NSString *message = [userInfo[@"aps"] objectForKey:@"alert"];
    //优惠券统计,请将示例中的100替换为优惠券类型
    [self judgeMessage:message];

}


//当程序处于后台或者被杀死状态，收到远程通知后，当你进入程序时，就会调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    NSLog(@"jpush-----iOS 7将接收极光推送）））））））））））））");
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

//当程序正在运行时，收到远程推送，就会调用,如果两个方法都实现了，就只会调用上面的那个方法
//基于iOS 6及以下的系统版本，如果 App状态为正在前台或者点击通知栏的通知消息，那么此函数将被调用，并且可通过AppDelegate的applicationState是否为UIApplicationStateActive判断程序是否在前台运行。此种情况在此函数中处理：
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
    // Required,For systems with less than or equal to iOS6
    NSLog(@"jpush-----iOS 6及之前版本将接收极光推送））））））））");
    [JPUSHService handleRemoteNotification:userInfo];
}
- (void)judgeMessage:(NSString *)str {
    
    if([str containsString:@"分享"]){
        NSLog(@"jpush-----发送给友盟统计，分享type0:%@", str);
        [MobClick event:@"__receive_coupon" attributes:@{@"type":@"0"}];
    }else if([str containsString:@"领取成功"]){
        NSLog(@"jpush-----发送给友盟统计，领取成功type1:%@", str);
        [MobClick event:@"__receive_coupon" attributes:@{@"type":@"1"}];
    }else if([str containsString:@"新用户"]){
        NSLog(@"jpush-----发送给友盟统计，新用户type2:%@", str);
        [MobClick event:@"__receive_coupon" attributes:@{@"type":@"2"}];
    }else if([str containsString:@"发福利"]){
        NSLog(@"jpush-----发送给友盟统计，发福利type3:%@", str);
        [MobClick event:@"__receive_coupon" attributes:@{@"type":@"3"}];
    }else if([str containsString:@"支付成功"]){
        NSLog(@"jpush-----发送给友盟统计，支付成功type4:%@", str);
        [MobClick event:@"__receive_coupon" attributes:@{@"type":@"4"}];
    }

}

#pragma -mark jpushdelegate
//通知方法
- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"jpush———已连接");
}
- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"jpush—未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"jpush—已注册%@", [notification userInfo]);
    [[notification userInfo] valueForKey:@"RegistrationID"];
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"jpush—已登录");
    //  NSString * resginId = [[NSUserDefaults  standardUserDefaults]objectForKey:mRegisterId];
    //  if(resginId == nil || resginId.length <=0)
    //  {
    if ([JPUSHService registrationID]) {
        [Utils writeRegister_id:[JPUSHService registrationID]];
        NSLog(@"get RegistrationID===%@",[JPUSHService registrationID]);
        
        //}
    }
}


// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    [self callBackWithOpenURL:url];
    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [self callBackWithOpenURL:url];
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [self callBackWithOpenURL:url];
    return YES;
}

-(void)callBackWithOpenURL:(NSURL *)url{
    
    NSLog(@"----00---0=--0000-----%@",url.host);
    if([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:[WXApiManager  sharedManager]];
    }
    else if([url.host isEqualToString:@"safepay"]){
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            if ([[resultDic objectForKey:@"resultStatus"]isEqualToString:@"9000"]) {
                if(self.pageType == 10000){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"zfKpaySuccess" object:nil];
                }else if (self.pageType == 10001)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"czKpaySuccess" object:nil];
                }
            }
            else{
                if(self.pageType == 10000){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"zfKpayFail" object:nil];
                }else if (self.pageType == 10001)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"czKpayFail" object:nil];
                }
            }
        }];
        
        
    }
    else if([url.host isEqualToString:@"platformapi"]){
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
    }
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[wyLogInCenter shareInstance] dataSave];

    /****未读消息****/
    int unReadNum = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
    NSLog(@"未读消息数%d",unReadNum);
    [UIApplication sharedApplication].applicationIconBadgeNumber = unReadNum;

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[wyLogInCenter shareInstance] dataSave];
    
    int unReadNum = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
    NSLog(@"未读消息数%d",unReadNum);
    [UIApplication sharedApplication].applicationIconBadgeNumber = unReadNum;

}

//- (void)GetDefaultUser{
//    wyModelLogin *defaultUser = wyModelLogin.new;
////    defaultUser.user_id = @"1";
//    defaultUser.username = @"";
//    defaultUser.sex = @"0";
//    defaultUser.logo = @"";
//    defaultUser.type = @"1";
//    defaultUser.plate_nu = @"";
//    defaultUser.brand_id = @"0";
////    defaultUser.token = @"";
//    defaultUser.phone = @"18810582115";
//    defaultUser.brand_name = @"";
//    defaultUser.brand_logo = @"";
//    defaultUser.user_type = @"普通用户";
//    defaultUser.pwd = @"123456";
//    defaultUser.recommend_code = @"681406";
//    defaultUser.isLatest = YES;
//    [wyLogInCenter shareInstance].sessionInfo = defaultUser;
//    [wyLogInCenter shareInstance].loginstate = wyLogInStateNotLogin;
//}
// 免登录
- (void)miandenglu{
    if ([wyLogInCenter shareInstance].loginstate == wyLogInStateSuccess) {
        wyTabBarController *rootVC = [[wyTabBarController alloc] init];
        WYNavigationController *nav = [[WYNavigationController alloc] initWithRootViewController:rootVC];
        self.rootVC = rootVC;
        self.window.rootViewController = nav;
        [self judgesmsg];
        [self getToken];
        
        [self getZC:[UIApplication sharedApplication]];
    }else{
//    [wyLogInCenter shareInstance].sessionInfo = [wyModelLogin mj_objectWithKeyValues:paramsDict[@"data"]];
//    [wyLogInCenter shareInstance].sessionInfo = [wyModelLogin mj_objectWithKeyValues:nil];
    [wyLogInCenter shareInstance].loginstate = wyLogInStateNotLogin;
//        [self GetDefaultUser];
        wyTabBarController *rootVC = [[wyTabBarController alloc] init];
        WYNavigationController *nav = [[WYNavigationController alloc] initWithRootViewController:rootVC];
        //    nav.rdv_tabBarController.selectedIndex = 4;
        self.rootVC = rootVC;
        self.window.rootViewController = nav;
        //[self changeRootController:nav animated:YES];
    //    [MobClick event:@"__login" attributes:@{@"userid":dic[@"user_id"]}];
//    [MobClick event:@"__login" attributes:@{@"userid":nil}];
    }
    
}
// 转到Tabbar界面
- (void)setTabBarAsRootVC{
    [self getToken];
    wyTabBarController *rootVC = [[wyTabBarController alloc] init];
//    [rootVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    WYNavigationController *nav = [[WYNavigationController alloc] initWithRootViewController:rootVC];
//    NSLog(@"%@", self.From[0]);
    
//    if ([self.From[0] isEqualToString:@"0"]){
//        rootVC.selectedIndex = 4;
//    }
//    if ([self.From[0] isEqualToString:@"1"]){
//        rootVC.selectedIndex = 1;
//    }
//    if ([self.From[0] isEqualToString:@"2"]){
//        rootVC.selectedIndex = 0;
//    }
//    if ([self.From[0] isEqualToString:@"3"]){
//        WYCarDetaiInfo *vc = [[WYCarDetaiInfo alloc] init];
//        vc.park_id =  self.From[1];
//        WYNavigationController *nav3 = [[WYNavigationController alloc] initWithRootViewController:vc];
//        vc.from_mdl = YES;
//        [self changeRootController:nav3 animated:YES];
//        return;
//        
////        NSMutableArray *CarDetail;
//        //                [CarDetail addObjectsFromArray:self.From];
//        //                [CarDetail addObject:nav];
//        
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToCar" object : self.From];
//        
////                WYCarDetaiInfo *parkDetail = WYCarDetaiInfo.new;
////                parkDetail.park_id = self.From[1];
////                UINavigationController * nav2 = [[UINavigationController alloc]initWithRootViewController:parkDetail];
////                parkDetail.isPresent = YES;
//////                self.window.rootViewController = nav;
////                UIViewController *rootVc = self.window.rootViewController;
////                [rootVc.navigationController presentViewController:nav2 animated:YES completion:^{
////                    ;
////                }];
////        return;
////        rootVC.selectedIndex = 0;
//    }
//    if ([self.From[0] isEqualToString:@"4"]){
//        WYUserDetailinfoVC *vc = [[WYUserDetailinfoVC alloc] init];
//        vc.user_id =  self.From[1];
//        WYNavigationController *nav3 = [[WYNavigationController alloc] initWithRootViewController:vc];
//        vc.from_mdl = YES;
//        [self changeRootController:nav3 animated:YES];
//        return;
////                NSMutableArray *UserDetail;
////                [UserDetail addObjectsFromArray:self.From];
////                [UserDetail addObject:nav];
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToUser" object : self.From];
////        rootVC.selectedIndex = 0;
////        WYUserDetailinfoVC *userDetail = WYUserDetailinfoVC.new;
////        userDetail.user_id = self.From[1];
////        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:userDetail];
////        userDetail.isPresent = YES;
////        UIViewController *rootVc = self.window.rootViewController;
////        [rootVc.navigationController presentViewController:nav animated:YES completion:^{
////            ;
////        }];
////        self.window.rootViewController = nav;
//    }

    self.rootVC = rootVC;
//    self.window.rootViewController = nav;
    [self changeRootController:nav animated:YES];

    
    // 需要判断来自哪个界面
    [self  judgesmsg];
//    WYRendoutVC *vc = [[WYRendoutVC alloc]init];
//    self.window.rootViewController = vc;
}



-(void)getToken{
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@user/rytoken", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.user_id forKey:@"user_id"];
    
    NSLog(@"user_id === %@",[wyLogInCenter shareInstance].sessionInfo.user_id);
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        NSMutableDictionary* paramsDict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingMutableContainers error:nil];
        NSString *status=[NSString stringWithFormat:@"%@",paramsDict[@"data"][@"code"]];
        if ([status isEqualToString:@"200"]) {
            NSLog(@"%@",paramsDict[@"data"][@"errorMessage"]);
            [[RCIM sharedRCIM] connectWithToken:paramsDict[@"data"][@"token"] success:^(NSString *userId) {
                // Connect 成功
                NSLog(@"Connect 成功");
//                [[RCIM sharedRCIM] setUserInfoDataSource:self];
                
                /****未读消息****/
                int unReadNum = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
                NSLog(@"未读消息数%d",unReadNum);
                if (unReadNum > 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:UNREADMESSAGE object:nil];
                }
                
                
                
            }
                                          error:^(RCConnectErrorCode status) {
                                              // Connect 失败
                                              NSLog(@"Connect 失败");
                                          }
                                 tokenIncorrect:^() {
                                     // Token 失效的状态处理
                                 }];
        }else{
            //            [self.view makeToast:paramsDict[@"message"]];
            NSLog(@"%@",paramsDict[@"data"][@"errorMessage"]);
        }
        
    } failuer:^(NSError *error) {
        ;
    }];
    
}

- (void)onRCIMReceiveMessage:(RCMessage *)message
                        left:(int)left{
    
    
    int unReadNum = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
    NSLog(@"未读消息数%d",unReadNum);
    if (unReadNum > 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UNREADMESSAGE object:nil];

    }else{

    }
}

#pragma mark - 融云 代理方法
/**
 *  获取用户信息。
 *
 *  @param userId     用户 Id。
 *  @param completion 用户信息
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{

        NSString *urlString = [[NSString alloc] initWithFormat:@"%@user/userinfo", KSERVERADDRESS];
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
        
        [paramsDict setObject:userId forKey:@"user_id"];
        
        [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
            
            NSMutableDictionary* paramsDict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingMutableContainers error:nil];
            NSString *status=[NSString stringWithFormat:@"%@",paramsDict[@"status"]];
            if ([status isEqualToString:@"200"]) {
                
                NSDictionary *tmp=paramsDict[@"data"];
                
                RCUserInfo *user = [[RCUserInfo alloc]init];
                user.userId = [NSString stringWithFormat:@"%@",tmp[@"id"]];
                user.name = tmp[@"username"];
                user.portraitUri = tmp[@"logo"];
                
                
                NSDictionary *dataDic=[NSDictionary dictionaryWithObjectsAndKeys:user.name,@"nickname",user.portraitUri,@"logo", nil];
                NSMutableDictionary *userDic=[[NSMutableDictionary alloc]init];
                [userDic setObject:dataDic forKey:[NSString stringWithFormat:@"%@",userId]];
                return completion(user);
                
            }
            
        } failuer:^(NSError *error) {
            ;
        }];
        return completion(nil);
}

- (void)handleJupushDic:(NSDictionary *)userInfo{
    //系统消息
    [[NSNotificationCenter defaultCenter] postNotificationName:WYHasNewXiTongXiaoXi object:@""];
    
//    NSString *type = userInfo[@"type"];
    
    NSString *type = [NSString stringWithFormat:@"%@",userInfo[@"type"]];

    if ([type isEqualToString:@"all"]) {
        //没有parkid
        self.isExpired = NO;
        self.isGreeting = YES;
        
        self.isZhuanTi = NO;

    }else if ([type isEqualToString:@"101"]){
        /**热门专题**/
        self.isZhuanTi = YES;
        self.isGreeting = NO;
        self.isExpired = NO;

        actionTitle = userInfo[@"title"];
        actionUrl = userInfo[@"url"];
 

    }else{
        self.isZhuanTi = NO;

        self.isGreeting = NO;
        //有 , 推送的订单是否马上过期(是)
        NSString *park_id = userInfo[@"type"];
        if ([park_id isEqualToString:@""] || park_id == nil) {
            self.isExpired = NO;
        }else{
            self.isExpired = YES;
            _park_id = park_id;
        }
    }
    tipStr = [NSString stringWithFormat:@"%@",userInfo[@"aps"][@"alert"]];
    [self setToast];
    [UIView animateWithDuration:0.3 animations:^{
        blurView.hidden = NO;
    }];
    
}


#pragma mark - 推送UI
-(void)setToast
{
    //提示
    toastView = [[UIView alloc]initWithFrame:CGRectMake(KscreenWidth/6, kScreenHeight/2.5, KscreenWidth*2/3, kScreenHeight/4)];
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.layer.cornerRadius = 5;
    toastView.layer.masksToBounds = YES;
    //提示文字
    NSDictionary *attributesDic = @{
                                    NSFontAttributeName:[UIFont systemFontOfSize:13]
                                    };
    CGFloat height = [tipStr boundingRectWithSize:CGSizeMake(toastView.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributesDic context:nil].size.height;
    UILabel * toastTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, toastView.height/2-22, toastView.width, height + 20)];
    toastTitle.text = [NSString stringWithFormat:@"%@",tipStr];
    toastTitle.textColor = [UIColor blackColor];
    toastTitle.font = [UIFont systemFontOfSize:13];
    [toastTitle setTextAlignment:NSTextAlignmentCenter];
    //添加到toastView
    [toastView addSubview:toastTitle];
    
    UIView *line = UIView.new;
    [toastView addSubview:line];
    line.backgroundColor = kNavigationBarBackGroundColor;
    line.frame = CGRectMake(10, toastTitle.bottom + 3, toastView.width-20, 0.8);
    UIButton * upDateBtn = [[UIButton alloc]initWithFrame:CGRectMake(line.left, line.bottom + 10, toastView.width - 10 *2, 30)];
    [upDateBtn setTitle:@"确定" forState:UIControlStateNormal];
    toastTitle.numberOfLines = 0;
    
    upDateBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    upDateBtn.backgroundColor = [UIColor whiteColor];
    [upDateBtn setTitleColor:kNavigationBarBackGroundColor forState:UIControlStateNormal];

    toastView.height = upDateBtn.bottom + 5;
    [toastView addSubview:upDateBtn];
    KLCPopup *popUp = [KLCPopup popupWithContentView:toastView showType:KLCPopupShowTypeBounceInFromTop dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter, KLCPopupVerticalLayoutCenter);
    [popUp showWithLayout:layout];
    @weakify(self);
    [upDateBtn bk_addEventHandler:^(id sender) {
        [popUp dismiss:YES];
        @strongify(self);
        [self orderDetail];
    } forControlEvents:UIControlEventTouchUpInside];
    
}



-(void)orderDetail
{
    if (self.isGreeting) {
        //如果是问候语 ， 就跳系统消息页面
        WYXitongXiaoXiVC *VC = WYXitongXiaoXiVC.new;
         UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:VC];
        VC.isPresent = YES;
        UIViewController *rootVc = self.window.rootViewController;
        [rootVc.navigationController presentViewController:nav animated:YES completion:^{
            ;
        }];
        return;
        
    }else if (self.isZhuanTi){
        /**专题**/
        
        ActiveViewController *actionVC = [[ActiveViewController alloc]init];
        actionVC.actionTitle = actionTitle;
        actionVC.actionUrl = actionUrl;
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:actionVC];
        UIViewController *rootVc = self.window.rootViewController;
        [rootVc presentViewController:nav animated:YES completion:^{
            ;
        }];
        return;
  
       
        
    }else{
        //不是问候语
        if(self.isExpired){
            //是订单过期信息
            WYCarDetaiInfo *parkDetail = WYCarDetaiInfo.new;
            parkDetail.park_id = _park_id;
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:parkDetail];
            parkDetail.isPresent = YES;
            UIViewController *rootVc = self.window.rootViewController;
            [rootVc.navigationController presentViewController:nav animated:YES completion:^{
                ;
            }];
            return;
        }else{
            //不是过期信息
            if ([tipStr hasPrefix:@"您有一笔提现申请已提交，请耐心等待"]||[tipStr hasPrefix:@"您有一笔提现被拒绝,钱已退至余额,请查收"]||[tipStr hasPrefix:@"您有一笔提现已处理,请查收支付宝账户"]||[tipStr hasPrefix:@"您有一笔提现被拒绝,钱已退至余额,请查收"]) {
                WYMingXiVC *incomeVC = WYMingXiVC.new;
                incomeVC.isPresent = YES;
                UIViewController *rootVc = self.window.rootViewController;
                [rootVc presentViewController:incomeVC animated:YES completion:^{
                    ;
                }];
                return;
            }
            if ([tipStr containsString:@"车位已通过审核,请前往查看"]) {
                UINavigationController *rootVc = (UINavigationController *)self.window.rootViewController;
                UIViewController *currentVC = rootVc.childViewControllers.lastObject;
                
                [currentVC.navigationController popToRootViewControllerAnimated:NO];
                [self.rootVC setSelectedIndex:1];
                return;
            }
            if ([tipStr containsString:@"车位未通过审核"]) {
                WYXitongXiaoXiVC *VC = WYXitongXiaoXiVC.new;
                UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:VC];
                VC.isPresent = YES;
                UIViewController *rootVc = self.window.rootViewController;
                [rootVc presentViewController:nav animated:YES completion:^{
                    ;
                }];
                return;
            }else{
                MyOrderViewController * orderVc = [[MyOrderViewController alloc]init];
                orderVc.isFromJpush = YES;//required , 从推动归来进这个vc ， 就要传这个参数
                UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:orderVc];
                UIViewController *rootVc = self.window.rootViewController;
//                UIViewController *currentVC = rootVc.childViewControllers.lastObject;
                [rootVc presentViewController:nav animated:YES completion:^{
                    ;
                }];
//                [currentVC.navigationController pushViewController:orderVc animated:YES];
//                WYOrderInfoVC *orderVc = [[WYOrderInfoVC alloc]init];
//                orderVc.isFromJpush = YES;
//                UIViewController *rootVc = (UINavigationController *)self.window.rootViewController;
//                UIViewController *currentVC = rootVc.childViewControllers.lastObject;
//                [currentVC.navigationController pushViewController:orderVc animated:YES];
            }
           

        }
    }
}




@end
