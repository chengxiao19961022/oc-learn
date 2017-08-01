//
//  wyUserAnnotation.h
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/10.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "wyModelPark_map.h"
#import <MAMapKit/MAMapKit.h>


@interface wyUserAnnotation : NSObject  <MAAnnotation>

@property (strong , nonatomic) wyModelPark_map *model;

@property (assign , nonatomic) CLLocationCoordinate2D coordinate;

@end
