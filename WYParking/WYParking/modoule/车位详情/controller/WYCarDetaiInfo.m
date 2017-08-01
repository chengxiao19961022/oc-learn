//
//  WYCarDetaiInfo.m
//  WYParking
//
//  Created by glavesoft on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYNavigationController.h"
#import "wyTabBarController.h"
#import "WYCarDetaiInfo.h"
#import "WYJudgeCell.h"
#import "WYCarDetaiInfoFooter.h"
#import "WYStarView.h"
#import "WYShareView.h"//分享的View
#import "WYTimeCell.h"
#import "wyParkSpotMangeVC.h"//车位管理页面
#import "WYJudgeDetailVC.h"//评价详情页面
#import "WYUserDetailinfoVC.h"
#import "WYCommitOrder.h"
#import "wyNavVC.h"
//高德地图
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "CustomAnnotationView.h"

#import "wyModel_Park_detail.h"

#import "WYSiLiaoVCViewController.h"

//分享
#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
//友盟
#import "UMMobClick/MobClick.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

/**智齿客服**/
//#import "ZCCustomViewController.h"
#import <SobotKit/SobotKit.h>
#import <UserNotifications/UserNotifications.h>
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define APPKEY @"fe98493d12154daa8db5916456b7b7b7"
#define SERVICE_ID @"您在融云后台开通的客服ID"
//#define CUSTOMEID @"KEFU148825322585191"//开发环境
#define CUSTOMEID @"KEFU148939802457289"//生产环境

/**融云核心库**/
#import <RongIMKit/RongIMKit.h>// 融云
// 可直接使用   <RongIMKit/RCIM.h> -》》
//            <RongIMKit/RongIMKit.h> -》》
//            <RongIMLib/RongIMLib.h> -》》
//            <RongIMLib/RCIMClient.h> -》》
//            RCIMClient
//  客服文档：
//  http://www.rongcloud.cn/docs/ios_imlib.html#custom_service
#import "RCDCustomerServiceViewController.h"

@interface WYCarDetaiInfo ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MAMapViewDelegate, AMapSearchDelegate>{
    
    __weak IBOutlet UIView *dayWorkView;//工作日日租
    __weak IBOutlet NSLayoutConstraint *dayWorkViewHeight;
    
    __weak IBOutlet UIView *dayHolidayView;//节假日日租
    __weak IBOutlet NSLayoutConstraint *dayHolidayViewHeight;
    
    __weak IBOutlet UIView *weekHolidayView;//周租
    __weak IBOutlet NSLayoutConstraint *weekHolidayViewHeight;
    
    __weak IBOutlet UIView *weekWorkView;//周租不含节假日
    __weak IBOutlet NSLayoutConstraint *weekWorkViewHeight;
    
    __weak IBOutlet UIView *monthHolidayView;//月租
    __weak IBOutlet NSLayoutConstraint *monthHolidayViewHeight;
    
    __weak IBOutlet UIView *monthWorkView;//月租不含节假日
    __weak IBOutlet NSLayoutConstraint *monthWorkViewHeight;
    
    __weak IBOutlet UIView *mTimeBgView;//时间备注底视图
    __weak IBOutlet NSLayoutConstraint *mTimeBgViewHeight;
    
    
    __weak IBOutlet UIView *mRentBgView;//
    
    __weak IBOutlet NSLayoutConstraint *mRentBgViewHeight;
    __weak IBOutlet NSLayoutConstraint *mBgViewHeight;
    
    CGFloat mHeight;//headview高度
}
@property (strong, nonatomic) IBOutlet UIView *tbHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *mainTbview;

@property (weak, nonatomic) IBOutlet UIButton *btnBottom;

@property (weak, nonatomic) IBOutlet UIView *starContainerView; //装评分的container

@property (weak, nonatomic) IBOutlet UIButton *btnSendMessage;

// 车场所在地址 及 所在地址备注
@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UILabel *labAddressRemark;

@property (strong, nonatomic) NSMutableArray<wyMOdelTime *> *timeDataSource;

@property (assign , nonatomic) CGFloat itemHeigh;
@property (weak, nonatomic) IBOutlet UIView *timeContainer; //时间段容器

@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;

