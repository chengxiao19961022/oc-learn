//
//  51FriendCollectionViewCell.h
//  TheGenericVersion
//
//  Created by glavesoft on 16/8/10.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface wyFriendCollectionViewCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath;

- (void)renderViewWithModel:(id)Model;




@end
