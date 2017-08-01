//
//  WYNearFriendCell.m
//  WYParking
//
//  Created by glavesoft on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYNearFriendCell.h"
#import "wyModelNearUser.h"

@interface WYNearFriendCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLog;
@property (weak, nonatomic) IBOutlet UILabel *labUserName;
@property (weak, nonatomic) IBOutlet UILabel *labChePai;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSex;

@end


@implementation WYNearFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageViewLog.layer.cornerRadius = 35.0f;
    self.imageViewLog.layer.masksToBounds = YES;
    // Initialization code
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath{
    WYNearFriendCell *cell = [collection dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WYNearFriendCell class]) forIndexPath:indexPath];
    return cell;
}

- (void)renderViewWithModel:(wyModelNearUser *)Model{
    [self.imageViewLog setImageWithURL:[NSURL URLWithString:Model.logo] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
    }];
    self.labUserName.text = Model.username;
    self.labChePai.text = Model.brand_name?:@"";
    if ([Model.sex isEqualToString:@"1"]) {
        self.imageViewSex.image = [UIImage imageNamed:@"yhxq_man"];
        
    }else{
        self.imageViewSex.image = [UIImage imageNamed:@"yhxq_woman"];
    }
}

@end
