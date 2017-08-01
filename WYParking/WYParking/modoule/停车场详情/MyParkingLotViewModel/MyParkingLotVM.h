//
//  MyParkingLotVM.h
//  CocoaPodsTestDemo
//
//  Created by lijie on 2017/2/16.
//  Copyright © 2017年 Lijie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^callback) (NSArray *array);

@interface MyParkingLotVM : NSObject

- (void)sendMyStaffRequestWithsendMyStaffRequestWithparkLotId:(NSString *)parklot_id Callback:(callback)callback;

- (void)sendRelationLotRequestWithParkLotid:(NSString *)parklot_id lat:(NSString *)lat lnt:(NSString *)lnt Callback:(callback)callback;

- (void)sendGoOutVoucherRequestWithParkLot_id:(NSString *)parklot_id Callback:(callback)callback;



@end
