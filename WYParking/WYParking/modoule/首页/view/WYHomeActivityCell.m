//
//  WYHomeActivityCell.m
//  WYParking
//
//  Created by glavesoft on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYHomeActivityCell.h"


@interface WYHomeActivityCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgUrl;
@property (weak, nonatomic) IBOutlet UILabel *AcName;
@property (weak, nonatomic) IBOutlet UILabel *AcDescr;

@end

@implementation WYHomeActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath{
    WYHomeActivityCell *cell = [collection dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WYHomeActivityCell class]) forIndexPath:indexPath];
    return cell;
}

- (void)renderViewWithModel:(wyModelActivity *)Model{
    self.model = Model;
    if (![Model.pic isEqualToString:@""]) {
        
        //self.imgUrl.contentMode = UIViewContentModeScaleAspectFit;
        self.imgUrl.contentMode = UIViewContentModeScaleToFill;
        
        [self.imgUrl setImageWithURL:[NSURL URLWithString:Model.pic_new] placeholder:KPlaceHolderImg options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            ;
        }];
        
        self.AcName.text = Model.title;
        self.AcDescr.text = Model.Description;
        
    }
   
}

@end
