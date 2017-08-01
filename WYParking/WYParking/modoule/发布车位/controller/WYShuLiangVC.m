//
//  WYShuLiangVC.m
//  WYParking
//
//  Created by glavesoft on 17/2/20.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYShuLiangVC.h"
#import "WYShiJianBeiZhuVC.h"

@interface WYShuLiangVC ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSMutableArray * countArr;
}
@property (weak, nonatomic) IBOutlet UIPickerView *qianPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *baiPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *gePickerView;
@property (copy , nonatomic) NSString *qian;
@property (copy , nonatomic) NSString *bai;
@property (copy , nonatomic) NSString *ge;
@property (copy , nonatomic) NSString *count;
@end

@implementation WYShuLiangVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.gePickerView.delegate = self.baiPickerView.delegate = self.qianPickerView.delegate = self;
    self.gePickerView.dataSource = self.baiPickerView.dataSource = self.qianPickerView.dataSource = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak typeof(self) weakSelf = self;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"设置时间数量";
    
    countArr = [[NSMutableArray alloc]init];
    for (int i=0; i<10; i++) {
        NSString * timeStr = [NSString stringWithFormat:@"%d",i];
        [countArr addObject:timeStr];
    }
    self.qian = self.bai = self.ge = countArr.firstObject;
    self.saletimes.spot_num = [NSString stringWithFormat:@"%@%@%@",_qian,_bai,_ge];
}

#pragma mark - UIPickerViewControllerDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return countArr.count;
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
    if (pickerView.tag == 103) {
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
        NSString * qianStr = [[NSString alloc]init];
        qianStr = countArr[row];
        _qian = qianStr;
        NSLog(@"%@",qianStr);
    }
    if (pickerView.tag == 102) {
        NSString * bai = [[NSString alloc]init];
        bai = countArr[row];
        _bai = bai;
        NSLog(@"%@",bai);
    }
    if (pickerView.tag == 103) {
        NSString * ge = [[NSString alloc]init];
        ge = countArr[row];
        _ge = ge;
        NSLog(@"%@",ge);
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

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
 
    return countArr[row];
}
- (IBAction)btnNextClick:(id)sender {
    
    NSString *spot_num;
    if ([_qian isEqualToString:@"0"]) {
        if ([_bai isEqualToString:@"0"]) {
            if ([_ge isEqualToString:@"0"]) {
                [self.view makeToast:@"车位数量不能为0"];
                return;
            }else{
                 spot_num = [NSString stringWithFormat:@"%@",_ge];
            }
           
        }else{
           spot_num = [NSString stringWithFormat:@"%@%@",_bai,_ge];
        }
    }else{
        spot_num = [NSString stringWithFormat:@"%@%@%@",_qian,_bai,_ge];
    }
     self.saletimes.spot_num = spot_num;
    WYShiJianBeiZhuVC *vc = WYShiJianBeiZhuVC.new;
    vc.saletimes = self.saletimes;
    [self.navigationController pushViewController:vc animated:YES];
    
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
