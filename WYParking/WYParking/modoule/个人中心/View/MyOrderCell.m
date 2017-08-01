//
//  MyOrderCell.m
//  WYParking
//
//  Created by admin on 17/2/17.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "MyOrderCell.h"
#import "WYModelMYOrder.h"

@interface MyOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *labOrderType;//类型
@property (weak, nonatomic) IBOutlet UILabel *labOrderState;//订单状态
@property (weak, nonatomic) IBOutlet UILabel *labParkAddress;//车位

@property (weak, nonatomic) IBOutlet UILabel *carNumberLab;//车牌号
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLab;//订单价格

@property (weak, nonatomic) IBOutlet UILabel *labDate;//开始时间

@end

@implementation MyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)renderViewWithModel:(WYModelMYOrder *)model{
    
    if ([model.is_me isEqualToString:@"1"]) {
//        self.labOrderType.text = @"租用订单";
        
        NSString *titleStr = [NSString stringWithFormat:@"租用订单·%@",model.sale_type_name];
        self.labOrderType.text = titleStr;

        self.labOrderType.textColor = RGBACOLOR(1, 1, 149, 1);
    }else{
//        self.labOrderType.text = @"出租订单";
        NSString *titleStr = [NSString stringWithFormat:@"出租订单·%@",model.sale_type_name];
        self.labOrderType.text = titleStr;

        self.labOrderType.textColor = RGBACOLOR(248, 201, 100, 1);
    }
    self.labOrderState.text = model.status_out_name;
    if ([model.status_out_name isEqualToString:@"进行中"]) {
        self.labOrderState.textColor = kJinXingZhongColor;
    }else if ([model.status_out_name isEqualToString:@"已确认"]){
        self.labOrderState.textColor = kYiQueRenColor;
    }else if ([model.status_out_name isEqualToString:@"待付款"]){
        self.labOrderState.textColor = kDaiFuKuanColor;
    }else if ([model.status_out_name isEqualToString:@"待确认"]){
        self.labOrderState.textColor = kDaiQueRenColor;
    }else if ([model.status_out_name isEqualToString:@"待评价"]){
        self.labOrderState.textColor = kDaiPingJiaColor;
    }else if ([model.status_out_name isEqualToString:@"已取消"]){
        self.labOrderState.textColor = kYiQuXiaoColor;
    }else if ([model.status_out_name isEqualToString:@"已拒绝"]){
        self.labOrderState.textColor = kYiJuJueColor;
    }else if ([model.status_out_name isEqualToString:@"已完成"]){
        self.labOrderState.textColor = kYiWanChengColor;
    }
    
//    self.labParkAddress.text = model.park_title?:@"";
//    if ([model.sale_type_name containsString:@"日租"]) {
//        self.labStart_endTime.text = [NSString stringWithFormat:@"%@:%@",model.sale_type_name,model.start_time];
//    }else{
//        self.labStart_endTime.text = [NSString stringWithFormat:@"%@:%@～%@",model.sale_type_name,model.start_time,model.end_time];
//    }
    
    /******车牌号******/
    self.carNumberLab.text = [NSString stringWithFormat:@"车牌号：%@",model.plate_nu];
    /******车  位******/
    self.labParkAddress.text = [NSString stringWithFormat:@"车    位：%@",model.park_title];
    /******订单价格******/
    
    if ([model.status_out_name containsString:@"退款成功"]) {
        self.orderPriceLab.text = [NSString stringWithFormat:@"¥%@",model.tui_price];
    }else{
        self.orderPriceLab.text = [NSString stringWithFormat:@"¥%@",model.pay_price];
    }
    
    /******开始日期 ******/
    self.labDate.text = [NSString stringWithFormat:@"开始日期：%@",model.start_date];

    
//    if ([model.start_date isEqualToString:model.end_date]) {
//        self.labDate.text = [NSString stringWithFormat:@"%@",model.start_date];
//    }else{
//         self.labDate.text = [NSString stringWithFormat:@"%@至%@",model.start_date,model.end_date];
//    }
    
    
}

@end
