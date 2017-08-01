//
//  WYRendOutVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/10.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYRendoutVC.h"
#import "wyTabBarController.h"

#import "WYRendountTopView.h"
#import "WYCarCell.h"
#import "WYCheWeiFooter.h"
#import "WYBecomeTingCheChang.h"//变成停车场footer
//#import "WYTingCheChangInfoFooter.h"
#import "WYTingCheChangCell.h"

#import "WYModelMineSpot.h"
#import "WYModelPark_info.h"

#import "wyBasicInfoVC.h"//发布车位
#import "WYChuangJianTingCheChangVC.h"//创建停车场
#import "WYCarDetaiInfo.h"//车位详情
#import "MyParkingLot.h"//停车场详情
#import "WYParkingIsEmployee.h"//停车场详情
#import "NaviView.h"

@interface WYRendoutVC ()<UITableViewDelegate , UITableViewDataSource>
{
    NaviView* naviView;
}
@property (nonatomic , weak) WYRendountTopView *topView;

@property (weak, nonatomic)  UITableView *tbView;

@property (strong , nonatomic) WYModelPark_info *park_info;
@property (weak , nonatomic)  WYCheWeiFooter *cheweiFooter;
@property (weak , nonatomic)   WYBecomeTingCheChang *tingchechangFooter;
//缓存作用
@property (strong , nonatomic) NSMutableArray *CheWeiDataSourceContainer;
@property (strong , nonatomic) NSMutableArray *TingCheChangDataSourceContainer;

//@property (assign , nonatomic) BOOL isTingCheChang;
@end

@implementation WYRendoutVC

- (NSMutableArray *)cheweiDataSource{
    if (_cheweiDataSource == nil) {
        _cheweiDataSource = [NSMutableArray array];//车位队列初始化
    }
    return _cheweiDataSource;
}
- (NSMutableArray *)tingchechangDataSource{
    if (_tingchechangDataSource == nil) {
        _tingchechangDataSource = [NSMutableArray array];//停车场队列初始化
    }
    return _tingchechangDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configStyle];
    [self SetNaviBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefresh) name:WYCheWeiNeedRefresh object:@""];
    //self.isTingCheChang = NO;//ToDelete
}

