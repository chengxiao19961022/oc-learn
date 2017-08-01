//
//  WYJiaGeCell.h
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYModelJiaGe;

typedef void(^endEditBlock)(WYModelJiaGe *model,NSIndexPath *ip);

@interface WYJiaGeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *isOnSwitch;

@property (copy , nonatomic) endEditBlock jiageBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)renderViewWithModel:(id)model;

@end
