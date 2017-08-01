//
//  WYCMTVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYCMTVC.h"
#import "WYCMTCell.h"
#import "WYModelCMT.h"

@interface WYCMTVC ()<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (strong , nonatomic) NSMutableArray *dataSource;
@end

@implementation WYCMTVC
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault]; //设置为白色
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak typeof(self) weakSelf = self;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"我的出门条";
//    @weakify(self);
//    self.tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        @strongify(self);
//        [self fetchData];
//    }];
//    [self.tbView.mj_header beginRefreshing];
    [self fetchData];
}


- (void)fetchData{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tbView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parklot/entrylist", KSERVERADDRESS];
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
     [paramsDict setObject:@"1" forKey:@"page"];
     [paramsDict setObject:@"10000" forKey:@"limit"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [self.tbView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.tbView animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            self.dataSource = [WYModelCMT mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
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
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}


#pragma mark - UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYCMTCell *cell = [WYCMTCell cellWithTableView:tableView indexPath:indexPath];
   
    if (self.dataSource.count > indexPath.row) {
        [cell renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 236;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
