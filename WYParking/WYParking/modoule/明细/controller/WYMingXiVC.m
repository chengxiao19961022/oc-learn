//
//  WYMingXiVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYMingXiVC.h"
#import "WYMingXiTopView.h"
#import "NaviView.h"
#import "WYMingXiCell.h"
#import "WYModelMingXi.h"
#import "LBHeaderFooterView.h"



@interface WYMingXiVC ()<UITableViewDelegate,UITableViewDataSource>{
      NaviView* naviView;
    NSInteger _index;
    type _t;
}

@property (weak , nonatomic) WYMingXiTopView *topView;

@property (weak, nonatomic)  UITableView *tbView;

@property (strong , nonatomic) NSMutableArray *dataSource;

@end

@implementation WYMingXiVC

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];

    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    WYMingXiTopView *topView = WYMingXiTopView.new;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
    }];
    topView.layer.masksToBounds = YES;
    self.topView = topView;
    
    UITableView *tbView = [[UITableView alloc] init];
    tbView.delegate = self;
    tbView.dataSource = self;
    [self.view addSubview:tbView];
    self.tbView = tbView;
    [tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    @weakify(self);
    [RACObserve(topView, type) subscribeNext:^(NSString * x) {
        NSInteger t = [x integerValue];
        @strongify(self);
        _t = t;
        _index = 1;
        [self fetcgDataWithType:t];
       
    }];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _index = 1;
        [self fetcgDataWithType:_t];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tbView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _index ++;
        [self fetcgDataWithType:_t];
    }];
    self.tbView.mj_footer = footer;
    footer.automaticallyRefresh = NO;
    
    [self SetNaviBar];
    
}

- (void)fetcgDataWithType:(type)t{
    if (t == typeShouRUMingXi) {
        [self fetchshouRuMIngXiData];
    }else{
        [self fetchZhiChuMingXiData];
    }
}

- (void)SetNaviBar
{
    naviView = [[NaviView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    [self.view addSubview:naviView];
    
    [naviView.leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    naviView.rightBtn.hidden = YES;
    naviView.titleLab.text = @"资金明细";
    naviView.titleLab.textColor = [UIColor whiteColor];
    [naviView.leftBtn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
}






- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)Back
{
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:^{
            ;
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)fetchshouRuMIngXiData{
 
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@account/list", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
     [paramsDict setObject:[NSString stringWithFormat:@"%d",_index] forKey:@"page"];
    [paramsDict setObject:@"1" forKey:@"type"];
     [paramsDict setObject:@"10" forKey:@"limit"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [self.tbView.mj_header endRefreshing];
        [self.tbView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            WYLog(@"daying");
//            [self.dataSource addObject: [WYModelMingXi mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]]];
            if (_index == 1){
                self.dataSource =[WYModelMingXi mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
                
            }
            else{
                DataSourceTmp = [WYModelMingXi mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
                if (DataSourceTmp)
                {[self.dataSource addObjectsFromArray:DataSourceTmp];}
                else{
                    [self.view makeToast:@"亲， 没有数据了"];
                    _index--;
                }
                [self.tbView reloadData];
            }
            //                            self.dataSource =[WYModelMingXi mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            //            if (self.dataSource.count == 0) {
            //                [self.view makeToast:@"亲， 没有数据了"];
            //            }
            [self.tbView reloadData];
            //            [self.tbView scrollToRow:0 inSection:0 atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
        [self.tbView.mj_header endRefreshing];
        [self.tbView.mj_footer endRefreshing];
        [self.view makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

NSMutableArray *DataSourceTmp;
- (void)fetchZhiChuMingXiData{
 
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@account/list", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:[NSString stringWithFormat:@"%d",_index] forKey:@"page"];
    [paramsDict setObject:@"2" forKey:@"type"];
    [paramsDict setObject:@"10" forKey:@"limit"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [self.tbView.mj_header endRefreshing];
        [self.tbView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            
            if (_index == 1){
                self.dataSource =[WYModelMingXi mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];

            }
            else{
               DataSourceTmp = [WYModelMingXi mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
                if (DataSourceTmp)
                {[self.dataSource addObjectsFromArray:DataSourceTmp];}
                else{
                    [self.view makeToast:@"亲， 没有数据了"];
                    _index--;
                }
                [self.tbView reloadData];
                }
//                            self.dataSource =[WYModelMingXi mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
//            if (self.dataSource.count == 0) {
//                [self.view makeToast:@"亲， 没有数据了"];
//            }
            [self.tbView reloadData];
//            [self.tbView scrollToRow:0 inSection:0 atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
        [self.tbView.mj_header endRefreshing];
        [self.tbView.mj_footer endRefreshing];
        [self.view makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //WYModelMingXi *m = [self.dataSource objectAtIndex:_index];
//    if(_index == 1)
//    {counter = 0;}
//
        WYModelMingXi *m = [self.dataSource objectAtIndex:section];
//        NSLog(@"%lu", m.data.count);
//        counter=counter+m.data.count;
    //counter = 1;
    return m.data.count;
    
}

NSIndexPath *indextmp;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYMingXiCell *cell = [WYMingXiCell cellWithTableView:tableView indexPath:indexPath];
    if (self.dataSource.count > indexPath.section) {
        WYModelMingXi *m = [self.dataSource objectAtIndex:indexPath.section];
        NSArray *tempArr = m.data;
        if (m.data.count > indexPath.row) {
            if (indexPath.row == 0 || indexPath.row == m.data.count -1) {
                if (indexPath.row == 0) {
                    cell.topLine.hidden = YES;
                }else{
                    cell.topLine.hidden = NO;
                }
                if (indexPath.row == m.data.count - 1) {
                    cell.bottomLine.hidden = YES;
                }else{
                    cell.bottomLine.hidden = NO;
                }
            }else{
                cell.bottomLine.hidden = NO;
                cell.topLine.hidden = NO;

            }
            
            WYModelDetail *detailModel = [tempArr objectAtIndex:indexPath.row];
            
            [cell renderViewWithModel:detailModel];
        }
       
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
    
}

#pragma mark 获取资金明细
-(void)getMyCapitalDetai{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary * parameDict = [NSMutableDictionary dictionary];
    [parameDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@", KSERVERADDRESS];
    
    [manager POST:urlString parameters:parameDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //            NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
        NSString * result = [responseObject objectForKey:@"status"];
        NSString * message = [responseObject objectForKey:@"message"];
        NSLog(@"message = %@",message);
        
        if ([result isEqualToString:@"200"]){
            
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            
            
            
        } else if([result isEqualToString:@"104"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }else{
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        
    }];
    
    
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LBHeaderFooterView *header = [LBHeaderFooterView HeaderWithTableview:tableView];
    WYModelMingXi * model = [self.dataSource objectAtIndex:section];
    header.titleLable.text = model.month;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    LBHeaderFooterView *header = [LBHeaderFooterView HeaderWithTableview:tableView];
    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}



@end
