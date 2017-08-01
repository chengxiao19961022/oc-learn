//
//  WYCommitOrder.m
//  WYParking
//
//  Created by glavesoft on 17/2/22.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYCommitOrder.h"
#import "CarBrandsViewController.h"
#import "WYPayVC.h"
#import "wyModel_Park_detail.h"
#import "EditPopView.h"
#import "WYRiZuVC.h"
#import "wyTiJIaoDingDanViewModel.h"
#import "CalendarModel.h"
#import "WYWMVC.h"
#import "WYPayVC.h"
#import "WYModelOrderPay.h"
#import "MYYouhuiquanViewController.h"
#import "WYModelYouHuiQuan.h"


@interface WYCommitOrder ()<CarBrandsViewControllerDelegate>{
    EditPopView * editPop;
    NSArray *_riZuArr;//日租选的数据源
    NSString *_ZYstartdate; //周租月租开始时间
    NSString *_ZYenddate; //周租月租结束时间
    BOOL _isFirstSetPlanute;

}
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *qiChePinPaiView;
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (weak, nonatomic) IBOutlet UITextField *TFZuYongXingShi;
@property (weak, nonatomic) IBOutlet UITextField *TFZuYongRiQi;

@property (strong , nonatomic) wyModel_Park_detail *park_detail_model;

@property (weak, nonatomic) IBOutlet UITextField *TFChePai;
@property (strong , nonatomic) wyMOdelTime *TimeModel;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserlog;

@property (weak, nonatomic) IBOutlet UILabel *labParkTitle;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;

@property (weak, nonatomic) IBOutlet UILabel *labBrandName;

@property (weak, nonatomic) IBOutlet UILabel *labUserName;

@property (weak, nonatomic) IBOutlet UILabel *labStartTime_endTime;

@property (copy , nonatomic) NSString *zuyongType;

@property (strong , nonatomic) wyTiJIaoDingDanViewModel *orderVM;

@property (weak, nonatomic) IBOutlet UILabel *labYouHuiQuan;
@property (copy , nonatomic) NSString *brand_id;

@property (strong , nonatomic) WYModelYouHuiQuan *youHuiQuanModel;

@end

@implementation WYCommitOrder


//vm
- (wyTiJIaoDingDanViewModel *)orderVM{
    if (_orderVM == nil) {
        _orderVM = [[wyTiJIaoDingDanViewModel alloc] init];
    }
    return _orderVM;
}

