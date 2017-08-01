//
//  LBHeaderFooterView.h
//  LBPersonalProject
//
//  Created by glavesoft on 16/9/22.
//  Copyright © 2016年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBHeaderFooterView : UITableViewHeaderFooterView

@property (weak , nonatomic) UILabel *titleLable;

+ (instancetype)HeaderWithTableview:(UITableView *)tableView;



@end
