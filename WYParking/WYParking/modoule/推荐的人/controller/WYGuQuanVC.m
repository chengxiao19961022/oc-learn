//
//  WYGuQuanVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYGuQuanVC.h"
#import "wyFriendCollectionViewCell.h"
#import "WYShareView.h"
#import "WYModelGuQuanFriend.h"
#import "WYUserDetailinfoVC.h"
#import "AgreementViewController.h"

//分享
#import "WXApi.h"
#import "WeiboSDK.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#define cellPadding 20

@interface WYGuQuanVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong , nonatomic) NSMutableArray *friends;
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *labRecommendCode;
@property (weak, nonatomic) IBOutlet UILabel *labGuQuanCount;

@end

@implementation WYGuQuanVC

- (NSArray *)friends{
    if (_friends == nil) {
        _friends = [NSMutableArray array];
    }
    return _friends;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //collectionView init
    
    {
        //1. regis
         [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([wyFriendCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([wyFriendCollectionViewCell class])];
        //2. delegate
        self.collectionView.delegate =self;
        self.collectionView.dataSource = self;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView.collectionViewLayout = flowLayout;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    CGSize s = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.headerView.height = s.height;
    self.tbView.tableHeaderView = self.headerView;
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //推荐吗
    [self requestTJM];
    
    [self requestGUQuan];
    
    [self requestFriends];
}

#pragma mark 分红股协议
- (IBAction)stockAgreementBtn:(id)sender {
    
    AgreementViewController *agreementVC = [[AgreementViewController alloc]init];
    [self.navigationController pushViewController:agreementVC animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.topView.layer.contents = (id)[UIImage imageNamed:@"jbbg"].CGImage;
    __weak typeof(self) weakSelf = self;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault]; //设置为白色
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"tcs_fb"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf popShareView];
    }];
    self.title = @"我的推广";
}
- (void)requestFriends{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@user/recommendlist", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            self.friends = [WYModelGuQuanFriend mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            [self.collectionView reloadData];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];

}

- (void)requestGUQuan{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
   
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@user/equity", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSDictionary *dic = paramsDict[@"data"];
            self.labGuQuanCount.text = dic[@"has"];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

- (void)requestTJM{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@user/recommendcode", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSDictionary *dic = paramsDict[@"data"];
            self.labRecommendCode.text = dic[@"recommend_code"];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

#pragma mark - 弹出分享View
- (void)popShareView{
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

- (void)doShareActionWithType:(shareType)t{
//-------------------------------------------------------------------------------------------------------
    //标题
    NSString *titleStr = @"停车·交友·分红";

    //内容
    NSMutableString * textStr = [NSMutableString stringWithFormat:@"分享拿分红，轻松实现股东梦！车位分享APP种子用户招募中！"];
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@parking/home/web/index.php/share/parkingsharing?recommendcode=%@", apiHosr,[NSString stringWithFormat:@"%@",self.labRecommendCode.text]];
   
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
            
            
            //(1).新浪微博本来就不能分享链接的，他只能分享text和image的，不能像微信那,所以不要想着能像微信那样直接带一个shareUrl，点击就可以看一个网页。
            //(2).微博要分享链接，只能写在text里，当做内容分享，分享出去，微博会把链接显示成网页链接几个字，点击网页链接，就可以跳转到链接,大家可以使用其他的app分享到新浪微博验证下
           [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@",textStr,urlStr]
                                             images:imageArray
                                                url:[NSURL URLWithString:urlStr]
                                              title:titleStr
                                               type:SSDKContentTypeAuto];
            
            
                     
           /* 
            if(WeiboSDK.isWeiboAppInstalled){
                platFormType=SSDKPlatformTypeSinaWeibo;
                
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装新浪微博" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return ;
            }
            */
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - collectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.friends.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    wyFriendCollectionViewCell *cell = [wyFriendCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    if (self.friends.count > indexPath.row) {
        [cell renderViewWithModel:[self.friends objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(83, 105);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return cellPadding;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WYUserDetailinfoVC *vc = WYUserDetailinfoVC.new;
    WYModelGuQuanFriend *people = [self.friends objectAtIndex:indexPath.row];
    vc.user_id = people.user_id;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
