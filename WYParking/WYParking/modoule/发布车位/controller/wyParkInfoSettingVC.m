//
//  wyParkInfoSettingVC.m
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/6.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import "wyParkInfoSettingVC.h"
//#import "wyAddTimeAndPriceVC.h"
//#import "LinkAdminViewController.h" //关联停车场
#import "wyAddTimeAndPriceVC.h"
#import "WYLinkVC.h"

@interface wyParkInfoSettingVC ()
{
    NSObject<UIViewPassValueDelegate> *delegate;
}
@property (weak, nonatomic) IBOutlet UIImageView *NeedImageView;
- (IBAction)btnDontNeedParkClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *dontNeedImageView;

@property (nonatomic, retain) NSObject<UIViewPassValueDelegate> *delegate;
- (IBAction)btnNeedParkClick:(id)sender;

@property (assign , nonatomic) BOOL isNeed;
@end

@implementation wyParkInfoSettingVC

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"设置停车场信息";
    self.isNeed = YES;
}

#pragma mark - 下一步
- (IBAction)nextClick:(id)sender {
    if (self.isNeed) {
        //需要
        self.push.park_type = @"1";
        WYLinkVC *vc = WYLinkVC.new;
        vc.push = self.push;
        self.delegate = vc;
        [self.delegate passValuelat:vc.push.lat passValuelnt:vc.push.lnt];
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        //不需要
        self.push.park_type = @"2";
        wyAddTimeAndPriceVC *vc = wyAddTimeAndPriceVC.new;
        vc.push = self.push;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

/**
 不需要停车场提供出入口放行服务

 @param sender
 */
- (IBAction)btnDontNeedParkClick:(id)sender {
    //sz_tcs  不需要
    self.dontNeedImageView.image = [UIImage imageNamed:@"sz_tcsxx"];
    self.NeedImageView.image = [UIImage imageNamed:@"sz_tcs"];
    self.isNeed = NO;
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    
//    NSString *urlString = [[NSString alloc] initWithFormat:@"%@/parking/api/web/index.php/v2/parkspot-v2/parkrelation", KSERVERADDRESS];
//    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
//    //    token	是	string	用户凭证
//    //    park_id	是	int	车位id
//    //    parklot_id	是	int	停车场id
//    //    park_type	是	int	类型 1停车场收费 2停车场不收费
//    [paramsDict setObject:[[Utils readDataFromPlist] objectForKey:@"token"] forKey:@"token"];
//    [paramsDict setObject:self.park_id forKey:@"park_id"];
//    [paramsDict setObject:@"0" forKey:@"parklot_id"];
//    [paramsDict setObject:@"2" forKey:@"park_type"];
//    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
//        [MBProgressHUD hideHUDForView:self.view];
//        NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:obj options:0 error:nil];
//        
//        if ([tempDict[@"status"] isEqualToString:@"200"]) {
//            wyAddTimeAndPriceVC *vc = wyAddTimeAndPriceVC.new;
//            vc.park_id = self.park_id;
//            [self.navigationController pushViewController:vc animated:YES];
//        
//        }else if([tempDict[@"status"] isEqualToString:@"104"])
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
//        }
//        else
//        {
//            [self.view makeToast:tempDict[@"message"]];
//        }
//
//    } failuer:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view];
//        [self.view makeToast:@"网络不通畅"];
//    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}



/**
 需要关联停车场

 @param sender
 */
- (IBAction)btnNeedParkClick:(id)sender {
   //sz_tcsxx  需要
    self.dontNeedImageView.image = [UIImage imageNamed:@"sz_tcs"];
    self.NeedImageView.image = [UIImage imageNamed:@"sz_tcsxx"];
    self.isNeed = YES;
}
@end
