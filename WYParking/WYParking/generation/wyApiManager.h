//
//  wyApiManager.h
//  TheGenericVersion
//
//  Created by Leon on 16/12/20.
//  Copyright © 2016年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^wySendSuccess)(id obj);
typedef void(^wySendError)(NSError *error);

@interface wyApiManager : NSObject

+ (void)sendApi:(NSString *)api parameters:(NSDictionary *)dict success:(wySendSuccess)blockSuccess failuer:(wySendError)blockError;

@end
