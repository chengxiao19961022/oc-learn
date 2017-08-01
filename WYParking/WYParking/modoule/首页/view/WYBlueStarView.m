//
//  WYBlueStarView.m
//  WYParking
//
//  Created by 高宇昊 on 2017/5/31.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYBlueStarView.h"

@interface WYBlueStarView ()

@property (strong , nonatomic) NSMutableArray *starBtnArr;

@end

@implementation WYBlueStarView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configStyle];
    }
    return self;
}

- (void)configStyle{
    NSMutableArray<UIButton *> *starBtnArr = [NSMutableArray array];
    int starCount = 5;
    for ( int i = 0; i < starCount; i ++) {
        UIButton *btn = UIButton.new;
        [btn setBackgroundImage:[UIImage imageNamed:@"grey_star"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"tc_star"] forState:UIControlStateSelected];
        [self addSubview:btn];
        [starBtnArr addObject:btn];
    }
    
    [starBtnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [starBtnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.starBtnArr = starBtnArr;
}

- (void)renderViewWithMark:(NSString *)mark{
    WYLog(@"render star: %@",mark);
    if ([mark isEqualToString:@""]) {
        return;
    }
    NSString *countStr = [mark substringWithRange:NSMakeRange(0, 1)];
    NSInteger countInteger = [countStr integerValue];
    CGFloat currentFloat = [[NSString stringWithFormat:@"%@",mark] floatValue];
    CGFloat minFloat = (CGFloat)countInteger;
    CGFloat maxFloat = (CGFloat)countInteger + 0.5;
    BOOL isBanke = NO;
    if (minFloat <= currentFloat && currentFloat < maxFloat) {
        isBanke = NO;
    }else{
        isBanke = YES;
    }
    [self.starBtnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (countInteger > idx) {
            obj.selected = YES;
        }else{
            obj.selected = NO;
        }
        while (idx == countInteger) {
            if (isBanke) {
                [obj setBackgroundImage:[UIImage imageNamed:@"tc_bstar"] forState:UIControlStateNormal];
            }
            break;
        }
    }];
    
}

@end
