//
//  WYTingCheChangCell.h
//  WYParking
//
//  Created by Sun Dawei on 2017/6/12.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYTingCheChangCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labStatus;
@property (weak, nonatomic) IBOutlet UILabel *labParkTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewParkDetailPic;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)renderViewWithModel:(id)model;

@end
