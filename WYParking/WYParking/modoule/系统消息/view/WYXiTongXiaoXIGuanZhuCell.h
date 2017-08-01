//
//  WYXiTongXiaoXIGuanZhuCell.h
//  WYParking
//
//  Created by glavesoft on 17/3/6.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYXiTongXiaoXIGuanZhuCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)renderViewWithModel:(id)model;

@end
