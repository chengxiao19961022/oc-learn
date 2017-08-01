//
//  WYShiJianDuanVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/20.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYMqdShiJianVC.h"
#import "WYShuLiangVC.h"
#import "WYChuangJianTingCheChangVC.h"

@interface WYMqdShiJianVC ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSMutableArray * timeArr;
}
@property (weak, nonatomic) IBOutlet UIPickerView *startPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *endPicker;

@end

@implementation WYMqdShiJianVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak typeof(self) weakSelf = self;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"设置免确定时间段";
    
    timeArr = [[NSMutableArray alloc]init];
    for (int i=0; i<25; i++) {
        NSString * timeStr = [NSString stringWithFormat:@"%d:00",i];
        [timeArr addObject:timeStr];
    }
    int i = (int)[timeArr indexOfObject:@"24:00"];
    [timeArr replaceObjectAtIndex:i withObject:@"23:59"];
    self.startPicker.delegate = self;
    self.startPicker.dataSource = self;
    self.endPicker.delegate = self;
    self.endPicker.dataSource = self;
    self.start_time = self.end_time = [timeArr firstObject];
//    int initStart = [[self.start_time componentsSeparatedByString:@":"][0] intValue];
//    int initEnd = [[self.end_time componentsSeparatedByString:@":"][0] intValue];
//    [self.startPicker selectRow:initStart inComponent:0 animated:YES];
//    [self.endPicker selectRow:initEnd inComponent:0 animated:YES];
}


#pragma mark - UIPickerViewControllerDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return timeArr.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    if (pickerView.tag == 101) {
        UILabel* pickerLabel = (UILabel*)view;
        if (!pickerLabel){
            pickerLabel = [[UILabel alloc] init];
            // Setup label properties - frame, font, colors etc
            pickerLabel.font = [UIFont systemFontOfSize:13];
            pickerLabel.adjustsFontSizeToFitWidth = YES;
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
            [pickerLabel setBackgroundColor:[UIColor whiteColor]];
            pickerLabel.textColor = [UIColor darkGrayColor];
        }
        // Fill the label text here
        pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
        return pickerLabel;
    }
    if (pickerView.tag == 102) {
        UILabel* pickerLabel = (UILabel*)view;
        if (!pickerLabel){
            pickerLabel = [[UILabel alloc] init];
            // Setup label properties - frame, font, colors etc
            pickerLabel.font = [UIFont systemFontOfSize:13];
            pickerLabel.adjustsFontSizeToFitWidth = YES;
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
            [pickerLabel setBackgroundColor:[UIColor whiteColor]];
            pickerLabel.textColor = [UIColor darkGrayColor];
        }
        // Fill the label text here
        pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
        return pickerLabel;
    }
    return nil;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 101) {
        NSString * startTimeStr = [[NSString alloc]init];
        startTimeStr = timeArr[row];
        self.start_time = startTimeStr;
        NSLog(@"%@",startTimeStr);
    }
    if (pickerView.tag == 102) {
        NSString * endTimeStr = [[NSString alloc]init];
        endTimeStr = timeArr[row];
        self.end_time = endTimeStr;
        NSLog(@"%@",endTimeStr);
    }
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return KscreenWidth / 3.0;
}

#pragma mark - 确定
- (IBAction)btnNextClick:(id)sender {
//    NSDictionary *dic = [NS];
    NSArray* dic =[NSArray arrayWithObjects:self.start_time,self.end_time,nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PassMqd" object:dic];
    [self.navigationController popViewControllerAnimated:YES];
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 101) {
        return timeArr[row];
    }
    if (pickerView.tag == 102) {
        return timeArr[row];
    }
    return nil;
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
