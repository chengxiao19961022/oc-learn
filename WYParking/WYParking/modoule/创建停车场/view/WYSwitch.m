//
//  WYSwitch.m
//  WYParking
//
//  Created by Leon on 17/3/5.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "WYSwitch.h"

@interface WYSwitch ()

@property (weak , nonatomic) UIImageView *bgImageView;

@end

@implementation WYSwitch



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configStyle];
    }
    return self;
}

- (void)configStyle{
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [self addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(30);
    }];
    bgImageView.image = [UIImage imageNamed:@"sz_kgk"];
    self.selected = YES;
    self.bgImageView = bgImageView;
    
    
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.bgImageView.image  = [UIImage imageNamed:@"sz_kgk"];
    }else{
         self.bgImageView.image  = [UIImage imageNamed:@"sz_kg"];
    }
}

@end
