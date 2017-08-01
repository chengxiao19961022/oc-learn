//
//  wyModelPark_map.h
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/10.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wyModelPark_map : NSObject
//address = "\U6c5f\U82cf\U7701\U5e38\U5dde\U5e02\U949f\U697c\U533a\U5317\U6e2f\U8857\U9053\U5e38\U5dde\U6587\U79d1\U878d\U5408\U53d1\U5c55\U4ea7\U4e1a\U56ed";
//building = 12;
//distance = "26.690844230541614";
//lat = "31.808266";
//lnt = "119.894253";

@property (copy , nonatomic) NSString *address;
//
@property (copy , nonatomic) NSString *building;
@property (copy , nonatomic) NSString *lat;
//
@property (copy , nonatomic) NSString *lnt;

@end
