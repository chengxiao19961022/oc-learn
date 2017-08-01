//
//  WYRiZuVC.h
//  WYParking
//
//  Created by glavesoft on 17/3/9.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^resultBlock)(NSArray *dic);

@interface WYRiZuVC : UIViewController



@property (copy , nonatomic) resultBlock RiZublock;

-(void)initWithparkID:(NSString*)parkIdStr parkType:(NSString *)parkType saltimes_id:(NSString *)saletimes_id;

@end
