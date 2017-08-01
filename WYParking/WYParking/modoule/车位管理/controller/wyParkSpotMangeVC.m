//
//  wyParkSpotMangeVC.m
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/9.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import "wyParkSpotMangeVC.h"
#import "wyTimesPriceCell.h"
#import "wyModelManageInfo.h"
#import "WYModelPush.h"
#import "WYTimeCountVC.h"
#import "WYParkManagerViewModel.h"
#import "wyBasicInfoVC.h"


@interface wyParkSpotMangeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak , nonatomic) UITableView *tbView;

@property (weak , nonatomic) UIImageView *imageView;//车位图片

@property (weak , nonatomic) UILabel *labAddress;//车位地址

@property (weak , nonatomic) UILabel *labAddressNote;//车位地址

@property (weak , nonatomic) UILabel *labIsNeedPark;//车位地址

@property (strong , nonatomic) NSMutableArray *dataSouceArr;

@property (weak , nonatomic) UITableViewCell *protoCell;

@property (strong , nonatomic) wyModelManageInfo *topModel;
@property (strong , nonatomic) WYParkManagerViewModel *parkMangerVM;
@property (assign , nonatomic) BOOL hasChanged ;

//@property (strong , nonatomic) wyModelManageInfo *topModel;



@end

@implementation wyParkSpotMangeVC

/**
 lazy load

 @return
 */
