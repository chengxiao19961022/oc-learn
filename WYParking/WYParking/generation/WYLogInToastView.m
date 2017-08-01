//
//  WYLogInToastView.m
//  WYParking
//
//  Created by glavesoft on 17/2/25.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYLogInToastView.h"

@interface WYLogInToastView ()

@property (weak , nonatomic) UILabel *titleLabel;
@property (weak , nonatomic) UILabel *Label;



@end

@implementation WYLogInToastView

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
    self.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = UILabel.new;
    titleLabel.text = @"重复密码";
    titleLabel.textColor = UIColor.redColor;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    self.titleLabel = titleLabel;
    
    UILabel *Label = UILabel.new;
    Label.text = @"错误，请重新输入。";
    Label.textColor = [UIColor darkGrayColor];
    Label.font = [UIFont systemFontOfSize:15];
    [self addSubview:Label];
    [Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right);
        make.centerY.equalTo(Label.superview);
    }];
    self.Label = Label;
}

- (void)renderWithErrorText:(NSString *)text Hidden:(BOOL)hidden{
    self.titleLabel.text = text?:@"请输入错误类型";
    self.Label.hidden = hidden;
}

@end
