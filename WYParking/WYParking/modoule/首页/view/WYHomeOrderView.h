//
//  WYHomeOrderView.h
//  WYParking
//
//  Created by glavesoft on 17/2/9.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^orderBlock)(id model);

@interface WYHomeOrderView : UIView

@property (copy , nonatomic) orderBlock block;

- (void)fetchData;

@end
