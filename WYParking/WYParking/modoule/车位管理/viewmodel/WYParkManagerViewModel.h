//
//  WYParkManagerViewModel.h
//  WYParking
//
//  Created by glavesoft on 17/3/11.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^complete) (BOOL flag,NSString *msg);

@interface WYParkManagerViewModel : NSObject

//token	是	string	用户凭证
//pic	是	string	车位图片
//park_title	是	int	车位标题
//address	是	string	车位地址
//lat	是	string	地址维度
//lnt	是	string	地址经度
//addr_note		string	地址备注
//parklot_id		int	停车场id
//park_type		int	类型 1停车场收费 2停车场不收费
//json_saletimes	是	string

- (void)releaseParkWithToken:(NSString *)token pic:(NSString *)pic park_title:(NSString *)park_title address:(NSString *)address lat:(NSString *)lat lnt:(NSString *)lnt addr_note:(NSString *)addr_note parklot_id:(NSString *)parklot_id park_type:(NSString *)park_type json_saletimes:(NSString *)json_saletimes park_id:(NSString *)park_id success:(complete)successBlock;

@end
