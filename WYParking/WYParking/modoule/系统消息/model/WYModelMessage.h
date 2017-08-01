//
//  WYModelMessage.h
//  WYParking
//
//  Created by glavesoft on 17/3/6.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYModelMessage : NSObject

//"smsg_id": "138842",
@property (copy , nonatomic) NSString *smsg_id;
//"content": "提现日到了，您今天可以在“我的钱包”中申请提现了",
@property (copy , nonatomic) NSString *content;
//"is_read": "1",
@property (copy , nonatomic) NSString *is_read;

@property (copy , nonatomic) NSString *is_deal;

//"order_id": "3815",
@property(copy,nonatomic)NSString *order_id;

//"add_time": "2017-03-01",
@property (copy , nonatomic) NSString *add_time;

//"type": "1"  type是1 表示订单，有订单id;type是2 表示关注、福利等，无订单id
@property (copy , nonatomic) NSString *type;
//"user_id": "324",
@property (copy , nonatomic) NSString *user_id;
//"logo": "http://pnparkdev.iwocar.com/parking/api/web/images/logo/1484722986364269.jpg",
@property (copy , nonatomic) NSString *logo;
//"username": "Leon",
@property (copy , nonatomic) NSString *username;
@end
