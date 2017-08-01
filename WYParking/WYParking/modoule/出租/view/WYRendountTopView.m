//
//  WYRendountTopView.m
//  WYParking
//
//  Created by glavesoft on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYRendountTopView.h"

@interface WYRendountTopView ()

@property (weak , nonatomic) UIView *hairLine;

@end

@implementation WYRendountTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configStyle];
    }
    return self;
}

- (void)configStyle{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"jbbg"];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UILabel *labTitle = UILabel.new;
    labTitle.textColor = [UIColor blackColor];
    labTitle.font = [UIFont systemFontOfSize:20];
    labTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labTitle];
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(44);
    }];
    labTitle.text = @"出租";
    labTitle.textColor = [UIColor whiteColor];
    
    NSArray<NSString *> *titlArr = @[
                                     @"车位",
                                     @"停车场"
                                     ];
    NSMutableArray<UIButton *> *btnArr = [NSMutableArray array];
    for (int i = 0; i < titlArr.count;  i++) {
        UIButton *btn = UIButton.new;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:[titlArr objectAtIndex:i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:RGBACOLOR(110, 141, 196, 1) forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn bk_addEventHandler:^(id sender) {
            if (_selectedBtn == btn) {
                return ;
            }
            _selectedBtn.selected = NO;
            _selectedBtn = btn;
            _selectedBtn.selected = YES;
            self.type = [NSString stringWithFormat:@"%d",btn.tag];
            [self.hairLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo([Utils sizeWithText:@"停车场" Font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, 25)]);
                make.height.mas_equalTo(4);
                make.centerX.equalTo(_selectedBtn.mas_centerX);
                make.top.equalTo(_selectedBtn.mas_bottom).with.offset(1);
            }];
            [self layoutIfNeeded];
        } forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
            self.type = [NSString stringWithFormat:@"%d",btn.tag];
        }
        [btnArr addObject:btn];
        
    }
    NSArray *arr = btnArr.copy;
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(40);
    }];
    UIView *hairLine = UIView.new;
    hairLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:hairLine];
    [hairLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([Utils sizeWithText:@"停车场" Font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, 25)]);
        make.height.mas_equalTo(4);
        make.centerX.equalTo(_selectedBtn.mas_centerX);
        make.top.equalTo(_selectedBtn.mas_bottom).with.offset(1);
    }];
    self.hairLine = hairLine;
    
    
}

@end
