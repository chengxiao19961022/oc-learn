//
//  WYModelPush.h
//  WYParking
//
//  Created by glavesoft on 17/2/26.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wyModelTypePrice : NSObject

//\"sale_type\":\"5\",\"is_show\":\"1\",\"price\":\"100\"
@property (copy , nonatomic) NSString *sale_type;
@property (copy , nonatomic) NSString *is_show;
@property (copy , nonatomic) NSString *price;
//"saletimes_id": "2878",
@property (copy , nonatomic) NSString *saletimes_id;
//"park_id": "2306",
@property (copy , nonatomic) NSString *park_id;
// "sale_type_name": "月租（节假日不租）"
@property (copy , nonatomic) NSString *sale_type_name;
@end

@interface wyModelSaletimes : NSObject

@property (assign , nonatomic) BOOL isEdit;//yes 就是修改，no 就是发布车位
@property (assign , nonatomic) NSInteger index;//修改车位的时候传进来的index

//{
//    "saletimes_id":"3555 ",
@property (copy , nonatomic) NSString *saletimes_id;
//    "start_date":"2017-05-14",
@property (copy , nonatomic) NSString *start_date;
//    "start_time":"01:00:00",
@property (copy , nonatomic) NSString *start_time;
//    "end_time":"06:00:00",
@property (copy , nonatomic) NSString *end_time;
//    "json_saletype":"[
//    {\"sale_type\":\"5\",\"is_show\":\"1\",\"price\":\"100\"},]","note":"1","spot_num":"8"},
@property (strong , nonatomic) NSMutableArray *json_saletype;
@property (copy , nonatomic) NSString *note;
@property (copy , nonatomic) NSString *spot_num;

//    ]
//    ｝




@end


@interface WYModelPush : NSObject

//token	是	string	用户凭证
@property (copy , nonatomic) NSString *token;
//pic	是	string	车位图片
@property (copy , nonatomic) NSString *pic;
//park_title	是	int	车位标题
@property (copy , nonatomic) NSString *park_title;
//address	是	string	车位地址
@property (copy , nonatomic) NSString *address;
//lat	是	string	地址维度
@property (copy , nonatomic) NSString *lat;
//lnt	是	string	地址经度
@property (copy , nonatomic) NSString *lnt;
//addr_note	否	string	地址备注
@property (copy , nonatomic) NSString *addr_note;
//parklot_id	否	int	停车场id
@property (copy , nonatomic) NSString *parklot_id;
//park_type	否	int	类型 1停车场收费 2停车场不收费
@property (copy , nonatomic) NSString *park_type;
//json_saletimes	是	string	出租类型[
@property (strong , nonatomic) NSMutableArray *json_saletimes;

//@property (strong , nonatomic) NSString *;

@end
