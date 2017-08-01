//
//  WYHomeTypeView.h
//  WYParking
//
//  Created by glavesoft on 17/2/9.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , homeViewType) {
    homeViewTypeAction = 0,
    homeViewTypeNearSpot,
    homeViewTypeFriend
    
};

typedef void(^homeTypeViewItemBlock)(homeViewType type , id model , NSIndexPath *indexPath);

@interface WYHomeTypeView : UIView

@property (weak ,nonatomic) UIButton *rightBtn;

@property (copy , nonatomic) homeTypeViewItemBlock block;

@property (weak , nonatomic) UIImageView *imageView;

@property (weak , nonatomic) UICollectionView * collectionView;

@property (assign , nonatomic) NSInteger RemenIndex;


- (void)renderViewWithleftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle type:(homeViewType)type;

- (void)renderViewWithArr:(NSMutableArray *)dataSource;

- (void)fetchActivityData;

@end
