//
//  wyApiManager.m
//  TheGenericVersion
//
//  Created by Leon on 16/12/20.
//  Copyright © 2016年 Leon. All rights reserved.
//

#import "wyApiManager.h"


@implementation wyApiManager

+ (void)sendApi:(NSString *)api parameters:(NSDictionary *)dict success:(wySendSuccess)blockSuccess failuer:(wySendError)blockError{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 8.0f;
    [manager POST:api parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (blockSuccess) {
            blockSuccess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (blockError) {
            blockError(error);
        }
    }];
    
    
}

@end
