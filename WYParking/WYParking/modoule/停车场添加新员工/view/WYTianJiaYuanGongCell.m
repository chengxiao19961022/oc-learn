//
//  WYTianJiaYuanGongCell.m
//  WYParking
//
//  Created by glavesoft on 17/2/23.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYTianJiaYuanGongCell.h"
#import "WYSearchModel.h"

@interface WYTianJiaYuanGongCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iamgeViewUserlog;
@property (weak, nonatomic) IBOutlet UILabel *labUserName;
@property (weak, nonatomic) IBOutlet UILabel *labDistance;

@end

@implementation WYTianJiaYuanGongCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iamgeViewUserlog.layer.cornerRadius = 25.0f;
    self.iamgeViewUserlog.layer.masksToBounds = YES;
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    return [[self alloc] initWithTableView:tableView indexPath:indexPath];
}

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    WYTianJiaYuanGongCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)renderViewWithModel:(WYSearchModel *)model{
    [self.iamgeViewUserlog setImageWithURL:[NSURL URLWithString:model.logo] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
    }];
    self.labUserName.text = model.username;
    self.labDistance.text = model.distance;
}

@end
