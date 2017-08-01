//
//  wyTimesPriceCell.m
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/6.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import "wyTimesPriceCell.h"
#import "WYModelPush.h"


@interface wyTimesPriceCell ()
@property (weak, nonatomic) IBOutlet UILabel *labYZBH;
@property (weak, nonatomic) IBOutlet UILabel *labZZH;
@property (weak, nonatomic) IBOutlet UILabel *labZZBH;
@property (weak, nonatomic) IBOutlet UILabel *labYZH;
@property (weak, nonatomic) IBOutlet UILabel *labCount;

@property (weak, nonatomic) IBOutlet UILabel *labRiZu;
@property (weak, nonatomic) IBOutlet UILabel *labRiZuJieJiaRiZu;
@property (weak, nonatomic) IBOutlet UILabel *labStart_date;

@property (weak, nonatomic) IBOutlet UILabel *labStarTime_endTime;
- (IBAction)btnFixClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnFix;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UILabel *labtime_note;


@property (strong , nonatomic) wyModelSaletimes* model;
@property (strong , nonatomic) NSIndexPath* indexPath;

@end

@implementation wyTimesPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    self.btnFix.layer.cornerRadius = 5.0f;
    self.btnDelete.layer.cornerRadius = 5.0f;
    self.btnFix.layer.borderWidth = self.btnDelete.layer.borderWidth = 0.5;
    self.btnFix.layer.borderColor = self.btnDelete.layer.borderColor  = RGBACOLOR(241, 242, 243, 1).CGColor;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    return [[self alloc] initWithTableView:tableView indexPath:indexPath];
}

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    wyTimesPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    cell.indexPath = indexPath;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)renderViewWithModel:(wyModelSaletimes *)model{
    self.model = model;
    self.labStarTime_endTime.text = [NSString stringWithFormat:@"%@-%@",model.start_time,model.end_time];
    NSArray<wyModelTypePrice *> *timePriceArr = model.json_saletype;
    self.labRiZu.text = self.labRiZuJieJiaRiZu.text= self.labZZH.text= self.labZZBH.text =  self.labYZH.text = self.labYZBH.text = @"暂无";
    [timePriceArr enumerateObjectsUsingBlock:^(wyModelTypePrice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.sale_type isEqualToString:@"6"]) {
            if ([obj.is_show boolValue]) {
                self.labRiZu.text = [NSString stringWithFormat:@"¥%@",obj.price];
            }else{
                self.labRiZu.text = @"暂无";
            }
        }else if ([obj.sale_type isEqualToString:@"5"]){
            if ([obj.is_show boolValue]) {
                self.labRiZuJieJiaRiZu.text = [NSString stringWithFormat:@"¥%@",obj.price];
            }else{
                self.labRiZuJieJiaRiZu.text = @"暂无";
            }

        }else if ([obj.sale_type isEqualToString:@"1"]){
            if ([obj.is_show boolValue]) {
                self.labZZH.text = [NSString stringWithFormat:@"¥%@",obj.price];
            }else{
                self.labZZH.text = @"暂无";
            }
        }else if ([obj.sale_type isEqualToString:@"2"]){
            if ([obj.is_show boolValue]) {
                self.labZZBH.text = [NSString stringWithFormat:@"¥%@",obj.price];
            }else{
                self.labZZBH.text = @"暂无";
            }
            
        }else if ([obj.sale_type isEqualToString:@"3"]){
            if ([obj.is_show boolValue]) {
                self.labYZH.text = [NSString stringWithFormat:@"¥%@",obj.price];
            }else{
                self.labYZH.text = @"暂无";
            }
        }else if ([obj.sale_type isEqualToString:@"4"]){
            if ([obj.is_show boolValue]) {
                self.labYZBH.text = [NSString stringWithFormat:@"¥%@",obj.price];
            }else{
                self.labYZBH.text = @"暂无";
            }
        }
    }];
    self.labStart_date.text =[NSString stringWithFormat:@"起租日期:%@",model.start_date];
    NSString *str = @"时间备注：";
    if ([model.note isEqualToString:@""]||model.note == nil) {
        str = [str stringByAppendingString:@"暂无"];
    }else{
        str = [str stringByAppendingString:model.note];
    }
    self.labtime_note.text = str;
    self.labCount.text = model.spot_num;
}


/**
 删除按钮

 @param sender <#sender description#>
 */
- (IBAction)btnDeleteClick:(id)sender {
    if (_clickBlock) {
        self.clickBlock(timeCellClickTypeDlete,self.indexPath,_model);
    }
}



/**
 修改

 @param sender <#sender description#>
 */
- (IBAction)btnFixClick:(id)sender {
    if (_clickBlock) {
        self.clickBlock(timeCellClickTypeFix,self.indexPath,_model);
    }
    
}
@end
