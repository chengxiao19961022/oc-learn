//
//  WYXitongXiaoXiVC.m
//  WYParking
//
//  Created by glavesoft on 17/3/6.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYXitongXiaoXiVC.h"
#import "WYOrderRemindCell.h"
#import "WYXitongXiaoXiVC.h"
#import "WYModelMessage.h"
#import "WYOrderRemindCell.h"
#import "WYXiTongXiaoXIGuanZhuCell.h"

#import "WYOrderInfoVC.h"
#import "WYModelMYOrder.h"
@interface WYXitongXiaoXiVC ()<UITableViewDelegate,UITableViewDataSource>{
    int page;
}
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (strong , nonatomic) NSMutableArray *dataSource;
@property (weak , nonatomic) UITableViewCell *protocolCell;

@end

@implementation WYXitongXiaoXiVC

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tbView.delegate = self;
     self.tbView.dataSource = self;
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         page = 1;
        [self requestMsgDataWithPage:[NSString stringWithFormat:@"%d",page] limit:@"10"];
    }];
    [self.tbView.mj_header beginRefreshing];
    
    self.tbView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self requestMsgDataWithPage:[NSString stringWithFormat:@"%d",page] limit:@"10"];
    }];
    [self.tbView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tbView.mj_header beginRefreshing];

//    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"jbbg"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"jbbg"] forBarMetrics:UIBarMetricsDefault];

    self.title = @"系统消息";
    if (self.isPresent) {
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:20],
           NSForegroundColorAttributeName:[UIColor blackColor]}];
         [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:20],
           NSForegroundColorAttributeName:[UIColor whiteColor]}];
         [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
   
    @weakify(self);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        if (self.isPresent) {
            [self dismissViewControllerAnimated:YES completion:^{
                ;
            }];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
//            [self becomeRed];
        }
        
    }];
  
}

- (void)becomeRed{
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@smsg/updatestatus", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
    
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
                   }
    } failuer:^(NSError *error) {
        
    }];
}

- (void)requestMsgDataWithPage:(NSString *)pageStr limit:(NSString *)limit{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@smsg/list", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:pageStr forKey:@"page"];
    [paramsDict setObject:limit forKey:@"limit"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [self.tbView.mj_header endRefreshing];
        [self.tbView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            if (page == 1) {
                 self.dataSource = [WYModelMessage mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            }else{
                NSArray *datasource = [WYModelMessage mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
                [datasource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.dataSource addObject:obj];
                }];
            }
           
            [self.tbView reloadData];
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
        [self.tbView.mj_footer endRefreshing];
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell1;
    WYModelMessage *m = [self.dataSource objectAtIndex:indexPath.row];
    if ([m.type isEqualToString:@"1"]) {
        //系统消息
       WYOrderRemindCell *  cell = [WYOrderRemindCell cellWithTableView:tableView indexPath:indexPath];
        if (self.dataSource.count > indexPath.row) {
            [cell renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
        }
        cell1 = cell;
    }else{
        if (self.dataSource.count > indexPath.row) {
            WYXiTongXiaoXIGuanZhuCell *  cell = [WYXiTongXiaoXIGuanZhuCell cellWithTableView:tableView indexPath:indexPath];
            [cell renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
            cell1 = cell;
        }
    }
   
    self.protocolCell = cell1;
    return cell1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.protocolCell == nil) {
        return 60;
    }else{
         return [self.protocolCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
   
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WYModelMessage *model = [self.dataSource objectAtIndex:indexPath.row];

    /**
     type是1 表示订单，有订单id
     type是2 表示关注、福利等，无订单id
     **/
    if ([model.type isEqualToString:@"1"]) {
        NSLog(@"%@",model.order_id);
        [self orderDetail:model.order_id andMessageID:model.smsg_id];
        
    }else{
        return;
    }
}



#pragma mark 订单详情数据
-(void)orderDetail:(NSString *)orderID andMessageID:(NSString *)messageID{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.requestSerializer.timeoutInterval = 10.0f;
    
    NSMutableDictionary * parameDict = [NSMutableDictionary dictionary];
    
    [parameDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    
    [parameDict setObject:orderID forKey:@"order_id"];
    [parameDict setObject:messageID forKey:@"smsg_id"];

    NSString * urlString = [[NSString alloc] initWithFormat:@"%@order/orderdetail", KSERVERADDRESS];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:urlString parameters:parameDict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSString * result = [responseObject objectForKey:@"status"];
        NSString * message = [responseObject objectForKey:@"message"];
        NSLog(@"message = %@",message);
        
        if ([result isEqualToString:@"200"]){
            
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            WYOrderInfoVC *vc = WYOrderInfoVC.new;
            vc.myorder = [WYModelMYOrder mj_objectWithKeyValues:dict];
//            vc.indexpath = indexPath;
            vc.orderBlock = ^(NSIndexPath *ip){
                if (ip != nil) {
                    [self.tbView.mj_header beginRefreshing];
//                    self.indexPath = ip;
                }
            };
            [self.navigationController pushViewController:vc  animated:YES];
            
            
        } else if([result isEqualToString:@"104"]){
            
            
        }else{
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}


@end
