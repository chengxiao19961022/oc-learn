
//
//  51FriendCollectionViewCell.m
//  TheGenericVersion
//
//  Created by glavesoft on 16/8/10.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "wyFriendCollectionViewCell.h"
#import "WYModelGuQuanFriend.h"

@interface wyFriendCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgViewHeader;
@property (weak, nonatomic) IBOutlet UILabel *labUsername;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserLogo;

@end

@implementation wyFriendCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgViewHeader.layer.cornerRadius = 30.f;
    self.imgViewHeader.clipsToBounds = YES;

}



+ (instancetype)cellWithCollectionView:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath{
    wyFriendCollectionViewCell *cell = [collection dequeueReusableCellWithReuseIdentifier:NSStringFromClass([wyFriendCollectionViewCell class]) forIndexPath:indexPath];
    return cell;
}

- (void)renderViewWithModel:(WYModelGuQuanFriend *)Model{
    [self.imageViewUserLogo setImageWithURL:[NSURL URLWithString:Model.logo] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
    }];
    self.labUsername.text = Model.username;
}

@end
