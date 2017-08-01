//
//  WYCarDetaiInfoFooter.h
//  WYParking
//
//  Created by glavesoft on 17/2/16.
//  Copyright © 2017年 glavesoft. All rights reserved.


#import <UIKit/UIKit.h>

@interface WYCarDetaiInfoFooter : UIView

@property (weak , nonatomic) UIButton *lookMoreJudge;

- (void)renderViewWithDataSource:(NSMutableArray *)arr;

@end
