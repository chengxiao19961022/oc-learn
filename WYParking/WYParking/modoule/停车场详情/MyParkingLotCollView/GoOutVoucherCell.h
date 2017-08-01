//
//  GoOutVoucherCell.h
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/16.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoOutVoucherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *expiredLab;

- (void)renderViewWithModel:(id)model;

@end
