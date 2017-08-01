//
//  GoOutVoucherCell.m
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/16.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import "GoOutVoucherCell.h"
#import "WYModelCMT.h"

@interface GoOutVoucherCell ()
@property (weak, nonatomic) IBOutlet UILabel *labOrderID;
@property (weak, nonatomic) IBOutlet UILabel *labBuilding;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labType;
@property (weak, nonatomic) IBOutlet UILabel *labStartTime_endTime;
@property (weak, nonatomic) IBOutlet UILabel *labChePaiHao;
@property (weak, nonatomic) IBOutlet UILabel *labStatus;

@end

@implementation GoOutVoucherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labStatus.layer.masksToBounds = YES;
    self.labStatus.layer.cornerRadius = 3;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)renderViewWithModel:(WYModelCMT *)model{
    self.labOrderID.text = [NSString stringWithFormat:@"订单号：%@",model.order_code];
    self.labBuilding.text = model.park_title;
    self.labName.text = model.username;
    self.labTime.text = [NSString stringWithFormat:@"%@~%@",model.start_date,model.end_date];
    self.labStartTime_endTime.text = [NSString stringWithFormat:@"%@~%@",model.start_time,model.end_time];
   
    self.labChePaiHao.text = [NSString stringWithFormat:@"车牌号：%@", model.plate_nu];
    self.labStatus.text = model.code_name;
}

@end
