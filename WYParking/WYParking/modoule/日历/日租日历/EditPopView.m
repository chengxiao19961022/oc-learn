//
//  EditPopView.m
//  TheGenericVersion
//
//  Created by liuqiang on 16/5/27.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "EditPopView.h"
#import "EditCalendarCell.h"
#import "CalendarModel.h"
#import "HYCalendarTool.h"
#import "YTKKeyValueStore.h"

//#define kLabelWidth (kScreenWidth-20)/7
#define kLabelWidth kScreenWidth/7

#define kLabelHeight kLabelWidth + 18
#define KDarkColor [UIColor darkGrayColor].CGColor


@interface EditPopView()
{
    NSMutableArray * dateArr;
    NSIndexPath * _indexPath;
    int tempIndex;
    NSMutableArray *calEditArr;
    NSMutableArray *calEditArr2;
    NSMutableArray * compareArr;
    NSString * jsonstr;
    NSString * strTemp;
    
    int maxIndex;
    int minIndex;
    
    NSString * maxDate;
    NSString * minDate;
    
    NSMutableDictionary * dayInfoDict;

}

@property (nonatomic , copy) NSString *parkType;
@property (weak, nonatomic)  UILabel * monthLab;



@end

@implementation EditPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame parkID:(NSString*)parkIdStr  parkType:(NSString *)parkType saltimes_id:(NSString *)saletimes_id{

    self = [super initWithFrame:frame];
    self.parkType = parkType;
    self.salttimes_id = saletimes_id;
    if (self) {
        
        self.autoresizingMask = 0;
        
        monthArr= [[NSMutableArray alloc]init];
        dayArr = [[NSMutableArray alloc]init];
        dateArr = [[NSMutableArray alloc]init];
        
        calEditArr = [[NSMutableArray alloc]init];
        calEditArr2 = [[NSMutableArray alloc]init];
        compareArr = [[NSMutableArray alloc]init];
        
        dayInfoDict = [[NSMutableDictionary alloc]init];
        
        self.park_id = parkIdStr;
        
        //获取日历信息
        [self getCalInfoWithSaleType:parkType];
        //创建table
        [self createTable];
        
        [self checkState];
        
    }
    return self;
    
}

-(void)createTable
{
    UITableView * calendarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height - 45)];
    _calendarTableView = calendarTableView;
//    _calendarTableView.backgroundColor = RGBACOLOR(212, 213, 214, 1);
//    _calendarTableView.backgroundColor = RGBACOLOR(241, 242, 243, 1);

    _calendarTableView.delegate = self;
    _calendarTableView.dataSource = self;
    _calendarTableView.bounces = NO;
    _calendarTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:_calendarTableView];
    
    
#pragma mark 顶部年、月
    //header视图
    UIView * headerView = [[UIView alloc]init];
//    headerView.backgroundColor = RGBACOLOR(212, 213, 214, 1);
    headerView.backgroundColor = RGBACOLOR(241, 242, 243, 1);

    
    
    
    UILabel * monthLab = [[UILabel alloc]init];
    _monthLab = monthLab;
    _monthLab.frame = CGRectMake(0,10, self.width, 30);

    
    self.year = (int)[HYCalendarTool year:[NSDate date]];
    self.month = (int)[HYCalendarTool month:[NSDate date]];
    
//    [_monthLab setText:[NSString stringWithFormat:@"%d-%d",self.year,self.month]];
    [_monthLab setText:[NSString stringWithFormat:@"%d年%d月",self.year,self.month]];

    _monthLab.textAlignment = NSTextAlignmentCenter;
//    _monthLab.textColor = [UIColor darkGrayColor];
    _monthLab.textColor = RGBACOLOR(30, 62, 159, 1);
    _monthLab.font = [UIFont systemFontOfSize:24];
    [headerView addSubview:_monthLab];
    
    UIButton * leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(45, _monthLab.top-4, 29, 29)];
    [leftBtn setImage:[UIImage imageNamed:@"sz_rlxz"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(lastMonth) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:leftBtn];
    
    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(calendarTableView.width-45 - 29, _monthLab.top-4, 29, 29)];
    [rightBtn setImage:[UIImage imageNamed:@"sz_rlxy"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:rightBtn];
    
    /**
     *  添加左右滑动手势
     */
    UISwipeGestureRecognizer*leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextMonth)];
    UISwipeGestureRecognizer*rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(lastMonth)];
    
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:leftSwipeGestureRecognizer];
    [self addGestureRecognizer:rightSwipeGestureRecognizer];
    
    
//    NSArray * weekLabArr = @[@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat"];
    NSArray * weekLabArr = @[@"      日",@"      一",@"      二",@"      三",@"      四",@"      五",@"      六"];

    for(int i=0;i<7;i++)
    {
//        UILabel * weekLab = [[UILabel alloc]initWithFrame:CGRectMake(10+kLabelWidth*i, _monthLab.bottom+20, kLabelWidth, 21)];
        UILabel * weekLab = [[UILabel alloc]initWithFrame:CGRectMake(kLabelWidth*i, _monthLab.bottom+20, kLabelWidth, 21)];

//        weekLab.textColor = [UIColor whiteColor];
        weekLab.textColor = RGBACOLOR(194, 195, 196, 1);

        weekLab.font = [UIFont systemFontOfSize:13];
        [weekLab setTextAlignment:NSTextAlignmentCenter];
        weekLab.text = [weekLabArr objectAtIndex:i];
        [headerView addSubview:weekLab];
    }
    headerView.height = _monthLab.bottom+45;
    
    calendarTableView.tableHeaderView = headerView;

#pragma mark 日期说明
    //footer视图
    UIView * footerView = [[UIView alloc]init];
