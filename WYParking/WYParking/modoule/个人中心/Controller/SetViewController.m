//
//  SetViewController.m
//  WYParking
//
//  Created by admin on 17/2/17.
//  Copyright © 2017年 glavesoft. All rights reserved.
// 设置

#import "SetViewController.h"
#import "PersonInfoCell.h"
#import "WYYongHuFanKui.h"
#import "WYEditPwdVC.h"
#import "WYLogINVC.h"
#import "wyNavVC.h"
#import "WYForgetPwdVC.h"
#import "AboutUsViewController.h"
#import "UserAgreementViewController.h"
#import "WYOldUserSetPwdVC.h"
#import "wyTabBarController.h"

//分享
#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>


#import <SobotKit/SobotKit.h>
#import <RongIMKit/RongIMKit.h>

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* mytableview;
    
    NSArray* titleArray;
    
    NSString *currentVersion;
    
    BOOL hasPwd;
    
    NSString *mUserPhone;
}
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    
    mytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60)];
    mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    mytableview.delegate = self;
    mytableview.dataSource = self;
    [self.view addSubview:mytableview];
    
    
    UIButton* saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50)];
    [saveBtn setBackgroundColor:[UIColor colorWithRed:191/255.0f green:192/255.0f blue:193/255.0f alpha:1]];
    [saveBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn bk_addEventHandler:^(id sender) {
        
        
        if ([ShareSDK hasAuthorized:SSDKPlatformTypeQQ]) {
            [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
        }
        if ([ShareSDK hasAuthorized:SSDKPlatformTypeWechat]) {
            [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
        }
        
        

        // 关闭推送（智齿）
        [[ZCLibClient getZCLibClient] removePush:^(NSString *uid, NSData *token, NSError *error) {
                if((uid==nil &&  token==nil) || error!=nil){
                    // 移除失败，可设置uid或token(uid可不设置)后再调用
                }else{
                    // 移除成功
                }
            }];
        
        //断开融云
        [[RCIMClient sharedRCIMClient]logout];
        
        
        
        [[wyLogInCenter shareInstance] singOut];
        // 改变根控制器到登录页面
        //wyTabBarController *vc = [[wyTabBarController alloc] init];
        WYLogINVC *vc = [[WYLogINVC alloc] init];
        AppDelegate *app = KappDelegate;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        app.window.rootViewController = nav;
        
    } forControlEvents:UIControlEventTouchUpInside];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:saveBtn];
    
    
    mUserPhone = [wyLogInCenter shareInstance].sessionInfo.phone;
    if ([mUserPhone isEqualToString:@"13151761030"]) {
        titleArray = [[NSArray alloc]initWithObjects:@"登录密码设置",@"支付密码设置",@"关于我们",@"用户协议",@"意见反馈", nil];
        
    }else{
        titleArray = [[NSArray alloc]initWithObjects:@"登录密码设置",@"支付密码设置",@"关于我们",@"用户协议",@"版本更新",@"意见反馈", nil];

    }
    
    
    
    
    [self verifyWeatherHasPayPwd];
}

- (void)verifyWeatherHasPayPwd{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@set/checkpwd", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            hasPwd = YES;
        }else if ([paramsDict[@"status"] isEqualToString:@"101"]){
            hasPwd = NO;
        }else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            [keyWindow makeToast:paramsDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self SetNaviBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void)SetNaviBar
{
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    self.title = @"设置";
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 27, 27)];
    [btn setImage:[UIImage imageNamed:@"back3"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)Back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 6;
    if ([mUserPhone isEqualToString:@"13151761030"]) {

        return 5;
    }else{
        return 6;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifer = @"cell";
    PersonInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonInfoCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.ContentLab.hidden = YES;
    cell.ShowImgView.hidden = YES;
    
    cell.TitleLab.text = titleArray[indexPath.row];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [titleArray objectAtIndex:indexPath.row];
    if ([str isEqualToString:@"登录密码设置"]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] init];
        [sheet bk_setCancelButtonWithTitle:@"取消" handler:^{
            
        }];
        [sheet bk_addButtonWithTitle:@"修改登录密码" handler:^{
            WYEditPwdVC *vc = WYEditPwdVC.new;
            [self.navigationController  presentViewController:vc animated:YES completion:^{
                ;
            }];

        }];
        [sheet bk_addButtonWithTitle:@"忘记登录密码" handler:^{
            WYForgetPwdVC *vc = WYForgetPwdVC.new;
            [self.navigationController  presentViewController:vc animated:YES completion:^{
                ;
            }];
        }];
        [sheet showInView:self.view];
    }else if ([str isEqualToString:@"意见反馈"]) {
        WYYongHuFanKui *vc = WYYongHuFanKui.new;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([str isEqualToString:@"关于我们"]) {
        AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc]init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
        
    }else if ([str isEqualToString:@"用户协议"]){
        UserAgreementViewController *userAgreementVC = [[UserAgreementViewController alloc]init];
        [self.navigationController pushViewController:userAgreementVC animated:YES];
    }else if ([str isEqualToString:@"支付密码设置"]){
        if (hasPwd) {
            UIActionSheet *sheet = [[UIActionSheet alloc] init];
            [sheet bk_setCancelButtonWithTitle:@"取消" handler:^{
                
            }];
            [sheet bk_addButtonWithTitle:@"修改支付密码" handler:^{
                WYEditPwdVC *vc = WYEditPwdVC.new;
                [vc renderViewWithType:editPwdTypePayPwd];
                [self.navigationController  presentViewController:vc animated:YES completion:^{
                    ;
                }];
                
            }];
            [sheet bk_addButtonWithTitle:@"忘记支付密码" handler:^{
                WYForgetPwdVC *vc = WYForgetPwdVC.new;
                [vc renderViewWithType:forgetPwdTypePayPwd];
                [self.navigationController  presentViewController:vc animated:YES completion:^{
                    ;
                }];
            }];
            [sheet showInView:self.view];
        }else{
            WYOldUserSetPwdVC *vc = WYOldUserSetPwdVC.new;
            [vc renderWith:oldUserPwdTypePayPwd];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nav animated:YES completion:^{
                ;
            }];
        }
       
    }else if ([str isEqualToString:@"版本更新"]){
        [self initVersionUpdate];
    }
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [wyApiManager sendApi:updateUrlString parameters:nil success:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view];
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
                        
                    }else{
                        
                        NSString *msg = [NSString stringWithFormat:@"当前为最新版本:%@",currentVersion];
                        UIAlertView *alertV = [[UIAlertView alloc] bk_initWithTitle:@"提示" message:msg];
                        [alertV bk_addButtonWithTitle:@"确定" handler:^{
                           
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
        [self.view makeToast:@"网络错误"];
        [MBProgressHUD hideHUDForView:self.view];
    }];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
