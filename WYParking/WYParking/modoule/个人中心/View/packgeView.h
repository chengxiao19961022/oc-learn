//
//  MyPackgeView.h
//  WYParking
//
//  Created by admin on 17/2/17.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface packgeView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *BgImgView;
@property (weak, nonatomic) IBOutlet UIButton *btnChongZhi;
@property (weak, nonatomic) IBOutlet UIButton *btnTiXian;
@property (weak, nonatomic) IBOutlet UIButton *btnMingXi;

@property (weak, nonatomic) IBOutlet UIButton *bangZfbBtn;//绑定支付宝


@property (weak, nonatomic) IBOutlet UILabel *balanceLab;



@end