- (void)viewDidLoad {
    _isFirstSetPlanute = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGSize s = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.headerView.height = s.height;
    self.tbView.tableHeaderView = self.headerView;
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak typeof(self) weakSelf = self;
    [self.qiChePinPaiView bk_whenTapped:^{
        CarBrandsViewController *vc = CarBrandsViewController.new;
        vc.delegate = self;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    //停车场信息
    [self renderTOpView];
    
}

#pragma mark - 选择汽车品牌回调
- (void)chooseCarBrandsId:(NSString *)brandId brandName:(NSString *)name{
    self.labBrandName.text = name;
    self.brand_id = brandId;
}

- (void)renderTOpView{
    [self.imageViewUserlog setImageWithURL:[NSURL URLWithString:self.park_detail_model.logo] options:YYWebImageOptionSetImageWithFadeAnimation];
    self.labUserName.text = self.park_detail_model.username;
    self.labParkTitle.text = self.park_detail_model.park_title;
    self.labAddress.text = self.park_detail_model.address;
    self.labStartTime_endTime.text = [NSString stringWithFormat:@"%@-%@",self.TimeModel.start_time,self.TimeModel.end_time];
    self.labBrandName.text = [wyLogInCenter shareInstance].sessionInfo.brand_name;
    NSString *str = [wyLogInCenter shareInstance].sessionInfo.plate_nu;
    if (str == nil || [str isEqualToString:@""]) {
        _isFirstSetPlanute = YES;
         self.TFChePai.text = @"";
    }else{
        _isFirstSetPlanute = NO;
        self.TFChePai.text = str;
    }
    
    self.TFZuYongRiQi.enabled = NO;
    self.TFZuYongXingShi.enabled = NO;
    if ([self.zuyongType isEqualToString:@"5"]) {
        self.TFZuYongXingShi.text = @"日租";
    }else if ([self.zuyongType isEqualToString:@"6"]){
        self.TFZuYongXingShi.text = @"日租(不含节假日)";
    }else if ([self.zuyongType isEqualToString:@"1"]){
        self.TFZuYongXingShi.text = @"周租";
    }else if ([self.zuyongType isEqualToString:@"2"]){
        self.TFZuYongXingShi.text = @"周租(不含节假日)";
    }else if ([self.zuyongType isEqualToString:@"3"]){
        self.TFZuYongXingShi.text = @"月租";
    }else if ([self.zuyongType isEqualToString:@"4"]){
        self.TFZuYongXingShi.text = @"月租(不含节假日)";
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController.navigationBar setTintColor:[UIColor darkGrayColor]];
    __weak typeof(self) weakSelf = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"提交订单";
}

- (void)renderViewWithParkDetailModel:(wyModel_Park_detail *)model andtimeTypeModel:(wyMOdelTime *)typeModel withType:(NSString *)type{
    self.TimeModel = typeModel;
    self.park_detail_model = model;
    self.zuyongType = type;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - 点击租用形式
/**
点击租用形式
 
 @param sender <#sender description#>
 */
- (IBAction)btnXingShiClick:(id)sender {
    
    
}

#pragma mark - 点击租用日期
/**
 点击租用日期

 @param sender <#sender description#>
 */
- (IBAction)btnRiQIClick:(id)sender {
    if (self.TFZuYongXingShi.text == nil || [self.TFZuYongXingShi.text isEqualToString:@""]) {
        [self.view makeToast:@"请先选择租用形式"];
        return;
    }
    
    if ([self.TFZuYongXingShi.text containsString:@"日租"]) {
        WYRiZuVC *vc = WYRiZuVC.new;
        [vc initWithparkID:self.park_detail_model.park_id parkType:self.zuyongType saltimes_id:self.TimeModel.saletimes_id];
        @weakify(self);
        vc.RiZublock = ^(NSArray *arr){
            @strongify(self);
            _riZuArr = arr.copy;
            NSString *firstdateMOdel = arr.firstObject;
            NSString *lastdateMOdel = arr.lastObject;
            self.TFZuYongRiQi.text = [NSString stringWithFormat:@"%@到%@",firstdateMOdel,lastdateMOdel];
        };
        [self.navigationController presentViewController:vc animated:YES completion:^{
            ;
        }];
    }else {
        WYWMVC *vc = [[WYWMVC alloc] init];
        [vc initWithparkID:self.park_detail_model.park_id parkType:self.zuyongType saleTimesid:self.TimeModel.saletimes_id];
        @weakify(self);
        vc.wmBlock = ^(NSString *startDate,NSString *endDate){
            @strongify(self);
            self.TFZuYongRiQi.text = [NSString stringWithFormat:@"%@到%@",startDate,endDate];
            _ZYstartdate = startDate;
            _ZYenddate = endDate;
        };
        [self.navigationController presentViewController:vc animated:YES completion:^{
            ;
        }];
    }
}


#pragma mark - 日租订单接口
- (IBAction)btnSubmitOrderClick1:(id)sender {
    if ([self.TFChePai.text isEqualToString:@""]||self.TFChePai == nil) {
        [self.view makeToast:@"车牌号不能为空"];
        return;
    }
    
    if (self.TFZuYongRiQi.text == nil||[self.TFZuYongRiQi.text isEqualToString:@""]) {
        [self.view makeToast:@"请选择租用日期"];
        return;
    }
    
    if ([self.TFZuYongRiQi.text containsString:@"null"]) {
        [self.view makeToast:@"抱歉，亲，该车位暂时不能出租了哦"];
        return;
    }
    
    if ([self.TFZuYongXingShi.text containsString:@"日租"]) {
        NSString *firstdateMOdel = _riZuArr.firstObject;
        NSString *lastdateMOdel = _riZuArr.lastObject;
        NSString *brand_id = @"";
        if (self.brand_id == nil || [self.brand_id isEqualToString:@""]) {
            brand_id = [wyLogInCenter shareInstance].sessionInfo.brand_id;
        }else{
            brand_id = self.brand_id;
        }
        if (_isFirstSetPlanute == YES) {
            [[wyLogInCenter shareInstance] upDateUserInfo];
        }
        
        [self.orderVM saveRiZuOrderWithToken:[wyLogInCenter shareInstance].sessionInfo.token park_id:self.park_detail_model.park_id  start_date:firstdateMOdel end_date:lastdateMOdel start_time:self.TimeModel.start_time end_time:self.TimeModel.end_time saletimes_id:self.TimeModel.saletimes_id plate_nu:self.TFChePai.text brand_id:brand_id jsonstr:[_riZuArr mj_JSONString] sale_type:self.zuyongType coupon_number:self.youHuiQuanModel.coupon_number];
        [self.orderVM submitRiZUOrdersuccess:^(BOOL flag, id model) {
            if (flag == YES) {
                [[NSNotificationCenter defaultCenter] postNotificationName:WYHomeVCNeedReFresh object:nil];
                WYPayVC *vc = WYPayVC.new;
                [vc renderViewWithPayOrder:model];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];

    }else{
        [self.orderVM SaveZhouZuInfoWithToken:[wyLogInCenter shareInstance].sessionInfo.token park_id:self.park_detail_model.park_id start_date:_ZYstartdate end_date:_ZYenddate start_time:self.TimeModel.start_time end_time:self.TimeModel.end_time saletimes_id:self.TimeModel.saletimes_id  plate_nu:self.TFChePai.text brand_id:[wyLogInCenter shareInstance].sessionInfo.brand_id jsonstr:@"" sale_type:self.zuyongType coupon_number:self.youHuiQuanModel.coupon_number];
        [self.orderVM submitZhouZUYueZuOrdersuccess:^(BOOL flag, id model) {
            if (flag == YES) {
                [[NSNotificationCenter defaultCenter] postNotificationName:WYHomeVCNeedReFresh object:nil];
                WYPayVC *vc = WYPayVC.new;
                [vc renderViewWithPayOrder:model];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    

}

#pragma mark - 选择优惠券接口
- (IBAction)btnChooseYHQClick:(id)sender {
    
    MYYouhuiquanViewController *youHuiQuanVC =  MYYouhuiquanViewController.new;
    youHuiQuanVC.rentType = self.zuyongType;
    
    @weakify(self);
    youHuiQuanVC.yhqBlock = ^(WYModelYouHuiQuan *model){
        @strongify(self);
        if([model.coupon_type isEqualToString: @"0"]){//优惠券类型，0折扣券 1代金券
            self.labYouHuiQuan.text = [NSString stringWithFormat:@"%@折优惠券", model.discount_margin];
            self.youHuiQuanModel = model;
        }else {
            self.labYouHuiQuan.text = [NSString stringWithFormat:@"%@元代金券", model.discount_margin];
            self.youHuiQuanModel = model;
        }
    };
    [self.navigationController pushViewController:youHuiQuanVC animated:YES];
}

@end
