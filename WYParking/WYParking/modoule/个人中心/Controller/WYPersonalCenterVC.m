//
//  WYPersonalCenterVC.m
//  WYParking
//
//  Created by Leon on 2017/2/14.
//  Copyright © 2017年 Leon. All rights reserved.
// 个人中心

#import "WYPersonalCenterVC.h"
#import "PersonalCenterView.h"
#import "MYYouhuiquanViewController.h"
#import "NaviView.h"
#import "MyPackgeViewController.h"
#import "SetViewController.h"
#import "MyOrderViewController.h"
#import "WYCMTVC.h"
#import "WYGuQuanVC.h"
#import "WYGuanZhuVC.h"
#import "WYPersonalInfoVC.h"
#import "WYRendoutVC.h"
#import "WYModelMineSpot.h"

@interface WYPersonalCenterVC ()<PersonalCenterViewDelegate,UITableViewDelegate>
{
    NSMutableAttributedString* YouhuiquanString;//优惠券
    
    NaviView* naviView;
    
    NSString *mMoney;//我的资金
    
    NSMutableArray *cheweiDataSource;// 车位队列
}
@property (nonatomic,strong) PersonalCenterView* personalcenterView;

@property (weak , nonatomic) UITableView *tbView;

@end

@implementation WYPersonalCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([wyLogInCenter shareInstance].loginstate == wyLogInStateNotLogin) {
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//        [keyWindow makeToast:@"您还未登录，即将跳转到登录页面！"];
        [NSThread sleepForTimeInterval:1];
        NSArray *isfromgrzx = [NSArray arrayWithObjects:@"0",@"",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToAPP" object:isfromgrzx];
        return;
    }
    UITableView* mytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    mytableview.delegate = self;
    [self.view addSubview:mytableview];
    mytableview.scrollEnabled = NO;
    self.tbView = mytableview;
    
    self.personalcenterView = [[[NSBundle mainBundle]loadNibNamed:@"PersonalCenterView" owner:nil options:nil]lastObject];
    self.personalcenterView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    self.personalcenterView.delegate = self;
    mytableview.tableHeaderView = self.personalcenterView;
    
    [self fetchFuJinCheWei];
    [self SetNaviBar];
    [self initialization];
}


-(void)initialization{
        
    //充值成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyBalance) name:@"czKpaySuccess" object:nil];
    
}

- (void)fetchData{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tbView animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@user/personal", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [self.tbView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.tbView animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {

            NSDictionary *dic = paramsDict[@"data"];
            
            
            //头像，昵称，汽车品牌
            /****设置名字*****/
            // 创建一个富文本
            NSString *nameStr = [NSString stringWithFormat:@"%@·",dic[@"username"]];
            NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:nameStr];
            // 修改富文本中的不同文字的样式
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, nameStr.length)];
            [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, nameStr.length)];
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            NSString *brandsImgUrl = [NSString stringWithFormat:@"%@",dic[@"brand_logo"]];
            
                //从网络上加载图片
                attch.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:brandsImgUrl]]];
                // 设置图片大小
                attch.bounds = CGRectMake(0, -4, 19, 19);
                // 创建带有图片的富文本
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri appendAttributedString:string];
                self.personalcenterView.NameLab.attributedText = attri;
                
            
            
            [self.personalcenterView.TouxiangImg setImageWithURL:[NSURL URLWithString:dic[@"logo"]] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                ;
            }];
            
            //性别
            if ([dic[@"sex"] isEqualToString:@"1"]) {
                self.personalcenterView.SexIcon.image = [UIImage imageNamed:@"yhxq_man"];
            }else{
                self.personalcenterView.SexIcon.image = [UIImage imageNamed:@"yhxq_woman"];
            }

            
            
            //推荐码
            NSString *tuijianStr = [NSString stringWithFormat:@"我的推荐码：%@",dic[@"recommend_code"]];
            self.personalcenterView.TuijianmaLab.text = dic[@"recommend_code"]?tuijianStr:@"我的推荐码";
            //钱
            NSDictionary *moneyDic = dic[@"money"];
            NSString *moneySTR = moneyDic[@"money"];
            mMoney = moneySTR;
            if ([moneySTR containsString:@"."]) {
                NSArray *temtAtt = [moneySTR componentsSeparatedByString:@"."];
                NSString *first = (NSString *)temtAtt.firstObject;
                NSString *lastStr =(NSString *)temtAtt.lastObject;
                 self.personalcenterView.view2.lab1.attributedText = [self SetAttributeString:moneySTR rang1:NSMakeRange(0, first.length + 1 ) rang2:NSMakeRange(first.length + 1  , lastStr.length)];
            }else{
                  self.personalcenterView.view2.lab1.attributedText = [self SetAttributeString:moneySTR rang1:NSMakeRange(0, moneySTR.length) rang2:NSMakeRange(moneySTR.length , 0)];
            }
            //优惠券
