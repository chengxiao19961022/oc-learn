//
//  WYYongHuCheWeiCell.m
//  WYParking
//
//  Created by glavesoft on 17/2/22.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYYongHuCheWeiCell.h"
#import "WYModelCheWei.h"


@interface WYYongHuCheWeiCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageviewUserLogo;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;
@property (weak, nonatomic) IBOutlet UILabel *labCount;
@property (weak, nonatomic) IBOutlet UILabel *labDistance;

@end

@implementation WYYongHuCheWeiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imageviewUserLogo.layer.cornerRadius =30.0f;
    self.imageviewUserLogo.layer.masksToBounds = YES;
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    return [[self alloc] initWithTableView:tableView indexPath:indexPath];
}

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    WYYongHuCheWeiCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)renderViewWithModel:(WYModelCheWei *)model{
    [self.imageviewUserLogo setImageWithURL:[NSURL URLWithString:model.pic] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
    }];

    self.labAddress.text = model.park_title;
    self.labDistance.text = model.distance;
}


@end
