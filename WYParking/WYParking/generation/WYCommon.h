//
//  WYCommon.h
//  WYParking
//
//  Created by Leon on 17/2/6.
//  Copyright © 2017年 Leon. All rights reserved.
//

#ifndef WYCommon_h
#define WYCommon_h


//[KSERVERADDRESS isEqualToString:@"http://pnpark.iwocar.com"]  要全局搜索这个东西  看哪里用到 ， 如果该正式服务器地址
//#define KSERVERADDRESS @"http://pnpark.iwocar.comparking/api/web/index.php/v3/"  //正式服务器 https 如果需要讲http 改为https



/*******正式*******/
//#define KSERVERADDRESS @"http://123.57.74.93/sim_parking/api/web/index.php/v3/"  //正式服务器
//#define apiHosr @"http://123.57.74.93/sim_"//正式分享
#define apiHosr @"http://pnpark.iwocar.com/sim_"//正式分享

#define RELATEADDRESS @"http://123.57.74.93/sim_park3ing/home/web/index.php/about/parklot"//正式关联停车场


/*******测试*******/
//#define KSERVERADDRESS @"http://192.168.101.10/parking/api/web/index.php/v3/"  //本地服务器

#define KSERVERADDRESS @"http://101.200.122.47/parking3/api/web/index.php/v3/" //测试服务器
//#define apiHosr @"http://pnparkdev.iwocar.com/"//测试分享
//#define RELATEADDRESS @"http://pnparkdev.iwocar.com/parking/home/web/index.php/about/parklot"//测试关联停车场


//#define KSERVERADDRESS @"http://pnparkdev.iwocar.com/parking/api/web/index.php/v3/" //测试服务器 https 如果需要讲http 改为https https


/**推广得股权**/
#define AGREEMENTADDRESS @"http://101.200.122.47/parking/home/web/index.php/share/promotion"

#define KappDelegate (AppDelegate*)[[UIApplication sharedApplication]delegate]

#define RGBACOLOR(r,g,b,a)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]/// rgb颜色转换（16进制->10进制）

#define kNavigationBarBackGroundColor  RGBACOLOR(28, 60, 158, 1)
#define kColor RGBACOLOR(1, 107, 201, 1)

#define SCREEN_SCALE        ([UIScreen mainScreen].scale)
#define ONE_PIXEL           (1.0f/SCREEN_SCALE)

#define KPlaceHolderImg [UIImage imageNamed:@"tx.png"]
#define KscreenWidth [UIScreen mainScreen].bounds.size.width
#define kErrorBackGroundColor  RGBACOLOR(225, 111, 52, 1)


#define kJinXingZhongColor RGBACOLOR(2, 227, 87, 1)
#define kYiQueRenColor RGBACOLOR(2, 227, 87, 1)
#define kDaiFuKuanColor RGBACOLOR(255, 45, 59, 1)
#define kDaiQueRenColor RGBACOLOR(248, 194, 69, 1)
#define kDaiPingJiaColor RGBACOLOR(248, 194, 69, 1)
#define kYiQuXiaoColor RGBACOLOR(135, 135, 134, 1)
#define kYiJuJueColor RGBACOLOR(135, 135, 134, 1)
#define kYiWanChengColor RGBACOLOR(90, 129, 212, 1)


#define UNREADMESSAGE @"unReadMessage"

#define WYHomeVCNeedReFresh @"WYHomeVCNeedReFresh"
#define WYCheWeiNeedRefresh @"WYCheWeiNeedRefresh"
#define WYHasNewXiTongXiaoXi @"WYHasNewXiTongXiaoXi"





#endif /* WYCommon_h */
//测试服务器后台管理：http://101.200.122.47/parking3/home/web/index.php
//
//账号&密码：admin
//
//本地服务器后台管理：http://192.168.101.10/parking/home/web/index.php/parklot/index
//
//账号&密码：admin
