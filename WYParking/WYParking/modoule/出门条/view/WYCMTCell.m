//
//  WYCMTCell.m
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYCMTCell.h"
#import "WYModelCMT.h"

@interface WYCMTCell ()
@property (weak, nonatomic) IBOutlet UILabel *labORder;
@property (weak, nonatomic) IBOutlet UILabel *labBuilding;
@property (weak, nonatomic) IBOutlet UILabel *labname;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labSaletype;
@property (weak, nonatomic) IBOutlet UILabel *labStartTime_endTime;
@property (weak, nonatomic) IBOutlet UILabel *labPlanute_num;
@property (weak, nonatomic) IBOutlet UILabel *labStatus;

@end

@implementation WYCMTCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    return [[self alloc] initWithTableView:tableView indexPath:indexPath];
}

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    WYCMTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)renderViewWithModel:(WYModelCMT *)model{
    
    self.labORder.text = [NSString stringWithFormat:@"订单号：%@",model.order_code];
    self.labname.text = model.username;
    self.labBuilding.text = model.park_title;
    self.labTime.text = [NSString stringWithFormat:@"%@~%@",model.start_date,model.end_date];
//    self.labSaletype.text = model.
    
    
    self.labStartTime_endTime.text = [NSString stringWithFormat:@"%@~%@",model.start_time,model.end_time];
    
    self.labPlanute_num.text = [NSString stringWithFormat:@"车牌号：%@",model.plate_nu];
    self.labStatus.text = model.code_name;
    self.labSaletype.text = model.type;
}

@end