//            "coupon": {
                //                    "coupon": "0"
                //                },
            NSDictionary *couponDic = dic[@"coupon"];
            NSString *coupCount = couponDic[@"coupon"];
            NSString *coupStr = [NSString stringWithFormat:@"%@张",coupCount];
            self.personalcenterView.view3.lab1.attributedText = [self SetAttributeString:coupStr rang1:NSMakeRange(0, coupStr.length - 1) rang2:NSMakeRange(coupStr.length - 1, 1)];
//            "friend": {
//                //                    "friend_sum": "20"
//                //                },
            NSDictionary *friendDic = dic[@"friend"];
            NSString *friendCount = friendDic[@"friend_sum"];
            NSString *friendStr = [NSString stringWithFormat:@"%@人",friendCount];
            self.personalcenterView.view4.lab1.attributedText = [self SetAttributeString:friendStr rang1:NSMakeRange(0, friendStr.length - 1) rang2:NSMakeRange(friendStr.length - 1, 1)];
            //出租个数
//            "order": {
                //                    "order_sum": "110"
                //                },
//            WYRendoutVC *vc0 = [[WYRendoutVC alloc]init];
//            cheweiDataSource = vc0.cheweiDataSource;
//            vc0 = nil;

//            NSDictionary *orderDic = dic[@"order"];
//            NSString *orderCount = orderDic[@"order_sum"];
            NSString *orderStr = [NSString stringWithFormat:@"%lu条",cheweiDataSource.count];
            self.personalcenterView.view1.lab1.attributedText = [self SetAttributeString:orderStr rang1:NSMakeRange(0, orderStr.length - 1) rang2:NSMakeRange(orderStr.length - 1, 1)];
            
            //出门条
            //                "article_out": {
            //                    "article_out": "2"
            //                }
            NSDictionary *article_outDic = dic[@"article_out"];
            NSString *article_outCount = article_outDic[@"article_out"];
            NSString *article_outStr = [NSString stringWithFormat:@"%@张",article_outCount];
            self.personalcenterView.view5.lab1.attributedText = [self SetAttributeString:article_outStr rang1:NSMakeRange(0, article_outStr.length - 1) rang2:NSMakeRange(article_outStr.length - 1, 1)];
            
            //推荐的人
            //                "recommend": {
            //                    "recommend_sum": "0"
            //                },
            NSDictionary *recommendDic = dic[@"recommend"];
            NSString *recommendCount = recommendDic[@"recommend_sum"];
            NSString *recommendStr = [NSString stringWithFormat:@"%@个",recommendCount];
            self.personalcenterView.view6.lab1.attributedText = [self SetAttributeString:recommendStr rang1:NSMakeRange(0, recommendStr.length - 1) rang2:NSMakeRange(recommendStr.length - 1, 1)];
            
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
        [self.tbView.mj_header endRefreshing];
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
    }];
    
}

