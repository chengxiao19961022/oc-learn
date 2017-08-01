//
//  WYModelLatesActivity.h
//  WYParking
//
//  Created by glavesoft on 17/3/10.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYModelLatesActivity : NSObject
//"id": "3",
@property (copy , nonatomic) NSString *ID;
//"title": "三个人",
@property (copy , nonatomic) NSString *title;
//"sort": 2,
@property (copy , nonatomic) NSString *sort;
//"pic": "http://localhost/parking/home/web/uploads/imgs/1487742511.jpg",
@property (copy , nonatomic) NSString *pic;
//"content": "他们",
@property (copy , nonatomic) NSString *content;
//"url": "",
@property (copy , nonatomic) NSString *url;
//"is_del": 0,
@property (copy , nonatomic) NSString *is_del;
//"created_at": 0,
@property (copy , nonatomic) NSString *created_at;
//"updated_at": 1487742520
@property (copy , nonatomic) NSString *updated_at;
@end
