//
//  PersonalItemView.h
//  WYParking
//
//  Created by admin on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalItemView : UIView
@property (strong, nonatomic) IBOutlet PersonalItemView *personalitemview;
@property (weak, nonatomic) IBOutlet UIImageView *IconImg;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IconY_Layout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LineY_Layout;

@end
