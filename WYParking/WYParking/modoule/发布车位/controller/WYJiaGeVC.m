//
//  WYJiaGeVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYJiaGeVC.h"
#import "WYModelJiaGe.h"
#import "WYJiaGeCell.h"

#import "WYModelPush.h"
@class wyAddTimeAndPriceVC;

@interface WYJiaGeVC ()<UITableViewDelegate , UITableViewDataSource>

@property (strong , nonatomic) NSMutableArray<WYModelJiaGe *> *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property(nonatomic, strong) wyModelTypePrice *typeprice;

@end

@implementation WYJiaGeVC

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        NSArray<NSString *> *titleArr = @[
                               @"日租（不含节假日）",
                               @"日租（含节假日）",
                               @"周租（含节假日）",
                               @"周租（不含节假日）",
                               @"月租（含节假日）",
                               @"月租（不含节假日）",
                              ];
        NSArray <NSString *> *typeArr = @[
                                         @"6",
                                         @"5",
                                         @"1",
                                         @"2",
                                         @"3",
                                         @"4"
                                         ];
        NSInteger count = titleArr.count;
        [titleArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WYModelJiaGe *m = WYModelJiaGe.new;
            NSString *typeStr = [typeArr objectAtIndex:idx];
            m.type = [typeStr integerValue];
            m.typeName = obj;
            if (idx == count - 1) {
                m.isOn = YES;
            }
            [_dataSource addObject:m];
        }];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak typeof(self) weakSelf = self;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"设置车位价格";
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tbView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYJiaGeCell *cell = [WYJiaGeCell cellWithTableView:tableView indexPath:indexPath];
    @weakify(self);
    cell.jiageBlock = ^(WYModelJiaGe *model,NSIndexPath *ip){
        @strongify(self);
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        [self.tbView reloadData];
    };
   
    if (self.dataSource.count > indexPath.row) {
    [cell renderViewWithModel:[self.dataSource objectAtIndex:indexPath.row]];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYModelJiaGe *model = [self.dataSource objectAtIndex:indexPath.row];
    if (model.isOn) {
        return 120;
    }else{
        return 60;
    }
   
}

#pragma mark - 提交
- (IBAction)btnNextClick:(id)sender {
    __block BOOL fail = YES;
    
    [self.dataSource enumerateObjectsUsingBlock:^(WYModelJiaGe * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        wyModelTypePrice *typeprice = wyModelTypePrice.new;
        if (obj.isOn) {
            fail = NO;
            if ([obj.price isEqualToString:@"0"]) {
                [self.view makeToast:@"价格不能为0"];
                
                fail = YES;
                stop = YES;
                
            }
            if ([obj.price isEqualToString:@""] || obj.price == nil) {
                [self.view makeToast:@"请先输入价格"];
                fail = YES;
                stop = YES;
                return;
            }
            
           
        }
        typeprice.price = obj.price?:@"0";
        typeprice.is_show = [NSString stringWithFormat:@"%d",obj.isOn];
        typeprice.sale_type = [NSString stringWithFormat:@"%d",obj.type];
        [self.saletimes.json_saletype addObject:typeprice];
    }];
    
    

    
    if (fail) {
        [self.saletimes.json_saletype removeAllObjects];
        [self.view makeToast:@"至少选择一种类型"];
        return;
    }
    
   
    @weakify(self);
//    __block BOOL isNeedTORootVC = NO;
    [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        NSString *class = NSStringFromClass([obj class]);
        //
      
        if ([class isEqualToString:@"wyAddTimeAndPriceVC"]||[class isEqualToString:@"wyParkSpotMangeVC"]) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"addTypeAndPrice" object:_saletimes];
            
             [Utils setNavigationControllerPopWithAnimation:self timingFunction:KYNaviAnimationTimingFunctionEaseInEaseOut type:KYNaviAnimationTypePageUnCurl subType:KYNaviAnimationDirectionDefault duration:0.38 target:obj];
        }
//        else if([class isEqualToString:@"wyParkSpotMangeVC"]){
//            isNeedTORootVC = YES;
//        }
       
    }];
    
//    if (isNeedTORootVC) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:WYCheWeiNeedRefresh object:@""];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
