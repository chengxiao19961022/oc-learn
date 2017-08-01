//
//  WYOrderInfoVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYOrderInfoVC.h"
#import "WYAlertV.h"
#import "WYUserDetailinfoVC.h"
#import "WYCarDetaiInfo.h"
#import "wyJugeVC.h"

#import "WYSiLiaoVCViewController.h"
#import "wyRefuseAlertView.h"
#import "WYPayVC.h"
#import "WYModelOrderPay.h"

#import "CancelPolicyViewController.h"


//#define CUSTOMEID @"KEFU148825322585191"//开发环境
#define CUSTOMEID @"KEFU148939802457289"//生产环境
#define PHONE @"400-690-6108"//客服电话
#define WYHomeVCNeedReFresh @"WYHomeVCNeedReFresh"

#import "wyLogInCenter.h"

/**智齿客服**/
//#import "ZCCustomViewController.h"
#import <SobotKit/SobotKit.h>
#import <UserNotifications/UserNotifications.h>
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define APPKEY @"fe98493d12154daa8db5916456b7b7b7"
#define SERVICE_ID @"您在融云后台开通的客服ID"

/**融云核心库**/
#import <RongIMKit/RongIMKit.h>//融云
// 可直接使用   <RongIMKit/RCIM.h> -》》
//            <RongIMKit/RongIMKit.h> -》》
//            <RongIMLib/RongIMLib.h> -》》
//            <RongIMLib/RCIMClient.h> -》》
//            RCIMClient
//  客服文档：
//  http://www.rongcloud.cn/docs/ios_imlib.html#custom_service
#import "RCDCustomerServiceViewController.h"

#import "WYDateDetail.h"

@interface WYOrderInfoVC (){
    
    
    __weak IBOutlet UIView *mCancelPolicyBgView;//退订政策
    __weak IBOutlet UILabel *mCarNumberLab;//车牌号
    __weak IBOutlet UILabel *mOverTimeLab;//结束时间
    MASConstraint *constraintNoDetail;// 没有展开详细的约束
    MASConstraint *constraintHasDetail;// 展开详细的约束
    MASConstraint *constraintHeight;
    MASConstraint *constraintNoBtn;
    MASConstraint *constraintHasBtn;
}
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tbView;

@property (weak , nonatomic) WYAlertV *alertView;
@property (weak , nonatomic) wyRefuseAlertView *refuseAlertView;

@property (strong, nonatomic) IBOutlet UIView *jinXingZhongFooterView;
@property (strong, nonatomic) IBOutlet UIView *yiWanChengTool;
@property (strong, nonatomic) IBOutlet UIView *daiFuKuanTool;
@property (strong, nonatomic) IBOutlet UIView *daiPingjiaToolIsMe;
@property (strong, nonatomic) IBOutlet UIView *daiQueRen;
@property (strong, nonatomic) IBOutlet UIView *daiQueRenChuZu;
@property (strong, nonatomic) IBOutlet UIView *tuiDingTool;

@property (strong, nonatomic) IBOutlet UIView *sanGeFooterView;

@property (strong, nonatomic) IBOutlet UIView *liangGeFooterView;
@property (weak, nonatomic) IBOutlet UILabel *labState;

@property (strong, nonatomic) IBOutlet UIView *yigeFooterView;

@property (weak, nonatomic) IBOutlet UIView *toolContainer;
@property (strong, nonatomic) IBOutlet UIView *jinXingZhongTool;


@property (weak, nonatomic) IBOutlet UIView *statusViewTop;
@property (weak, nonatomic) IBOutlet UILabel *labOrderID;//订单号
@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UILabel *labOrderType;
@property (weak, nonatomic) IBOutlet UILabel *labOrderD;//承租人，租用人
@property (weak, nonatomic) IBOutlet UILabel *labPeopleName;
@property (weak, nonatomic) IBOutlet UILabel *labStartTime_endTime;
@property (weak, nonatomic) IBOutlet UIButton *labZctimeline;
// 租车时间段
@property (weak, nonatomic) IBOutlet UIButton *BtnZhanKai;


// 需要隐藏的部分
@property (weak, nonatomic) IBOutlet UILabel *kaishriqi;
@property (weak, nonatomic) IBOutlet UILabel *jiesuriqi;
@property (weak, nonatomic) IBOutlet UIView *kaishiriqihou;
@property (weak, nonatomic) IBOutlet UIButton *Sjxz;
@property (weak, nonatomic) IBOutlet UIButton *Sqxdd;




// 总的租用时间
@property (weak, nonatomic) IBOutlet UILabel *TotalDateNum;

// 开始时间
@property (weak, nonatomic) IBOutlet UILabel *labReserveDate;
//添加约束的line
@property (weak, nonatomic) IBOutlet UIView *xiandanshijianqian;
@property (weak, nonatomic) IBOutlet UIView *zucheshijianhou;



@property (weak, nonatomic) IBOutlet UILabel *labOrderTime;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;

//yige
@property (weak, nonatomic) IBOutlet UILabel *yiGeFooterViewLabStatusName;
@property (weak, nonatomic) IBOutlet UILabel *yiGeFooterViewLabOrderTime;
//两个
@property (weak, nonatomic) IBOutlet UILabel *liangGeFooterViewXiaDanStatusName;
@property (weak, nonatomic) IBOutlet UILabel *liangGeFooterViewXiaDanTIme;
@property (weak, nonatomic) IBOutlet UILabel *liangGeFooterViewQueRenDingDanStatusName;
@property (weak, nonatomic) IBOutlet UILabel *liangGeFooterViewQueRenDingDanTIme;
//三个
@property (weak, nonatomic) IBOutlet UILabel *sangeFooterViewXiaDanStatusName;
@property (weak, nonatomic) IBOutlet UILabel *sangeFooterViewXiaDanTIme;

