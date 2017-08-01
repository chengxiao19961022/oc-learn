//
//  wyModel_Park_detail.h
//  WYParking
//
//  Created by glavesoft on 17/3/1.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wyModelJudge : NSObject

//                "content": "其他,车位一般般,车位很好，值得推荐,地理位置方便,很满意，好评!,租主态度很好",
@property (copy , nonatomic) NSString *content;
//                "created_date": "2016-12-22",
@property (copy , nonatomic) NSString *created_date;
//                "logo": "http://pnparkdev.iwocar.com/parking/api/web/images/logo/1484722986364269.jpg",
@property (copy , nonatomic) NSString *logo;
//                "username": "Leon",
@property (copy , nonatomic) NSString *username;
//                "count": "1",
@property (copy , nonatomic) NSString *count;
//                "star": "4",
@property (copy , nonatomic) NSString *star;
//                "avg": "4"
@property (copy , nonatomic) NSString *avg;

@end


@interface wyModelSaleType : NSObject

//"saletimes_id": "3511",
@property (copy , nonatomic) NSString *saletimes_id;
//                          "park_id": "2675",
@property (copy , nonatomic) NSString *park_id;
//                          "price": "2.00",
@property (copy , nonatomic) NSString *price;
//                          "sale_type": "4",
@property (copy , nonatomic) NSString *sale_type;
//                          "is_show": "1",
@property (copy , nonatomic) NSString *is_show;
//                          "sale_type_name": "月租（节假日不租）"
@property (copy , nonatomic) NSString *sale_type_name;

@end


@interface wyMOdelTime : NSObject
//"start_date": "2017-01-01",
@property (copy , nonatomic) NSString *start_date;
//    "start_time": "00:00:00",
@property (copy , nonatomic) NSString *start_time;
//    "end_time": "02:00:00",
@property (copy , nonatomic) NSString *end_time;
//    "spot_num": "5",
@property (copy , nonatomic) NSString *spot_num;
//    "note": "",
@property (copy , nonatomic) NSString *note;
//    "park_id": "2675",
@property (copy , nonatomic) NSString *park_id;
//    "saletimes_id": "3511",
@property (copy , nonatomic) NSString *saletimes_id;
//    "saletype_list": [
//                      {
//                          "saletimes_id": "3511",
//                          "park_id": "2675",
//                          "price": "2.00",
//                          "sale_type": "4",
//                          "is_show": "1",
//                          "sale_type_name": "月租（节假日不租）"
//                      }
//                      ]

@property (strong , nonatomic) NSMutableArray *saletype_list;

@property (assign , nonatomic) BOOL isSelected;

@end

@interface wyModel_Park_detail : NSObject
//"park_title": "想边伯贤边伯贤吧",
@property (copy , nonatomic) NSString *park_title;
@property (copy , nonatomic) NSString *auto_logo;
@property (copy , nonatomic) NSString *brand_logo;
//"is_success": "1",
@property (copy , nonatomic) NSString *is_success;
@property (copy , nonatomic) NSString *sex;
//"is_pass": "1",
@property (copy , nonatomic) NSString *is_pass;
//"pic": "http://pnparkdev.iwocar.com/parking/api/web/images/logo/1485167698530471.jpg",
@property (copy , nonatomic) NSString *pic;
//"park_id": "2675",
@property (copy , nonatomic) NSString *park_id;
//"address": "江苏省常州市钟楼区北港街道星港花苑北区44栋星港花苑小区北区",
@property (copy , nonatomic) NSString *address;
//"park_type": "1",
@property (copy , nonatomic) NSString *park_type;
//"addr_note": "",
@property (copy , nonatomic) NSString *addr_note;
//"username": "Leon",
@property (copy , nonatomic) NSString *username;
//"user_id": "185",
@property (copy , nonatomic) NSString *user_id;
//"logo": "parking/admin/web/brand/m_86_100.imageset/m_86_100.png",
@property (copy , nonatomic) NSString *logo;
//"plate_nu": "苏F88888",
@property (copy , nonatomic) NSString *plate_nu;
//"name": "兰博基尼",
@property (copy , nonatomic) NSString *name;
//"average": "4.0000",
@property (copy , nonatomic) NSString *average;

@property (copy , nonatomic) NSString *lat;

@property (copy , nonatomic) NSString *lnt;

//{
//    "start_date": "2017-01-01",
//    "start_time": "00:00:00",
//    "end_time": "02:00:00",
//    "spot_num": "5",
//    "note": "",
//    "park_id": "2675",
//    "saletimes_id": "3511",
//    "saletype_list": [
//                      {
//                          "saletimes_id": "3511",
//                          "park_id": "2675",
//                          "price": "2.00",
//                          "sale_type": "4",
//                          "is_show": "1",
//                          "sale_type_name": "月租（节假日不租）"
//                      }
//                      ]
//}

@property (strong , nonatomic) NSMutableArray *time_quantum;

//"comment": [
//            {
//                "content": "其他,车位一般般,车位很好，值得推荐,地理位置方便,很满意，好评!,租主态度很好",
//                "created_date": "2016-12-22",
//                "logo": "http://pnparkdev.iwocar.com/parking/api/web/images/logo/1484722986364269.jpg",
//                "username": "Leon",
//                "count": "1",
//                "star": "4",
//                "avg": "4"
//            }
//            ]

@property (strong , nonatomic) NSMutableArray *comment;



@end
