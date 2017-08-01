//
//  LBTabBarController.m
//  LBPersonalProject
//
//  Created by Leon on 16/7/28.
//  Copyright © 2016年 Leon. All rights reserved.
//

#import "wyTabBarController.h"
#import "wyLogInCenter.h"

//controllers
#import "WYHomeVC.h"
#import "WYSearchVC.h"
#import "WYRendOutVC.h"
#import "WYPersonalCenterVC.h"
#import "WYChatListVCViewController.h"
#import "MyOrderViewController.h"

#import <RDVTabBarController/RDVTabBarItem.h>
#import <RDVTabBarController/RDVTabBar.h>



@interface wyTabBarController ()<RDVTabBarDelegate,RDVTabBarControllerDelegate>{
    
    WYChatListVCViewController * mChatListViewController;
}

@property (strong , nonatomic) NSMutableArray *titilesArr;

@end

@implementation wyTabBarController

- (instancetype)init{
    if (self = [super init]) {
        [self configStyle];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCornerMark) name:UNREADMESSAGE object:nil];

    
}


#pragma mark 消息添加角标
-(void)addCornerMark{
    [[mChatListViewController rdv_tabBarItem] setBadgeValue:@" "];

}

//WithType:(WYRootViewControllerType)type
- (void)configStyle{
    self.delegate = self;
    
#define kTabbarHeightOrginal (42)
#define kTabbarHeight (kTabbarHeightOrginal+16)
    [self.tabBar setHeight:kTabbarHeight];
    self.tabBar.backgroundColor = [UIColor clearColor];
    //tabbar backgroudView
    UIView *backgroudView = UIView.new;
    backgroudView.backgroundColor = [UIColor whiteColor];
    [self.tabBar addSubview:backgroudView];
    [backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(backgroudView.superview);
        make.height.mas_equalTo(kTabbarHeightOrginal);
    }];
    
    //hairline
    UIView *hairline = UIView.new;
    hairline.backgroundColor = RGBACOLOR(193, 193, 193, 1.0);
    [backgroudView addSubview:hairline];
    [hairline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(hairline.superview);
        make.height.mas_equalTo(ONE_PIXEL/2.0);
    }];
    hairline.backgroundColor = [UIColor lightGrayColor];
#pragma mark - controllers init
    //childControllers
    
//    WYChatListVCViewController * chatListViewController=[[WYChatListVCViewController alloc] init];
    
    mChatListViewController = [[WYChatListVCViewController alloc] init];
    
//    [self setViewControllers:@[
//                               WYHomeVC.new,
//                               [[WYRendoutVC alloc] init],
//                               WYSearchVC.new,
//                               mChatListViewController,
//                               WYPersonalCenterVC.new
//                               ]];

    // 如果用户没有处于登录状态->跳转到登录页
    [self setViewControllers:@[
                                   WYHomeVC.new,
                                   [[MyOrderViewController alloc]init],
                                   WYSearchVC.new,
                                   mChatListViewController,
                                   WYPersonalCenterVC.new
                                   ]];

  


    //titles
    NSArray *titlesArr = @[
                           @"首页",
                           @"订单",
                           @"搜索",
                           @"消息",
                           @"个人中心"
                           ];
    [titlesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.titilesArr addObject:obj];
    }];
    
    

    
    //tarbarItem
    [self.tabBar.items enumerateObjectsUsingBlock:^(RDVTabBarItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *selectedUrlString = [NSString stringWithFormat:@"tab_%d_1",idx];
        NSString *unSelectedUrlString = [NSString stringWithFormat:@"tab_%d_0",idx];
        if (idx != 2) {
            [item setTitle:[titlesArr objectAtIndex:idx]];
            [item setFinishedSelectedImage:[UIImage imageNamed:selectedUrlString] withFinishedUnselectedImage:[UIImage imageNamed:unSelectedUrlString]];
            item.selectedTitleAttributes = @{
                                             NSForegroundColorAttributeName:RGBACOLOR(0, 88, 196, 1)
//                                            NSForegroundColorAttributeName:UIColorFromRGB(0xe7ba44)
                                             };
            item.unselectedTitleAttributes = @{
                                               NSForegroundColorAttributeName:[UIColor darkGrayColor]
//                                               NSForegroundColorAttributeName:UIColorFromRGB(0xeb544d)
                                               };
              item.itemHeight = kTabbarHeightOrginal;
        }else{
            [item setFinishedSelectedImage:[UIImage imageNamed:selectedUrlString] withFinishedUnselectedImage:[UIImage imageNamed:unSelectedUrlString]];
            item.itemHeight = kTabbarHeight;
        }
        
       
    }];
}

//RDVTabBar
- (void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index{
    if (index == 0) {
        self.title = @"";
        [self setTabBarHidden:NO animated:NO];
    }else if(index == 1){
         self.title = @"我的订单";
    }else if(index == 2){
        self.title =@"";
        [self setTabBarHidden:YES animated:YES];
    }else if(index == 3){
        self.title =@"消息中心";
    }else if(index == 4){
        self.title =@"个人中心";
    }
    [super tabBar:tabBar didSelectItemAtIndex:index];
    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
