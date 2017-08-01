//
//  MYYouhuiquanCell.m
//  WYParking
//
//  Created by admin on 17/2/16.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "MYYouhuiquanCell.h"
#import "WYModelYouHuiQuan.h"

@interface MYYouhuiquanCell ()
@property (weak, nonatomic) IBOutlet UILabel *labDis_count;
@property (weak, nonatomic) IBOutlet UILabel *labTme;
@property (weak, nonatomic) IBOutlet UILabel *labCoupon_type;
@property (weak, nonatomic) IBOutlet UILabel *labDistribute_type;
@property (weak, nonatomic) IBOutlet UILabel *labMin_consumption;


@end

@implementation MYYouhuiquanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)renderWithModel:(WYModelYouHuiQuan *)model{
   
    self.labTme.text = [NSString stringWithFormat:@"有效期：%@至%@", model.start_date,model.end_date];
    
    if([model.min_consumption isEqualToString:@"0"]){
        self.labMin_consumption.text = [NSString stringWithFormat:@"无条件使用"];
    }else{
        self.labMin_consumption.text = [NSString stringWithFormat:@"满%@可用",model.min_consumption];
    }
    
    if([model.coupon_type isEqualToString:@"1"]){
        self.labCoupon_type.text = [NSString stringWithFormat:@"代金券"];
        self.labDis_count.text = [NSString stringWithFormat:@"￥%@",model.discount_margin];
    }else{
        self.labCoupon_type.text = [NSString stringWithFormat:@"折扣券"];
        self.labDis_count.text = [NSString stringWithFormat:@"%@折",model.discount_margin];
    }

    if([model.type isEqualToString:@"0"]){
        self.labDistribute_type.text = [NSString stringWithFormat:@"分享所得"];
    }else{
        if([model.distribute_type isEqualToString:@"0"]){
            self.labDistribute_type.text = [NSString stringWithFormat:@"微信领取"];
        }else if([model.distribute_type isEqualToString:@"1"]){
            self.labDistribute_type.text = [NSString stringWithFormat:@"活动所得"];
        }else if([model.distribute_type isEqualToString:@"2"]){
            self.labDistribute_type.text = [NSString stringWithFormat:@"新用户"];
        }else if([model.distribute_type isEqualToString:@"3"]){
            self.labDistribute_type.text = [NSString stringWithFormat:@"全员发送"];
        }else if([model.distribute_type isEqualToString:@"4"]){
            self.labDistribute_type.text = [NSString stringWithFormat:@"支付完成"];
        }
    }

    
}

@end
