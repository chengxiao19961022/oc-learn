//
//  WYTingCheChangCell.m
//  WYParking
//
//  Created by Sun Dawei on 2017/6/12.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYTingCheChangCell.h"
#import "WYModelPark_info.h"

@interface WYTingCheChangCell ()
//@property (weak, nonatomic) IBOutlet UIImageView *imageViewParkDetailPic;
//@property (weak, nonatomic) IBOutlet UILabel *labParkTitle;
//@property (assign , nonatomic) BOOL isTingCheChang;

@end

@implementation WYTingCheChangCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    return [[self alloc] initWithTableView:tableView indexPath:indexPath];
}

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    WYTingCheChangCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)renderViewWithModel:(WYModelPark_info *)model{
    
    
    self.labParkTitle.text = model.building;
    
    if ([model.status isEqualToString:@""]) {
        //self.isTingCheChang = NO;//未申请
    }else if ([model.status isEqualToString:@"1"]){
        //审核中
        //status_name = @"审核中";
        //self.isTingCheChang = YES;
        self.labStatus.text = @"审核中";
        self.labStatus.hidden = NO;
        self.labStatus.backgroundColor = [UIColor orangeColor];
        
    }else if ([model.status isEqualToString:@"2"]){
        //审核成功
        //status_name = @"审核成功";
        //self.isTingCheChang = YES;
        self.labStatus.text = @"审核通过";
        self.labStatus.hidden = YES;
    }else if ([model.status isEqualToString:@"3"]){
        //审核失败
        //status_name = @"";
        //self.isTingCheChang = YES;
        self.labStatus.text = @"审核失败";
        self.labStatus.backgroundColor = [UIColor redColor];
        self.labStatus.hidden = NO;

    }

    [self.imageViewParkDetailPic setImageWithURL:[NSURL URLWithString:model.identification_pic] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
    }];
}

@end
