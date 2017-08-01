//
//  WYShareViewItem.m
//  WYParking
//
//  Created by glavesoft on 17/2/16.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYShareViewItem.h"

@implementation WYShareViewItem

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configStyle];
    }
    return self;
}

- (void)configStyle{
    UIImageView *imageViewIcon = [[UIImageView alloc] init];
    [self addSubview:imageViewIcon];
    imageViewIcon.layer.cornerRadius = 25.0f;
    [imageViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(55);
        make.top.mas_equalTo(0);
        make.centerX.equalTo(imageViewIcon.superview);
    }];
    imageViewIcon.image = KPlaceHolderImg;
    self.imageViewIcon = imageViewIcon;
    
    UILabel *labTitle = UILabel.new;
    labTitle.font = [UIFont systemFontOfSize:14];
    [self addSubview:labTitle];
    labTitle.text = @"qq";
    labTitle.textAlignment = NSTextAlignmentCenter;
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageViewIcon.mas_bottom).with.offset(5);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(85);
        make.left.right.mas_equalTo(0);
    }];
    self.labTitle = labTitle;
}

@end
