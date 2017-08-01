//
//  WYFuJinCheYOuCell.m
//  WYParking
//
//  Created by glavesoft on 17/2/22.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYFuJinCheYOuCell.h"
#import "wyModelNearUser.h"

@interface WYFuJinCheYOuCell ()
@property (weak, nonatomic) IBOutlet UILabel *labDistance;
@property (weak, nonatomic) IBOutlet UILabel *labUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSex;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserLog;

@end

@implementation WYFuJinCheYOuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imageViewUserLog.layer.cornerRadius = 25.0f;
    self.imageViewUserLog.layer.masksToBounds = YES;
    
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    return [[self alloc] initWithTableView:tableView indexPath:indexPath];
}

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    WYFuJinCheYOuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)renderViewWithModel:(wyModelNearUser *)model{
    self.labUserName.text = model.username;
    self.labDistance.text = model.distance;
    if ([model.sex_name isEqualToString:@"女"]) {
        self.imageViewSex.image = [UIImage imageNamed:@"yhxq_woman"];
    }else{
        self.imageViewSex.image = [UIImage imageNamed:@"yhxq_man"];
    }
    [self.imageViewUserLog setImageWithURL:[NSURL URLWithString:model.logo] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
    }];
}


@end
