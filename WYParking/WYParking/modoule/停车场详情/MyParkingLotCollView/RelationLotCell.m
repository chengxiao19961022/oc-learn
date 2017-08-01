//
//  RelationLotCell.m
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/16.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import "RelationLotCell.h"

@implementation RelationLotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageViewPic.layer.cornerRadius = 28.0f;
    self.imageViewPic.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
