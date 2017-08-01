//
//  WMEditPopView.h
//  TheGenericVersion
//
//  Created by Glavesoft on 16/8/3.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMEditPopView : UIView<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray * monthArr;
    NSMutableArray * monthArr2;
    NSMutableArray * dayArr;

    
}
-(instancetype)initWithFrame:(CGRect)frame parkID:(NSString*)parkIdStr parkType:(NSString*)parkType saleTimesid:(NSString *)saletimes_id;
@property (nonatomic) int year;
@property (nonatomic) int month;

@property (nonatomic) int num;
@property (weak, nonatomic) UITableView * calendarTableView;
@property(strong,nonatomic)UIButton * submitBtn;
@property(strong,nonatomic)    NSMutableArray *calEditArrWM;


//@property(strong,nonatomic)UIView * clickView;

@property (copy, nonatomic) NSString * park_id;

@property (copy, nonatomic) NSString * park_type;

@property (nonatomic, copy) void(^wmJumpBlock)(NSString *wmInfo,NSString *endDate);


@end
