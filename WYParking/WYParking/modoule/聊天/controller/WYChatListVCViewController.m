//
//  WYChatListVCViewController.m
//  WYParking
//
//  Created by glavesoft on 17/3/9.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYChatListVCViewController.h"
#import "WYXitongXiaoXiVC.h"
#import "WYSiLiaoVCViewController.h"

#import "wyTabBarController.h"
#import "RDVTabBarItem.h"
#import "NaviView.h"

//友盟
#import "UMMobClick/MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>


@interface WYChatListVCViewController ()

@property(weak , nonatomic) UIView * redspoit;

@end

@implementation WYChatListVCViewController

//int secondsCountDown;
//NSTimer *countDownTimer;
- (void)viewDidLoad {
    
    
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    //    [self SetNaviBar];
    if ([wyLogInCenter shareInstance].loginstate == wyLogInStateNotLogin) {
        //        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        //        [keyWindow makeToast:@"您还未登录，即将跳转到登录页面！"];
        [NSThread sleepForTimeInterval:1];
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //
        //            NSString *isfromgrzx = @"2";
        //            [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToAPP" object:isfromgrzx];
        //        });
        NSArray *isfromgrzx = [NSArray arrayWithObjects:@"2",@"",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToAPP" object:isfromgrzx];
        return;
        
    }
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.conversationListTableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    [self setUpViews];
    [self.conversationListTableView.mj_footer beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRedSpot) name:WYHasNewXiTongXiaoXi object:@""];
    
    
    //是否有未读消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ifHaveUnReadMessage) name:UNREADMESSAGE object:nil];
    [self refreshConversationTableViewIfNeeded];
    
    
    
}

//-(void)showMessage{
//    NSString *isfromgrzx = @"2";
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToAPP" object:isfromgrzx];
//}
#pragma mark 是否有未读消息
-(void)ifHaveUnReadMessage{
    //    [self refreshConversationTableViewIfNeeded];
    //融云和系统消息全都已读才能去掉角标
    
    //添加角标
    //    [[self rdv_tabBarItem] setBadgeValue:@" "];
    
    @synchronized(self)
    //保证线程安全
    {
        //切换到主线程
        dispatch_async(dispatch_get_main_queue(),^{
            //添加角标
            //            [self refreshConversationTableViewIfNeeded];
            [[self rdv_tabBarItem] setBadgeValue:@" "];
        });
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
                [self refreshConversationTableViewIfNeeded];
                [self.conversationListTableView.mj_header endRefreshing];
        NSString * result = [responseObject objectForKey:@"status"];
        NSString * message = [responseObject objectForKey:@"message"];
        NSLog(@"message = %@",message);
        
        if ([result isEqualToString:@"200"]){
            //            [self refreshConversationTableViewIfNeeded];
            //            [self.conversationListTableView.mj_header endRefreshing];
            
            NSArray *arr = [responseObject objectForKey:@"data"];
            if (arr.count > 0) {
                [[self rdv_tabBarItem] setBadgeValue:@" "];
                self.redspoit.hidden = NO;
            }else{
                self.redspoit.hidden = YES;
                
#pragma mark 融云未读消息
                int unReadNum = [[RCIMClient sharedRCIMClient]getTotalUnreadCount];
                NSLog(@"未读消息数%d",unReadNum);
                if (unReadNum==0) {
                    //去除角标
                    [[self rdv_tabBarItem] setBadgeValue:@""];
                    
                }
                
            }
            
        } else if([result isEqualToString:@"104"]){
            
            
        }else{
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
                [self refreshConversationTableViewIfNeeded];
                [self.conversationListTableView.mj_header endRefreshing];
    }];
}



- (void)showRedSpot{
    self.redspoit.hidden = NO;
    //    [self refreshConversationTableViewIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.rdv_tabBarController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jbbg"] forBarMetrics:UIBarMetricsDefault];
    self.rdv_tabBarController.navigationItem.rightBarButtonItem = nil;
    self.rdv_tabBarController.title = @"消息中心";
    /**查看消息是否有未读**/
    [self judgesmsg];
    [self refreshConversationTableViewIfNeeded];
    //    WYLog(@"%ld",self.conversationListTableView.mj_totalDataCount);
    NSString *selfClass = @"ChatListViewController";
    WYLog(@"class name>> %@",selfClass);
    [MobClick beginLogPageView:selfClass];//("PageOne"为页面名称，可自定义)
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    //    [self refreshConversationTableViewIfNeeded];
    NSString *selfClass = @"ChatListViewController";
    WYLog(@"class name>> %@",selfClass);
    [MobClick endLogPageView:selfClass];//("PageOne"为页面名称，可自定义)
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
////    [self refreshConversationTableViewIfNeeded];
//    [self.conversationListTableView reloadData];
////    [self refreshConversationTableViewIfNeeded];
//
//}



//基本界面搭建
-(void)setUpViews
{
    //tableview的headView
    UIView * headView = UIView.new;
    headView.backgroundColor = RGBACOLOR(235, 235, 235, 1);
    //系统栏
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIImageView * headImg = [[UIImageView alloc]init];
    headImg.image = [UIImage imageNamed:@"xxzx_mrtx"];
    [headView addSubview:headImg];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.width.height.mas_equalTo(46);
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-12);
    }];
    
    
    UILabel * lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:17];
    lab.text = @"系统消息";
    [headView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImg.mas_right).mas_equalTo(20);
        make.centerY.equalTo(lab.superview);
    }];
    
    UIView * redspoit = [[UIView alloc]init];
    redspoit.backgroundColor = [UIColor redColor];
    redspoit.layer.cornerRadius = 4;
    redspoit.clipsToBounds = YES;
    
    redspoit.hidden = YES;
    
    [headView addSubview:redspoit];
    [redspoit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(8);
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(redspoit.superview);
    }];
    self.redspoit= redspoit;
    
    
    UIView *line  = UIView.new;
    line.backgroundColor = [UIColor lightGrayColor];
    [headView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(ONE_PIXEL);
    }];
    CGFloat h = [headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    headView.height = h;
    @weakify(self);
    [headView bk_whenTapped:^{
        @strongify(self);
        
        
        WYXitongXiaoXiVC *vc = WYXitongXiaoXiVC.new;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    self.conversationListTableView.tableHeaderView=headView;
    self.conversationListTableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    [self.conversationListTableView.mj_header beginRefreshing];
}



- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 66, kScreenWidth, 1)];
    [lineview setBackgroundColor:RGBACOLOR(215, 215, 215, 1)];
    [cell addSubview:lineview];
    //    [self.conversationListTableView reloadData];
    
    //    [self refreshConversationTableViewWithConversationModel:cell.model];
//        [self refreshConversationTableViewIfNeeded];
    
}

-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    WYSiLiaoVCViewController *conversationVC = [[WYSiLiaoVCViewController alloc]init];
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

@end
