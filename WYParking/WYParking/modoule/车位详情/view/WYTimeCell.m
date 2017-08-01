//
//  WYTimeCell.m
//  WYParking
//
//  Created by glavesoft on 17/2/17.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYTimeCell.h"
#import "wyModel_Park_detail.h"

@interface WYTimeCell ()



@end

@implementation WYTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.labTime.layer.cornerRadius = 5.0f;
    self.labTime.layer.masksToBounds = YES;
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collection indexPath:(NSIndexPath *)indexPath{
    WYTimeCell *cell = [collection dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WYTimeCell class]) forIndexPath:indexPath];
    return cell;
}

- (void)renderViewWithModel:(wyMOdelTime *)Model{
    if (Model.isSelected) {
        self.labTime.backgroundColor = kNavigationBarBackGroundColor;
        self.labTime.textColor = [UIColor whiteColor];
    }else{
        self.labTime.backgroundColor = RGBACOLOR(227, 227, 227, 1);
        self.labTime.textColor = [UIColor lightGrayColor];
    }
    self.labTime.text = [NSString stringWithFormat:@"%@-%@",Model.start_time,Model.end_time];
}

@end
