
//
//  WYSiLiaoVCViewController.m
//  WYParking
//
//  Created by glavesoft on 17/3/11.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYSiLiaoVCViewController.h"
#import "WYUserDetailinfoVC.h"

@interface WYSiLiaoVCViewController ()

@end

@implementation WYSiLiaoVCViewController{
    BOOL _wasKeyboardManagerEnabled;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:3];


    [RCIM sharedRCIM].globalNavigationBarTintColor = RGBACOLOR(23, 68, 166, 1);

    
    [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;

    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1101];

    
    
    
//    int unReadNum = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
//    NSLog(@"未读消息数%d",unReadNum);
//    if (unReadNum > 0) {
//        
//    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:UNREADMESSAGE object:nil];
//        
//    }

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
    
//    // 将停车场地址发给客服
//    if (self.labAddress)
//    {
//        NSString *pushAddress = [NSString stringWithFormat:@"当前车场的地址为：%@。\n地址备注为：%@",self.labAddress,self.labAddressRemark];
//        [self sendMessage:nil pushContent:pushAddress];
//    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jbbg"] forBarMetrics:0];
    
    
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}

- (void)didTapCellPortrait:(NSString *)userId{
    WYUserDetailinfoVC *vc = [[WYUserDetailinfoVC alloc] init];
    NSLog(@"%@",userId);
    vc.user_id = userId;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)sendMessage:(RCMessageContent *)messageContent
//        pushContent:(NSString *)pushContent;
//{
//    NSLog(@"%@",pushContent);
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
