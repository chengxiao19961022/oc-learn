//
//  WYNearCell.m
//  WYParking
//
//  Created by glavesoft on 17/3/2.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYNearCell.h"
#import "WYModelFuJin.h"
#import "WYStarView.h"
#import "WYBlueStarView.h"

@interface WYNearCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPark;
@property (weak, nonatomic) IBOutlet UILabel *labDistance;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;


@property (weak , nonatomic) WYStarView *starView;
@property (weak, nonatomic) IBOutlet WYBlueStarView *blueStarView;

@end

@implementation WYNearCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    WYStarView *starView = WYStarView.new;
//    [self.contentView addSubview:starView];
//    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//    }];
//    self.starView = starView;
    // Initialization code
    [self.blueStarView configStyle];
    
}
+ (instancetype)cellWithCollectionView:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath{
       return [[self alloc] initWithCollectionView:collection indexPath:indexPath];
}

- (instancetype)initWithCollectionView:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath{
    WYNearCell *cell = [collection dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WYNearCell class]) forIndexPath:indexPath];
    
    return cell;
}


- (void)renderViewWithModel:(WYModelFuJin *)Model{
    
    [self.imageViewPark setImageWithURL:[NSURL URLWithString:Model.pic] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
    }];
    
    self.labDistance.text = Model.distance;
    self.labAddress.text = Model.park_title;
//    if ([Model.average isEqualToString:@""]||Model.average == nil) {
//        [self.starView renderViewWithMark:@"0"];
//    }else{
//        [self.starView renderViewWithMark:Model.average];
//    }
    [self.blueStarView renderViewWithMark:Model.average];
    
    
}


@end
