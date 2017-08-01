//
//  WYShareView.m
//  WYParking
//
//  Created by glavesoft on 17/2/16.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYShareView.h"
#import "WYShareViewItem.h"

@implementation WYShareView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configStyle];
    }
    return self;
}

- (void)configStyle{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *lab = UILabel.new;
    lab.text = @"分享到";
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = [UIColor darkGrayColor];
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lab.superview);
        make.top.mas_equalTo(10);
    }];
    
    WYShareViewItem *item = WYShareViewItem.new;
    CGFloat h = [item systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height
    ;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(lab.mas_bottom).with.offset(10);
        make.height.mas_equalTo(h);
    }];
    UIView *containerV = UIView.new;
    [scrollView addSubview:containerV];
    [containerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.equalTo(scrollView.mas_height);
    }];
    
    NSArray *titleArr = @[
                          @"微信朋友圈",
                          @"微信好友",
                          @"QQ空间",
                          @"QQ好友",
                          @"微博",
                          ];
    
    NSArray *imageNameArr = @[
                              @"wx",
                              @"wxhy",
                              @"kj",
                              @"qq",
                              @"wb"
                              ];
    NSMutableArray<WYShareViewItem *> *buttonArr = [NSMutableArray array];
    for (int i = 0; i < titleArr.count; i ++ ) {
        WYShareViewItem *item = WYShareViewItem.new;
        item.labTitle.text = [titleArr objectAtIndex:i];
        item.imageViewIcon.image = [UIImage imageNamed:[imageNameArr objectAtIndex:i]];
        [item bk_whenTapped:^{
            if (self.shareblock) {
                self.shareblock(i);
            }
        }];
        [containerV addSubview:item];
        [buttonArr addObject:item];
    }
    WYShareViewItem *firstItem = buttonArr.firstObject;
    [firstItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(3);
        make.centerY.equalTo(firstItem.superview);
        
    }];
    [buttonArr enumerateObjectsUsingBlock:^(WYShareViewItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            WYShareViewItem *preItem = [buttonArr objectAtIndex:idx - 1];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(preItem.mas_right).with.offset(10);
                make.centerY.equalTo(preItem.mas_centerY);
            }];
        }
    }];
    [buttonArr.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-3);
    }];
    
    UIButton *btnCancel = UIButton.new;
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.backgroundColor = [UIColor whiteColor];
    [self addSubview:btnCancel];
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.mas_bottom).with.offset(15);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-3);
        make.height.mas_equalTo(50);
    }];
    self.btnCancel = btnCancel;
    
}

@end
