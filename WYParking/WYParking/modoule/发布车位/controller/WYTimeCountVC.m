//
//  WYTimeCountVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/20.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYTimeCountVC.h"
#import "CKCalendarView.h"
#import "WYShiJianDuanVC.h"

@interface WYTimeCountVC ()<CKCalendarDelegate>

@property(nonatomic, weak) CKCalendarView *calendar;//日历

@property(nonatomic, strong) NSDateFormatter *dateFormatter;

@property(nonatomic, strong) NSArray *disabledDates;

@property(nonatomic, strong) NSDate *minimumDate;

@property(nonatomic, strong) wyModelSaletimes *saletimes;

@end

@implementation WYTimeCountVC

- (wyModelSaletimes *)saletimes{
    if (_saletimes == nil) {
        _saletimes = [[wyModelSaletimes alloc] init];
    }
    return _saletimes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.saletimes.saletimes_id = @"";//要给空，不然接口报错
    
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak typeof(self) weakSelf = self;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"设置时间数量";
    [self initCalenda];
}


/**
 private
 */
- (void)initCalenda{
    UIView *bottomeView = UIView.new;
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    [bottomeView addSubview:calendar];
    [calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(335);
    }];
//    calendar.backgroundColor = RGBACOLOR(241, 242, 243, 1);
    calendar.backgroundColor = [UIColor whiteColor];

    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.minimumDate = [self.dateFormatter dateFromString:@"2016-04-10"];
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = NO;

    UIButton *submitBtn = UIButton.new;
    [submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:kNavigationBarBackGroundColor];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomeView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(calendar.mas_bottom);
        make.height.mas_equalTo(45);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [self.view addSubview:bottomeView];
    [bottomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
    }];
    
#pragma mark - 下一步
    @weakify(self);
    [submitBtn bk_addEventHandler:^(id sender) {
        @strongify(self);
        if ([self.saletimes.start_date isEqualToString:@""] || self.saletimes.start_date == nil) {
            [self.view makeToast:@"请先选择日期"];
            return;
        }
        
        WYShiJianDuanVC *vc = WYShiJianDuanVC.new;
        vc.saletimes = self.saletimes;
        [self.navigationController pushViewController:vc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
//    calendar.frame = CGRectMake(0, kScreenHeight - 335-64-45, KscreenWidth, 335);
//    [self.view addSubview:calendar];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}


/**
 见头文件
 public
 */
- (void)isEdit:(BOOL)isedit withIndexPathRow:(NSInteger)index{
    self.saletimes.isEdit = YES;
    self.saletimes.index = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}

- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date]) {
        dateItem.textColor = [UIColor whiteColor];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    self.saletimes.start_date = [date stringWithFormat:@"yyyy-MM-dd"];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    
    if ([date laterDate:self.minimumDate] == date) {
        //        self.calendar.backgroundColor = RGBACOLOR(112, 212, 246, 1);
        return YES;
    } else {
        //        self.calendar.backgroundColor = RGBACOLOR(112, 212, 246, 1);
        return NO;
    }
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
