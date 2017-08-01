//
//  wyParkCallOutView.h
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/10.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wyParkCallOutView : UIView

@property (weak , nonatomic) UILabel *labAddress;

- (void)renderViewWithModel:(id)model;

@end