@property (weak, nonatomic) IBOutlet UILabel *sangeFooterViewQueRenDingDanStatusName;
@property (weak, nonatomic) IBOutlet UILabel *sangeFooterViewQueRenDingDanTIme;
@property (weak, nonatomic) IBOutlet UILabel *sangeFooterViewWanChengDingDanStatusName;
@property (weak, nonatomic) IBOutlet UILabel *sangeFooterViewWanChengDingDanTIme;
- (IBAction)showDates:(id)sender;

@end

@implementation WYOrderInfoVC

bool zhankai;// 记录点击情况，点击则展开，下次点击则折叠
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    zhankai = YES;
    // 加载继续租按钮
    [self.toolContainer addSubview:self.yiWanChengTool];
    [self.yiWanChengTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    // 开始加载时隐藏租用日期详细
//    [self DateShowController:YES];
    self.BtnZhanKai.hidden = YES;
    [self.labZctimeline mas_makeConstraints:^(MASConstraintMaker *make) {
        constraintNoBtn = make.right.equalTo(self.headerView.mas_right).offset(-5);
        constraintHasBtn = make.right.equalTo(self.BtnZhanKai.mas_left).with.offset(-5);
    }];
    [constraintHasBtn uninstall];
    [constraintNoBtn install];
//    [self.xiandanshijianqian mas_makeConstraints:^(MASConstraintMaker *make) {
//        constraintNoDetail = make.top.equalTo(self.zucheshijianhou);
//        constraintHasDetail = make.top.equalTo(self.jiesuriqi.mas_bottom).with.offset(10);
//        constraintHeight = make.height.mas_equalTo(1);
//    }];
//    [constraintHasDetail uninstall];
//    [constraintNoDetail install];
//    [constraintHeight uninstall];
    
    CGSize s = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.headerView.height = s.height;
    self.tbView.tableHeaderView = self.headerView;
    self.tbView.showsVerticalScrollIndicator = NO;
    
    
    ////退订政策
    UITapGestureRecognizer *cancelPolicyRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelPolicyBtn)];
    [mCancelPolicyBgView addGestureRecognizer:cancelPolicyRecognizer];
    
    
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    WYAlertV *alertView = [WYAlertV view];
    [self.view addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
    }];
    self.alertView = alertView;
    __weak typeof(self) weakSelf = self;
    [alertView.onlineView bk_whenTapped:^{
        weakSelf.alertView.hidden = YES;
        WYLog(@"在线客服");
        
//        
//      WYSiLiaoVCViewController *chatVC = [[WYSiLiaoVCViewController alloc]init];
//        chatVC.conversationType = ConversationType_CUSTOMERSERVICE;//会话类型
//        chatVC.targetId = CUSTOMEID;//目标会话ID
//        chatVC.title = @"客服";//会话标题（好友姓名）
//        [weakSelf.navigationController pushViewController:chatVC animated:YES];
        
//        RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
//        chatService.userName = @"客服";
//        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
//        chatService.targetId = CUSTOMEID;
//        chatService.title = chatService.userName;
//        [self.navigationController pushViewController :chatService animated:YES];
//       
//        RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
        
        [IQKeyboardManager sharedManager].enable = NO;


        //  初始化配置信息
        ZCLibInitInfo *initInfo = [ZCLibInitInfo new];
        [self setZCLibInitInfoParam:initInfo];
        
        //自定义用户参数
        [self customUserInformationWith:initInfo];
        ZCKitInfo *uiInfo=[ZCKitInfo new];
        
        // 自定义UI(设置背景颜色相关)
        [self customerUI:uiInfo];
        
        // 之定义商品和留言页面的相关UI
//        [self customerGoodAndLeavePageWithParameter:uiInfo];
        
        // 未读消息
//        [self customUnReadNumber:uiInfo];
        
        // 测试模式
//        [ZCSobot setShowDebug:YES];
        [[ZCLibClient getZCLibClient] setLibInitInfo:initInfo];
        
        // 启动
        [ZCSobot startZCChatView:uiInfo with:weakSelf pageBlock:^(ZCUIChatController *object, ZCPageBlockType type) {
            // 点击返回
            if(type==ZCPageBlockGoBack){
                NSLog(@"点击了关闭按钮");
                
                [IQKeyboardManager sharedManager].enable = YES;

//                [[ZCLibClient getZCLibClient]removePush:^(NSString *uid, NSData *token, NSError *error) {
                    //
//                }];
                
            }
            
            // 页面UI初始化完成，可以获取UIView，自定义UI
            if(type==ZCPageBlockLoadFinish){
                
            }
        } messageLinkClick:nil];
        
        
        
        
    }];
    [alertView.contactDuiFangView bk_whenTapped:^{
          weakSelf.alertView.hidden = YES;
        WYLog(@"联系对方");
        if ([self.myorder.is_me isEqualToString:@"1"]) {
        // 我是租用者，接客服
            RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
            chatService.userName = @"客服";
            chatService.conversationType = ConversationType_CUSTOMERSERVICE;
            chatService.targetId = CUSTOMEID;
            chatService.title = chatService.userName;
            chatService.parktitle = _myorder.park_title;
            [self.navigationController pushViewController :chatService animated:YES];
        }else{
            // 我是出租者，接对方
            WYSiLiaoVCViewController *chatVC = [[WYSiLiaoVCViewController alloc]init];
            chatVC.conversationType = ConversationType_PRIVATE;//会话类型
            chatVC.targetId = self.myorder.user_id;//目标会话ID
            chatVC.title = self.myorder.username;//会话标题（好友姓名）
            [self.navigationController pushViewController:chatVC animated:YES];
        }
    }];
    [alertView.contackServerView bk_whenTapped:^{
          weakSelf.alertView.hidden = YES;
        WYLog(@"电话客服");
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",PHONE];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        
        
    }];
    self.alertView.hidden = YES;
    [self renderViewWithModel];
}

