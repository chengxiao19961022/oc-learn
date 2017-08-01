//
//  WYHomeActivityCell.h
//  WYParking
//
//  Created by glavesoft on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wyModelActivity.h"

@interface WYHomeActivityCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath;

- (void)renderViewWithModel:(id)Model;

@property (nonatomic , strong) wyModelActivity *model;

@end
