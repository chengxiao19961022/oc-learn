//
//  MyStaffCell.m
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/16.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import "MyStaffCell.h"

@implementation MyStaffCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.logoImg.layer.cornerRadius = 25.0f;
    self.logoImg.layer.masksToBounds = YES;
}
@end