//// 隐藏|显示 日期明细
//- (void)DateShowController:(bool)option{
//    self.kaishriqi.hidden = option;
//    self.TotalDateNum.hidden = option;
//    self.kaishiriqihou.hidden = option;
//    self.jiesuriqi.hidden = option;
//    mOverTimeLab.hidden = option;
//}
#pragma mark 智齿客服配置
- (void)setZCLibInitInfoParam:(ZCLibInitInfo *)initInfo{
    initInfo.appKey = APPKEY;
//    initInfo.skillSetId = _groupIdTF.text;
//    initInfo.skillSetName = _groupNameTF.text;
//    initInfo.receptionistId = _aidTF.text;
//    initInfo.robotId = _robotIdTF.text;
//    initInfo.tranReceptionistFlag = _aidTurn;
//    initInfo.scopeTime = [_historyScopeTF.text intValue];
    initInfo.titleType = @"2";
    initInfo.customTitle = @"客服";
    
}
// 自定义用户信息参数
- (void)customUserInformationWith:(ZCLibInitInfo*)initInfo{
    initInfo.userId       = [wyLogInCenter shareInstance].sessionInfo.user_id;
    
//    NSUserDefaults *user  = [NSUserDefaults standardUserDefaults];
//    initInfo.email        = [user valueForKey:@"email"];
    initInfo.avatarUrl    = [wyLogInCenter shareInstance].sessionInfo.logo;
//    initInfo.sourceURL    = [user valueForKey:@"sourceURL"];
//    initInfo.sourceTitle  = [user valueForKey:@"sourceTitle"];
    
    
//    initInfo.serviceMode  = _type;
    // 微信，微博，用户的真实昵称，生日，备注性别 QQ号
    // 生日字段用户传入的格式，例：20170323，如果不是这个格式，初始化接口会给过滤掉
//    initInfo.qqNumber = [user valueForKey:@"qqNumber"];
    initInfo.userSex = [wyLogInCenter shareInstance].sessionInfo.sex;
    initInfo.useName = [wyLogInCenter shareInstance].sessionInfo.username;
//    initInfo.weiBo = [user valueForKey:@"weiBo"];
//    initInfo.weChat = [user valueForKey:@"weChat"];
//    initInfo.userBirthday = [user valueForKey:@"userBirthday"];
//    initInfo.userRemark = [user valueForKey:@"userRemark"];
//    initInfo.customInfo = @{
//                            @"标题1":@"自定义1",
//                            @"内容1":@"我是一个自定义字段。",
//                            @"标题2":@"自定义字段2",
//                            @"内容2":@"我是一个自定义字段，我是一个自定义字段，我是一个自定义字段，我是一个自定义字段。",
//                            @"标题3":@"自定义字段字段3",
//                            @"内容3":@"<a href=\"www.baidu.com\" target=\"_blank\">www.baidu.com</a>",
//                            @"标题4":@"自定义4",
//                            @"内容4":@"我是一个自定义字段 https://www.sobot.com/chat/pc/index.html?sysNum=9379837c87d2475dadd953940f0c3bc8&partnerId=112"
//                            };
    
}