//    footerView.backgroundColor = RGBACOLOR(212, 213, 214, 1);
    footerView.backgroundColor = [UIColor whiteColor];

    UILabel*grayLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 7, 10, 10)];
    grayLab.backgroundColor = RGBACOLOR(30, 62, 159, 1);
    grayLab.layer.cornerRadius = grayLab.frame.size.width/2;
    grayLab.layer.masksToBounds = YES;
    [footerView addSubview:grayLab];
    UILabel * grayTitle = [[UILabel alloc]initWithFrame:CGRectMake(grayLab.right, 2, 90, 20)];
    grayTitle.textColor = [UIColor darkGrayColor];
    grayTitle.font = [UIFont systemFontOfSize:13];
//    grayTitle.text = @" 可租出日期";
    grayTitle.text = @"本次选中日期";

    [footerView addSubview:grayTitle];
    
    UILabel*purpleLab = [[UILabel alloc]initWithFrame:CGRectMake(grayTitle.right, 9, 10, 2)];
    purpleLab.backgroundColor = RGBACOLOR(30, 62, 159, 1);
    [footerView addSubview:purpleLab];
    
    UILabel * purpleTitle = [[UILabel alloc]initWithFrame:CGRectMake(purpleLab.right, 2, 125, 20)];
    purpleTitle.textColor = [UIColor darkGrayColor];
    purpleTitle.font = [UIFont systemFontOfSize:13];
    purpleTitle.text = @"您已经租用过的日期";

    [footerView addSubview:purpleTitle];
    
    UILabel*blueLab = [[UILabel alloc]initWithFrame:CGRectMake(purpleTitle.right, 7, 10, 10)];
    blueLab.backgroundColor = RGBACOLOR(228, 229, 230, 1);
    blueLab.layer.cornerRadius = blueLab.frame.size.width/2;
    blueLab.layer.masksToBounds = YES;
    [footerView addSubview:blueLab];
    UILabel * blueTitle = [[UILabel alloc]initWithFrame:CGRectMake(blueLab.right, 2, 80, 20)];
    blueTitle.textColor = [UIColor darkGrayColor];
    blueTitle.font = [UIFont systemFontOfSize:13];
    blueTitle.text = @"不可用日期";
    [footerView addSubview:blueTitle];
    
//    UILabel*blueLab2 = [[UILabel alloc]initWithFrame:CGRectMake(blueTitle.right - 30, blueTitle.centerY, 10, 1)];
//    blueLab2.backgroundColor = RGBACOLOR(112, 212, 246, 1);
//    [footerView addSubview:blueLab2];
//    UILabel * blueTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(blueLab2.right , 2, 80, 20)];
//    blueTitle2.textColor = [UIColor darkGrayColor];
//    blueTitle2.font = [UIFont systemFontOfSize:13];
//    blueTitle2.text = @"我已租日期";
//    [footerView addSubview:blueTitle2];
    
    
    
      footerView.height = blueTitle.bottom + 10;
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.height - 45, calendarTableView.width, 45)];
    //    self.submitBtn.enabled = NO;
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.submitBtn.backgroundColor =kNavigationBarBackGroundColor;
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitBtn];
    
  

    
    calendarTableView.tableFooterView = footerView;
    
    
}





