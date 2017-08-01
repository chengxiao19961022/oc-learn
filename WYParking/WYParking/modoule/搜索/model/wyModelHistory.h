//
//  wyModelHistory.h
//  WYParking
//
//  Created by glavesoft on 17/3/8.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wyModelHistory : NSObject

//"id": "9",
//@property (copy , nonatomic) NSString *;
//"user_id": "367",
@property (copy , nonatomic) NSString *user_id;
//"address": "江苏省常州市钟楼区北港街道常州文科融合发展产业园",
@property (copy , nonatomic) NSString *address;
//"lnt": "119.894332",
@property (copy , nonatomic) NSString *lnt;
//"lat": "31.808331",
@property (copy , nonatomic) NSString *lat;
//"created_at": "1488934041",
@property (copy , nonatomic) NSString *created_at;
//"updated_at": "1488934041",
@property (copy , nonatomic) NSString *updated_at;
//"is_del": "0"
@property (copy , nonatomic) NSString *is_del;

@end
