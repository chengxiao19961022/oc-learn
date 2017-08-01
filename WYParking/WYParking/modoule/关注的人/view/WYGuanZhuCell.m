//
//  WYGuanZhuCell.m
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYGuanZhuCell.h"
#import "wyModelGuanZhu.h"

@interface WYGuanZhuCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserLogo;
@property (weak, nonatomic) IBOutlet UILabel *labUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSex;

@end

@implementation WYGuanZhuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageViewUserLogo.layer.cornerRadius = 30.0f;
    self.imageViewUserLogo.layer.masksToBounds = YES;
    // Initialization code
}



+ (instancetype)cellWithCollectionView:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath{
    WYGuanZhuCell *cell = [collection dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WYGuanZhuCell class]) forIndexPath:indexPath];
    return cell;
}

- (void)renderViewWithModel:(wyModelGuanZhu *)Model{
    [self.imageViewUserLogo setImageWithURL:[NSURL URLWithString:Model.logo] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
    }];
    self.labUserName.text = Model.username;
    if ([Model.sex_name isEqualToString:@"女"]) {
         self.imageViewSex.image = [UIImage imageNamed:@"yhxq_woman"];
    }else{
         self.imageViewSex.image = [UIImage imageNamed:@"yhxq_man"];
    }
   
}

@end
