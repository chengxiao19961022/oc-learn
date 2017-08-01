//
//  MYYouhuiquanViewController.m
//  WYParking
//
//  Created by admin on 17/2/16.
//  Copyright © 2017年 glavesoft. All rights reserved.
// 优惠券
#define BILI 200/598.f

#import "MYYouhuiquanViewController.h"
#import "MYYouhuiquanCell.h"
#import "WYModelYouHuiQuan.h"

@interface MYYouhuiquanViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _index;
}

@property (nonatomic,strong) UITableView* mytableview;

@property (strong , nonatomic) NSMutableArray *dataSource;

@end

@implementation MYYouhuiquanViewController

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self SetNaviBar];

    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    
    self.mytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.mytableview.backgroundColor = [UIColor whiteColor];
    self.mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mytableview.delegate = self;
    self.mytableview.dataSource = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _index = 1;
        [self requestYouHuiQuanData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.mytableview.mj_header = header;
    
    [self.mytableview.mj_header beginRefreshing];
    [self.view addSubview:self.mytableview];
    
}


#pragma mark - 优惠券详情
- (void)requestYouHuiQuanData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@user/coupondetail", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:[NSString stringWithFormat:@"%d",_index] forKey:@"page"];
    [paramsDict setObject:@"10000" forKey:@"limit"];
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [self.mytableview.mj_header endRefreshing];
        [self.mytableview.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSArray *datasourceArr = [WYModelYouHuiQuan mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            if (_index == 1) {
                self.dataSource = datasourceArr.mutableCopy;
            }else{
                if (datasourceArr.count == 0) {
                    [self.view makeToast:@"亲，这回真没有了"];
                }else{
                    [datasourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.dataSource addObject:obj];
                    }];
                   
                }
            }
           
            [self.mytableview reloadData];

        }
        else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
             _index --;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
             _index --;
            [self.view makeToast:paramsDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        _index --;
        [self.mytableview.mj_header endRefreshing];
        [self.mytableview.mj_footer endRefreshing];
        [self.view makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

- (void)SetNaviBar
{
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    

    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    

    self.title = @"优惠券";
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 27, 27)];
    [btn setImage:[UIImage imageNamed:@"back3"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)Back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
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
    MYYouhuiquanCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MYYouhuiquanCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.dataSource.count > indexPath.row) {
        [cell renderWithModel:[self.dataSource objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WYModelYouHuiQuan *m = [self.dataSource objectAtIndex:indexPath.row];
   
    
    if ([m.is_use isEqualToString:@"1"]) {
        [self.view makeToast:@"该优惠券还没到使用日期"];
        return;
    }
    
    //个人中心进入不进行判断
    if (self.rentType) {
        /**判断优惠券能否使用**/
        [self judgeType:self.rentType andModel:m];
    }


    
    
}

#pragma mark 后台判断该优惠券是否能使用

-(void)judgeType:(NSString *)type andModel:(WYModelYouHuiQuan *)model{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@order/couponjudgment", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:type forKey:@"type"];
    [paramsDict setObject:model.coupon_number forKey:@"coupon_number"];
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:keyWindow animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            if (self.yhqBlock) {
                self.yhqBlock(model);
                [self.navigationController popViewControllerAnimated:YES];
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

@end
