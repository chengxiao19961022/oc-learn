//
//  WYCollectionViewCell.m
//  WYParking
//
//  Created by glavesoft on 17/2/9.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYCollectionViewCell.h"
#import "WYModelMYOrder.h"

@interface WYCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *labOrder;
@property (weak, nonatomic) IBOutlet UILabel *labStatus;

@property (weak, nonatomic) IBOutlet UILabel *labStartTime;
@property (weak, nonatomic) IBOutlet UILabel *labEndTime;
@property (weak, nonatomic) IBOutlet UILabel *labParkTile;
@property (weak, nonatomic) IBOutlet UILabel *labStarDate;
@property (weak, nonatomic) IBOutlet UILabel *labEndDate;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation WYCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.layer.cornerRadius = 25.0f;
    self.iconImageView.layer.masksToBounds = YES;
    // Initialization code
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath{
    WYCollectionViewCell *cell = [collection dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WYCollectionViewCell class]) forIndexPath:indexPath];
    return cell;
}

- (void)renderViewWithModel:(WYModelMYOrder *)Model{
    self.labOrder.text = Model.order_code;
    self.labStatus.text = Model.status_out_name;
    self.labParkTile.text = Model.park_title;
    self.labStartTime.text = Model.start_time;
    self.labEndTime.text = Model.end_time;
    self.labStarDate.text = Model.start_date;
    self.labEndDate.text = Model.end_date;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:Model.pic] placeholder:KPlaceHolderImg options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
    }];
        if ([Model.status_out_name isEqualToString:@"进行中"]) {
            self.labStatus.backgroundColor = kJinXingZhongColor;
        }else if ([Model.status_out_name isEqualToString:@"已确认"]){
            self.labStatus.backgroundColor = kYiQueRenColor;
        }else if ([Model.status_out_name isEqualToString:@"待付款"]){
            self.labStatus.backgroundColor = kDaiFuKuanColor;
        }else if ([Model.status_out_name isEqualToString:@"待确认"]){
            self.labStatus.backgroundColor = kDaiQueRenColor;
        }else if ([Model.status_out_name isEqualToString:@"待评价"]){
            self.labStatus.backgroundColor = kDaiPingJiaColor;
        }else if ([Model.status_out_name isEqualToString:@"已取消"]){
            self.labStatus.backgroundColor = kYiQuXiaoColor;
        }else if ([Model.status_out_name isEqualToString:@"已拒绝"]){
            self.labStatus.backgroundColor = kYiJuJueColor;
        }else if ([Model.status_out_name isEqualToString:@"已完成"]){
            self.labStatus.backgroundColor = kYiWanChengColor;
        }

}

@end
