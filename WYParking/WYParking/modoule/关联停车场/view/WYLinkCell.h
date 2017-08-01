//
//  WYLinkCell.h
//  WYParking
//
//  Created by glavesoft on 17/2/24.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^linkCellBlock)(id model);

@interface WYLinkCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@property (weak, nonatomic) IBOutlet UIButton *btnGuanLian;

- (void)renderViewWithModel:(id)model;

@property (copy , nonatomic) linkCellBlock block;

@end
