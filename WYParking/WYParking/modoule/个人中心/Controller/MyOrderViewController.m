//
//  MyOrderViewController.m
//  WYParking
//
//  Created by admin on 17/2/17.
//  Copyright © 2017年 glavesoft. All rights reserved.
// 订单
#define BILI 200/598.f

#import "MyOrderViewController.h"
#import "MyOrderCell.h"
#import "WYModelMYOrder.h"
#import "WYOrderInfoVC.h"
#import "NaviView.h"

@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _index;
    NaviView* naviView;
}

@property (nonatomic,strong) UITableView* mytableview;
@property (strong , nonatomic) NSMutableArray *dataSource;

//private
@property (strong , nonatomic) NSIndexPath *indexPath;

@end

@implementation MyOrderViewController

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    if ([wyLogInCenter shareInstance].loginstate == wyLogInStateNotLogin) {
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//        [keyWindow makeToast:@"您还未登录，即将跳转到登录页面！"];
        [NSThread sleepForTimeInterval:1];
        NSArray *isfromgrzx = [NSArray arrayWithObjects:@"1",@"",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToAPP" object:isfromgrzx];
        return;
    }

    [self.view setBackgroundColor:[UIColor whiteColor]];
//    UITableView *tbView = [[UITableView alloc] init];
//    tbView.delegate = self;
//    tbView.dataSource = self;
//    [self.view addSubview:tbView];
//    self.mytableview = tbView;
    self.mytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
//    self.mytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, (self.navigationController.navigationBar.height+self.navigationController.navigationBar.top),[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    [self.mytableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.navigationController.navigationBar.mas_bottom);
//    }];
//    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.mytableview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.rdv_tabBarController.navigationController.navigationBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.rdv_tabBarController.navigationController.navigationBar.height];
//    [self.view addConstraint:topConstraint];
    self.mytableview.backgroundColor = [UIColor whiteColor];
    self.mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mytableview.delegate = self;
    self.mytableview.dataSource = self;
    
    //self.mytableview.rowHeight = UITableViewAutomaticDimension;
    //self.mytableview.estimatedRowHeight = 1000.0f;
//    @weakify(self);
    self.mytableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        @strongify(self);
        _index = 1;
        [self fetchData];
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _index++;
        [self fetchData];
    }];
    footer.automaticallyRefresh = YES;
    self.mytableview.mj_footer = footer;
    [self.mytableview.mj_header beginRefreshing];
    [self.view addSubview:self.mytableview];
    [self SetNaviBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.rdv_tabBarController.navigationController.navigationItem setHidesBackButton:YES];
//    [self.rdv_tabBarController.navigationItem setHidesBackButton:YES];
//    [self.rdv_tabBarController.navigationController.navigationBar.backItem setHidesBackButton:YES];
//    [self.navigationController.navigationItem setHidesBackButton:YES];
//    [self.navigationItem setHidesBackButton:YES];
//    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    
    [self.rdv_tabBarController.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.rdv_tabBarController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jbbg"] forBarMetrics:UIBarMetricsDefault];
    self.rdv_tabBarController.navigationItem.rightBarButtonItem = nil;
    self.rdv_tabBarController.navigationController.title = @"我的订单";
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.rdv_tabBarController.navigationController.navigationBarHidden = NO;
    
}

- (void)fetchData{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@order/orderlist", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:[NSString stringWithFormat:@"%d",_index] forKey:@"page"];
    [paramsDict setObject:@"10" forKey:@"limit"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [self.mytableview.mj_footer endRefreshing];
        [self.mytableview.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSArray *temtArr =[WYModelMYOrder mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            if (_index == 1) {
                [self.dataSource removeAllObjects];
                self.dataSource = temtArr.mutableCopy;
            }else{
                for (int i = 0; i<temtArr.count; i++) {
                    [self.dataSource addObject:[temtArr objectAtIndex:i]];
                }
            }
            if (temtArr.count > 0) {
                 [self.mytableview reloadData];
            }else{
                [self.view makeToast:@"亲～，没有订单了"];
            }
           
           
            if (self.indexPath != nil) {
//                [self.mytableview scrollToRowAtIndexPath:self.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
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
        if (_index!=0) {
            _index--;
        }
        [self.mytableview.mj_footer endRefreshing];
        [self.mytableview.mj_header endRefreshing];
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)SetNaviBar
//{
//    self.rdv_tabBarController.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBarHidden = NO;
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     
//     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
//       
//       NSForegroundColorAttributeName:[UIColor blackColor]}];
//    
//    
//    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jbbg"] forBarMetrics:UIBarMetricsDefault];
//    
//    
//    self.title = @"我的订单";
////    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 27, 27)];
////    [btn setImage:[UIImage imageNamed:@"back3"] forState:UIControlStateNormal];
////    [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
////    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
////    self.navigationItem.leftBarButtonItem = leftItem;
//    self.navigationItem.hidesBackButton = YES;
//
//}

- (void)SetNaviBar
{
    naviView = [[NaviView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    [self.view addSubview:naviView];
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"jbbg"]];
    [naviView.bgView setBackgroundColor:bgColor];
//    [naviView.leftBtn setImage:[UIImage imageNamed:@"grzx_fb"] forState:UIControlStateNormal];
    [naviView.leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    naviView.titleLab.text = @"我的订单";
    naviView.titleLab.textColor = [UIColor whiteColor];
    naviView.rightBtn.hidden = YES;
    [naviView.leftBtn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    if (!_isFromJpush)
    {naviView.leftBtn.hidden = YES;}
//    [naviView.leftBtn addTarget:self action:@selector(GotoPersonInfoVC) forControlEvents:UIControlEventTouchUpInside];
//    [naviView.rightBtn addTarget:self action:@selector(GotoSetVC) forControlEvents:UIControlEventTouchUpInside];
}

- (void)Back
{
    if (self.isFromJpush) {
        [self dismissViewControllerAnimated:YES completion:^{
            ;
        }];
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate && UITableViewDataSource
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 135;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.width*BILI;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifer = @"cell";
    MyOrderCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyOrderCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.dataSource.count > indexPath.row) {
        [cell renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WYOrderInfoVC *vc = WYOrderInfoVC.new;
    vc.myorder = [self.dataSource objectAtIndex:indexPath.row];
    vc.indexpath = indexPath;
    vc.orderBlock = ^(NSIndexPath *ip){
        if (ip != nil) {
            [self.mytableview.mj_header beginRefreshing];
            self.indexPath = ip;
        }
    };
    [self.navigationController pushViewController:vc  animated:YES];
}
@end
