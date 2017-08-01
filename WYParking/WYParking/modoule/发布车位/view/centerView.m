//
//  centerView.m
//  WYParking
//
//  Created by glavesoft on 17/2/23.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "centerView.h"

@implementation centerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configStyle];
    }
    return self;
}

- (void)configStyle{
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"map_bottom"];
    [self addSubview:backImageView];
    UILabel *labTitle = UILabel.new;
    labTitle.numberOfLines = 0;
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.preferredMaxLayoutWidth = 200;
    [self addSubview:labTitle];
    labTitle.text = @"定位中";
    labTitle.font = [UIFont systemFontOfSize:13];
    labTitle.textColor = [UIColor whiteColor];
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
    }];
    self.labTitle = labTitle;
    
 
    
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"map_arrow"];
    [self addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(arrowImageView.superview);
        make.top.equalTo(labTitle.mas_bottom).with.offset(0);
        make.width.height.mas_equalTo(10);
    }];
    UIImageView *locationImageView = [[UIImageView alloc] init];
    locationImageView.image = [UIImage imageNamed:@"dt_dw"];
    [self addSubview:locationImageView];
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(arrowImageView.mas_bottom);
        make.width.mas_equalTo(33/2.0);
        make.height.mas_equalTo(45/2.0);
        make.bottom.mas_equalTo(0);
        make.centerX.equalTo(locationImageView.superview);
    }];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(arrowImageView.mas_top).with.offset(3);
    }];
}

@end
