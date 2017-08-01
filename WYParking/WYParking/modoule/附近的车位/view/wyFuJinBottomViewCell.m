//
//  wyFuJinBottomViewCell.m
//  WYParking
//
//  Created by glavesoft on 17/3/2.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "wyFuJinBottomViewCell.h"
#import "WYModelFuJin.h"

@interface wyFuJinBottomViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *labID;
@property (weak, nonatomic) IBOutlet UILabel *labPark_Time;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUerlog;
@property (weak, nonatomic) IBOutlet UILabel *labUserName;
@property (strong , nonatomic) WYModelFuJin *   Model;

@end

@implementation wyFuJinBottomViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageViewUerlog.layer.cornerRadius = 15.0f;
    self.imageViewUerlog.layer.masksToBounds = YES;
    // Initialization code
    
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath{
    wyFuJinBottomViewCell *cell = [collection dequeueReusableCellWithReuseIdentifier:NSStringFromClass([wyFuJinBottomViewCell class]) forIndexPath:indexPath];
    return cell;
}

- (void)renderViewWithModel:(WYModelFuJin *)Model{
    self.Model = Model;
    self.labID.text = [NSString stringWithFormat:@"%@.",Model.ID] ;
    self.labAddress.text = Model.address;
    self.labUserName.text = Model.username;
    self.labPark_Time.text = Model.park_title;
    [self.imageViewUerlog setImageWithURL:[NSURL URLWithString:Model.logo] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
    }];
    self.faXiaoXIView.tag = self.xiangqingView.tag = [Model.ID integerValue]-1;
}

- (IBAction)btnFaXiaoXIClick:(id)sender {
    if (_blockcel) {
        self.blockcel(clicktypeFaXiaoXi , self.Model);
    }
}

- (IBAction)btnDetailClick:(id)sender {
    if (_blockcel) {
        self.blockcel(clicktypeXiangQing , self.Model);
    }
}

//点击用户头像
- (IBAction)btnTapUserLogoClick:(id)sender {
    if (_blockcel) {
        self.blockcel(clicktypeTouXiang , self.Model);
    }
}

@end
