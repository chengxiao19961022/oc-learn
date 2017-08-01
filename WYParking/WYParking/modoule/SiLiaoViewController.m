//
//  SiLiaoViewController.m
//  TheGenericVersion
//
//  Created by 李杰 on 15/11/19.
//  Copyright © 2015年 李杰. All rights reserved.
//

#import "SiLiaoViewController.h"
#import "IQKeyBoardManager.h"
#import "WYUserDetailinfoVC.h"
//友盟
#import "UMMobClick/MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>


@interface SiLiaoViewController ()
{
    BOOL _wasKeyboardManagerEnabled;
}

@end

@implementation SiLiaoViewController



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jbbg"] forBarMetrics:0];
    
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
    [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    NSLog(@"%@",self.targetId);

    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1101];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jbbg"] forBarMetrics:0];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    __weak typeof(self) weakSelf = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];

    
    [IQKeyboardManager sharedManager].enable = NO;
    NSString *selfClass = @"SiLiaoViewController";
    WYLog(@"class name>> %@",selfClass);
    [MobClick beginLogPageView:selfClass];//("PageOne"为页面名称，可自定义)

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    NSString *selfClass = @"SiLiaoViewController";
    WYLog(@"class name>> %@",selfClass);
    [MobClick endLogPageView:selfClass];//("PageOne"为页面名称，可自定义)
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//- (void)didTapCellPortrait:(RCConversationModel *)model
//{
//    NSLog(@"可以跳转");
//   
//    
//}

- (void)didTapCellPortrait:(NSString *)userId{
    WYUserDetailinfoVC *vc = [[WYUserDetailinfoVC alloc] init];
    NSLog(@"%@",userId);
    vc.user_id = userId;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent{
//    NSString * str = self.chatSessionInputBarControl.inputTextView.text;
//    NSLog(@"---%@",str);
//    return messageCotent;
//}








@end