-(void)submit
{
    if (calEditArr.count>0) {
        jsonstr = [calEditArr mj_JSONString];
        

        [compareArr removeAllObjects];
        for (int i=0; i<calEditArr.count; i++) {
            NSArray *array = [calEditArr[i] componentsSeparatedByString:@"-"];
            NSString * yearT = array[0];
            NSString * monthT = array[1];
            NSString * dayT = array[2];
            if (monthT.length == 1) {
                monthT = [@"0" stringByAppendingString:monthT];
            }
            if (dayT.length == 1) {
                dayT = [@"0" stringByAppendingString:dayT];
            }

            NSString * date = [NSString stringWithFormat:@"%@%@%@",yearT,monthT,dayT];
            [compareArr addObject:date];
        }
        NSString * maxDateStr = [NSString stringWithFormat:@"%@",[compareArr valueForKeyPath:@"@max.intValue"]];
        NSString * minDateStr = [NSString stringWithFormat:@"%@",[compareArr valueForKeyPath:@"@min.intValue"]];

        for (int i = 0; i<calEditArr.count; i++) {
            NSArray *array = [calEditArr[i] componentsSeparatedByString:@"-"];
            NSString * yearT = array[0];
            NSString * monthT = array[1];
            NSString * dayT = array[2];
            if (monthT.length == 1) {
                monthT = [@"0" stringByAppendingString:monthT];
            }
            if (dayT.length == 1) {
                dayT = [@"0" stringByAppendingString:dayT];
            }
            
            NSString * date = [NSString stringWithFormat:@"%@%@%@",yearT,monthT,dayT];
            if ([date isEqualToString:maxDateStr]) {
                maxIndex = i;
            }
            if ([date isEqualToString:minDateStr]) {
                minIndex = i;
            }
        }
        
         //最大最小日期已获取
        maxDate = calEditArr[maxIndex];
        minDate = calEditArr[minIndex];
        
        [dayInfoDict setObject:maxDate forKey:@"end_date"];
        [dayInfoDict setObject:minDate forKey:@"start_date"];
        [dayInfoDict setObject:jsonstr forKey:@"jsonstr"];
        [dayInfoDict setObject:self.parkType forKey:@"parkType"];
        if (calEditArr.count > 0) {
            [dayInfoDict setObject:[NSString stringWithFormat:@"%d",calEditArr.count] forKey:@"totalCount"];
        }
        
        
        [self delCalDB];
        if (self.block) {
            self.block(calEditArr);
        }
        [calEditArr removeAllObjects];
        
//        [UIView animateWithDuration:0.3 animations:^{
//            [self removeFromSuperview];
//        
//        } completion:^(BOOL finished) {
//            
//            
//////            
//////            MMDrawerController * mmv = (MMDrawerController*)[Utils getCurrentVC];
//////            UINavigationController* navc = (UINavigationController*)mmv.centerViewController;
//////            NSLog(@"%@",navc);
////            if ([navc.topViewController isKindOfClass:[PushOrderController class]]) {
////                self.dayJumpBlock(dayInfoDict);
////            }else{
////                //创建通知
////                NSNotification *notification =[NSNotification notificationWithName:@"dayJump" object:nil userInfo:dayInfoDict];
////                //通过通知中心发送通知
////                [[NSNotificationCenter defaultCenter] postNotification:notification];
//
////            }
//        }];
//        
//
        

       
        
        
    }else
    {
        [self makeToast:@"请选择所要操作的日期"];
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.num;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kLabelHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditCalendarCell *cell = [[EditCalendarCell alloc]init];
    
    if (dayArr.count == 0) {
        return cell;
    }
    
    [dateArr removeAllObjects];
    int i = (int)indexPath.row;
    dateArr = dayArr[i];
    //mj字典转模型
    dateArr = [CalendarModel mj_objectArrayWithKeyValuesArray:dateArr];
    
    CalendarModel *model1=dateArr[0];
    CalendarModel *model2=dateArr[1];
    CalendarModel *model3=dateArr[2];
    CalendarModel *model4=dateArr[3];
    CalendarModel *model5=dateArr[4];
    CalendarModel *model6=dateArr[5];
    CalendarModel *model7=dateArr[6];
    

    cell.labLeft1.text = [NSString stringWithFormat:@"余:%@",model1.can_sale_num];
    

    cell.labLeft2.text = [NSString stringWithFormat:@"余:%@",model2.can_sale_num];
    
    cell.labLeft3.text = [NSString stringWithFormat:@"余:%@",model3.can_sale_num];

    
    cell.labLeft4.text = [NSString stringWithFormat:@"余:%@",model4.can_sale_num];
    

    cell.labLeft5.text = [NSString stringWithFormat:@"余:%@",model5.can_sale_num];
    

    cell.labLeft6.text = [NSString stringWithFormat:@"余:%@",model6.can_sale_num];


    cell.labLeft7.text = [NSString stringWithFormat:@"余:%@",model7.can_sale_num];
    
    if ([model1.can_sale_num isEqualToString:@"0"]) {
        cell.labLeft1.hidden = YES;
    }else{
        cell.labLeft1.hidden = NO;
    }
    
    if ([model2.can_sale_num isEqualToString:@"0"]) {
        cell.labLeft2.hidden = YES;
    }else{
        cell.labLeft2.hidden = NO;
    }
    
    if ([model3.can_sale_num isEqualToString:@"0"]) {
        cell.labLeft3.hidden = YES;
    }else{
        cell.labLeft3.hidden = NO;
    }
    
    if ([model4.can_sale_num isEqualToString:@"0"]) {
        cell.labLeft4.hidden = YES;
    }else{
        cell.labLeft4.hidden = NO;
    }
    
    if ([model5.can_sale_num isEqualToString:@"0"]) {
        cell.labLeft5.hidden = YES;
    }else{
        cell.labLeft5.hidden = NO;
    }
    
    if ([model6.can_sale_num isEqualToString:@"0"]) {
        cell.labLeft6.hidden = YES;
    }else{
        cell.labLeft6.hidden = NO;
    }
    
    if ([model7.can_sale_num isEqualToString:@"0"]) {
        cell.labLeft7.hidden = YES;
    }else{
        cell.labLeft7.hidden = NO;
    }

    
    /**
     *  周一
     */
    //赋值
    NSString * text1 = [NSString stringWithFormat:@"%@", model1.day];
    [cell.btn1 setTitle:text1 forState:UIControlStateNormal];
    
    
    //判断状态
#pragma mark 租用过的日期
    if ([model1.is_me isEqual:@"1"]) {
        if ([model1.is_buy boolValue]) {
//            [cell.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.bgView1.backgroundColor = RGBACOLOR(228, 229, 230, 1);

            //            cell.btn1.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn1.layer.borderWidth = 1;
        }else{
            [cell.btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn1.layer.borderColor = KDarkColor;
//            cell.btn1.layer.borderWidth = 1;
        }
        
        cell.lineView1.hidden = NO;

    }else{
        if ([model1.is_buy isEqual:@"1"]) {
//            [cell.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.bgView1.backgroundColor = RGBACOLOR(228, 229, 230, 1);

//            cell.btn1.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn1.layer.borderWidth = 1;
            
        }
        else{
            [cell.btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn1.layer.borderColor = KDarkColor;
//            cell.btn1.layer.borderWidth = 1;
        }
    }
//    //判断是否处于当前月份，不是当前月的隐藏禁用
//    if (![model1.month isEqualToString:[NSString stringWithFormat:@"%d",self.month]]) {
//        [cell.btn1 setTitle:@"" forState:UIControlStateNormal];
//        cell.btn1.enabled = NO;
//        cell.btn1.hidden = YES;
//        cell.bgView1.backgroundColor = [UIColor whiteColor];
//        cell.labLeft1.hidden = YES;
//        [cell.centerbg1 removeFromSuperview];
//        [cell.leftbg1 removeFromSuperview];
//        [cell.rightbg1 removeFromSuperview];
//        cell.lineView1.hidden = YES;
//        
//    }
    //日历点击操作状态判断
    if ([model1.is_choose isEqual:@"1"]) {
        cell.btn1.layer.borderColor = [UIColor clearColor].CGColor;
        cell.centerbg1.hidden = NO;
        cell.leftbg1.hidden = NO;
        cell.rightbg1.hidden = NO;
        
    }
#pragma mark 当天之前的字体颜色
    if ([model1.is_weekend isEqual:@"1"]||[model1.is_holiday isEqual:@"1"]) {
        cell.labLeft1.hidden = YES;
//        [cell.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.bgView1.backgroundColor = RGBACOLOR(228, 229, 230, 1);


//        cell.btn1.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn1.layer.borderWidth = 1;
    }
    if (cell.labLeft1.hidden) {
//        [cell.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn1.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn1.layer.borderWidth = 1;
        
        cell.bgView1.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    
    //判断是否处于当前月份，不是当前月的隐藏禁用
    if (![model1.month isEqualToString:[NSString stringWithFormat:@"%d",self.month]]) {
        [cell.btn1 setTitle:@"" forState:UIControlStateNormal];
        cell.btn1.enabled = NO;
        cell.btn1.hidden = YES;
        cell.labLeft1.hidden = YES;
        [cell.centerbg1 removeFromSuperview];
        [cell.leftbg1 removeFromSuperview];
        [cell.rightbg1 removeFromSuperview];
        cell.lineView1.hidden = YES;
        
        cell.bgView1.backgroundColor = [UIColor whiteColor];

        
    }
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PressToDo:)];
    [cell.btn1 addGestureRecognizer:singleTap];
    
    
    /**
     *  周二
     */
    NSString * text2 = [NSString stringWithFormat:@"%@", model2.day];
    [cell.btn2 setTitle:text2 forState:UIControlStateNormal];
    if ([model2.is_me isEqual:@"1"]) {
        if ([model2.is_buy boolValue]) {
//            [cell.btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            cell.btn2.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn2.layer.borderWidth = 1;
            cell.bgView2.backgroundColor = RGBACOLOR(228, 229, 230, 1);

        }else{
            [cell.btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn2.layer.borderColor = KDarkColor;
//            cell.btn2.layer.borderWidth = 1;
        }
       
        cell.lineView2.hidden = NO;
    }else{
        if ([model2.is_buy isEqual:@"1"]) {
//            [cell.btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            cell.btn2.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn2.layer.borderWidth = 1;
            cell.bgView2.backgroundColor = RGBACOLOR(228, 229, 230, 1);

        }
        else{
            [cell.btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn2.layer.borderColor = KDarkColor;
//            cell.btn2.layer.borderWidth = 1;
        }
    }
 
    if ([model2.is_choose isEqual:@"1"]) {
        cell.centerbg2.hidden = NO;
        cell.leftbg2.hidden = NO;
        cell.rightbg2.hidden = NO;
        
        cell.btn2.layer.borderColor = [UIColor clearColor].CGColor;
        
        
    }
    if ([model2.is_weekend isEqual:@"1"]||[model2.is_holiday isEqual:@"1"]) {
        cell.labLeft2.hidden = YES;
//        [cell.btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn2.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn2.layer.borderWidth = 1;
        
        cell.bgView2.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    
    if (cell.labLeft2.hidden) {
//        [cell.btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn2.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn2.layer.borderWidth = 1;
        
        cell.bgView2.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    if (![model2.month isEqualToString:[NSString stringWithFormat:@"%d",self.month]]) {
        cell.labLeft2.hidden = YES;
        [cell.btn2 setTitle:@"" forState:UIControlStateNormal];
        cell.btn2.enabled = NO;
        cell.btn2.hidden = YES;
        [cell.centerbg2 removeFromSuperview];
        [cell.leftbg2 removeFromSuperview];
        [cell.rightbg2 removeFromSuperview];
        cell.lineView2.hidden = YES;
        cell.bgView2.backgroundColor = [UIColor whiteColor];

    }
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PressToDo:)];
    [cell.btn2 addGestureRecognizer:singleTap2];
    
    /**
     *  周三
     */
    NSString * text3 = [NSString stringWithFormat:@"%@", model3.day];
    [cell.btn3 setTitle:text3 forState:UIControlStateNormal];
    if ([model3.is_me isEqual:@"1"]) {
        if ([model3.is_buy boolValue]) {
//            [cell.btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            cell.btn3.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn3.layer.borderWidth = 1;
            cell.bgView3.backgroundColor = RGBACOLOR(228, 229, 230, 1);

        }else{
            [cell.btn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn3.layer.borderColor = KDarkColor;
//            cell.btn3.layer.borderWidth = 1;

        }
        
        cell.lineView3.hidden = NO;

    }else{
        if ([model3.is_buy isEqual:@"1"]) {
//            [cell.btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            cell.btn3.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn3.layer.borderWidth = 1;
            cell.bgView3.backgroundColor = RGBACOLOR(228, 229, 230, 1);

        }
        else{
            [cell.btn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn3.layer.borderColor = KDarkColor;
//            cell.btn3.layer.borderWidth = 1;
            
        }
    }
 
    if ([model3.is_choose isEqual:@"1"]) {
        cell.centerbg3.hidden = NO;
        cell.leftbg3.hidden = NO;
        cell.rightbg3.hidden = NO;
        
        cell.btn3.layer.borderColor = [UIColor clearColor].CGColor;
        
    }
    if ([model3.is_weekend isEqual:@"1"]||[model3.is_holiday isEqual:@"1"]) {
        cell.labLeft3.hidden = YES;
        cell.labLeft3.hidden = YES;
//        [cell.btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn3.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn3.layer.borderWidth = 1;
        
        cell.bgView3.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    if (cell.labLeft3.hidden) {
//        [cell.btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn3.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn3.layer.borderWidth = 1;
        cell.bgView3.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    if (![model3.month isEqualToString:[NSString stringWithFormat:@"%d",self.month]]) {
        cell.labLeft3.hidden = YES;
        [cell.btn3 setTitle:@"" forState:UIControlStateNormal];
        cell.btn3.enabled = NO;
        cell.btn3.hidden = YES;
        [cell.centerbg3 removeFromSuperview];
        [cell.leftbg3 removeFromSuperview];
        [cell.rightbg3 removeFromSuperview];
        cell.lineView3.hidden = YES;
        cell.bgView3.backgroundColor = [UIColor whiteColor];

    }
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PressToDo:)];
    [cell.btn3 addGestureRecognizer:singleTap3];
    
    /**
     *  周四
     */
    NSString * text4 = [NSString stringWithFormat:@"%@", model4.day];
    [cell.btn4 setTitle:text4 forState:UIControlStateNormal];
    if ([model4.is_me isEqual:@"1"]) {
        if ([model4.is_buy isEqual:@"1"]) {
//            [cell.btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            cell.btn4.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn4.layer.borderWidth = 1;
            cell.bgView4.backgroundColor = RGBACOLOR(228, 229, 230, 1);

            
        }else{
            [cell.btn4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn4.layer.borderColor = KDarkColor;
//            cell.btn4.layer.borderWidth = 1;
        }
        cell.lineView4.hidden = NO;

    }else{
        if ([model4.is_buy isEqual:@"1"]) {
//            [cell.btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            cell.btn4.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn4.layer.borderWidth = 1;
            cell.bgView4.backgroundColor = RGBACOLOR(228, 229, 230, 1);

            
        }else{
            [cell.btn4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn4.layer.borderColor = KDarkColor;
//            cell.btn4.layer.borderWidth = 1;
        }
    }
  
    if ([model4.is_choose isEqual:@"1"]) {
        cell.centerbg4.hidden = NO;
        cell.leftbg4.hidden = NO;
        cell.rightbg4.hidden = NO;
        
        cell.btn4.layer.borderColor = [UIColor clearColor].CGColor;
        
    }
    if ([model4.is_weekend isEqual:@"1"]||[model4.is_holiday isEqual:@"1"]) {
        cell.labLeft4.hidden = YES;
//        [cell.btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn4.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn4.layer.borderWidth = 1;
        cell.bgView4.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    if (cell.labLeft4.hidden) {
//        [cell.btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn4.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn4.layer.borderWidth = 1;
        cell.bgView4.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    if (![model4.month isEqualToString:[NSString stringWithFormat:@"%d",self.month]]) {
        cell.labLeft4.hidden = YES;
        [cell.btn4 setTitle:@"" forState:UIControlStateNormal];
        cell.btn4.enabled = NO;
        cell.btn4.hidden = YES;
        [cell.centerbg4 removeFromSuperview];
        [cell.leftbg4 removeFromSuperview];
        [cell.rightbg4 removeFromSuperview];
        cell.lineView4.hidden = YES;
        
        cell.bgView4.backgroundColor = [UIColor whiteColor];

    }
    UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PressToDo:)];
    [cell.btn4 addGestureRecognizer:singleTap4];
    
    /**
     *  周五
     */
    NSString * text5 = [NSString stringWithFormat:@"%@", model5.day];
    [cell.btn5 setTitle:text5 forState:UIControlStateNormal];
    if ([model5.is_me isEqual:@"1"]) {
        if ([model5.is_buy isEqual:@"1"]) {
//            [cell.btn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            cell.btn5.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn5.layer.borderWidth = 1;
            cell.bgView5.backgroundColor = RGBACOLOR(228, 229, 230, 1);

        }else{
            [cell.btn5 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn5.layer.borderColor = KDarkColor;
//            cell.btn5.layer.borderWidth = 1;
        }

        cell.lineView5.hidden = NO;

    }else{
        if ([model5.is_buy isEqual:@"1"]) {
//            [cell.btn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            cell.btn5.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn5.layer.borderWidth = 1;
            cell.bgView5.backgroundColor = RGBACOLOR(228, 229, 230, 1);

        }else{
            [cell.btn5 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn5.layer.borderColor = KDarkColor;
//            cell.btn5.layer.borderWidth = 1;
        }
    }
    if (![model5.month isEqualToString:[NSString stringWithFormat:@"%d",self.month]]) {
        cell.labLeft5.hidden = YES;
        [cell.btn5 setTitle:@"" forState:UIControlStateNormal];
        cell.btn5.enabled = NO;
        cell.btn5.hidden = YES;
        [cell.centerbg5 removeFromSuperview];
        [cell.leftbg5 removeFromSuperview];
        [cell.rightbg5 removeFromSuperview];
        cell.lineView5.hidden = YES;
    }
    
    if ([model5.is_choose isEqual:@"1"]) {
        cell.centerbg5.hidden = NO;
        cell.leftbg5.hidden = NO;
        cell.rightbg5.hidden = NO;
        
        cell.btn5.layer.borderColor = [UIColor clearColor].CGColor;
        
    }
    if ([model5.is_weekend isEqual:@"1"]||[model5.is_holiday isEqual:@"1"]) {
        cell.labLeft5.hidden = YES;
//        [cell.btn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn5.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn5.layer.borderWidth = 1;
        cell.bgView5.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    if (cell.labLeft5.hidden) {
//        [cell.btn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn5.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn5.layer.borderWidth = 1;
        cell.bgView5.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    if (![model5.month isEqualToString:[NSString stringWithFormat:@"%d",self.month]]) {
        cell.labLeft5.hidden = YES;
        [cell.btn5 setTitle:@"" forState:UIControlStateNormal];
        cell.btn5.enabled = NO;
        cell.btn5.hidden = YES;
        [cell.centerbg5 removeFromSuperview];
        [cell.leftbg5 removeFromSuperview];
        [cell.rightbg5 removeFromSuperview];
        cell.lineView5.hidden = YES;
        cell.bgView5.backgroundColor = [UIColor whiteColor];

    }
    
    UITapGestureRecognizer *singleTap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PressToDo:)];
    [cell.btn5 addGestureRecognizer:singleTap5];
    
    /**
     *  周六
     */
    NSString * text6 = [NSString stringWithFormat:@"%@", model6.day];
    [cell.btn6 setTitle:text6 forState:UIControlStateNormal];
    if ([model6.is_me isEqual:@"1"]) {
        if ([model6.is_buy isEqual:@"1"]) {
//            [cell.btn6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            cell.btn6.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn6.layer.borderWidth = 1;
            cell.bgView6.backgroundColor = RGBACOLOR(228, 229, 230, 1);

        }else{
            [cell.btn6 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn6.layer.borderColor = KDarkColor;
//            cell.btn6.layer.borderWidth = 1;
        }

        cell.lineView6.hidden = NO;

    }else{
        if ([model6.is_buy isEqual:@"1"]) {
//            [cell.btn6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            cell.btn6.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn6.layer.borderWidth = 1;
            cell.bgView6.backgroundColor = RGBACOLOR(228, 229, 230, 1);

        }else{
            [cell.btn6 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn6.layer.borderColor = KDarkColor;
//            cell.btn6.layer.borderWidth = 1;
        }
    }
    if (![model6.month isEqualToString:[NSString stringWithFormat:@"%d",self.month]]) {
        cell.labLeft6.hidden = YES;
        [cell.btn6 setTitle:@"" forState:UIControlStateNormal];
        cell.btn6.enabled = NO;
        cell.btn6.hidden = YES;
        [cell.centerbg6 removeFromSuperview];
        [cell.leftbg6 removeFromSuperview];
        [cell.rightbg6 removeFromSuperview];
        cell.lineView6.hidden = YES;
        
    }
    if ([model6.is_choose isEqual:@"1"]) {
        cell.centerbg6.hidden = NO;
        cell.leftbg6.hidden = NO;
        cell.rightbg6.hidden = NO;
        
        cell.btn6.layer.borderColor = [UIColor clearColor].CGColor;
        
    }
    if ([model6.is_weekend isEqual:@"1"]||[model6.is_holiday isEqual:@"1"]) {
        cell.labLeft6.hidden = YES;
//        [cell.btn6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn6.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn6.layer.borderWidth = 1;
        cell.bgView6.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    if (cell.labLeft6.hidden) {
//        [cell.btn6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn6.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn6.layer.borderWidth = 1;
        cell.bgView6.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    
    if (![model6.month isEqualToString:[NSString stringWithFormat:@"%d",self.month]]) {
        cell.labLeft6.hidden = YES;
        [cell.btn6 setTitle:@"" forState:UIControlStateNormal];
        cell.btn6.enabled = NO;
        cell.btn6.hidden = YES;
        [cell.centerbg6 removeFromSuperview];
        [cell.leftbg6 removeFromSuperview];
        [cell.rightbg6 removeFromSuperview];
        cell.lineView6.hidden = YES;
        cell.bgView6.backgroundColor = [UIColor whiteColor];

        
    }
    UITapGestureRecognizer *singleTap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PressToDo:)];
    [cell.btn6 addGestureRecognizer:singleTap6];
    
    /**
     *  周日
     */
    NSString * text7 = [NSString stringWithFormat:@"%@", model7.day];
    [cell.btn7 setTitle:text7 forState:UIControlStateNormal];
    if ([model7.is_me isEqual:@"1"]) {
        if ([model7.is_buy isEqual:@"1"]) {
//            [cell.btn7 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            cell.btn7.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn7.layer.borderWidth = 1;
            cell.bgView7.backgroundColor = RGBACOLOR(228, 229, 230, 1);

        }else{
            [cell.btn7 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn7.layer.borderColor = KDarkColor;
//            cell.btn7.layer.borderWidth = 1;
        }
        cell.lineView7.hidden = NO;

    }else{
        if ([model7.is_buy isEqual:@"1"]) {
            
//            [cell.btn7 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            cell.btn7.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn7.layer.borderWidth = 1;
            cell.bgView7.backgroundColor = RGBACOLOR(228, 229, 230, 1);

        }else{
            [cell.btn7 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn7.layer.borderColor = KDarkColor;
//            cell.btn7.layer.borderWidth = 1;
        }
    }
    if (![model7.month isEqualToString:[NSString stringWithFormat:@"%d",self.month]]) {
        cell.labLeft7.hidden = YES;
        [cell.btn7 setTitle:@"" forState:UIControlStateNormal];
        cell.btn7.enabled = NO;
        cell.btn7.hidden = YES;
        [cell.centerbg7 removeFromSuperview];
        [cell.leftbg7 removeFromSuperview];
        [cell.rightbg7 removeFromSuperview];
        cell.lineView7.hidden = YES;
    }
    if ([model7.is_choose isEqual:@"1"]) {
        cell.centerbg7.hidden = NO;
        cell.leftbg7.hidden = NO;
        cell.rightbg7.hidden = NO;
        
        cell.btn7.layer.borderColor = [UIColor clearColor].CGColor;
        
    }
    if ([model7.is_weekend isEqual:@"1"]||[model7.is_holiday isEqual:@"1"]) {
        cell.labLeft7.hidden = YES;
//        [cell.btn7 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn7.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn7.layer.borderWidth = 1;
        cell.bgView7.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    if (cell.labLeft7.hidden) {
//        [cell.btn7 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn7.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn7.layer.borderWidth = 1;
        cell.bgView7.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    if (![model7.month isEqualToString:[NSString stringWithFormat:@"%d",self.month]]) {
        cell.labLeft7.hidden = YES;
        [cell.btn7 setTitle:@"" forState:UIControlStateNormal];
        cell.btn7.enabled = NO;
        cell.btn7.hidden = YES;
        [cell.centerbg7 removeFromSuperview];
        [cell.leftbg7 removeFromSuperview];
        [cell.rightbg7 removeFromSuperview];
        cell.lineView7.hidden = YES;
        cell.bgView7.backgroundColor = [UIColor whiteColor];

    }
    UITapGestureRecognizer *singleTap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PressToDo:)];
    [cell.btn7 addGestureRecognizer:singleTap7];
    
    cell.backgroundColor = RGBACOLOR(246, 247, 247, 1);

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 *  日历按钮点击操作
 */
-(void)PressToDo:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        //获取当前所在行
        EditCalendarCell *cell = (EditCalendarCell *)[[gesture.view superview] superview];
        _indexPath = [self.calendarTableView indexPathForCell:cell];
        int i = (int)_indexPath.row;
        //获取当前所点击按钮tag值
        int t = (int)gesture.view.tag-1000;
        //当前日期在monthArr中的位置
        tempIndex = i*7+t-1;
        //若当前日期已不可租，做出提示并跳出方法
        NSString * str = [NSString stringWithFormat:@"%@",monthArr[tempIndex][@"is_buy"]];
        NSString * weekend = [NSString stringWithFormat:@"%@",monthArr[tempIndex][@"is_weekend"]];
        NSString * holiday = [NSString stringWithFormat:@"%@",monthArr[tempIndex][@"is_holiday"]];
        if ([str isEqualToString:@"1"]||[weekend isEqualToString:@"1"]||[weekend isEqualToString:@"1"]||[holiday isEqualToString:@"1"]|| gesture.view.layer.borderColor == [UIColor whiteColor].CGColor) {
            [self makeToast:@"当前日期不可操作"];
            return;
        }
        
        /**
         *  根据tag值获取相应的控件
         */
        int centerTag = t+2000;
        int leftTag = t+3000;
        int rightTag = t+4000;
        int btnTag = t+1000;
        int bgViewTag = t + 10000;//每个日期的底视图
        UIImageView * centerImg = [cell viewWithTag:centerTag];
        UIImageView * leftImg = [cell viewWithTag:leftTag];
        UIImageView * rightImg = [cell viewWithTag:rightTag];
        UIButton * btn = [cell viewWithTag:btnTag];
        
        UIView *bgView = [cell viewWithTag:bgViewTag];
       
        centerImg.hidden ?  [self setStatusValue:@"1"]:[self setStatusValue:@"0"];

        
#pragma mark 选择日期的边框
//        if (centerImg.hidden) {
            btn.layer.borderColor = [UIColor clearColor].CGColor;
//        }else
//        {
//            btn.layer.borderColor = KDarkColor;
//        }
        
        
#pragma mark 取消点击可选日期
        if (centerImg.hidden == NO) {
            leftImg.hidden = NO;
            rightImg.hidden = NO;
            int temptag = (int)gesture.view.tag;
//            NSString * tyearMonthStr = _monthLab.text;
            NSString * tyearMonthStr = [NSString stringWithFormat:@"%d-%d",self.year,self.month];

            UIButton * tdayBtn = [cell viewWithTag:temptag];
            NSString * tdayStr = tdayBtn.titleLabel.text;
            
            NSString * dayId = [NSString stringWithFormat:@"%@-%@",tyearMonthStr,tdayStr];
            NSLog(@"%@",dayId);
            
            if ([calEditArr containsObject:dayId]) {
                [calEditArr removeObject:dayId];
            }
            
            
            centerImg.hidden = YES;
            leftImg.hidden = YES;
            rightImg.hidden = YES;
            
            
            bgView.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];


        }else{
#pragma mark 点击可选日期

            int temptag = (int)gesture.view.tag;
//            NSString * tyearMonthStr = _monthLab.text;
            NSString * tyearMonthStr = [NSString stringWithFormat:@"%d-%d",self.year,self.month];
            UIButton * tdayBtn = [cell viewWithTag:temptag];
            NSString * tdayStr = tdayBtn.titleLabel.text;
            
            NSString * dayId = [NSString stringWithFormat:@"%@-%@",tyearMonthStr,tdayStr];
            NSLog(@"%@",dayId);
            
            if (![calEditArr containsObject:dayId]) {
                [calEditArr addObject:dayId];
            }
            
            centerImg.hidden = NO;
            leftImg.hidden = NO;
            rightImg.hidden = NO;
            
            bgView.backgroundColor = RGBACOLOR(30, 69, 159, 1);
            
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

//            leftImg.textColor = RGBACOLOR(201, 202, 203, 1);
        }
            NSLog(@"%d",tempIndex);
            [self checkState];
        }
}

/**
 *  重新赋值 is_choose 字段
 */
-(void)setStatusValue:(NSString*)typeInt
{
    NSMutableDictionary * tempDict = [NSMutableDictionary dictionaryWithDictionary:monthArr[tempIndex]];
    [tempDict setValue:typeInt forKey:@"is_choose"];
    NSMutableArray * temparr = [NSMutableArray arrayWithArray:monthArr];
    [temparr removeObjectAtIndex:tempIndex];
    [temparr insertObject:tempDict atIndex:tempIndex];
    monthArr = [NSMutableArray arrayWithArray:temparr];
}
///**
// *  点击屏幕隐藏日历并删除数据库
// */
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        [self removeFromSuperview];
//        [self delCalDB];
//        [calEditArr removeAllObjects];
//    }];
//}

-(void)lastMonth
{
    int monthIndex = (int)[HYCalendarTool month:[NSDate date]];
    
    if (self.month == monthIndex) {
        [self makeToast:@"请于当前日期起半年内操作"];
        return;
    }

    [self saveCalInfo];
    //上个月
    if (self.month == 1) {
        self.month = 12;
        self.year -= 1;
        [_monthLab setText:[NSString stringWithFormat:@"%d年%d月",self.year,self.month]];
        [self getOldCalInfo];
    }else
    {
        self.month -= 1;
        [_monthLab setText:[NSString stringWithFormat:@"%d年%d月",self.year,self.month]];
        [self getOldCalInfo];
    }
    
    
}

-(void)nextMonth
{
    int monthIndex = (int)[HYCalendarTool month:[NSDate date]];
    
    if (monthIndex<8) {
        if (self.month == monthIndex+5) {
            [self makeToast:@"请于当前日期起半年内操作"];
            return;
        }
    }else
    {
        if (self.month == monthIndex-7) {
            [self makeToast:@"请于当前日期起半年内操作"];
            return;
        }
        
    }

    [self saveCalInfo];
    //下个月
    if (self.month == 12) {
        self.month = 1;
        self.year += 1;
        [_monthLab setText:[NSString stringWithFormat:@"%d年%d月",self.year,self.month]];
        [self getOldCalInfo];
    }else
    {
        self.month += 1;
        [_monthLab setText:[NSString stringWithFormat:@"%d年%d月",self.year,self.month]];
        [self getOldCalInfo];
    }
    
}

/**
 *  从数据库中查找老数据，若存在直接用，不存在则直接调接口
 */
-(void)getOldCalInfo
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"calendar.db"];
    NSString * dateStr = [NSString stringWithFormat:@"%d-%d",self.year,self.month];
    NSArray * calarr = [store getObjectById:dateStr fromTable:@"calendar_table"];
    if (calarr) {
        monthArr = [NSMutableArray arrayWithArray:calarr];
        [self handleCalInfo];
        [self.calendarTableView reloadData];
    }else
    {
        [self getCalInfoWithSaleType:self.parkType];
    }

}

/**
 *  保存接口所获取的数据
 */
-(void)saveCalInfo
{
    NSString *tableName = @"calendar_table";
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"calendar.db"];
    [store createTableWithName:tableName];
    NSString * calendarID = [NSString stringWithFormat:@"%d-%d",self.year,self.month];
    NSArray * calendarInfoArr = [NSArray arrayWithArray:monthArr];
    [store putObject:calendarInfoArr withId:calendarID intoTable:tableName];
    
    NSArray * arr = [store getObjectById:calendarID fromTable:tableName];
    NSLog(@"query data result: %@", arr);
}

#pragma mark - 获取日历信息
-(void)getCalInfoWithSaleType:(NSString *)parkType
{
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@order/calendar", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:self.park_id forKey:@"park_id"];
     [paramsDict setObject:self.salttimes_id forKey:@"saletimes_id"];//时间段id
    [paramsDict setObject:parkType forKey:@"sale_type"];
    if (self.year == 0) {
        [paramsDict setObject:[NSString stringWithFormat:@"%d",(int)[HYCalendarTool year:[NSDate date]]] forKey:@"year"];
    }else
    {
        [paramsDict setObject:[NSString stringWithFormat:@"%d",self.year] forKey:@"year"];
    }
    
    if (self.month == 0) {
        [paramsDict setObject:[NSString stringWithFormat:@"%d",(int)[HYCalendarTool month:[NSDate date]]] forKey:@"month"];
    }else
    {
        [paramsDict setObject:[NSString stringWithFormat:@"%d",self.month] forKey:@"month"];
    }
    
   
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {

        NSMutableDictionary *tempDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        NSLog(@"%@",paramsDict);
        if ([tempDict[@"status"] isEqualToString:@"200"]) {
            monthArr = tempDict[@"data"];
            [dayArr removeAllObjects];
            self.num = (int)monthArr.count/7;
            [self handleCalInfo];
            [_calendarTableView reloadData];
            
        }
        else if ([tempDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }

    } failuer:^(NSError *error) {
        [self makeToast:@"请检查网络"];
    }];
    NSLog(@"%@",urlString);
    
   
    
}

/**
 *  处理日历数据monthArr
 */
-(void)handleCalInfo
{
     //日历有几行
    self.num = (int)monthArr.count/7;
    [dayArr removeAllObjects];
    //每一行数据源
    NSMutableArray *arrFG=[[NSMutableArray alloc]init];
    for (int i=0; i<monthArr.count; i++) {
        if ((i+1)%7!=0) {
            
            [arrFG addObject:monthArr[i]];
            
        }else
        {
            [arrFG addObject:monthArr[i]];
            [dayArr addObject:[arrFG mutableCopy]];
            [arrFG removeAllObjects];
            
        }
    }
    self.num = (int)dayArr.count;
}
/**
 *  clear数据库中日租日历（table） 数据
 */
-(void)delCalDB
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"calendar.db"];
    [store clearTable:@"calendar_table"];
}

/**
 *  取消修改操作
 */
//-(void)chanceEdit
//{
//    [calEditArr removeAllObjects];
//    [self delCalDB];
//    [self getCalInfo];
//}

-(void)checkState
{
    if (calEditArr.count > 0) {
        self.submitBtn.backgroundColor = kNavigationBarBackGroundColor;
        self.submitBtn.enabled = YES;
    }else
    {
        self.submitBtn.backgroundColor = [UIColor lightGrayColor];
        self.submitBtn.enabled = NO;
        
    }
    
}

- (void)dealloc{
    WYLog(@"dealloc");
}

@end
