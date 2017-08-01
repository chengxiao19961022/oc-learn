//
//  WYNearCell.h
//  WYParking
//
//  Created by glavesoft on 17/3/2.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYNearCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath;

- (void)renderViewWithModel:(id)Model;

@end