// 定义UI部分
-(void) customerUI:(ZCKitInfo *) kitInfo{
    // 点击返回是否触发满意度评价（符合评价逻辑的前提下）
//    kitInfo.isOpenEvaluation = _isBackSwitch.on;
    // 如果isShowTansfer=NO 通过记录机器人未知说辞的次数，设置显示转人工按钮，默认1次;
//    kitInfo.unWordsCount = _robotUnknowCount.text;
    // 是否显示语音按钮
//    kitInfo.isOpenRecord = _isOpenVideoSwitch.on;
    
    // 是否显示转人工按钮
//    kitInfo.isShowTansfer = _isShowTansferSwitch.on;
    
    /**
     *  自定义信息
     */
    // 顶部导航条标题文字 评价标题文字 系统相册标题文字 评价客服（立即结束 取消）按钮文字
    //    kitInfo.titleFont = [UIFont systemFontOfSize:30];
    
    // 返回按钮      输入框文字   评价客服是否有以下情况 label 文字  提价评价按钮
    //    kitInfo.listTitleFont = [UIFont systemFontOfSize:22];
    
    //没有网络提醒的button 没有更多记录label的文字    语音tipLabel的文字   评价不满意（4个button）文字  占位图片的lablel文字   语音输入时间label文字   语音输入的按钮文字
    //    kitInfo.listDetailFont = [UIFont systemFontOfSize:25];
    
    // 录音按钮的文字
    //    kitInfo.voiceButtonFont = [UIFont systemFontOfSize:25];
    // 消息提醒 （转人工、客服接待等）
    //    kitInfo.listTimeFont = [UIFont systemFontOfSize:22];
    
    // 聊天气泡中的文字
    //    kitInfo.chatFont  = [UIFont systemFontOfSize:22];
    
    // 聊天的背景颜色
    //    kitInfo.backgroundColor = [UIColor redColor];
    
    // 导航、客服气泡、线条的颜色
    // kitInfo.customBannerColor  = [UIColor redColor];
    
    // 左边气泡的颜色
    //    kitInfo.leftChatColor = [UIColor redColor];
    
    // 右边气泡的颜色
    //    kitInfo.rightChatColor = [UIColor redColor];
    
    // 底部bottom的背景颜色
    //    kitInfo.backgroundBottomColor = [UIColor redColor];
    
    // 底部bottom的输入框线条背景颜色
    //    kitInfo.bottomLineColor = [UIColor redColor];
    
    // 提示气泡的背景颜色
    //    kitInfo.BgTipAirBubblesColor = [UIColor redColor];
    
    // 顶部文字的颜色
    //    kitInfo.topViewTextColor  =  [UIColor redColor];
    
    // 提示气泡文字颜色
    //        kitInfo.tipLayerTextColor = [UIColor redColor];
    
    // 评价普通按钮选中背景颜色和边框(默认跟随主题色customBannerColor)
    //        kitInfo.commentOtherButtonBgColor=[UIColor redColor];
    
    // 评价(立即结束、取消)按钮文字颜色(默认跟随主题色customBannerColor)
    //    kitInfo.commentCommitButtonColor = [UIColor redColor];
    
    //评价提交按钮背景颜色和边框(默认跟随主题色customBannerColor)
    //    kitInfo.commentCommitButtonBgColor = [UIColor redColor];
    
    //    评价提交按钮点击后背景色，默认0x089899, 0.95
    //    kitInfo.commentCommitButtonBgHighColor = [UIColor yellowColor];
    
    // 左边气泡文字的颜色
    //    kitInfo.leftChatTextColor = [UIColor redColor];
    
    // 右边气泡文字的颜色[注意：语音动画图片，需要单独替换]
    //    kitInfo.rightChatTextColor  = [UIColor redColor];
    
    // 时间文字的颜色
    //    kitInfo.timeTextColor = [UIColor redColor];
    
    // 客服昵称颜色
    //        kitInfo.serviceNameTextColor = [UIColor redColor];
    
    
    // 提交评价按钮的文字颜色
    //    kitInfo.submitEvaluationColor = [UIColor redColor];
    
    // 相册的导航栏背景颜色
    
    //    kitInfo.imagePickerColor = [UIColor redColor];
    // 相册的导航栏标题的文字颜色
    //    kitInfo.imagePickerTitleColor = [UIColor redColor];
    
    // 左边超链的颜色
    //    kitInfo.chatLeftLinkColor = [UIColor blueColor];
    
    // 右边超链的颜色
    //    kitInfo.chatRightLinkColor =[UIColor redColor];
    
    // 提示客服昵称的文字颜色
    //    kitInfo.nickNameTextColor = [UIColor redColor];
    // 相册的导航栏是否设置背景图片(图片来自SobotKit.bundle中ZCIcon_navcBgImage)
    //    kitInfo.isSetPhotoLibraryBgImage = YES;
    
    // 富媒体cell中线条的背景色
    //    kitInfo.LineRichColor = [UIColor redColor];
    
    //    // 语音cell选中的背景颜色
    //    kitInfo.videoCellBgSelColor = [UIColor redColor];
    //
    //    // 商品cell中标题的文字颜色
    //    kitInfo.goodsTitleTextColor = [UIColor redColor];
    //
    //    // 商品详情cell中摘要的文字颜色
    //    kitInfo.goodsDetTextColor = [UIColor redColor];
    //
    //    // 商品详情cell中标签的文字颜色
    //    kitInfo.goodsTipTextColor = [UIColor redColor];
    //
    //    // 商品详情cell中发送的文字颜色
    //    kitInfo.goodsSendTextColor = [UIColor redColor];
    
    // 发送按钮的背景色
    //    kitInfo.goodSendBtnColor = [UIColor yellowColor];
    
}


#pragma mark 退订政策
-(void)cancelPolicyBtn{
    CancelPolicyViewController *cancelPolicyVC = [[CancelPolicyViewController alloc]init];
    [self.navigationController pushViewController:cancelPolicyVC animated:YES];
}


