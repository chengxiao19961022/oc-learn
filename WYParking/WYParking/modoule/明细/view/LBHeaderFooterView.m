//
//  LBHeaderFooterView.m
//  LBPersonalProject
//
//  Created by glavesoft on 16/9/22.
//  Copyright © 2016年 glavesoft. All rights reserved.
//

#import "LBHeaderFooterView.h"

@implementation LBHeaderFooterView


+ (instancetype)HeaderWithTableview:(UITableView *)tableView{
    static NSString *ID = @"ggadafasdfa";
    LBHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        //注册
        header = [[LBHeaderFooterView alloc] initWithReuseIdentifier:ID];
    }
    header.contentView.backgroundColor = RGBACOLOR(243, 245, 246, 1);
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier ]) {
        [self configUI];
        
    }
    return self;
}


- (void)configUI{
    UILabel *titleLable = UILabel.new;
    titleLable.text = @"--";
    titleLable.font= [UIFont systemFontOfSize:15];
    [self.contentView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.centerX.equalTo(titleLable.superview);
        make.bottom.mas_equalTo(-6);
    }];
    self.titleLable = titleLable;
}



@end
