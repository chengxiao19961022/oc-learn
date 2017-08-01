//
//  WYQiChePinPaiVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/23.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYQiChePinPaiVC.h"
#import <QuartzCore/QuartzCore.h>
#import "MJNIndexView.h"
#import "CarTableViewCell.h"

@interface WYQiChePinPaiVC ()<UITableViewDelegate,UITableViewDataSource,MJNIndexViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UILabel *labQuXiao;
@property (weak, nonatomic) IBOutlet UITextField *TFSearch;
@property (weak, nonatomic) IBOutlet UITableView *tbView;


@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@property (nonatomic, strong) MJNIndexView *indexView;

@end

@implementation WYQiChePinPaiVC
{
    NSArray * dataArr;
    NSMutableArray * nameArr;
    NSMutableArray * iconArr;
    NSMutableArray * idArr;
    NSMutableDictionary * carDict;
    NSMutableDictionary * idDict;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    __weak typeof(self) weakSelf = self;
    self.labQuXiao.userInteractionEnabled = YES;
    self.searchView.layer.cornerRadius = 20.0f;
    self.searchView.layer.borderColor = RGBACOLOR(241, 242, 243, 1).CGColor;
    
    
    YYWebImageManager *mgr = [YYWebImageManager sharedManager];
    [mgr.cache.memoryCache removeAllObjects];
    
    dataArr = [[NSArray alloc]init];
    nameArr = [[NSMutableArray alloc]init];
    iconArr = [[NSMutableArray alloc]init];
    idArr = [[NSMutableArray alloc]init];
    carDict = [[NSMutableDictionary alloc]init];
    idDict = [[NSMutableDictionary alloc]init];
    
     [self getCarInfo];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
}

#pragma mark - 获取车数据
-(void)getCarInfo{
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"获取中";
    
        NSString *urlString = [[NSString alloc] initWithFormat:@"%@user/brandlist", KSERVERADDRESS];
    
        [wyApiManager sendApi:urlString parameters:nil success:^(id obj) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
    
            if ([paramsDict[@"status"] isEqualToString:@"200"]) {
    
                NSArray * arr = paramsDict[@"data"];
                dataArr = arr;
                NSLog(@"%@",dataArr);
                for (int i = 0; i<dataArr.count; i++) {
                    NSString * carName = dataArr[i][@"name"];
                    NSString * carIcon = dataArr[i][@"logo"];
                    NSString * carId = dataArr[i][@"brand_id"];
                    [nameArr addObject:carName];
                    [iconArr addObject:carIcon];
                    [idArr addObject:carId];
                    [carDict setObject:iconArr[i] forKey:nameArr[i]];
                    [idDict setObject:idArr[i] forKey:nameArr[i]];
                }
    
        
    
    
            }else if([paramsDict[@"status"] isEqualToString:@"104"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
    
            }else
            {
                [self.view makeToast:paramsDict[@"message"]];
            }
    
        } failuer:^(NSError *error) {
            [self.view makeToast:@"请检查网络"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    
}

#pragma mark - two methods needed for MJNINdexView protocol
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    return self.indexArray;
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index;
{
    [self.tbView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0  inSection:index] atScrollPosition: UITableViewScrollPositionTop     animated:NO];
}

#pragma mark - UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    headView.backgroundColor = RGBACOLOR(212, 213, 214, 1);
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, 300, 20)];
    lab.backgroundColor = RGBACOLOR(212, 213, 214, 1);
    lab.text = [self.indexArray objectAtIndex:section];
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = [UIColor whiteColor];
    [headView addSubview:lab];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.brand_name=[[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSString * temp = self.brand_name;
    if ([temp isEqualToString:@"ACSchnitzer"]) {
        self.brand_name = @"AC Schnitzer";
    }
    
    self.brand_id=idDict[self.brand_name];
    
    
    if (self.selectCarCompleteBlock) {
        self.selectCarCompleteBlock();
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
    
    
}



- (IBAction)btnQuXiaoClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
