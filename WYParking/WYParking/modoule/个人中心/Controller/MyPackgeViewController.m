//
//  MyPackgeViewController.m
//  WYParking
//
//  Created by admin on 17/2/16.
//  Copyright © 2017年 glavesoft. All rights reserved.
// 资金

#import "MyPackgeViewController.h"
#import "packgeView.h"
#import "NaviView.h"
#import "WYChongZhiFangShiVC.h"
#import "WYTiXianVC.h"
#import "WYMingXiVC.h"
#import "WYChongZhiFangShiVC.h"
#import "BoundZfbViewController.h"

@interface MyPackgeViewController ()<UITableViewDelegate>
{
    NaviView* naviView;
    
    packgeView* packgeview;
}
@end

@implementation MyPackgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView* mytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    mytableview.delegate = self;
    [self.view addSubview:mytableview];

    
    packgeview = [[[NSBundle mainBundle]loadNibNamed:@"packgeView" owner:self options:nil]lastObject];
    packgeview.userInteractionEnabled = YES;
    packgeview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
   
    
    mytableview.tableHeaderView = packgeview;
    [packgeview.btnChongZhi addTarget:self action:@selector(chongZhi) forControlEvents:UIControlEventTouchUpInside];
    [packgeview.btnTiXian addTarget:self action:@selector(tiXian) forControlEvents:UIControlEventTouchUpInside];
    
     [packgeview.btnMingXi addTarget:self action:@selector(mingXi) forControlEvents:UIControlEventTouchUpInside];

    [packgeview.bangZfbBtn addTarget:self action:@selector(bangZfb) forControlEvents:UIControlEventTouchUpInside];

    [self SetNaviBar];
    
    [self initialization];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)initialization{
    
    packgeview.balanceLab.text = self.balance;//余额

    //充值成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyBalance) name:@"czKpaySuccess" object:nil];
    
    
    //前往绑定支付宝
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bangZfb) name:@"GOTOBOUND" object:nil];


}

- (void)chongZhi{
    WYLog(@"充值");
    WYChongZhiFangShiVC *vc =  WYChongZhiFangShiVC.new;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tiXian{
    WYLog(@"提现");
    WYTiXianVC *vc =  WYTiXianVC.new;
    vc.balance = self.balance;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)mingXi{
    WYLog(@"明细");
    
    WYMingXiVC *vc =  WYMingXiVC.new;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 绑定支付宝
-(void)bangZfb{
    BoundZfbViewController *zfbVC = [[BoundZfbViewController alloc]init];
    [self.navigationController pushViewController:zfbVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)SetNaviBar
{
    naviView = [[NaviView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    [self.view addSubview:naviView];
    
    [naviView.leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    naviView.rightBtn.hidden = YES;
    naviView.titleLab.text = @"我的钱包";
    naviView.titleLab.textColor = [UIColor whiteColor];
    
    [naviView.leftBtn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)Back
{
    [self.navigationController popViewControllerAnimated:YES];
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
            
            self.balance = dict[@"moneys"];
            packgeview.balanceLab.text = self.balance;//余额

            
        } else if([result isEqualToString:@"104"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }else{
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        
    }];
    
    
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
