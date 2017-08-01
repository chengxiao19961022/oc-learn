//
//  wyBasicInfoVC.h
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/6.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYModelPush.h"
#import "WYViewController.h"


@interface wyBasicInfoVC : WYViewController


- (void)renderWithIFFix:(BOOL)flag park_id:(NSString *)park_id;

@property (strong , nonatomic) WYModelPush *push;

@end
