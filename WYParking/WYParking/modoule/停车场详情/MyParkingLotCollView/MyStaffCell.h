//
//  MyStaffCell.h
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/16.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyStaffCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImg;

@end