#pragma mark - 下拉刷新数据？
- (void)needRefresh{
    [self.tbView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.rdv_tabBarController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jbbg"] forBarMetrics:UIBarMetricsDefault];
    self.rdv_tabBarController.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     self.rdv_tabBarController.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)SetNaviBar
{
    naviView = [[NaviView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    [self.view addSubview:naviView];
    
    [naviView.leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    naviView.rightBtn.hidden = YES;
    naviView.titleLab.text = @"出租";
    naviView.titleLab.textColor = [UIColor whiteColor];
    
    [naviView.leftBtn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
}
- (void)Back
{
    [self.navigationController popViewControllerAnimated:YES];
//    wyTabBarController *rootVC = [[wyTabBarController alloc] init];
//    rootVC.selectedIndex = 4;
//    [self.navigationController pushViewController:rootVC animated:YES];
}


#pragma mark - 配置布局的风格
- (void)configStyle{
    WYRendountTopView *topView = WYRendountTopView.new;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44 + 64);
    }];
    self.topView = topView;
    
    UITableView *tbView = [[UITableView alloc] init];
    [self.view addSubview:tbView];
    [tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.tbView = tbView;
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    @weakify(self);
    [RACObserve(topView, type) subscribeNext:^(NSString * x) {
        NSInteger type = [x integerValue];
        @strongify(self);
        if (type == renoutVcTypeCarSpot) {
            //车位
            [self configCheWei];
            [self fetchFuJinCheWei];
        }else{
            //停车场
            [self configTingCheChang];
            [self fetchTingCheChangInfo];
        }
        [self.tbView reloadData];
    }];

    self.tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if ([self.topView.type integerValue] == renoutVcTypeCarSpot) {
            [self fetchFuJinCheWei];
        }else{
            [self fetchTingCheChangInfo];
        }
        
    }];
    
}



#pragma mark - 初始化车位
- (void)configCheWei{
    self.tbView.tableFooterView = nil;
    self.tbView.tableHeaderView = nil;
    if (self.cheweiFooter == nil) {
        WYCheWeiFooter *cheweiFooter = WYCheWeiFooter.new;
        CGSize s = [cheweiFooter systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        cheweiFooter.height = s.height;
        self.tbView.tableFooterView = cheweiFooter;
        self.cheweiFooter = cheweiFooter;
        __weak typeof(self) weakSelf = self;
        [self.cheweiFooter bk_whenTapped:^{
            wyBasicInfoVC *vc = wyBasicInfoVC.new;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }else{
        self.tbView.tableFooterView = self.cheweiFooter;
    }
    
}

#pragma mark - 初始化停车场
- (void)configTingCheChang{
    self.tbView.tableFooterView = nil;
    self.tbView.tableHeaderView = nil;
    /*
    self.isTingCheChang = NO;
    if (self.isTingCheChang) {
        WYTingCheChangCell *footerView = WYTingCheChangCell.new;

        //WYTingCheChangInfoFooter *footerView = [WYTingCheChangInfoFooter view];
        footerView.height = [footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
        [footerView bk_whenTapped:^{
            MyParkingLot *vc = MyParkingLot.new;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        self.tbView.tableFooterView = footerView;
    }else{
    */
    if (self.tingchechangFooter == nil) {
        
        WYBecomeTingCheChang *tingchechangFooter = WYBecomeTingCheChang.new;
        CGSize s = [tingchechangFooter systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        tingchechangFooter.height = s.height;
        self.tbView.tableFooterView = tingchechangFooter;
        self.tingchechangFooter = tingchechangFooter;
        @weakify(self);
        __weak typeof(self) weakSelf = self;
        [tingchechangFooter bk_whenTapped:^{
            @strongify(self);
            WYChuangJianTingCheChangVC *vc = WYChuangJianTingCheChangVC.new;
            vc.refreshBlock = ^(BOOL needRefresh){
                if (needRefresh) {
                    [self configTingCheChang];
                }
            };
            [self.navigationController pushViewController:vc animated:YES];

        }];
    }else{
        self.tbView.tableFooterView = self.tingchechangFooter;
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;//返回列数sectons
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.topView.type integerValue] == renoutVcTypeCarSpot) {
        return self.cheweiDataSource.count;//返回车位的个数
    }else{
        return self.tingchechangDataSource.count;//返回停车场的个数
    }

}

#pragma mark - 返回每一行cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.topView.type integerValue] == renoutVcTypeCarSpot) {
        WYCarCell *cell = [WYCarCell cellWithTableView:tableView indexPath:indexPath];
        if (self.cheweiDataSource.count > indexPath.row) {
            [cell renderViewWithModel:[self.cheweiDataSource objectAtIndex:indexPath.row]];
        }
        return cell;
    }else{
        WYTingCheChangCell *cell = [WYTingCheChangCell cellWithTableView:tableView indexPath:indexPath];
        if (self.tingchechangDataSource.count > indexPath.row) {
            [cell renderViewWithModel:[self.tingchechangDataSource objectAtIndex:indexPath.row]];
        }
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.topView.type integerValue] == renoutVcTypeCarSpot) {
        return 60;
    }else{
        return 80;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.topView.type integerValue] == renoutVcTypeCarSpot) {
        return YES;
    }else{
        WYTingCheChangCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.labStatus.text isEqualToString:@"审核中"]) {
            return NO;
        }else{
            return YES;
        }
    }
}
/*
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([self.topView.type integerValue] == renoutVcTypeCarSpot) {
        return UITableViewCellEditingStyleDelete;
    }else{
        WYTingCheChangCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.labStatus.text isEqualToString:@"审核中"]) {
            return UITableViewCellEditingStyleNone;
        }else{
            return UITableViewCellEditingStyleDelete;
        }
    }
    
        
}
*/
#pragma mark - 删除和修改按钮
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.topView.type integerValue] == renoutVcTypeCarSpot) {
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self delParkWithIndexPath:indexPath];
        }];
        return @[deleteAction];
    }else{
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [self delTCCWithIndexPath:indexPath];
        }];
        action.backgroundColor = [UIColor orangeColor];
        return @[action];
    }
    
}

#pragma mark - 点击显示详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.topView.type integerValue] == renoutVcTypeCarSpot) {
        WYCarCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.labStatus.hidden == YES) {
            WYCarDetaiInfo *vc = WYCarDetaiInfo.new;
            vc.isMe = YES;
            WYModelMineSpot *model = [self.cheweiDataSource objectAtIndex:indexPath.row];
            vc.park_id = model.park_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self.view makeToast:cell.labStatus.text];
        }
     }else{
         WYTingCheChangCell *cell = [tableView cellForRowAtIndexPath:indexPath];
         if (cell.labStatus.hidden == YES) {
             
             MyParkingLot *vc = MyParkingLot.new;
             WYModelPark_info *model = [self.tingchechangDataSource objectAtIndex:indexPath.row];
             vc.parklot_id = model.parklot_id;
             WYLog(@"点击cell跳转到MyParkingLot显示停车场详情");
             [self.navigationController pushViewController:vc animated:YES];
            
         }else{
             [self.view makeToast:cell.labStatus.text];
         }
     }
}

