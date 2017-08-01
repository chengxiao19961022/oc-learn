//
//  WYButton.h
//  WYParking
//  仅仅适用于两种状态下的，只有文字或者图片
//  Created by Leon on 17/2/7.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYButton : UIControl

@property (weak , nonatomic , readwrite) UILabel *LabTitle;
@property (weak , nonatomic , readwrite) UIImageView * imageView;

- (void)renderWithNormalTitle:(NSString *)normalTitle SelectedTitle:(NSString *)selectedTitle normalImage:(UIImage *)normalImage SelectedImage:(UIImage *)SelectedImage;

@end
