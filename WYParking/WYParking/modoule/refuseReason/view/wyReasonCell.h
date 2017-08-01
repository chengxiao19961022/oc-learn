//
//  wyReasonCell.h
//  TheGenericVersion
//
//  Created by glavesoft on 16/9/6.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class wyModelReason;

@interface wyReasonCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)renderViewWithModel:(wyModelReason *)model;

@end
