//
//  wyFuJinBottomViewCell.h
//  WYParking
//
//  Created by glavesoft on 17/3/2.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , clicktype) {
    clicktypeFaXiaoXi = 0,
    clicktypeXiangQing = 1,
    clicktypeTouXiang = 2
};
typedef void(^BottomViewBlock)(clicktype type,id Model);

@interface wyFuJinBottomViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *faXiaoXIView;

@property (weak, nonatomic) IBOutlet UIView *xiangqingView;
@property (copy , nonatomic) BottomViewBlock blockcel;


+ (instancetype)cellWithCollectionView:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath;

- (void)renderViewWithModel:(id)Model;

@end