- (void)renderViewWithModel{
    self.labAddress.text = self.myorder.address;
    self.labOrderType.text = self.myorder.sale_type_name;
    if ([self.myorder.is_me isEqualToString:@"1"]) {
        self.labOrderD.text = @"承租人：";
        
        mCancelPolicyBgView.hidden = NO;
    }else{
        self.labOrderD.text = @"租用人：";
        
        mCancelPolicyBgView.hidden = YES;
    }
    self.labOrderID.text = self.myorder.order_code;
    self.labPeopleName.text = self.myorder.username;
    
    
    /****停车时段****/
    NSString *start_time = [self.myorder.start_time substringToIndex:5];
    NSString *end_time = [self.myorder.end_time substringToIndex:5];
//    self.labStartTime_endTime.text = [NSString stringWithFormat:@"%@-%@",self.myorder.start_time,self.myorder.end_time];
    self.labStartTime_endTime.text = [NSString stringWithFormat:@"%@-%@",start_time,end_time];

    
//    if ([self.myorder.start_date isEqualToString:self.myorder.end_date]) {
//        self.labReserveDate.text = self.myorder.start_date;
//    }else{
//        self.labReserveDate.text = [NSString stringWithFormat:@"%@~%@",self.myorder.start_date,self.myorder.end_date];
//    }
    
    /****车牌号****/
    mCarNumberLab.text = self.myorder.plate_nu;
    /* 租用时间 */
    [self.labZctimeline setTitle:self.myorder.start_date forState:UIControlStateNormal];
    if (self.myorder.start_date != self.myorder.end_date )
    {
        if ([self.myorder.sale_type_name isEqualToString:@"日租（含节假日）"]||[self.myorder.sale_type_name isEqualToString:@"日租(不含节假日)"])
        {
            self.BtnZhanKai.hidden = NO;
            [constraintHasBtn install];
            [constraintNoBtn uninstall];
        }
        /* 租用时间 */
        [self.labZctimeline setTitle:[self.myorder.start_date stringByAppendingFormat:@" 至 %@", self.myorder.end_date] forState:UIControlStateNormal];
    }
    /****日期总数****/
    self.TotalDateNum.text = self.myorder.sum;
    /****开始日期****/
//    self.labReserveDate.text = self.myorder.start_date;
    /****结束日期****/
//    mOverTimeLab.text = self.myorder.end_date;
    /****下单时间****/
//    self.labOrderTime.text = self.myorder.order_time;
    self.labOrderTime.text = [self.myorder.order_time substringToIndex:16];

    
    
    if ([self.myorder.status_out_name containsString:@"退款成功"]) {
        self.labMoney.text = self.myorder.tui_price;
    }else{
        self.labMoney.text = self.myorder.pay_price;
    }
    self.labState.text = self.myorder.status_out_name;
    if ([self.myorder.status_out_name isEqualToString:@"进行中"]) {
        self.statusViewTop.backgroundColor = kJinXingZhongColor;
//        if ([self.myorder.is_me isEqualToString:@"1"]) {
//            [self.toolContainer addSubview:self.jinXingZhongTool];
//            [self.jinXingZhongTool mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//            }];
//            
//        }
        CGSize s2 = [self.liangGeFooterView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.liangGeFooterView.height = s2.height+ 45;
        if (self.myorder.process.count > 0) {
            WYModelProcess *m1 = [self.myorder.process objectAtIndex:0];
            self.liangGeFooterViewXiaDanStatusName.text = m1.status_name;
            self.liangGeFooterViewXiaDanTIme.text = m1.pro_time;
            WYModelProcess *m2 = self.myorder.process.lastObject;
            self.liangGeFooterViewQueRenDingDanStatusName.text = m2.status_name;
            self.liangGeFooterViewQueRenDingDanTIme.text = m2.pro_time;
        }
        self.tbView.tableFooterView = self.liangGeFooterView;
        
    }else if ([self.myorder.status_out_name isEqualToString:@"已确认"]){
         self.statusViewTop.backgroundColor = kYiQueRenColor;
        if ([self.myorder.is_me isEqualToString:@"1"]) {

                [self.toolContainer addSubview:self.tuiDingTool];
                [self.tuiDingTool mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
                }];

        }
        CGSize s2 = [self.liangGeFooterView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.liangGeFooterView.height = s2.height+ 45;
        if (self.myorder.process.count > 0) {
            WYModelProcess *m1 = [self.myorder.process objectAtIndex:0];
            self.liangGeFooterViewXiaDanStatusName.text = m1.status_name;
            self.liangGeFooterViewXiaDanTIme.text = m1.pro_time;
            WYModelProcess *m2 = self.myorder.process.lastObject;
            self.liangGeFooterViewQueRenDingDanStatusName.text = m2.status_name;
            self.liangGeFooterViewQueRenDingDanTIme.text = m2.pro_time;
        }
        self.tbView.tableFooterView = self.liangGeFooterView;
    }else if ([self.myorder.status_out_name isEqualToString:@"待付款"]){
        //没问题
         self.statusViewTop.backgroundColor = kDaiFuKuanColor;
        if ([self.myorder.is_me isEqualToString:@"1"]) {
            [self.toolContainer addSubview:self.daiFuKuanTool];
            [self.daiFuKuanTool mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            self.Sjxz.hidden = YES;
        }
        CGSize s2 = [self.yigeFooterView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.yigeFooterView.height = s2.height+ 45;
        if (self.myorder.process.count > 0) {
            WYModelProcess *m = [self.myorder.process objectAtIndex:0];
            NSDictionary *dic = [self.myorder.process objectAtIndex:0];
            self.yiGeFooterViewLabOrderTime.text = m.pro_time;
            self.yiGeFooterViewLabStatusName.text = m.status_name;
        }
       
        self.tbView.tableFooterView = self.yigeFooterView;
    }else if ([self.myorder.status_out_name isEqualToString:@"待确认"]){
         self.statusViewTop.backgroundColor = kDaiQueRenColor;
        if ([self.myorder.is_me isEqualToString:@"1"]) {
            //我是租用者
            [self.toolContainer addSubview:self.daiQueRen];
            [self.daiQueRen mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }else{
            //我是出租者
            [self.toolContainer addSubview:self.daiQueRenChuZu];
            [self.daiQueRenChuZu mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];

        }
        CGSize s2 = [self.yigeFooterView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.yigeFooterView.height = s2.height + 60;
        if (self.myorder.process.count > 0) {
            WYModelProcess *m = [self.myorder.process objectAtIndex:0];
            NSDictionary *dic = [self.myorder.process objectAtIndex:0];
            self.yiGeFooterViewLabOrderTime.text = m.pro_time;
            self.yiGeFooterViewLabStatusName.text = m.status_name;
        }
       
        self.tbView.tableFooterView = self.yigeFooterView;
        
    }else if ([self.myorder.status_out_name isEqualToString:@"待评价"]){
        self.statusViewTop.backgroundColor = kDaiPingJiaColor;
        if ([self.myorder.is_me isEqualToString:@"1"]) {
            [self.toolContainer addSubview:self.daiPingjiaToolIsMe];
            [self.daiPingjiaToolIsMe mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }
        CGSize s2 = [self.sanGeFooterView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.sanGeFooterView.height = s2.height+ 45;
        if (self.myorder.process.count > 0) {
            WYModelProcess *m1 = [self.myorder.process objectAtIndex:0];
            self.sangeFooterViewXiaDanStatusName.text = m1.status_name;
            self.sangeFooterViewXiaDanTIme.text = m1.pro_time;
            WYModelProcess *m2 = [self.myorder.process objectAtIndex:1];
            self.sangeFooterViewQueRenDingDanStatusName.text = m2.status_name;
            self.sangeFooterViewQueRenDingDanTIme.text = m2.pro_time;
            WYModelProcess *m3 = self.myorder.process.lastObject;
            self.sangeFooterViewWanChengDingDanStatusName.text = m3.status_name;
            self.sangeFooterViewWanChengDingDanTIme.text = m3.pro_time;
        }
        self.tbView.tableFooterView = self.sanGeFooterView;
    }else if ([self.myorder.status_out_name isEqualToString:@"已取消"]){
        //没问题
        self.statusViewTop.backgroundColor = kYiQuXiaoColor;
        CGSize s2 = [self.liangGeFooterView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.liangGeFooterView.height = s2.height+ 45;
        if (self.myorder.process.count > 0) {
            if (self.myorder.process.count > 0) {
                WYModelProcess *m1 = [self.myorder.process objectAtIndex:0];
                self.liangGeFooterViewXiaDanStatusName.text = m1.status_name;
                self.liangGeFooterViewXiaDanTIme.text = m1.pro_time;
                WYModelProcess *m2 = self.myorder.process.lastObject;
                self.liangGeFooterViewQueRenDingDanStatusName.text = m2.status_name;
                self.liangGeFooterViewQueRenDingDanTIme.text = m2.pro_time;
            }
        }

        self.tbView.tableFooterView = self.liangGeFooterView;
    }else if ([self.myorder.status_out_name isEqualToString:@"已拒绝"]){
         self.statusViewTop.backgroundColor = kYiJuJueColor;
        CGSize s2 = [self.yigeFooterView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.liangGeFooterView.height = s2.height + 45;
        if (self.myorder.process.count > 0) {
            WYModelProcess *m1 = [self.myorder.process objectAtIndex:0];
            self.liangGeFooterViewXiaDanStatusName.text = m1.status_name;
            self.liangGeFooterViewXiaDanTIme.text = m1.pro_time;
            WYModelProcess *m2 = self.myorder.process.lastObject;
            self.liangGeFooterViewQueRenDingDanStatusName.text = m2.status_name;
            self.liangGeFooterViewQueRenDingDanTIme.text = m2.pro_time;
        }

        self.tbView.tableFooterView = self.liangGeFooterView;
    }else if ([self.myorder.status_out_name isEqualToString:@"已完成"]){
         self.statusViewTop.backgroundColor = kYiWanChengColor;
        if ([self.myorder.is_me isEqualToString:@"1"]) {
//            [self.toolContainer addSubview:self.yiWanChengTool];
//            [self.yiWanChengTool mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//            }];
            self.yiWanChengTool.hidden = NO;
        }
        CGSize s2 = [self.sanGeFooterView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        self.sanGeFooterView.height = s2.height+ 45;
        if (self.myorder.process.count > 0) {
            WYModelProcess *m1 = [self.myorder.process objectAtIndex:0];
            self.sangeFooterViewXiaDanStatusName.text = m1.status_name;
            self.sangeFooterViewXiaDanTIme.text = m1.pro_time;
            if (self.myorder.process.count > 1) {
                WYModelProcess *m2 = [self.myorder.process objectAtIndex:1];
                self.sangeFooterViewQueRenDingDanStatusName.text = m2.status_name;
                self.sangeFooterViewQueRenDingDanTIme.text = m2.pro_time;
            }
           
            WYModelProcess *m3 = self.myorder.process.lastObject;
            self.sangeFooterViewWanChengDingDanStatusName.text = m3.status_name;
            self.sangeFooterViewWanChengDingDanTIme.text = m3.pro_time;
        }
        self.tbView.tableFooterView = self.sanGeFooterView;
        
    }else if ([self.myorder.status_out_name isEqualToString:@"退款成功"]){
        if (self.myorder.process.count > 0) {
            WYModelProcess *m1 = [self.myorder.process objectAtIndex:0];
            self.sangeFooterViewXiaDanStatusName.text = m1.status_name;
            self.sangeFooterViewXiaDanTIme.text = m1.pro_time;
            if (self.myorder.process.count > 1) {
                WYModelProcess *m2 = [self.myorder.process objectAtIndex:1];
                self.sangeFooterViewQueRenDingDanStatusName.text = m2.status_name;
                self.sangeFooterViewQueRenDingDanTIme.text = m2.pro_time;
            }

            WYModelProcess *m3 = self.myorder.process.lastObject;
            self.sangeFooterViewWanChengDingDanStatusName.text = m3.status_name;
            self.sangeFooterViewWanChengDingDanTIme.text = m3.pro_time;
        }
        self.tbView.tableFooterView = self.sanGeFooterView;
    }
    if (self.toolContainer.subviews.count ==0) {
        self.toolContainer.hidden = YES;
    }else{
        self.toolContainer.hidden = NO;
    }

}

- (void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.title = @"订单详情";


    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttrs];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault];

    
    __weak typeof(self) weakSelf = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"ddxq_kf"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        weakSelf.alertView.hidden = !weakSelf.alertView.hidden;
    }];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        if (weakSelf.isFromJpush){
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                ;
            }];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 承租人点击确认
- (IBAction)btnQueRenClick:(id)sender {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [NSString stringWithFormat:@"%@order/confirm", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:self.myorder.order_id forKey:@"order_id"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
             [[NSNotificationCenter defaultCenter] postNotificationName:WYHomeVCNeedReFresh object:nil];
            [self.view makeToast:@"确认成功"];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.orderBlock) {
                self.orderBlock(self.indexpath);
            }

        }
        else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            [keyWindow makeToast:paramsDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
    }];
    
}

#pragma mark - 我是租用着 ， 取消订单，待确认
- (IBAction)btnQuXiaoDingDanChuZuClick:(id)sender {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [NSString stringWithFormat:@"%@order/cancel", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:self.myorder.order_id forKey:@"order_id"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
         [[NSNotificationCenter defaultCenter] postNotificationName:WYHomeVCNeedReFresh object:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            [self.navigationController popViewControllerAnimated:YES];
            if (self.orderBlock) {
                self.orderBlock(self.indexpath);
            }
        }
        else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            self.Sjxz.hidden = NO;
            self.Sqxdd.hidden = YES;
            [keyWindow makeToast:paramsDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
    }];
    
}

#pragma mark - 拒绝
- (IBAction)btnRefuseClick:(id)sender {
    
    //弹出选择原因对话框
    wyRefuseAlertView *alertView = [[wyRefuseAlertView alloc] init];
    [alertView renderViewWithType:contentsTypeRefuse];
    alertView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 4/5.0, 146 + 40 * 3 + 10);
    KLCPopup *popUp = [KLCPopup popupWithContentView:alertView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,KLCPopupVerticalLayoutCenter);
    [popUp showWithLayout:layout];
    alertView.clickBlock = ^(BOOL isClick,BOOL isEnsure,NSString *reason){
        if (isEnsure) {
            // 是否点击了确定按钮
            NSString *urlString = [NSString stringWithFormat:@"%@order/refuses",KSERVERADDRESS];
            NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
            
            [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
            [paramsDict setObject:self.myorder.order_id forKey:@"order_id"];
            [paramsDict setObject:reason forKey:@"content"];
    
            [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSMutableDictionary *tempDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
                if ([tempDict[@"status"] isEqualToString:@"200"]) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:WYHomeVCNeedReFresh object:nil];
//                    _isChooseReason = YES;
                    [self.view makeToast:@"已拒绝"];
                    [self.navigationController popViewControllerAnimated:YES];
                    if (self.orderBlock) {
                        self.orderBlock(self.indexpath);
                    }
                }
                else if ([tempDict[@"status"] isEqualToString:@"104"])
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
                }else
                {
                    [self.view makeToast:tempDict[@"message"]];
                }
                
            } failuer:^(NSError *error) {
                [self.view makeToast:@"请检查网络"];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
        }
        // 只要点击了 不管是确定还是取消 ，都消失
        if (isClick) {
            [popUp dismiss:YES];
        }
        
    };
}

#pragma mark - 去评价，租用者
- (IBAction)btnQuPingJiaClick:(id)sender {
    @weakify(self);
    wyJugeVC *vc = [[wyJugeVC alloc] init];
    vc.isDone = ^(BOOL flag){
        if (flag == YES) {
            @strongify(self);
            [self.toolContainer removeAllSubviews];
            [self.toolContainer addSubview:self.yiWanChengTool];
            [self.yiWanChengTool mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
           
        }
    };
    vc.order_id = self.myorder.order_id;
    vc.type = judgeReasonTypeUser;
    [self.navigationController pushViewController:vc  animated:YES];
}

#pragma mark - 继续租
- (IBAction)btnJiXuZuClick:(id)sender {
    if (!([self.myorder.park_id isEqualToString:@""]||self.myorder.park_id == nil)) {
        [self verifyCanContinueRentWithPark_id:self.myorder.park_id Result:^(BOOL can) {
            if (can) {
                WYCarDetaiInfo *vc = [[WYCarDetaiInfo alloc] init];
                vc.park_id = self.myorder.park_id;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }else{
        [self.view makeToast:@"亲，该车位暂时不能租了"];
    }
}

#pragma mark - 去付款
- (IBAction)btnQuFuKuanClick:(id)sender {
    WYPayVC *pay = [[WYPayVC alloc] init];
    WYModelOrderPay *payModel = [[WYModelOrderPay alloc] init];
    payModel.buliding = self.myorder.building;
    payModel.day = nil;
    payModel.end_date = self.myorder.end_date;
    payModel.order_code = self.myorder.order_code;
    payModel.park_title = self.myorder.park_title;
    payModel.start_date = self.myorder.start_date;
    
    
    payModel.total_price = self.myorder.total_price;
    
    //分享所需
    payModel.saletimes_id = self.myorder.saletimes_id;
    payModel.park_id = self.myorder.park_id;
    payModel.order_id = self.myorder.order_id;
    payModel.sale_type = self.myorder.sale_type;
    payModel.sale_type_name = self.myorder.sale_type_name;
    
    payModel.pay_price = self.myorder.pay_price;    //金额
    payModel.money = self.myorder.money;
    
    [pay renderViewWithPayOrder:payModel];
    [self.navigationController pushViewController:pay animated:YES];
}

#pragma mark - 退订
- (IBAction)btnTuiDingClick:(id)sender {
    wyRefuseAlertView *alertView = [[wyRefuseAlertView alloc] init];
    [alertView renderViewWithType:contentsTypeUnsubscribe];
    alertView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 4/5.0, 146 + 40 * 3 + 10);
    KLCPopup *popUp = [KLCPopup popupWithContentView:alertView showType:KLCPopupShowTypeBounceIn dismissType:KLCPopupDismissTypeBounceOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,KLCPopupVerticalLayoutCenter);
    [popUp showWithLayout:layout];
    alertView.clickBlock = ^(BOOL isClick,BOOL isEnsure,NSString *reason){
        if (isEnsure) {
            // 是否点击了确定按钮
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            
            NSString *urlString = [NSString stringWithFormat:@"%@order/tuidings",KSERVERADDRESS];
            NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
            [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
            [paramsDict setObject:self.myorder.order_id forKey:@"order_id"];
            [paramsDict setObject:reason forKey:@"content"];
            [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
                
                if ([paramsDict[@"status"] isEqualToString:@"200"]) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:WYHomeVCNeedReFresh object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    if (self.orderBlock) {
                        self.orderBlock(self.indexpath);
                    }
                }
                else if([paramsDict[@"status"] isEqualToString:@"104"])
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];

                }
                else
                {
                    [keyWindow makeToast:paramsDict[@"message"]];
                    self.tuiDingTool.hidden = YES;
                    self.daiQueRen.hidden = YES;
                    self.jinXingZhongTool.hidden = YES;
                    self.yiWanChengTool.hidden = NO;
                }
                
            } failuer:^(NSError *error) {
                [keyWindow makeToast:@"请检查网络"];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }];
        }
        // 只要点击了 不管是确定还是取消 ，都消失
        if (isClick) {
            [popUp dismiss:YES];
        }
        
    };
}


- (void)verifyCanContinueRentWithPark_id:(NSString *)park_id Result:(void(^)(BOOL can))result{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parkspot/continuerent", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
     [paramsDict setObject:park_id forKey:@"park_id"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            result(YES);
        }
        else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            [self.view makeToast:paramsDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [self.view makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

// 点击展开详细时间，再次点击收缩时间
- (IBAction)showDates:(id)sender {// 添加跳转页面
//    if(zhankai){
//        CGRect newFrame = self.headerView.frame;
//        newFrame.size.height = newFrame.size.height + 36 + 38;
//        self.headerView.frame = newFrame;
//        [self.tbView beginUpdates];
//        [self.tbView setTableHeaderView:self.headerView];
//        [self.tbView endUpdates];
//        [self DateShowController:NO];
//        [constraintHasDetail install];
//        [constraintNoDetail uninstall];
//        [constraintHeight install];
//    }else{
//        CGRect newFrame = self.headerView.frame;
//        newFrame.size.height = newFrame.size.height - 36 - 38;
//        self.headerView.frame = newFrame;
//        [self.tbView beginUpdates];
//        [self.tbView setTableHeaderView:self.headerView];
//        [self.tbView endUpdates];
//        [self DateShowController:YES];
//        [self.xiandanshijianqian mas_makeConstraints:^(MASConstraintMaker *make) {
//            constraintNoDetail = make.top.equalTo(self.zucheshijianhou);
//            constraintHasDetail = make.top.equalTo(self.jiesuriqi.mas_bottom).with.offset(10);
//            constraintHeight = make.height.mas_equalTo(1);
//        }];
//        [constraintHasDetail uninstall];
//        [constraintNoDetail install];
//        [constraintHeight uninstall];
//    
//    }
//    zhankai = !zhankai;
////    [self.kaishriqi mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self.zucheshijianhou).offset(8);
////    }];
////    [self.labReserveDate mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self.zucheshijianhou).offset(8);
////    }];
////    [self.kaishiriqihou mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self.kaishriqi).offset(10);
////    }];
////    [self.jiesuriqi mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self.kaishiriqihou).offset(10);
////    }];
////    [mOverTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self.kaishriqi).offset(10);
////    }];
//
//
    WYDateDetail *vc = [[WYDateDetail alloc] init];
//    WYDateDetail *vc = WYDateDetail.new;
//    [vc renderWithUrl:m.url title:m.title];
    vc.DateDetail = self.myorder.all_date;
    //vc.DateArray = @[@"2017-01-02", @"2017-01-03", @"2017-01-04", @"2017-01-05", @"2017-01-06"];
    [self.navigationController pushViewController:vc  animated:YES];
    
}
- (IBAction)BtnZhanKai:(id)sender {
}
@end
