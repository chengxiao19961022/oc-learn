//
//  WYParkingIsEmployee.m
//  WYParking
//
//  Created by glavesoft on 17/3/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYParkingIsEmployee.h"
#import "wyModelEmpolyee.h"
#import "WYModelParkDetailInfo.h"
#import "WYModelCMT.h"
#import "WYCMTCell.h"


typedef void(^fetchParkInfoBlock)(WYModelParkDetailInfo *model,BOOL issuccess);

@interface WYParkingIsEmployee ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBuilding;
@property (weak, nonatomic) IBOutlet UILabel *labParkTItle;
@property (strong , nonatomic) WYModelParkDetailInfo *detailInfo;
@property (strong , nonatomic) NSMutableArray *dataSource;

@end

@implementation WYParkingIsEmployee
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    @weakify(self);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //获取停车场信息
        @strongify(self);
      [self fetchParkInfoWithSuccess:^(WYModelParkDetailInfo *model, BOOL issuccess) {
          ;
      }];
    }];
    
    CGSize s = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.headerView.height = s.height;
     self.tbView.tableHeaderView = self.headerView;
    self.tbView.mj_header = header;
    header.stateLabel.hidden = YES;
     header.lastUpdatedTimeLabel.hidden = YES;
    [self.tbView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
//    [self.tbView.mj_header beginRefreshing];
    
}

- (void)fetchData{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parklot/entrylist", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    //    parklot_id	否	int	停车场id
    //    plate_nu	否	string	车牌号
    //    page	否	int	页数1 默认1
    //    limit	否	int	限制 默认10
    [paramsDict setObject:self.detailInfo.parklot_id   forKey:@"parklot_id"];
    [paramsDict setObject:@"1" forKey:@"page"];
    [paramsDict setObject:@"10000" forKey:@"limit"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            self.dataSource = [WYModelCMT mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            if (self.dataSource.count == 0) {
                [keyWindow makeToast:@"暂无出门条数据"];
            }else{
                [self.tbView reloadData];
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
        [keyWindow makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
    }];
}


#pragma mark - 停车场
- (void)fetchParkInfoWithSuccess:(fetchParkInfoBlock)successBolock{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parklot/parklotlist", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [self.tbView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            self.detailInfo = [WYModelParkDetailInfo mj_objectWithKeyValues:paramsDict[@"data"]];
            [self.imageViewBuilding setImageWithURL:[NSURL URLWithString:[wyLogInCenter shareInstance].sessionInfo.logo] placeholder:KPlaceHolderImg];
            self.labAddress.text = _detailInfo.address;
            self.labParkTItle.text = _detailInfo.building;
            self.imageViewBuilding.layer.cornerRadius = 25.0f;
            self.imageViewBuilding.layer.masksToBounds = YES;
            [self fetchData];
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

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
