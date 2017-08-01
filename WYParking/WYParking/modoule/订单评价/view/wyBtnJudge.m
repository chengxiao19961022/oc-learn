//
//  wyBtnJudge.m
//  TheGenericVersion
//
//  Created by glavesoft on 16/9/20.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "wyBtnJudge.h"

@implementation wyBtnJudge

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpStyle];
    }
    return self;
}


- (void)setUpStyle{
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
    UILabel *labelTitle = UILabel.new;
    [self addSubview:labelTitle];
    labelTitle.font = [UIFont systemFontOfSize:13];
    labelTitle.textColor = [UIColor whiteColor];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    self.labelTitle = labelTitle;
    
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.backgroundColor = selected?[UIColor redColor]:[UIColor darkGrayColor];
}

@end