#pragma mark - 附近车位数据
- (void)fetchFuJinCheWei{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中";
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parkspot3/parklist", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:@"1" forKey:@"page"];
    [paramsDict setObject:@"10000" forKey:@"limit"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [self.tbView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            self.CheWeiDataSourceContainer = self.cheweiDataSource = [WYModelMineSpot mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
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

#pragma mark - 接受停车场数据
- (void)fetchTingCheChangInfo{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中";
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parklot/parklotlist", KSERVERADDRESS];
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:@"1" forKey:@"page"];
    [paramsDict setObject:@"10000" forKey:@"limit"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [self.tbView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            // 将字典数组转成模型数组
            self.TingCheChangDataSourceContainer = self.tingchechangDataSource = [WYModelPark_info mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            NSIndexSet *indexS = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
            [self.tbView reloadSections:indexS withRowAnimation:UITableViewRowAnimationFade];
            /*
            self.park_info = [self.tingchechangDataSource objectAtIndex:indexPath.row];
            [footerView bk_whenTapped:^{
                
                if ([self.park_info.is_employe isEqualToString:@"1"]) {
                    //是停车场员工
                    WYParkingIsEmployee *vc = WYParkingIsEmployee.new;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([obj1.is_employe isEqualToString:@"2"]){
                    //不是停车场员工
                    if ([footerView.labStatus.text isEqualToString:@"审核失败"]) {
                        WYChuangJianTingCheChangVC *vc = WYChuangJianTingCheChangVC.new;
                        @weakify(self);
                        vc.refreshBlock = ^(BOOL needRefresh){
                            if (needRefresh) {
                                @strongify(self);
                                [self configTingCheChang];
                            }
                        };
                        [vc renderWithType:vctypeEdit model:_park_info];
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        MyParkingLot *vc = MyParkingLot.new;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                }
                
            }];
            */
            
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
/*
- (void)fetchTingCheChangInfo{
    __block NSString *status_name = @"";
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parklot/parklotlist", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [self.tbView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
       
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            self.TingCheChangDataSourceContainer = self.tingchechangDataSource = [WYModelPark_info mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            //self.park_info = [WYModelPark_info mj_objectWithKeyValues:paramsDict[@"data"]];
           
            if (self.isTingCheChang) {
                WYTingCheChangCell *footerView = WYTingCheChangCell.new;
                //WYTingCheChangInfoFooter *footerView = [WYTingCheChangInfoFooter view];
                footerView.labStatus.hidden = NO;
                if ([status_name isEqualToString:@"审核中"]) {
                    footerView.labStatus.backgroundColor = [UIColor orangeColor];
                }else if([status_name isEqualToString:@"审核失败"]){
                    footerView.labStatus.backgroundColor = [UIColor redColor];
                }else{
                    footerView.labStatus.hidden = YES;
                }
                
                footerView.labStatus.text = status_name;
                //footerView.labParkTitle.text = self.park_info.building;
                footerView.height = [footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                [footerView bk_whenTapped:^{
                    if ([status_name isEqualToString:@"审核中"]) {
                        [self.view makeToast:@"停车场审核中"];
                        return ;
                    }
                    if ([self.park_info.is_employe isEqualToString:@"1"]) {
                        //是停车场员工
                        WYParkingIsEmployee *vc = WYParkingIsEmployee.new;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else if ([self.park_info.is_employe isEqualToString:@"2"]){
                        //不是停车场员工
                        if ([footerView.labStatus.text isEqualToString:@"审核失败"]) {
                            WYChuangJianTingCheChangVC *vc = WYChuangJianTingCheChangVC.new;
                            @weakify(self);
                            vc.refreshBlock = ^(BOOL needRefresh){
                                if (needRefresh) {
                                    @strongify(self);
                                    [self configTingCheChang];
                                }
                            };
                            [vc renderWithType:vctypeEdit model:_park_info];
                            [self.navigationController pushViewController:vc animated:YES];
                        }else{
                            MyParkingLot *vc = MyParkingLot.new;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        
                    }
                    
                }];
                self.tbView.tableFooterView = footerView;
            }else{
                [self configTingCheChang];//初始化停车场
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
        [self.tbView.mj_header endRefreshing];
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
    }];
}

*/

#pragma mark  - 删除车位
- (void)delParkWithIndexPath:(NSIndexPath *)indexPath{
    
    WYModelMineSpot  *model = [self.cheweiDataSource objectAtIndex:indexPath.row];
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@parkspot/delpark", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:model.park_id forKey:@"park_id"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        NSMutableDictionary *tempDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        NSLog(@"删除车位%@",paramsDict);
        if ([tempDict[@"status"] isEqualToString:@"200"]) {
            //成功
            [self.view makeToast:@"删除成功"];
            [self.cheweiDataSource removeObjectAtIndex:indexPath.row];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
            [self.tbView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else if([tempDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            [self.view makeToast:tempDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [self.view makeToast:@"请检查网络"];
    }];
    
}

#pragma mark  - 修改停车场
- (void)delTCCWithIndexPath:(NSIndexPath *)indexPath{
    
    WYModelPark_info  *model = [self.tingchechangDataSource objectAtIndex:indexPath.row];
    WYChuangJianTingCheChangVC *vc = WYChuangJianTingCheChangVC.new;
    [vc renderWithType:vctypeEdit model: model];
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@parklot/editparklot", KSERVERADDRESS];
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:model.parklot_id forKey:@"parklot_id"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        NSLog(@"参数%@",paramsDict);
        //NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        NSMutableDictionary *tempDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        NSLog(@"状态%@",tempDict);
        //NSLog(@"状态%@",paramsDict);
        if ([tempDict[@"status"] isEqualToString:@"101"]) {
            
            
            [self.navigationController pushViewController:vc animated:YES];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
            [self.tbView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            //成功
            //[self.view makeToast:@"修改成功"];

        }else if([tempDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            [self.view makeToast:tempDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [self.view makeToast:@"请检查网络"];
    }];
    
}


@end
