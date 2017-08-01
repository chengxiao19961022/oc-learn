//
//  wyModelActivity.h
//  WYParking
//
//  Created by glavesoft on 17/2/27.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wyModelActivity : NSObject

//"topic_id": "38",
//"pic": "http://101.200.122.47/parking/home/web/uploads/imgs/1490063944.jpg",
//"url": "http://localhost/parking/home/web/index.php/zhuanti/detail?id=38"

@property (copy , nonatomic) NSString *topic_id;

@property (copy , nonatomic) NSMutableString *pic;

@property (copy , nonatomic) NSMutableString *pic_new;

@property (copy , nonatomic) NSString *url;

@property (copy , nonatomic) NSString *title;
//副标题
@property (copy , nonatomic) NSString *Description;

@end
