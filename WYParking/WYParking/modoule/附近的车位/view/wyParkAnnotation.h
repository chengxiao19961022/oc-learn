//
//  wyParkAnnotation.h
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/10.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

#import "wyParkCallOutView.h"
@class wyModelPark_map;

//大头针，停车场的 不是车位的大头针
@interface wyParkAnnotation : MAAnnotationView

@property (weak , nonatomic , readwrite) wyParkCallOutView *callOutView;

@property (strong , nonatomic) wyModelPark_map *park_model; //required

@end
