//
//  WYModelGuanLianCheWei.h
//  WYParking
//
//  Created by glavesoft on 17/3/11.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYModelGuanLianCheWei : NSObject
//"parklot_id": "83",
@property (copy , nonatomic) NSString *parklot_id;
//"building": "李兵",
@property (copy , nonatomic) NSString *building;
//"address": "江苏省常州市新北区薛家镇河海西路522号",
@property (copy , nonatomic) NSString *address;
//"lat": "31.848492",
@property (copy , nonatomic) NSString *lat;
//"lnt": "119.900431",
@property (copy , nonatomic) NSString *lnt;
//"distance": "0",
@property (copy , nonatomic) NSString *distance;
//"logo": "http://pnparkdev.iwocar.com/parking/api/web/images/logo/1484722986364269.jpg",
@property (copy , nonatomic) NSString *logo;
//"is_ed": "0"
@property (copy , nonatomic) NSString *is_ed;

@end
