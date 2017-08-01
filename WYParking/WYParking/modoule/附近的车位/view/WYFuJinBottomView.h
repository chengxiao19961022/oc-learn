//
//  WYFuJinBottomView.h
//  WYParking
//
//  Created by glavesoft on 17/3/2.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wyFuJinBottomViewCell.h"

typedef void(^pageBlock)(NSString *str);

@interface WYFuJinBottomView : UIView
@property (copy , nonatomic) BottomViewBlock fujinBottomblock;

@property (weak , nonatomic) UICollectionView *collectionView;

@property (copy , nonatomic) pageBlock blockIndex;

- (void)renderViewWithArr:(NSMutableArray *)arr;

@end