- (NSMutableArray *)dataSouceArr{
    if (_dataSouceArr == nil) {
        _dataSouceArr = [NSMutableArray array];
    }
    return _dataSouceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *linetop = UIView.new;
    [self.view addSubview:linetop];
    [linetop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    linetop.backgroundColor = RGBACOLOR(243, 243, 243, 1);

    UITableView *tbView = [[UITableView alloc] init];
    [self.view addSubview:tbView];
    tbView.backgroundColor = [UIColor whiteColor];
    [tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(1, 0, 0, 0));
    }];
    tbView.showsVerticalScrollIndicator = NO;
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.delegate = self;
    tbView.dataSource = self;
    self.tbView = tbView;
    //header view
    {
        UIView *headerView = UIView.new;
        headerView.backgroundColor = UIColor.whiteColor;
        
        //车位图片标题
        UIView *bottomView = UIView.new;
        bottomView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        bottomView.backgroundColor = RGBACOLOR(241, 242, 243, 1);
        
        //车位图片标题
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode  = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [bottomView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(10);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(100);
            make.bottom.mas_equalTo(-10);
        }];
        imageView.image = [UIImage imageNamed:@"tx"];
        self.imageView = imageView;
        
       
        
        UILabel *labAddres_note = UILabel.new;
        labAddres_note.text = @"  ----- ";//
         labAddres_note.font = [UIFont systemFontOfSize:13];
        [bottomView addSubview:labAddres_note];
        [labAddres_note mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(imageView.mas_right).with.offset(25);
            make.centerY.equalTo(imageView.mas_centerY);
            make.right.mas_equalTo(-6);
        }];
        self.labAddressNote = labAddres_note;
        
        UILabel *parkTitleLabel = UILabel.new;
        parkTitleLabel.text = @" ***大街  ";//***大街
        parkTitleLabel.font = [UIFont systemFontOfSize:15];
        [bottomView addSubview:parkTitleLabel];
        [parkTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(imageView.mas_right).with.offset(25);
            make.right.mas_equalTo(-6);
            make.bottom.equalTo(labAddres_note.mas_top).with.offset(-10);
        }];
        self.labAddress = parkTitleLabel;
        
        
        UIButton *btnFix = UIButton.new;
        [bottomView addSubview:btnFix];
        [btnFix mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(50);
        }];
        
        UILabel *labIsNeedPark = UILabel.new;
        labIsNeedPark.text = @" 是否需要停车场111 ";//是否需要停车场111
        labIsNeedPark.font = [UIFont systemFontOfSize:13];
        [bottomView addSubview:labIsNeedPark];
        
        [labIsNeedPark mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(imageView.mas_right).with.offset(25);
            make.top.equalTo(labAddres_note.mas_bottom).with.offset(10);
            make.right.equalTo(btnFix.mas_left).with.offset(-5);
        }];
        
        [btnFix mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(labIsNeedPark);
        }];
        self.labIsNeedPark = labIsNeedPark;
       
        [btnFix setTitle:@"  修改  " forState:UIControlStateNormal];
        [btnFix setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btnFix.titleLabel.font = [UIFont systemFontOfSize:13];
        btnFix.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btnFix.layer.borderWidth = 0.5;
        btnFix.layer.cornerRadius = 5.0f;
        btnFix.layer.masksToBounds = YES;
        @weakify(self);
        [btnFix bk_addEventHandler:^(id sender) {
            @strongify(self);
            [self verifyPakrID:self.park_id];
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *line = UIView.new;
        [bottomView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        line.backgroundColor = RGBACOLOR(243, 243, 243, 1);
        
        headerView.height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        self.tbView.tableHeaderView = headerView;
    }
    
    //footer view
    {
        UIView *footerView = UIView.new;
        UIButton *btn = UIButton.new;
        [btn setTitle:@"新增时间价格" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setBackgroundColor:RGBACOLOR(30, 61, 157, 1)];
        [footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(45);
        }];
        [btn addTarget:self action:@selector(btnAddTimePrice) forControlEvents:UIControlEventTouchUpInside];
        footerView.height = [footerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        self.tbView.tableFooterView = footerView;
        
    }
    
    // 获取当前车位数据
    [self fetchTimeAndPrice];
    
    //获取顶部数据
    [self fetchTopViewData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchTimeAndPrice:) name:@"addTypeAndPrice" object:nil];
}


- (void)verifyPakrID:(NSString *)park_id{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parkspot/editpark", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:park_id forKey:@"park_id"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            self.hasChanged = YES;
            wyBasicInfoVC *vc = wyBasicInfoVC.new;
            [vc renderWithIFFix:YES park_id:self.park_id];
            [[NSNotificationCenter defaultCenter] postNotificationName:WYCheWeiNeedRefresh object:@""];
            [self.navigationController pushViewController:vc animated:YES];
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
        [self.view makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

- (void)fetchTimeAndPrice:(NSNotification *)notification{
     wyModelSaletimes *saletimes = notification.object;
     self.parkMangerVM = WYParkManagerViewModel.new;
    if (saletimes.isEdit == YES) {
        wyModelSaletimes *m = [self.dataSouceArr objectAtIndex:saletimes.index];
        saletimes.saletimes_id = m.saletimes_id;
        [self.dataSouceArr removeObjectAtIndex:saletimes.index];
        [self.dataSouceArr addObject:saletimes];
    }else{
        [self.dataSouceArr addObject:saletimes];
    }
    
    NSMutableArray *jsonSaletimes_Arr = [NSMutableArray array];
    [self.dataSouceArr enumerateObjectsUsingBlock:^(wyModelSaletimes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    @weakify(self);
    [self.parkMangerVM releaseParkWithToken:[wyLogInCenter shareInstance].sessionInfo.token pic:self.topModel.pic park_title:self.topModel.park_title address:self.topModel.address lat:self.topModel.lat lnt:_topModel.lnt addr_note:self.topModel.addr_note parklot_id:self.topModel.parklot_id park_type:self.topModel.park_type json_saletimes:str park_id:self.topModel.park_id  success:^(BOOL flag, NSString *msg) {
        @strongify(self);
        if (flag) {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
            [self.tbView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
             [self.dataSouceArr removeObject:saletimes];
        }
    }];
   
  
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault]; //设置为白色
    self.automaticallyAdjustsScrollViewInsets = NO;
    @weakify(self);
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        if (self.hasChanged) {
            [[NSNotificationCenter defaultCenter] postNotificationName:WYCheWeiNeedRefresh object:@""];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    self.title = @"车位管理";
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}



- (void)verifyOrderPark_id:(NSString *)park_id saletimes_id:(NSString *)saletimes_id success:(void(^)(BOOL isSuccess))isSucc{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"验证中...";
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@parkspot/editsaletimes", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:park_id forKey:@"park_id"];
     [paramsDict setObject:saletimes_id forKey:@"saletimes_id"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
       
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSLog(@"adfads");
            self.hasChanged = YES;
            isSucc(YES);
            
        }else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
            
        }
        else
        {
            [self.view makeToast:paramsDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [self.view makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    
}




#pragma mark - 新增时间价格
- (void)btnAddTimePrice{
    WYLog(@"新增时间价格");
    WYTimeCountVC *vc = WYTimeCountVC.new;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDatasouce , UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSouceArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    wyTimesPriceCell *cell = [wyTimesPriceCell cellWithTableView:tableView indexPath:indexPath];

    @weakify(self);
    cell.clickBlock = ^(timeCellClickType clickType,NSIndexPath *ip , wyModelSaletimes * model){
        @strongify(self);
        if (clickType == timeCellClickTypeFix) {
            //修改
            if ([model.saletimes_id isEqualToString:@""]) {
                WYTimeCountVC *vc = WYTimeCountVC.new;
                [vc isEdit:YES withIndexPathRow:indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self verifyOrderPark_id:self.park_id saletimes_id:model.saletimes_id success:^(BOOL isSuccess) {
                    @strongify(self);
                    if (isSuccess) {
                        WYTimeCountVC *vc = WYTimeCountVC.new;
                        [vc isEdit:YES withIndexPathRow:indexPath.row];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }];
            }
           
            
        }else{
            //删除
#pragma mark - 删除接口
            if ([model.saletimes_id isEqualToString:@""]) {
                [self.dataSouceArr removeObjectAtIndex:indexPath.row];
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)];
                [self.tbView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                [self verifyOrderPark_id:self.park_id saletimes_id:model.saletimes_id success:^(BOOL isSuccess) {
                    @strongify(self);
                    if (isSuccess) {
                        [self delParkWithIndexPath:indexPath];
                    }
                }];
            }

           
        }
    };
    if (indexPath.row < self.dataSouceArr.count) {
        [cell renderViewWithModel:[self.dataSouceArr objectAtIndex:indexPath.row]];
    }
    self.protoCell = cell;
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.protoCell == nil) {
        return 180;
    }else{
        return [self.protoCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
}


#pragma mark - 请求车位数据接口
- (void)fetchTimeAndPrice{
   

    NSString *urlString = [NSString stringWithFormat:@"%@parkspot3/parkmanage",KSERVERADDRESS];
    NSMutableDictionary *parametersDict = @{
                                            @"park_id":self.park_id
                                            }.mutableCopy;
    [parametersDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
     [parametersDict setObject:@"10000" forKey:@"limit"];
        [parametersDict setObject:@"1" forKey:@"page"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [wyApiManager sendApi:urlString parameters:parametersDict success:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view];
        NSDictionary *tempDict= [NSJSONSerialization JSONObjectWithData:obj options:0 error:nil];
        if ([tempDict[@"status"] isEqualToString:@"200"]) {
            //成功
            NSArray *temptArr = [wyModelSaletimes mj_objectArrayWithKeyValuesArray:tempDict[@"data"]];
            [self.dataSouceArr removeAllObjects];
            self.dataSouceArr = temptArr.mutableCopy;
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
        [self.view makeToast:@"网络不通畅"];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - 请求头部数据
- (void)fetchTopViewData{
    NSString *urlString = [NSString stringWithFormat:@"%@parkspot/infos",KSERVERADDRESS];
    NSDictionary *parameters = @{
                                    @"token":[wyLogInCenter shareInstance].sessionInfo.token,
                                    @"park_id":self.park_id
                                 };
    [wyApiManager sendApi:urlString parameters:parameters success:^(id obj) {
        
        NSDictionary *tempDict= [NSJSONSerialization JSONObjectWithData:obj options:0 error:nil];
        if ([tempDict[@"status"] isEqualToString:@"200"]) {
            //成功
            self.topModel = [wyModelManageInfo mj_objectWithKeyValues:tempDict[@"data"]];
            [self renderTopView];
            
            
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

- (void)renderTopView{
    [self.imageView setImageWithURL:[NSURL URLWithString:self.topModel.pic]  placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
    }];
    self.labAddress.text = self.topModel.address?:@"";
    self.labAddressNote.text = self.topModel.addr_note?:@"";
    if ([self.topModel.park_type isEqualToString:@"1"]) {
        self.labIsNeedPark.text = @"需要停车场放行";
    }else{
        self.labIsNeedPark.text = @"不需要停车场放行";
    }

}




- (void)delParkWithIndexPath:(NSIndexPath *)indexPath{
   
    wyModelSaletimes  *model = [self.dataSouceArr objectAtIndex:indexPath.row];
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@parkspot/delsaletimes", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:self.topModel.park_id forKey:@"park_id"];
    [paramsDict setObject:model.saletimes_id forKey:@"saletimes_id"];
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        NSMutableDictionary *tempDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        NSLog(@"%@",paramsDict);
        if ([tempDict[@"status"] isEqualToString:@"200"]) {
            //成功
            [self.view makeToast:@"删除成功"];
            [self.dataSouceArr removeObjectAtIndex:indexPath.row];
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
