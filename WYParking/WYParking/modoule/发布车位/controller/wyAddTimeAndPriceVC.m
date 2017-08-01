//
//  wyAddTimeAndPriceVC.m
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/6.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import "wyAddTimeAndPriceVC.h"
#import "wyTimesPriceCell.h"
#import "wyAddTimeAndPriceBtn.h"
#import "WYTimeCountVC.h"
//#import "FreeTimeViewController.h"//设置时间数量
//#import "wyMineSpotVC.h" //我的车位页面
//#import "wyModelTimePrice.h" //时间段模型
//#import "SelectCycleViewController.h"

@interface wyAddTimeAndPriceVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak , nonatomic) UITableView *tbView;

@property (strong , nonatomic) NSMutableArray *dataSourceArr;

@property (weak , nonatomic) UIView *headerView;

@property (weak , nonatomic) wyTimesPriceCell *protocalCell;

@property (assign , nonatomic) BOOL hasChanged;

@end

@implementation wyAddTimeAndPriceVC


/**
 lazy load

 @return 
 */
- (NSMutableArray *)dataSourceArr{
    if (_dataSourceArr == nil) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchTimeAndPrice:) name:@"addTypeAndPrice" object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    @weakify(self);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];

        
    }];
    self.title = @"添加时间价格";
    
    UITableView *tbView = UITableView.new;
    tbView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:tbView];
    [tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    tbView.showsVerticalScrollIndicator = NO;
    tbView.delegate  = self;
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.dataSource = self;
    self.tbView = tbView;
    
    //footerView
    {
        UIView *footerView = UIView.new;
        footerView.backgroundColor = [UIColor clearColor];
        //add time and price
        UIView *topView = UIView.new;
        [footerView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(5);
            make.height.mas_equalTo(50);
        }];
        topView.backgroundColor = UIColor.whiteColor;
        
        wyAddTimeAndPriceBtn *btn = wyAddTimeAndPriceBtn.new;
        [topView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.mas_equalTo(btn.superview);
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [btn addTarget:self action:@selector(addPriceAndTime1) forControlEvents: UIControlEventTouchUpInside];
       
        //add btn提交按钮
        UIButton *btnCommit = UIButton.new;
        btnCommit.backgroundColor = kNavigationBarBackGroundColor;
        [btnCommit setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [btnCommit setTitle:@"提交" forState:UIControlStateNormal];
        [btnCommit addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:btnCommit];
        [btnCommit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).with.offset(15);
            make.left.right.equalTo(topView);
            make.height.mas_equalTo(45);
            make.bottom.mas_equalTo(-10);
        }];
        footerView.height = [footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        self.tbView.tableFooterView = footerView;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (self.isNeedShow) {
        [self.view makeToast:@"关联车位修改成功"];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
}


- (void)fetchTimeAndPrice:(NSNotification *)notification{
    wyModelSaletimes *saletimes = notification.object;
    if (saletimes.isEdit == YES) {
        [self.push.json_saletimes removeObjectAtIndex:saletimes.index];
    }
    [self.dataSourceArr addObject:saletimes];
    [self.push.json_saletimes addObject:saletimes];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
    [self.tbView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - 提交最后一步
- (void)commit{
    if (self.push.json_saletimes.count <= 0) {
        [self.view makeToast:@"请先添加时间价格"];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@parkspot3/releaseparking",KSERVERADDRESS];
//    NSDictionary *parametersDic = self.push.mj_keyValues.copy;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
//    token	是	string	用户凭证
//    pic	是	string	车位图片
//    park_title	是	int	车位标题
//    address	是	string	车位地址
//    lat	是	string	地址维度
//    lnt	是	string	地址经度
//    addr_note	否	string	地址备注
//    parklot_id	否	int	停车场id
//    park_type	否	int	类型 1停车场收费 2停车场不收费
//    json_saletimes
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    [parametersDic setObject:self.push.token forKey:@"token"];
    [parametersDic setObject:self.push.pic forKey:@"pic"];
    [parametersDic setObject:self.push.park_title forKey:@"park_title"];
    [parametersDic setObject:self.push.address forKey:@"address"];
    [parametersDic setObject:self.push.lat forKey:@"lat"];[parametersDic setObject:self.push.lnt forKey:@"lnt"];
    if (!([self.push.addr_note isEqualToString:@""]||self.push.addr_note  == nil)) {
        [parametersDic setObject:self.push.addr_note forKey:@"addr_note"];
    }else{
        [parametersDic setObject:@"" forKey:@"addr_note"];
    }
    if ([self.push.park_type isEqualToString:@"1"]) {
        //需要
         [parametersDic setObject:self.push.parklot_id forKey:@"parklot_id"];
        [parametersDic setObject:self.push.park_type forKey:@"park_type"];
        
    }else{
        [parametersDic setObject:self.push.park_type forKey:@"park_type"];
    }

   
    
    NSMutableArray *jsonSaletimes_Arr = [NSMutableArray array];
    [self.push.json_saletimes enumerateObjectsUsingBlock:^(wyModelSaletimes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *arr = [wyModelTypePrice mj_keyValuesArrayWithObjectArray:obj.json_saletype];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:obj.saletimes_id forKey:@"saletimes_id"];
        [dic setObject:obj.start_date forKey:@"start_date"];
        [dic setObject:obj.start_time forKey:@"start_time"];
        [dic setObject:obj.end_time forKey:@"end_time"];
        [dic setObject:obj.note forKey:@"note"];
       
        [dic setObject:obj.spot_num forKey:@"spot_num"];
        [dic setObject:arr.mj_JSONString forKey:@"json_saletype"];
        [jsonSaletimes_Arr addObject:dic];
        
    }];
    NSString *str = jsonSaletimes_Arr.mj_JSONString;
    

    [parametersDic setObject:str forKey:@"json_saletimes"];
    
//    NSMutableArray *jsonSaletimes_Arr = [NSMutableArray array];
//    jsonSaletimes_Arr = self.push.json_saletimes.mutableCopy;
//    [jsonSaletimes_Arr enumerateObjectsUsingBlock:^(wyModelSaletimes*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSArray *arr = [wyModelTypePrice mj_keyValuesArrayWithObjectArray:obj.json_saletype];
//        obj.json_saletype = arr.mutableCopy;
//    }];
//    NSString *str = [wyModelSaletimes mj_keyValuesArrayWithObjectArray:jsonSaletimes_Arr].mj_JSONString;
//     [parametersDic setObject:str forKey:@"json_saletimes"];
    NSLog(@"%@",str);
    [wyApiManager sendApi:urlString parameters:parametersDic success:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view];
        NSDictionary *tempDict= [NSJSONSerialization JSONObjectWithData:obj options:0 error:nil];
        if ([tempDict[@"status"] isEqualToString:@"200"]) {
            //成功
            WYLog(@"saf");
            WYLog(@"添加时间和价格");
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if([tempDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            [self.view makeToast:tempDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [self.view makeToast:@"网络不通畅"];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}


#pragma mark - 跳转添加时间价格页面
- (void)addPriceAndTime1{
//    FreeTimeViewController *vc = [[FreeTimeViewController alloc] init];
//    vc.isFormParkSpotManger = self.isFormParkSpotManger;
//    vc.parkID = self.park_id;
//    [self.navigationController pushViewController:vc animated:YES];
    WYTimeCountVC *vc = [[WYTimeCountVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableViewDelegate , tableViewData

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.push.json_saletimes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    wyTimesPriceCell *cell = [wyTimesPriceCell cellWithTableView:tableView indexPath:indexPath];
    @weakify(self);
    cell.clickBlock = ^(timeCellClickType tt,NSIndexPath *iP , wyModelSaletimes *model){
        @strongify(self);
        if (tt == timeCellClickTypeDlete) {
            [self delParkWithIndexPath:indexPath];
        }else{
            WYTimeCountVC *vc = WYTimeCountVC.new;
            [vc isEdit:YES withIndexPathRow:indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    if (indexPath.row < self.push.json_saletimes.count) {
        [cell renderViewWithModel:[self.push.json_saletimes objectAtIndex:indexPath.row]];
    }
    self.protocalCell = cell;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.protocalCell == nil) {
        return 180;
    }else{
        CGFloat height = [self.protocalCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        return height;
    }
   
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self delParkWithIndexPath:indexPath];
    }];
    return @[action];
}

#pragma mark  - 删除车位
- (void)delParkWithIndexPath:(NSIndexPath *)indexPath{
    
    [self.push.json_saletimes removeObjectAtIndex:indexPath.row];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
    [self.tbView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
//  [self.tbView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    wyModelTimePrice  *model = [self.dataSourceArr objectAtIndex:indexPath.row];
//    NSString *urlString = [[NSString alloc] initWithFormat:@"%@//parking/api/web/index.php/v2/parkspot/delsaletimes", KSERVERADDRESS];
//    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
//    [paramsDict setObject:[[Utils readDataFromPlist] objectForKey:@"token"] forKey:@"token"];
//    [paramsDict setObject:self.park_id forKey:@"park_id"];
//    [paramsDict setObject:model.saletimes_id forKey:@"saletimes_id"];
//    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
//        [MBProgressHUD hideHUDForView:self.view];
//        NSMutableDictionary *tempDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
//        NSLog(@"%@",paramsDict);
//        if ([tempDict[@"status"] isEqualToString:@"200"]) {
//            //成功
//            [self.dataSourceArr removeObjectAtIndex:indexPath.row];
//            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
//            [self.tbView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
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
//        [self.view makeToast:@"请检查网络"];
//    }];
    
}

- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
