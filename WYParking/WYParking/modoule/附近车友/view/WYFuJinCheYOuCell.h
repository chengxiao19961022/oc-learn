//
//  WYFuJinCheYOuCell.h
//  WYParking
//
//  Created by glavesoft on 17/2/22.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYFuJinCheYOuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnSendMsg;
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)renderViewWithModel:(id)model;


@end
