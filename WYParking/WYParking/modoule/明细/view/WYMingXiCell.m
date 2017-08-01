//
//  WYMingXiCell.m
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYMingXiCell.h"
#import "WYModelMingXi.h"

@interface WYMingXiCell ()
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;//类型图片

@property (weak, nonatomic) IBOutlet UILabel *typeTitleLab;//类型名称
@property (weak, nonatomic) IBOutlet UILabel *typeTimeLab;//类型时间
@property (weak, nonatomic) IBOutlet UILabel *typePriceLab;//类型价格
@property (weak, nonatomic) IBOutlet UILabel *typeStateLab;//类型状态

@end

@implementation WYMingXiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    return [[self alloc] initWithTableView:tableView indexPath:indexPath];
}

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    WYMingXiCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)renderViewWithModel:(WYModelDetail *)model{
    self.typeTimeLab.text = model.created_at;
    self.typePriceLab.text = model.account_in;
    self.typeStateLab.text = model.status_out_name;
    if ([model.style isEqualToString:@"2"]) {
        if ([model.type isEqualToString:@"3"]||[model.type isEqualToString:@"4"]) {
            self.typeTitleLab.text = @"停车场支出";
        }else{
            self.typeTitleLab.text = @"停车场收入";
        }
    }else{
         self.typeTitleLab.text = model.value;
    }
//    1订单收入 2 充值收入 3 支付 4 提现  5退款 6余额提现退款'
    if ([model.type isEqualToString:@"1"]) {
        self.typeImgView.image = [UIImage imageNamed:@"zjmx_ddzf"];
    }else if ([model.type isEqualToString:@"2"]){
        self.typeImgView.image = [UIImage imageNamed:@"zjmx_tx"];
    }else if ([model.type isEqualToString:@"3"]){
        self.typeImgView.image = [UIImage imageNamed:@"zjmx_ddzf"];
    }else if ([model.type isEqualToString:@"4"]){
        self.typeImgView.image = [UIImage imageNamed:@"zjmx_tx"];
    }else if ([model.type isEqualToString:@"5"]){
        self.typeImgView.image = [UIImage imageNamed:@"tui"];
    }else if ([model.type isEqualToString:@"6"]){
        self.typeImgView.image = [UIImage imageNamed:@"zjmx_tx"];
    }
}

@end
