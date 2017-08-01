//
//  WYCommitOrder.h
//  WYParking
//
//  Created by glavesoft on 17/2/22.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYViewController.h"
@class wyModel_Park_detail;
@class wyMOdelTime;

@interface WYCommitOrder : WYViewController



- (void)renderViewWithParkDetailModel:(wyModel_Park_detail *)model andtimeTypeModel:(wyMOdelTime *)typeModel withType:(NSString *)type;

@end
