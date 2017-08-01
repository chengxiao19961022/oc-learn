//
//  CustomAnnotationView.h
//  TheGenericVersion
//
//  Created by lijie on 16/2/29.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "QiPaoView.h"

#import "WYModelFuJin.h"

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, strong) QiPaoView *qiPaoView;

@property (retain,nonatomic)  WYModelFuJin *fjModel;

@property(strong,nonatomic) UIImageView * bgImgV;

@property (nonatomic, copy)void(^SelectAnnBlock)(void);

@end
