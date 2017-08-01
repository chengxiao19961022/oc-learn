//
//  ZJListViewController.m
//  TheGenericVersion
//
//  Created by 李杰 on 16/1/18.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "ZJListViewController.h"
#import "SiLiaoViewController.h"
#import "WYXitongXiaoXiVC.h"
//友盟
#import "UMMobClick/MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>


@interface ZJListViewController ()
@property(copy,nonatomic)UILabel * redspoit;
@property(copy,nonatomic)UILabel * focuredspoit;
@end

@implementation ZJListViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upMessagePoint) name:@"xtMessagePoint" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upfocuPoint) name:@"focusMessagePoint" object:nil];
    
    
    
 

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setUpViews];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewWillAppear:(BOOL)animated{
    
    
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

    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.rdv_tabBarController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jbbg"] forBarMetrics:UIBarMetricsDefault];
    NSString *selfClass = @"ZJListViewController";
    WYLog(@"class name>> %@",selfClass);
    [MobClick beginLogPageView:selfClass];//("PageOne"为页面名称，可自定义)
}

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
    headImg.image = [UIImage imageNamed:@"tx.png"];
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
    
    UILabel * redspoit = [[UILabel alloc]init];
    redspoit.backgroundColor = [UIColor redColor];
    redspoit.layer.cornerRadius = 4;
    redspoit.clipsToBounds = YES;
    if (self.is_showxtred == YES) {
        redspoit.hidden = NO;
    }else
    {
        redspoit.hidden = YES;
    }
    [headView addSubview:redspoit];
    [redspoit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(8);
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(redspoit.superview);
    }];
    _redspoit = redspoit;
    
    UIView *line  = UIView.new;
    line.backgroundColor = [UIColor lightGrayColor];
    [headView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(ONE_PIXEL);
    }];
    CGFloat h = [headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    headView.height = h;
    [headView bk_whenTapped:^{
        WYXitongXiaoXiVC *vc = WYXitongXiaoXiVC.new;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    self.conversationListTableView.tableHeaderView=headView;
    self.conversationListTableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    
    
}

-(void)upMessagePoint
{
    _redspoit.hidden = YES;
}
-(void)upfocuPoint
{
    _focuredspoit.hidden = YES;
}

////点击展示侧边导航
//-(void)showLeftMenu
//{
//    AppDelegate *appDelegate=KappDelegate;
//    RootViewController * rvc = [[RootViewController alloc]init];
//    NavigationController * nav = [[NavigationController alloc]initWithRootViewController:rvc];
//    appDelegate.drawerController.centerViewController = nav;
//    [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//}


-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    SiLiaoViewController *conversationVC = [[SiLiaoViewController alloc]init];
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
//    [conversationVC setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
//    conversationVC.userName =model.conversationTitle;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, 66, kScreenWidth, 1)];
    [lineview setBackgroundColor:RGBACOLOR(215, 215, 215, 1)];
    [cell addSubview:lineview];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    [super viewWillDisappear: animated];
    
    int totalUnreadCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    if (totalUnreadCount >0) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"refreshMessagePoint"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessagePoint" object:nil];
        });
    }
    
    NSString *selfClass = @"ZJListViewController";
    WYLog(@"class name>> %@",selfClass);
    [MobClick endLogPageView:selfClass];//("PageOne"为页面名称，可自定义)
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}



//-(void)xitongMes
//{
//    XitongMesViewController * xitongMes = [[XitongMesViewController alloc]init];
//    [self.navigationController pushViewController:xitongMes animated:YES];
//}
//
//-(void)addMes
//{
//    FriendCycleViewController * addVc = [[FriendCycleViewController alloc]init];
//    [self.navigationController pushViewController:addVc animated:YES];
//}

@end
