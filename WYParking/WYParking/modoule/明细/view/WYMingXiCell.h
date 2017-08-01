//
//  WYMingXiCell.h
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYMingXiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)renderViewWithModel:(id)model;






@end