@property (weak , nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnNav;

//
@property (weak, nonatomic) IBOutlet UIView *timeRentLineView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPark;
@property (weak, nonatomic) IBOutlet UILabel *labPark_title;


@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserLog;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewChePai;
@property (weak, nonatomic) IBOutlet UILabel *labStarTime_endTime;
@property (weak, nonatomic) IBOutlet UILabel *labCount;
@property (weak, nonatomic) IBOutlet UILabel *labStartDate;
@property (weak, nonatomic) IBOutlet UILabel *labRiZUBH;

@property (weak, nonatomic) IBOutlet UILabel *labRiZu;

@property (weak, nonatomic) IBOutlet UILabel *labZhouZu;

@property (weak, nonatomic) IBOutlet UILabel *labZhouZuBH;
@property (weak, nonatomic) IBOutlet UILabel *labYueZu;
@property (weak, nonatomic) IBOutlet UILabel *labYueZuBH;

@property (weak, nonatomic) IBOutlet UILabel *labTimeNote;

@property (weak , nonatomic) WYStarView * starView ;

@property (weak , nonatomic) UILabel *labStr;

@property (strong , nonatomic) wyModel_Park_detail *park_detail_model;

@property (strong , nonatomic) wyMOdelTime* model;//选的时间段模型



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeight;//高度


@end

@implementation WYCarDetaiInfo

- (NSMutableArray *)timeDataSource{
    if (_timeDataSource == nil) {
        _timeDataSource = [NSMutableArray array];
    }
    return _timeDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imgViewHeight.constant = kScreenWidth*5/6;
    
    self.mainTbview.tag = 100;//住tableview
    self.title = @"加载中...";
    __weak typeof(WYCarDetaiInfo *) weakSelf = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
            if (weakSelf.from_mdl){
                wyTabBarController *rootVC = [[wyTabBarController alloc] init];
//                WYNavigationController *nav = [[WYNavigationController alloc] initWithRootViewController:rootVC];
//                [self changeRootController:nav animated:YES];
                
//                [self.navigationController pushViewController:rootVC animated:YES];
//                return;
                AppDelegate *app = KappDelegate;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
                app.window.rootViewController = nav;
            }else{
                if(weakSelf.isPresent){
                        [weakSelf dismissViewControllerAnimated:YES completion:^{
                            ;
                        }];
                    }else{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
            }
    }];
    @weakify(self);
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"tcs_fb"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self popShareView];
    }];
    
    self.mainTbview.separatorStyle = UITableViewCellSeparatorStyleNone;

    WYStarView *starView = WYStarView.new;
    [self.starContainerView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(starView.superview);
    }];
    self.starView = starView;
    
    //分数
    UILabel *labStar = UILabel.new;
    labStar.text = @"4.0分";
    labStar.font = [UIFont systemFontOfSize:14];
    labStar.textColor = RGBACOLOR(255, 190, 0, 1.0);
    [self.starContainerView addSubview:labStar];
    [labStar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(starView.mas_right).offset(10);
        make.centerY.equalTo(starView);
    }];
    self.labStr = labStar;
    
    //时间段collectionview
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    [self.timeContainer addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.bottom.mas_equalTo(0);
    }];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.collectionViewLayout = flowLayout;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WYTimeCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WYTimeCell class])];
    self.collectionView = collectionView;
    
    [self.tbHeaderView layoutIfNeeded];
    self.labAddress.preferredMaxLayoutWidth = self.tbHeaderView.width - 2 * 20;
   
    
    [RACObserve(self, isMe) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        BOOL isme = [x boolValue];
        weakSelf.btnSendMessage.hidden = isme;
        if (isme) {
            [weakSelf.btnBottom setTitle:@"车位管理" forState:UIControlStateNormal];
        }else{
            [weakSelf.btnBottom setTitle:@"租车位" forState:UIControlStateNormal];
        }
        
    }];
    
    [self fetchData];
}

- (void)changeRootController:(UIViewController *)controller animated:(BOOL)animated{
    CGFloat duration = 0.5;
    CATransition *transition = [CATransition animation];
    transition.duration = animated?duration:0;
    transition.type = kCATransitionFade;
    [[UIApplication sharedApplication].windows lastObject].rootViewController = controller;
    [[[UIApplication sharedApplication].windows lastObject].layer addAnimation:transition forKey:@"rootViewControllerAnimation"];
}


