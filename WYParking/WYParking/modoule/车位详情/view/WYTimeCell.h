//
//  WYTimeCell.h
//  WYParking
//
//  Created by glavesoft on 17/2/17.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYTimeCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *labTime;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath;

- (void)renderViewWithModel:(id)Model;

@end
