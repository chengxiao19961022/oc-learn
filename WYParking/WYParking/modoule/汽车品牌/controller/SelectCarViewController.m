//
//  SelectCarViewController.m
//  TheGenericVersion
//
//  Created by Glavesoft on 16/1/11.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "SelectCarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MJNIndexView.h"
#import "CarTableViewCell.h"

@interface SelectCarViewController ()<UITableViewDelegate,UITableViewDataSource,MJNIndexViewDataSource>
@property (weak, nonatomic) UITableView *carTableView;
@property (weak, nonatomic) UILabel *topTitle;



@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@property (nonatomic, strong) MJNIndexView *indexView;

@end

@implementation SelectCarViewController
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
    
    YYWebImageManager *mgr = [YYWebImageManager sharedManager];
    [mgr.cache.memoryCache removeAllObjects];
    
    dataArr = [[NSArray alloc]init];
    nameArr = [[NSMutableArray alloc]init];
    iconArr = [[NSMutableArray alloc]init];
    idArr = [[NSMutableArray alloc]init];
    carDict = [[NSMutableDictionary alloc]init];
    idDict = [[NSMutableDictionary alloc]init];
    
    [self getCarInfo];
    
    UILabel * topTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 64, kScreenWidth-40, 80)];
    _topTitle = topTitle;
    _topTitle.text = @"选择车型";
    _topTitle.textColor = [UIColor blackColor];
    _topTitle.font = [UIFont systemFontOfSize:25];
    _topTitle.backgroundColor = [UIColor clearColor];
    _topTitle.textAlignment = NSTextAlignmentCenter;
    _topTitle.layer.cornerRadius = 5;
    _topTitle.layer.masksToBounds = YES;
    
    [self.view addSubview:_topTitle];
    
    
    //initTable
    UITableView * carTableView = [[UITableView alloc]initWithFrame:CGRectMake(20,_topTitle.bottom-5,kScreenWidth-40,kScreenHeight-_topTitle.bottom)];
    _carTableView = carTableView;
    _carTableView.delegate = self;
    _carTableView.dataSource = self;
    _carTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_carTableView];
    // Do any additional setup after loading the view from its nib.
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [self.indexArray objectAtIndex:section];
    return key;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.letterResultArr objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString*ID = @"CarTableViewCell";
    CarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:ID owner:nil options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString * tempStr = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    if ([tempStr isEqualToString:@"ACSchnitzer"]) {
        cell.carName.text = @"AC Schnitzer";
        tempStr = @"AC Schnitzer";
    }else{
        cell.carName.text = tempStr;
    }
    
    NSString * imgUrlStr = [carDict objectForKey:tempStr];
    NSURL * url = [NSURL URLWithString:imgUrlStr];
    [cell.carIcon setImageURL:url];
    return cell;
}
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    return index;
//}
#pragma mark - UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
    
    [self.navigationController popViewControllerAnimated:YES];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 获取车数据
-(void)getCarInfo
{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"获取中";
//    
//    NSString *urlString = [[NSString alloc] initWithFormat:@"%@/parking/api/web/index.php/v2/user/brandlist", KSERVERADDRESS];
//    
//    [wyApiManager sendApi:urlString parameters:nil success:^(id obj) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
//        
//        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
//            
//            NSArray * arr = paramsDict[@"data"];
//            dataArr = arr;
//            NSLog(@"%@",dataArr);
//            for (int i = 0; i<dataArr.count; i++) {
//                NSString * carName = dataArr[i][@"name"];
//                NSString * carIcon = dataArr[i][@"logo"];
//                NSString * carId = dataArr[i][@"brand_id"];
//                [nameArr addObject:carName];
//                [iconArr addObject:carIcon];
//                [idArr addObject:carId];
//                [carDict setObject:iconArr[i] forKey:nameArr[i]];
//                [idDict setObject:idArr[i] forKey:nameArr[i]];
//            }
//            
//            //排序后
//            self.indexArray = [ChineseString IndexArray:nameArr];
//            self.letterResultArr = [ChineseString LetterSortArray:nameArr];
//            
//            // initialise MJNIndexView
//            self.indexView = [[MJNIndexView alloc]initWithFrame:_carTableView.frame];
//            self.indexView.dataSource = self;
//            self.indexView.fontColor = RGBACOLOR(112, 212, 245, 1);
//            self.indexView.font = [UIFont systemFontOfSize:12];
//            self.indexView.selectedItemFont = [UIFont systemFontOfSize:17];
//            self.indexView.rangeOfDeflection = 3;
//            self.indexView.rightMargin = 5;
//            self.indexView.upperMargin = 20;
//            self.indexView.lowerMargin=20;
//            self.indexView.fading = YES;
//            self.indexView.darkening = NO;
//            self.indexView.selectedItemFontColor = RGBACOLOR(112, 212, 245, 1);
//            [self.view addSubview:self.indexView];
//            
//            
//            [self.carTableView reloadData];
//            
//            
//            
//        }else if([paramsDict[@"status"] isEqualToString:@"104"])
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
//            
//        }else
//        {
//            [self.view makeToast:paramsDict[@"message"]];
//        }
//
//    } failuer:^(NSError *error) {
//        [self.view makeToast:@"请检查网络"];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
//
}

#pragma mark - two methods needed for MJNINdexView protocol
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    return self.indexArray;
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index;
{
    [self.carTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0  inSection:index] atScrollPosition: UITableViewScrollPositionTop     animated:NO];
}

@end