- (void)fetchData{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parkspot3/info", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    if ([wyLogInCenter shareInstance].loginstate == wyLogInStateSuccess) {
        [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    }
    [paramsDict setObject:self.park_id forKey:@"park_id"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            WYLog(@"fsdaf");
            wyModel_Park_detail *model = [wyModel_Park_detail mj_objectWithKeyValues:paramsDict[@"data"]];
            if ([model.user_id isEqualToString:[wyLogInCenter shareInstance].sessionInfo.user_id]) {
                self.isMe = YES;
            }else{
                self.isMe = NO;
            }
            
            
            mHeight = 250.0f;
            
            [self renderViewWithModel:model];
            
            WYLog(@"mBgViewHeight:%f",mHeight);

            //mBgViewHeight.constant = mHeight - 10;
            mBgViewHeight.constant = mHeight;//new version 20170602
            mRentBgViewHeight.constant = mHeight - 37;

            CGSize s = [_tbHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            self.tbHeaderView.height = s.height;

            self.mainTbview.tableHeaderView = _tbHeaderView;

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

- (void)renderViewWithModel:(wyModel_Park_detail *)model{
    self.park_detail_model = model;//for view for annotation
    self.title = model.park_title;
    [self.imageViewPark setImageWithURL:[NSURL URLWithString:model.pic] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    if ([model.average isEqualToString:@""]) {
         self.labStr.text = @"";
    }else{
         self.labStr.text = [NSString stringWithFormat:@"%@分",model.average];
    }
   
    [self.starView renderViewWithMark:model.average];
    self.labAddress.text = model.address?:@"";
    NSString *addr_note = model.addr_note;
    if (addr_note.length == 0 || addr_note == nil) {
        addr_note = @"暂无";
    }
    self.labAddressRemark.text = addr_note;
    self.labPark_title.text = model.username;
    [self.imageViewUserLog setImageWithURL:[NSURL URLWithString:model.logo] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    self.imageViewUserLog.layer.cornerRadius = 25.0f;
    self.imageViewUserLog.layer.masksToBounds = YES;
    
    [self.imageViewChePai setImageWithURL:[NSURL URLWithString:model.brand_logo] placeholder:UIImage.new options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    
    if ([model.sex isEqualToString:@"1"]) {
        self.sexImage.image = [UIImage imageNamed:@"yhxq_man"];
    }else{
        self.sexImage.image = [UIImage imageNamed:@"yhxq_woman"];

    }

    /**
     发消息
     */
    @weakify(self);
    [self.btnSendMessage bk_addEventHandler:^(id sender) {
        @strongify(self);
//        WYSiLiaoVCViewController *vc = [[WYSiLiaoVCViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.user_id];
//        vc.title = model.username;
//        [self.navigationController pushViewController:vc animated:YES];
        
//        RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
//        chatService.userName = @"客服";
//        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
//        chatService.targetId = CUSTOMEID;
//        chatService.title = chatService.userName;
//        [self.navigationController pushViewController :chatService animated:YES];
        
//        __weak typeof(self) weakSelf = self;
//        WYSiLiaoVCViewController *chatVC = [[WYSiLiaoVCViewController alloc]init];
//        chatVC.conversationType = ConversationType_CUSTOMERSERVICE;//会话类型
//        chatVC.targetId = CUSTOMEID;//目标会话ID
//        chatVC.title = @"客服";//会话标题（好友姓名）
//        chatVC.labAddress = self.labAddress.text;
//        chatVC.labAddressRemark = self.labAddressRemark.text;
//        [weakSelf.navigationController pushViewController:chatVC animated:YES];
//        [self sendDataWithAddress];
        
        if ([wyLogInCenter shareInstance].loginstate == wyLogInStateNotLogin) {
            //        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            //        [keyWindow makeToast:@"您还未登录，即将跳转到登录页面！"];
            [NSThread sleepForTimeInterval:1];
            NSArray *isfromgrzx = @[@"3", self.park_id];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToAPP" object:isfromgrzx];
        }
        
        RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
//        chatService.delegate = self;
        chatService.userName = @"客服";
        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
        chatService.targetId = CUSTOMEID;
        chatService.title = chatService.userName;
//        chatService.labAddress = self.labAddress.text;
//        chatService.labAddressRemark = self.labAddressRemark.text;
        chatService.parktitle = self.title;
//        RCIMClient *speak = RCIMClient.new;
//        RCMessageContent *sendAddress;
//        NSString *pushAddress = [NSString stringWithFormat:@"当前车场的地址为：%@。\n地址备注为：%@",self.labAddress,self.labAddressRemark];
//        sendAddress.rawJSONData = [pushAddress dataUsingEncoding:NSUTF8StringEncoding];
//        [speak sendMessage:ConversationType_CUSTOMERSERVICE targetId:CUSTOMEID content:sendAddress pushContent:pushAddress pushData:pushAddress success:nil error:nil];
//        speak = nil;
//        [speak sendMessage:ConversationType_CUSTOMERSERVICE targetId:CUSTOMEID content:sendAddress pushContent:pushAddress pushData:pushAddress success:<#^(long messageId)successBlock#> error:<#^(RCErrorCode nErrorCode, long messageId)errorBlock#>];
        [self.navigationController pushViewController :chatService animated:YES];
        

        
        
        //统计车位详情页用户点击发消息
        [MobClick event:@"__deviceSend_click"];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.timeDataSource = model.time_quantum.copy;
    [self.timeDataSource enumerateObjectsUsingBlock:^(wyMOdelTime * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            obj.isSelected = YES;
        }else{
            obj.isSelected = NO;
        }
    }];
    [self.collectionView reloadData];
    //中间各种类型的价格数量等
    if (self.timeDataSource.count > 0) {
        self.model = self.timeDataSource.firstObject;
        [self renderMiddleViewWithModle:self.timeDataSource.firstObject];
    }
    
    //底部评论
    if (model.comment.count > 0) {
        WYCarDetaiInfoFooter *footerView = WYCarDetaiInfoFooter.new;
        footerView.height = [footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        [footerView renderViewWithDataSource:model.comment.copy];
        if (model.comment.count <= 5) {
            footerView.lookMoreJudge.hidden = YES;
        }else{
             footerView.lookMoreJudge.hidden = NO;
        }
        @weakify(self);
        [footerView.lookMoreJudge bk_addEventHandler:^(id sender) {
            @strongify(self);
            WYJudgeDetailVC *vc = WYJudgeDetailVC.new;
            [vc renderWithModel:self.park_detail_model];
            [self.navigationController pushViewController:vc animated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        self.mainTbview.tableFooterView = footerView;
    }
    
    //地图
    if ([model.lat isEqualToString:@""]) {
        [self.view makeToast:@"该车位无效"];
    }else{
        CGFloat lat = [model.lat floatValue];
        CGFloat lnt = [model.lnt floatValue];
        CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(lat, lnt);
        [self.mapView setCenterCoordinate:locationCoordinate];
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate =locationCoordinate;
        [self.mapView addAnnotation:pointAnnotation];
    }
    

    
    [self.btnNav bk_addEventHandler:^(id sender) {
        @strongify(self);
        if ([model.lat isEqualToString:@""]) {
            [self.view makeToast:@"该车位无效"];
        }else{
            wyNavVC *vc = wyNavVC.new;
            CGFloat lat = [model.lat floatValue];
            CGFloat lnt = [model.lnt floatValue];
            CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(lat, lnt);
            vc.endLocationCoordinate2D = locationCoordinate;
            [self.navigationController pushViewController:vc animated:YES];
        }
       
    } forControlEvents:UIControlEventTouchUpInside];
   
    
}

#pragma mark - 给客服发车场的地址
- (void)sendDataWithAddress{
//    
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parkspot/lotadmins", KSERVERADDRESS];
//    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
//    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
//    [paramsDict setObject:[NSString stringWithFormat:@"%@",self.lat] forKey:@"lat"];
//    [paramsDict setObject:[NSString stringWithFormat:@"%@",self.lnt]  forKey:@"lnt"];
//    //[paramsDict setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"lat"];
//    //[paramsDict setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude]  forKey:@"lnt"];
//    [paramsDict setObject:@"1" forKey:@"page"];
//    [paramsDict setObject:@"10000" forKey:@"limit"];
//    //    token	是	string	用户名凭证
//    //    lat	是	string	经纬度
//    //    lnt	否	string	经纬度
//    //    limit	否	string	个数
//    //    page	否	string	页数
//    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
//        [self.tbView.mj_header endRefreshing];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
//        
//        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
//            
//            self.dataSource = [WYModelGuanLianCheWei mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
//            [self.tbView reloadData];
//            
//        }
//        else if([paramsDict[@"status"] isEqualToString:@"104"])
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
//        }
//        else
//        {
//            [keyWindow makeToast:paramsDict[@"message"]];
//        }
//        
//    } failuer:^(NSError *error) {
//        [self.tbView.mj_header endRefreshing];
//        [keyWindow makeToast:@"请检查网络"];
//        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
//        
//    }];
}


#pragma mark - 初始化地图

- (void)initMapView
{
    
    //[MAMapServices sharedServices].apiKey = GaoDeKey;

    self.mapView.showsCompass=NO;
    self.mapView.delegate = self;
    self.mapView.showsScale=YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    self.mapView.scaleOrigin=CGPointMake(10, 0);//设置比例尺
    
    self.mapView.showsUserLocation=NO;
    self.mapView.userInteractionEnabled = NO;
    
}


#pragma mark - 弹出分享View
- (void)popShareView{
    if ([wyLogInCenter shareInstance].loginstate == wyLogInStateNotLogin) {
        //        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        //        [keyWindow makeToast:@"您还未登录，即将跳转到登录页面！"];
        [NSThread sleepForTimeInterval:1];
        NSArray *isfromgrzx = @[@"3", self.park_id];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToAPP" object:isfromgrzx];
        return;
    }
    WYShareView *shareView = WYShareView.new;
    CGSize s = [shareView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    shareView.frame = CGRectMake(0, 0,kScreenWidth, s.height);
    KLCPopup *popUp = [KLCPopup popupWithContentView:shareView showType:KLCPopupShowTypeBounceInFromBottom dismissType:KLCPopupDismissTypeSlideOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCenter,KLCPopupVerticalLayoutBottom);
    [popUp showWithLayout:layout];
     [shareView.btnCancel bk_addEventHandler:^(id sender) {
         [popUp dismiss:YES];
     } forControlEvents:UIControlEventTouchUpInside];
    @weakify(self);
    shareView.shareblock = ^(shareType t){
        @strongify(self);
        [self doShareActionWithType:t];
    };
}



- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.alpha = 1;
    }];
    [self initMapView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.alpha = 0;
    }];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.timeDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WYTimeCell *cell = [WYTimeCell cellWithCollectionView:collectionView indexPath:indexPath];
    if (self.timeDataSource.count > indexPath.row) {
        [cell renderViewWithModel:[self.timeDataSource objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(117, 38);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    wyMOdelTime *model = [self.timeDataSource objectAtIndex:indexPath.row];
    [self.timeDataSource enumerateObjectsUsingBlock:^(wyMOdelTime * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == indexPath.row) {
            obj.isSelected = YES;
        }else{
            obj.isSelected = NO;
        }
    }];
    self.model = model;
    
    
    
    mHeight = 250.0f;

    dayWorkViewHeight.constant = 34.0;
    dayHolidayViewHeight.constant = 34.0;
    weekHolidayViewHeight.constant = 34.0;
    weekWorkViewHeight.constant = 34.0;
    monthHolidayViewHeight.constant = 34.0;
    monthWorkViewHeight.constant = 34.0;
    mTimeBgViewHeight.constant = 36.0;
    
    
    [self renderMiddleViewWithModle:model];
    
        
    mBgViewHeight.constant = mHeight;
    CGSize s = [_tbHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.tbHeaderView.height = s.height;
    self.mainTbview.tableHeaderView = _tbHeaderView;

    
    
    [self.collectionView reloadData];
   
    
}


- (void)renderMiddleViewWithModle:(wyMOdelTime *)model{
    self.labStarTime_endTime.text = [NSString stringWithFormat:@"%@-%@",model.start_time,model.end_time];
    self.labCount.text = model.spot_num;
    self.labStartDate.text = model.start_date;
    self.labZhouZuBH.text=self.labZhouZu.text=self.labRiZUBH.text=self.labRiZu.text = self.labYueZu.text = self.labYueZuBH.text = [NSString stringWithFormat:@"暂无"];
    [model.saletype_list enumerateObjectsUsingBlock:^(wyModelSaleType *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.sale_type isEqualToString:@"5"]) {
            /**节假日日租**/
            if (![obj.price isEqualToString:@"0.00"]) {
                dayHolidayView.hidden = NO;

                 self.labRiZu.text = [NSString stringWithFormat:@"¥%@",obj.price];

            }else{
                ////隐藏
                dayHolidayView.hidden = YES;
                dayHolidayViewHeight.constant = 0;
                mHeight = mHeight - 34;

            }
            /**工作日日租**/
        }else if ([obj.sale_type isEqualToString:@"6"]){
            if (![obj.price isEqualToString:@"0.00"]) {
                dayWorkView.hidden = NO;

                self.labRiZUBH.text = [NSString stringWithFormat:@"¥%@",obj.price];

            }else{
                ////隐藏
                dayWorkView.hidden = YES;
                dayWorkViewHeight.constant = 0;
                mHeight = mHeight - 34;
            }
            /**周租**/
        }else if ([obj.sale_type isEqualToString:@"1"]){
            if (![obj.price isEqualToString:@"0.00"]) {
                weekHolidayView.hidden = NO;

                self.labZhouZu.text = [NSString stringWithFormat:@"¥%@",obj.price];

            }else{
                ////隐藏
                weekHolidayView.hidden = YES;
                weekHolidayViewHeight.constant = 0;
                mHeight = mHeight - 34;
            }
            /**周租不含节假日**/
        }else if ([obj.sale_type isEqualToString:@"2"]){
            if (![obj.price isEqualToString:@"0.00"]) {
                weekWorkView.hidden = NO;

                 self.labZhouZuBH.text = [NSString stringWithFormat:@"¥%@",obj.price];

            }else{
                ////隐藏
                weekWorkView.hidden = YES;
                weekWorkViewHeight.constant = 0;
                mHeight = mHeight - 34;
            }
           
            /**月租**/
        }else if ([obj.sale_type isEqualToString:@"3"]){
            if (![obj.price isEqualToString:@"0.00"]) {
                monthHolidayView.hidden = NO;

                self.labYueZu.text = [NSString stringWithFormat:@"¥%@",obj.price];

            }else{
                ////隐藏
                monthHolidayView.hidden = YES;
                monthHolidayViewHeight.constant = 0;
                mHeight = mHeight - 34;
            }
            
            /**月租不含节假日**/
        }else if ([obj.sale_type isEqualToString:@"4"]){
            if (![obj.price isEqualToString:@"0.00"]) {
                monthWorkView.hidden = NO;

                self.labYueZuBH.text = [NSString stringWithFormat:@"¥%@",obj.price];

            }else{
                ////隐藏
                monthWorkView.hidden = YES;
                monthWorkViewHeight.constant = 0;
                mHeight = mHeight - 34;
            }
        }

        
    }];
    
  
    NSString *str = model.note;
    if ([str isEqualToString:@""]||str == nil) {
//        str = @"暂无";
        mTimeBgView.hidden = YES;
        _timeRentLineView.hidden = YES;
        mTimeBgViewHeight.constant = 0;
        mHeight = mHeight - 36;
    }else{
        WYLog(@"has time note:%@",str);
        mTimeBgView.hidden = NO;
        _timeRentLineView.hidden = NO;

    }
    self.labTimeNote.text = str;
}

//租车位，车位管理
- (IBAction)btnClick:(UIButton *)sender {
    if ([wyLogInCenter shareInstance].loginstate == wyLogInStateNotLogin) {
        //        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        //        [keyWindow makeToast:@"您还未登录，即将跳转到登录页面！"];
        [NSThread sleepForTimeInterval:1];
        NSArray *isfromgrzx = @[@"3", self.park_id];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToAPP" object:isfromgrzx];
        return;
    }
    
    NSString *str = sender.titleLabel.text;
    if ([str isEqualToString:@"租车位"]) {
        
        
        UIActionSheet *sheet = [[UIActionSheet alloc] init];
        NSArray<wyModelSaleType *> *arr = self.model.saletype_list;
        [sheet bk_setCancelButtonWithTitle:@"取消" handler:^{
            ;
        }];
        [arr enumerateObjectsUsingBlock:^(wyModelSaleType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.is_show isEqualToString:@"1"]) {
                [sheet bk_addButtonWithTitle:obj.sale_type_name handler:^{
                    //租车位
                    WYCommitOrder *vc = WYCommitOrder.new;
                    [vc renderViewWithParkDetailModel:_park_detail_model andtimeTypeModel:_model withType:obj.sale_type];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }];
            }
        }];
        [sheet showInView:self.view];
        
      
    }else{
        //车位管理
        wyParkSpotMangeVC *vc = wyParkSpotMangeVC.new;
        vc.park_id = self.park_detail_model.park_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - 导航
- (IBAction)btnNaviClick:(id)sender {
    
}


-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    //取出当前位置的坐标
    //NSLog(@"定位 latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    
        self.mapView.centerCoordinate=userLocation.coordinate;
        
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.mapView = nil;
    WYLog(@"--------dealloc");
}

#pragma mark - 自定义锚点

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:reuseIndetifier];
        }
        
       
        
    
        
       
        
        
        
        annotationView.frame=CGRectMake(0, 0, 30, 40);
        
        annotationView.bgImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
        annotationView.bgImgV.image=[UIImage imageNamed:@"map_dwb"];
        
        [annotationView addSubview:annotationView.bgImgV];
        
        UIImageView *headView=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 26, 26)];
        [headView setImageWithURL:[NSURL URLWithString:self.park_detail_model.logo] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            ;
        }];
        headView.layer.cornerRadius=13;
        headView.clipsToBounds=YES;
        [annotationView addSubview:headView];
        
        annotationView.canShowCallout = NO;
        
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -20);
        
        
        
        
        //        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAnn:)];
        //        [annotationView addGestureRecognizer:tap];
        
        
        
        return annotationView;
    
    
    
}



- (void)doShareActionWithType:(shareType)t{
    //-------------------------------------------------------------------------------------------------------
    
    //标题
    NSString *titleStr = @"这个车位不错！";
    
    //内容
    NSMutableString * textStr = [NSMutableString stringWithFormat:@"%@停车场邀请您来体验",self.park_detail_model.park_title];
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@parking/home/web/index.php/share/shareparkspot?park_id=%@", apiHosr,[NSString stringWithFormat:@"%@",self.park_detail_model.park_id]];
    
    NSArray* imageArray = @[[UIImage imageNamed:@"icon120"]];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:textStr
                                     images:imageArray
                                        url:[NSURL URLWithString:urlStr]
                                      title:titleStr
                                       type:SSDKContentTypeAuto];
    
    [shareParams SSDKEnableUseClientShare];
    
    
    
    SSDKPlatformType platFormType;
    switch (t) {
        case shareTypeWXPYQ:
            NSLog(@"分享至朋友圈");
            platFormType = SSDKPlatformSubTypeWechatTimeline;
            if (WXApi.isWXAppInstalled) {
                platFormType=SSDKPlatformSubTypeWechatTimeline;
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return ;
            }
            break;
            
            
            break;
        case shareTypeWXHY:
            if (WXApi.isWXAppInstalled) {
                platFormType=SSDKPlatformSubTypeWechatSession;
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            break;
        case shareTypeQQKJ:
            NSLog(@"分享至qq空间");
            platFormType = SSDKPlatformSubTypeQZone;
            break;
        case shareTypeQQHY:
            NSLog(@"分享至qq好友");
            platFormType = SSDKPlatformSubTypeQQFriend;
            break;
        case shareTypeWB:
            NSLog(@"分享至微博");
            platFormType = SSDKPlatformTypeSinaWeibo;
         /*   if(WeiboSDK.isWeiboAppInstalled)
            {
                platFormType=SSDKPlatformTypeSinaWeibo;
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装新浪微博" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return ;
            }
          */
            [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@",textStr,urlStr]
                                             images:imageArray
                                                url:[NSURL URLWithString:urlStr]
                                              title:titleStr
                                               type:SSDKContentTypeAuto];
            
            break;
        default:
            break;
    }
    [ShareSDK share: platFormType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"                                                         message:nil                                                               delegate:nil                                                       cancelButtonTitle:@"确定"                                                      otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"                                                              message:[NSString stringWithFormat:@"%@",error]                                                   delegate:nil                               cancelButtonTitle:@"确定"                                                  otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
//            case SSDKResponseStateCancel:
//            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
//                break;
//            }
            default:
                break;
        }
    }];
    
    
}

- (IBAction)btnJumpToUserInfo:(id)sender {
    WYUserDetailinfoVC *userVC = WYUserDetailinfoVC.new;
    userVC.user_id = self.park_detail_model.user_id;
    [self.navigationController pushViewController:userVC animated:YES];
}

/*
- (IBAction)btnSendMsgClick:(id)sender {
    WYUserDetailinfoVC *userVC = WYUserDetailinfoVC.new;
    if ([userVC.user_id isEqualToString:@""]||userVC.user_id == nil) {
        [self.view makeToast:@"此用户失效"];
        return;
    }
    WYSiLiaoVCViewController *vc = [[WYSiLiaoVCViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:userVC.user_id];
    vc.title = userVC.user_id;
    [self.navigationController pushViewController:vc animated:YES];
}

*/
@end
