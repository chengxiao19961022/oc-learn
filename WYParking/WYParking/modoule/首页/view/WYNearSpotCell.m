//
//  WYNearSpotCell.m
//  WYParking
//
//  Created by glavesoft on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYNearSpotCell.h"
#import "WYModelFuJin.h"
#import "WYBlueStarView.h"

@interface WYNearSpotCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *labDistance;
@property (weak, nonatomic) IBOutlet UILabel *labBuilding;
@property (weak, nonatomic) IBOutlet WYBlueStarView *BlueStar;

@end

@implementation WYNearSpotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImage.layer.masksToBounds = YES;
    // Initialization code
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath{
    WYNearSpotCell *cell = [collection dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WYNearSpotCell class]) forIndexPath:indexPath];
    return cell;
}

- (void)renderViewWithModel:(WYModelFuJin *)Model{
    WYLog(@"data %@",Model);
    WYLog(@"url %@",Model.pic);
    [self.iconImage setImageWithURL:[NSURL URLWithString:Model.pic] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
    }];
    WYLog(@"distance %@",Model.distance);
    self.labDistance.text = [NSString stringWithFormat:@"%@",Model.distance];
    self.labBuilding.text = Model.park_title;
    self.labBuilding.text = [NSString stringWithFormat:@"%@",Model.park_title];
    WYLog(@"star %@",Model.average);
    [self.BlueStar configStyle];
    [self.BlueStar renderViewWithMark:Model.average];
}

@end
