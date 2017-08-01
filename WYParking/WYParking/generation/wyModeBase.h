//
//  wyModeBase.h
//  WYParking
//
//  Created by Leon on 17/2/6.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wyModeBase : NSObject<NSCoding>

- (NSData*)archiveToData2;

+ (instancetype)unArchiveWithData:(NSData *)data;
@end