#pragma mark - 附近车位数据
- (void)fetchFuJinCheWei{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"加载中";
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parkspot3/parklist", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:@"1" forKey:@"page"];
    [paramsDict setObject:@"10000" forKey:@"limit"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [self.tbView.mj_header endRefreshing];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            cheweiDataSource = [WYModelMineSpot mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            NSIndexSet *indexS = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
            [self.tbView reloadSections:indexS withRowAnimation:UITableViewRowAnimationFade];
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
        [self.tbView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [keyWindow makeToast:@"请检查网络"];
    }];
}


-(void)getMyBalance{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.requestSerializer.timeoutInterval = 10.0f;
    
    NSMutableDictionary * parameDict = [NSMutableDictionary dictionary];
    [parameDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@account/sum", KSERVERADDRESS];
    
    [manager POST:urlString parameters:parameDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //            NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
        NSString * result = [responseObject objectForKey:@"status"];
        NSString * message = [responseObject objectForKey:@"message"];
        NSLog(@"message = %@",message);
        
        if ([result isEqualToString:@"200"]){
            
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            
            NSString *moneySTR = dict[@"moneys"];
            mMoney = moneySTR;
            if ([moneySTR containsString:@"."]) {
                NSArray *temtAtt = [moneySTR componentsSeparatedByString:@"."];
                NSString *first = (NSString *)temtAtt.firstObject;
                NSString *lastStr =(NSString *)temtAtt.lastObject;
                self.personalcenterView.view1.lab1.attributedText = [self SetAttributeString:moneySTR rang1:NSMakeRange(0, first.length + 1 ) rang2:NSMakeRange(first.length + 1  , lastStr.length)];
            }else{
                self.personalcenterView.view1.lab1.attributedText = [self SetAttributeString:moneySTR rang1:NSMakeRange(0, moneySTR.length) rang2:NSMakeRange(moneySTR.length , 0)];
            }
            
        } else if([result isEqualToString:@"104"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }else{
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        
    }];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self fetchData];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}

- (void)SetNaviBar
{
    naviView = [[NaviView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    [self.view addSubview:naviView];
    
    [naviView.leftBtn setImage:[UIImage imageNamed:@"grzx_fb"] forState:UIControlStateNormal];
    [naviView.rightBtn setImage:[UIImage imageNamed:@"grzx_sz"] forState:UIControlStateNormal];
    naviView.titleLab.text = @"个人中心";
    naviView.titleLab.textColor = [UIColor whiteColor];
    
    [naviView.leftBtn addTarget:self action:@selector(GotoPersonInfoVC) forControlEvents:UIControlEventTouchUpInside];
    [naviView.rightBtn addTarget:self action:@selector(GotoSetVC) forControlEvents:UIControlEventTouchUpInside];
}



/******跳转到个人信息页*******/
- (void)GotoPersonInfoVC
{
    WYPersonalInfoVC *vc = WYPersonalInfoVC.new;
    [self.navigationController pushViewController:vc animated:YES];
}

/******跳转到设置页面*******/
- (void)GotoSetVC
{
    SetViewController* vc = [[SetViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableAttributedString*)SetAttributeString:(NSString*)string rang1:(NSRange)rang1 rang2:(NSRange)rang2
{
    NSString *str = string;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont boldSystemFontOfSize:16.0f]
                    range:rang1];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:13.0f]
                    range:rang2];
    return attrStr;
}

//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

#pragma mark - PersonalCenterViewDelegate
/*****点击资金*****/
/*****点击出租*****/
- (void)clickview1
{
    //    MyPackgeViewController* vc = [[MyPackgeViewController alloc]init];
    //    vc.balance = mMoney;
    //    [self.navigationController pushViewController:vc animated:YES];
    WYRendoutVC *vc = [[WYRendoutVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/*****点击优惠券*****/
/*****点击资金*****/
- (void)clickview2
{
    //    MYYouhuiquanViewController* vc = [[MYYouhuiquanViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
    
    MyPackgeViewController* vc = [[MyPackgeViewController alloc]init];
    vc.balance = mMoney;
    [self.navigationController pushViewController:vc animated:YES];
    
}

/*****点击关注*****/
/*****点击优惠券*****/
- (void)clickview3
{
    //    WYGuanZhuVC *vc = WYGuanZhuVC.new;
    //    [self.navigationController pushViewController:vc  animated:YES];
    
    MYYouhuiquanViewController* vc = [[MYYouhuiquanViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/*****点击订单*****/
/*****点击关注*****/
- (void)clickview4
{
    //    MyOrderViewController* vc = [[MyOrderViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
    
    WYGuanZhuVC *vc = WYGuanZhuVC.new;
    [self.navigationController pushViewController:vc  animated:YES];
}

/*****点击出门条*****/
- (void)clickview5
{
    WYCMTVC *vc = WYCMTVC.new;
    [self.navigationController pushViewController:vc animated:YES];
    
}

/*****点击推荐人*****/
- (void)clickview6
{
    WYLog(@"我推荐的人");
    WYGuQuanVC *vc = WYGuQuanVC.new;
    [self.navigationController pushViewController:vc animated:YES];
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
