//
//  EditPopView.h
//  TheGenericVersion
//
//  Created by liuqiang on 16/5/27.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^resultBlock)(NSArray *dic);

@interface EditPopView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * monthArr;
    NSMutableArray * dayArr;
}
-(instancetype)initWithFrame:(CGRect)frame parkID:(NSString*)parkIdStr parkType:(NSString *)parkType saltimes_id:(NSString *)saletimes_id;
@property (nonatomic) int year;
@property (nonatomic) int month;

@property (nonatomic) int num;
@property (weak, nonatomic) UITableView * calendarTableView;

@property(strong,nonatomic)UIButton * submitBtn;


@property (copy, nonatomic) NSString * park_id;

@property (copy , nonatomic) NSString *salttimes_id;//初始化的时候穿的，构造方法

@property (copy , nonatomic) resultBlock block;
@end
