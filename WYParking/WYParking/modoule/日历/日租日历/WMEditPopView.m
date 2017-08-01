//
//  WMEditPopView.m
//  TheGenericVersion
//
//  Created by Glavesoft on 16/8/3.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "WMEditPopView.h"
#import "EditCalendarCell.h"
#import "CalendarModel.h"
#import "HYCalendarTool.h"
#import "YTKKeyValueStore.h"


#define kLabelWidth kScreenWidth/7
#define kLabelHeight kLabelWidth + 18
#define KDarkColor [UIColor darkGrayColor].CGColor

@interface WMEditPopView()
{
    NSMutableArray * dateArr;
    NSIndexPath * _indexPath;
    int tempIndex;
//    NSMutableArray *calEditArrWM;
    NSMutableArray *calEditArr2;
    NSString * jsonstr;
    NSString * strTemp;
    
    int tempMonth;
    int tempYear;
    
    NSMutableArray * firstArr;
    NSMutableArray * lastArr;
    
    int firstIndex;
    int lastIndex;
    
    NSMutableArray * localMonthArr;//半年内的月份数组
    
    NSString * selectDate;
    
}

@property (copy , nonatomic) NSString *endDate;//获取租用的最后一天
@property (weak, nonatomic)  UILabel * monthLab;
@property (nonatomic , copy) NSString *saletimes_id;
@end


@implementation WMEditPopView
@synthesize calEditArrWM;
-(instancetype)initWithFrame:(CGRect)frame parkID:(NSString*)parkIdStr parkType:(NSString*)parkType saleTimesid:(NSString *)saletimes_id
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.autoresizingMask = 0;
        
        monthArr= [[NSMutableArray alloc]init];
        monthArr2= [[NSMutableArray alloc]init];
        dayArr = [[NSMutableArray alloc]init];
        dateArr = [[NSMutableArray alloc]init];
        
        calEditArrWM = [[NSMutableArray alloc]init];
        calEditArr2 = [[NSMutableArray alloc]init];
        
        firstArr = [[NSMutableArray alloc]init];
        lastArr = [[NSMutableArray alloc]init];
        
        localMonthArr = [[NSMutableArray alloc]init];
        
        firstIndex = 0;
        lastIndex = 0;
        
        self.park_id = parkIdStr;
        self.park_type = parkType;
        self.saletimes_id = saletimes_id;
        
        int yearIndex = (int)[HYCalendarTool year:[NSDate date]];
        int monthIndex = (int)[HYCalendarTool month:[NSDate date]];
        //获取日历信息
        for (int i = 0; i<6; i++) {
            tempMonth = monthIndex+i;
            if (tempMonth > 12) {
                tempMonth = tempMonth-12;
                tempYear =yearIndex+1;
            }else
            {
                tempYear =yearIndex;
            }
            
            NSString * temp = [NSString stringWithFormat:@"%d",tempMonth];
            [localMonthArr addObject:temp];
            [self getCalInfoFunc:tempYear month:tempMonth];
        }
        
        //创建table
        [self createTable];
        

        [self checkState];
        
    }
    return self;
    
}

#pragma mark - 右上方关闭按钮
- (void)close{
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
        [self delCalDB];
        [calEditArrWM removeAllObjects];
    }];

}

-(void)createTable
{
    UITableView * calendarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, kScreenHeight-45)];
    _calendarTableView = calendarTableView;
//    _calendarTableView.backgroundColor = RGBACOLOR(212, 213, 214, 1);
    _calendarTableView.delegate = self;
    _calendarTableView.bounces = NO;
    _calendarTableView.dataSource = self;
    _calendarTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:_calendarTableView];
    
    
    
    //header视图
    UIView * headerView = [[UIView alloc]init];
//    headerView.backgroundColor = RGBACOLOR(212, 213, 214, 1);
    headerView.backgroundColor = RGBACOLOR(241, 242, 243, 1);

    
    UILabel * monthLab = [[UILabel alloc]init];
    _monthLab = monthLab;
    _monthLab.frame = CGRectMake(0, 0, self.width, 35);
    
    self.year = (int)[HYCalendarTool year:[NSDate date]];
    self.month = (int)[HYCalendarTool month:[NSDate date]];
    
    [_monthLab setText:[NSString stringWithFormat:@"%d年%d月",self.year,self.month]];

    _monthLab.textAlignment = NSTextAlignmentCenter;
//    _monthLab.textColor = [UIColor darkGrayColor];
    _monthLab.textColor = RGBACOLOR(30, 62, 159, 1);

    _monthLab.font = [UIFont systemFontOfSize:17];
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
//    blueTitle2.font = [UIFont systemFontOfSize:10];
//    blueTitle2.text = @"我已租日期";
//    [footerView addSubview:blueTitle2];
    
    footerView.height = blueTitle.bottom+4;
     calendarTableView.tableFooterView = footerView;
    self.submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.height - 45, self.width, 45)];
    //    self.submitBtn.enabled = NO;
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.submitBtn.backgroundColor = RGBACOLOR(112, 212, 246,1);
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitBtn];
}


#pragma mark -点击提交
-(void)submit
{
    if (calEditArrWM.count>0) {
        jsonstr = [calEditArrWM mj_JSONString];
//        [self makeToast:jsonstr];
        UIAlertView * tipAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前所选时段周末及节假日不可租" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        if ([self.park_type isEqualToString:@"2"]||[self.park_type isEqualToString:@"4"]) {
            [tipAlert show];
        }else
        {
            NSString *temptStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"endDate11"];
            selectDate = calEditArrWM[0];
            [UIView animateWithDuration:0.3 animations:^{
                [self removeFromSuperview];
                [self delCalDB];
                [calEditArrWM removeAllObjects];
            } completion:^(BOOL finished) {
                self.wmJumpBlock(selectDate,temptStr);
                NSUserDefaults *standardUserdefaults = [NSUserDefaults standardUserDefaults];
                [standardUserdefaults setObject:@"" forKey:@"endDate11"];
                [standardUserdefaults synchronize];
            }];

        }
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
    }
    if ([model2.can_sale_num isEqualToString:@"0"]) {
        cell.labLeft2.hidden = YES;
    }if ([model3.can_sale_num isEqualToString:@"0"]) {
        cell.labLeft3.hidden = YES;
    }
    if ([model4.can_sale_num isEqualToString:@"0"]) {
        cell.labLeft4.hidden = YES;
    }
    if ([model5.can_sale_num isEqualToString:@"0"]) {
        cell.labLeft5.hidden = YES;
    }
    if ([model6.can_sale_num isEqualToString:@"0"]) {
        cell.labLeft6.hidden = YES;
    }
    if ([model7.can_sale_num isEqualToString:@"0"]) {
        cell.labLeft7.hidden = YES;
    }

    /**
     *  周一
     */
    //赋值
    NSString * text1 = [NSString stringWithFormat:@"%@", model1.day];
    [cell.btn1 setTitle:text1 forState:UIControlStateNormal];
    //判断状态
    if ([model1.is_me isEqual:@"1"]) {
        if ([model1.is_buy isEqual:@"1"]) {
//            [cell.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            cell.btn1.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn1.layer.borderWidth = 1;
            cell.bgView1.backgroundColor = RGBACOLOR(228, 229, 230, 1);

        }
        else{
            [cell.btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn1.layer.borderColor = KDarkColor;
//            cell.btn1.layer.borderWidth = 1;
        }
        cell.lineView1.hidden = NO;
    }else{
        if ([model1.is_buy isEqual:@"1"]) {
//            [cell.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            cell.btn1.layer.borderColor = [UIColor whiteColor].CGColor;
//            cell.btn1.layer.borderWidth = 1;
            cell.bgView1.backgroundColor = RGBACOLOR(228, 229, 230, 1);

        }
        else{
            [cell.btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            cell.btn1.layer.borderColor = KDarkColor;
//            cell.btn1.layer.borderWidth = 1;
        }
    }
    if ([model1.is_weekend isEqual:@"1"]||[model1.is_holiday isEqual:@"1"]) {
        cell.labLeft1.hidden = YES;
//        [cell.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn1.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn1.layer.borderWidth = 1;
        
        cell.bgView1.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    
    //日历点击操作状态判断
    if ([model1.is_choose isEqual:@"1"]) {
//        self.endDate = [NSString stringWithFormat:@"%@-%@-%@",model1.year,model1.month,model1.day];
        cell.btn1.layer.borderColor = [UIColor clearColor].CGColor;
//        cell.centerbg1.hidden = NO;
        
        cell.bgView1.backgroundColor = RGBACOLOR(30, 69, 159, 1);
        [cell.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        cell.leftbg1.hidden = NO;
        cell.rightbg1.hidden = NO;
    }
    if (cell.labLeft1.hidden) {
//        [cell.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn1.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn1.layer.borderWidth = 1;
        cell.bgView1.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    
    //判断是否处于当前月份，不是当前月的隐藏禁用
    if (![model1.month isEqualToString:[NSString stringWithFormat:@"%d",self.month]]) {
        cell.labLeft1.hidden = YES;
        [cell.btn1 setTitle:@"" forState:UIControlStateNormal];
        cell.btn1.enabled = NO;
        cell.btn1.hidden = YES;
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
 
    if ([model2.is_weekend isEqual:@"1"]||[model2.is_holiday isEqual:@"1"]) {
        cell.labLeft2.hidden = YES;
//        [cell.btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn2.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn2.layer.borderWidth = 1;
        
        cell.bgView2.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    if ([model2.is_choose isEqual:@"1"]) {
//        self.endDate = [NSString stringWithFormat:@"%@-%@-%@",model2.year,model2.month,model2.day];
//        cell.centerbg2.hidden = NO;
        cell.bgView2.backgroundColor = RGBACOLOR(30, 69, 159, 1);
        [cell.btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        cell.leftbg2.hidden = NO;
        cell.rightbg2.hidden = NO;

        cell.btn2.layer.borderColor = [UIColor clearColor].CGColor;
        
        
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
 
    if ([model3.is_weekend isEqual:@"1"]||[model3.is_holiday isEqual:@"1"]) {
        cell.labLeft3.hidden = YES;
//        [cell.btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn3.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn3.layer.borderWidth = 1;
        cell.bgView3.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }
    if ([model3.is_choose isEqual:@"1"]) {
//        self.endDate = [NSString stringWithFormat:@"%@-%@-%@",model3.year,model3.month,model3.day];
//        cell.centerbg3.hidden = NO;
        cell.bgView3.backgroundColor = RGBACOLOR(30, 69, 159, 1);
        [cell.btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        cell.leftbg3.hidden = NO;
        cell.rightbg3.hidden = NO;
        cell.btn3.layer.borderColor = [UIColor clearColor].CGColor;
        
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
  
    if ([model4.is_weekend isEqual:@"1"]||[model4.is_holiday isEqual:@"1"]) {
        cell.labLeft4.hidden = YES;
//        [cell.btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn4.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn4.layer.borderWidth = 1;
        cell.bgView4.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }

    if ([model4.is_choose isEqual:@"1"]) {
//        self.endDate = [NSString stringWithFormat:@"%@-%@-%@",model4.year,model4.month,model4.day];
//        cell.centerbg4.hidden = NO;
        cell.bgView4.backgroundColor = RGBACOLOR(30, 69, 159, 1);
        [cell.btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        
        cell.leftbg4.hidden = NO;
        cell.rightbg4.hidden = NO;

        cell.btn4.layer.borderColor = [UIColor clearColor].CGColor;
        
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
   
    if ([model5.is_weekend isEqual:@"1"]||[model5.is_holiday isEqual:@"1"]) {
        cell.labLeft5.hidden = YES;
//        [cell.btn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn5.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn5.layer.borderWidth = 1;
        cell.bgView5.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }

    if ([model5.is_choose isEqual:@"1"]) {
//        self.endDate = [NSString stringWithFormat:@"%@-%@-%@",model5.year,model5.month,model5.day];
//        cell.centerbg5.hidden = NO;
        cell.bgView5.backgroundColor = RGBACOLOR(30, 69, 159, 1);
        [cell.btn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        cell.leftbg5.hidden = NO;
        cell.rightbg5.hidden = NO;

        cell.btn5.layer.borderColor = [UIColor clearColor].CGColor;
        
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
    
    if ([model6.is_weekend isEqual:@"1"]||[model6.is_holiday isEqual:@"1"]) {
        cell.labLeft6.hidden = YES;
//        [cell.btn6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn6.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn6.layer.borderWidth = 1;
        cell.bgView6.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }

    if ([model6.is_choose isEqual:@"1"]) {
//        self.endDate = [NSString stringWithFormat:@"%@-%@-%@",model6.year,model6.month,model6.day];
//        cell.centerbg6.hidden = NO;
        cell.bgView6.backgroundColor = RGBACOLOR(30, 69, 159, 1);
        [cell.btn6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        cell.leftbg6.hidden = NO;
        cell.rightbg6.hidden = NO;

        cell.btn6.layer.borderColor = [UIColor clearColor].CGColor;
        
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
            cell.bgView7.backgroundColor = RGBACOLOR(228, 229, 230, 1);

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
 
    if ([model7.is_weekend isEqual:@"1"]||[model7.is_holiday isEqual:@"1"]) {
        cell.labLeft7.hidden = YES;
//        [cell.btn7 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        cell.btn7.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.btn7.layer.borderWidth = 1;
        cell.bgView7.backgroundColor = RGBACOLOR(228, 229, 230, 1);

    }

    if ([model7.is_choose isEqual:@"1"]) {
//        self.endDate = [NSString stringWithFormat:@"%@-%@-%@",model7.year,model7.month,model7.day];
//        cell.centerbg7.hidden = NO;
        cell.bgView7.backgroundColor = RGBACOLOR(30, 69, 159, 1);
        [cell.btn7 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        cell.leftbg7.hidden = NO;
        cell.rightbg7.hidden = NO;

        cell.btn7.layer.borderColor = [UIColor clearColor].CGColor;
        
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
    
    cell.backgroundColor = RGBACOLOR(212, 213, 214, 1);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 *  日历按钮点击操作
 */
-(void)PressToDo:(UILongPressGestureRecognizer *)gesture
{
    [self resetOldDb];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        [self getCalInfo];
        
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
            if ([str isEqualToString:@"1"]||[weekend isEqualToString:@"1"]||[holiday isEqualToString:@"1"]||gesture.view.layer.borderColor == [UIColor whiteColor].CGColor) {
                [self makeToast:@"当前日期不可操作"];
                [self getOriginalCalInfo];
                [calEditArrWM removeAllObjects];
                [self checkState];
                return;
            }
            
            [calEditArrWM removeAllObjects];
            NSDictionary* dict = [monthArr objectAtIndex:tempIndex];
            NSString * selectDateTemp = [NSString stringWithFormat:@"%@-%@-%@",dict[@"year"],dict[@"month"],dict[@"day"]];

            [calEditArrWM addObject:selectDateTemp];
        
            if ([self.park_type isEqualToString:@"1"]||[self.park_type isEqualToString:@"2"]) {
                int temp = (int)(monthArr.count-lastIndex-tempIndex);
                if (temp > 6) {
                    for (int i = 0; i<7; i++) {
                        [self setStatusValue:@"1" index:tempIndex+i];
                    }
                }else
                {
                    for (int i = 0; i<temp; i++) {
                        [self setStatusValue:@"1" index:tempIndex+i];
                    }
                    
                    //获取当前月与下一月
                    int now = self.month;
                    int next;
                    int year = self.year;
                    if (now == 12) {
                        next = 1;
                        year = self.year+1;
                    }else
                    {
                        next = now+1;
                    }
                    
                    NSString * nowStr = [NSString stringWithFormat:@"%d",now];
                    NSString * nextStr = [NSString stringWithFormat:@"%d",next];
                    
                    if ([localMonthArr containsObject:nowStr]&&[localMonthArr containsObject:nextStr]) {
                        int remainIndex = 7-temp;
                        [self getOriginalCalInfo:year month:next remainIndex:remainIndex];
                    }else
                    {
                        [self makeToast:@"请于当前日期起半年内操作"];
                        [self resetOldDb];
                        [self getOriginalCalInfo];
                    }
                   
                }
                
            }else
            {
                int temp = (int)(monthArr.count-lastIndex-tempIndex);
                if (temp > 29) {
                    for (int i = 0; i<30; i++) {
                        [self setStatusValue:@"1" index:tempIndex+i];
                    }
                    
                }else
                {
                    for (int i = 0; i<temp; i++) {
                        [self setStatusValue:@"1" index:tempIndex+i];
                    }
                    //获取当前月与下一月
                    int now = self.month;
                    int next;
                    int year = self.year;
                    if (now == 12) {
                        next = 1;
                        year = self.year+1;
                    }else
                    {
                        next = now+1;
                    }
                    
                    NSString * nowStr = [NSString stringWithFormat:@"%d",now];
                    NSString * nextStr = [NSString stringWithFormat:@"%d",next];
                    
                    if ([localMonthArr containsObject:nowStr]&&[localMonthArr containsObject:nextStr]) {
                        int remainIndex = 30-temp;
                        [self getOriginalCalInfo:year month:next remainIndex:remainIndex];
                    }else
                    {
                        [self makeToast:@"请于当前日期起半年内操作"];
                        [self resetOldDb];
                        [self getOriginalCalInfo];

                    }

                }

            }
        
        [self saveCalInfo];
        
        [self getOldCalInfo];


        [self checkOrderFun];
    }
}

#pragma mark - 检查某个车位的开始日期能否下单
-(void)checkOrderFun
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@order/checkdate", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:self.park_id forKey:@"park_id"];
    [paramsDict setObject:self.park_type forKey:@"sale_type"];
    [paramsDict setObject:self.saletimes_id forKey:@"saletimes_id"];
    if (calEditArrWM.count != 0) {
        [paramsDict setObject:calEditArrWM[0] forKey:@"start_date"];
    }else
    {
        [self makeToast:@"请选择租赁日期"];
    }
    
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        NSMutableDictionary *tempDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        NSLog(@"%@",paramsDict);
        if ([tempDict[@"status"] isEqualToString:@"200"]) {
            [self checkState];
            _endDate = tempDict[@"message"];
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults] ;
            [standardUserDefaults setObject:_endDate forKey:@"endDate11"];
            [standardUserDefaults synchronize];
            
            
        }
        else if([tempDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            [self makeToast:tempDict[@"message"]];
            YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"calendar.db"];
            [store clearTable:@"calendar_table"];
            [self getOriginalCalInfo];
            [calEditArrWM removeAllObjects];
            [self checkState];
        }

    } failuer:^(NSError *error) {
        [self makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self animated:YES];

    }];
    
}



/**
 *  重新赋值 is_choose 字段
 */
-(void)setStatusValue:(NSString*)typeInt index:(int)index
{
    NSMutableDictionary * tempDict = [NSMutableDictionary dictionaryWithDictionary:monthArr[index]];
    [tempDict setValue:typeInt forKey:@"is_choose"];
    NSMutableArray * temparr = [NSMutableArray arrayWithArray:monthArr];
    [temparr removeObjectAtIndex:index];
    [temparr insertObject:tempDict atIndex:index];
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
//        [calEditArrWM removeAllObjects];
//    }];
//}

-(void)lastMonth
{
//    [self.clickView removeFromSuperview];
    
    int monthIndex = (int)[HYCalendarTool month:[NSDate date]];
    
    if (self.month == monthIndex) {
        [self makeToast:@"请于当前日期起半年内操作"];
        return;
    }
    
    [self getCalInfo];
    [self saveCalInfo];
    //上个月
    if (self.month == 1) {
        self.month = 12;
        self.year -= 1;
        [_monthLab setText:[NSString stringWithFormat:@"%d-%d",self.year,self.month]];
        [self getOldCalInfo];
    }else
    {
        self.month -= 1;
        [_monthLab setText:[NSString stringWithFormat:@"%d-%d",self.year,self.month]];
        [self getOldCalInfo];
    }
    
    
}

-(void)nextMonth
{
//    [self.clickView removeFromSuperview];
    
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
    
    [self getCalInfo];
    [self saveCalInfo];
    //下个月
    if (self.month == 12) {
        self.month = 1;
        self.year += 1;
        [_monthLab setText:[NSString stringWithFormat:@"%d-%d",self.year,self.month]];
        [self getOldCalInfo];
    }else
    {
        self.month += 1;
        [_monthLab setText:[NSString stringWithFormat:@"%d-%d",self.year,self.month]];
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
        [self dealWithWeekHoliday];
        [self handleCalInfo];
        [self.calendarTableView reloadData];
    }else
    {
        YTKKeyValueStore *store2 = [[YTKKeyValueStore alloc]initDBWithName:@"originalcalendar.db"];
        NSString * dateStr2 = [NSString stringWithFormat:@"%d-%d-original",self.year,self.month];
        NSArray * calarr2 = [store2 getObjectById:dateStr2 fromTable:@"original_calendar_table"];
        if (calarr2) {
            monthArr = [NSMutableArray arrayWithArray:calarr2];
            [self dealWithWeekHoliday];
            [self handleCalInfo];
            [self.calendarTableView reloadData];
        }else
        {
            [self makeToast:@"日期获取失败"];
        }

    }
    
}

-(void)getCalInfo
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"calendar.db"];
    NSString * dateStr = [NSString stringWithFormat:@"%d-%d",self.year,self.month];
    NSArray * calarr = [store getObjectById:dateStr fromTable:@"calendar_table"];
    if (calarr) {
        monthArr = [NSMutableArray arrayWithArray:calarr];
    }else
    {
        YTKKeyValueStore *store2 = [[YTKKeyValueStore alloc]initDBWithName:@"originalcalendar.db"];
        NSString * dateStr2 = [NSString stringWithFormat:@"%d-%d-original",self.year,self.month];
        NSArray * calarr2 = [store2 getObjectById:dateStr2 fromTable:@"original_calendar_table"];
        if (calarr2) {
            monthArr = [NSMutableArray arrayWithArray:calarr2];
        }else
        {
            [self makeToast:@"日期获取失败"];
        }
        
    }

}

-(void)getOriginalCalInfo
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"originalcalendar.db"];
    NSString * dateStr = [NSString stringWithFormat:@"%d-%d-original",self.year,self.month];
    NSArray * calarr = [store getObjectById:dateStr fromTable:@"original_calendar_table"];
    if (calarr) {
        monthArr = [NSMutableArray arrayWithArray:calarr];
        [self dealWithWeekHoliday];
        [self handleCalInfo];
        [self.calendarTableView reloadData];
    }else
    {
        YTKKeyValueStore *store2 = [[YTKKeyValueStore alloc]initDBWithName:@"calendar.db"];
        NSString * dateStr2 = [NSString stringWithFormat:@"%d-%d",self.year,self.month];
        NSArray * calarr2 = [store2 getObjectById:dateStr2 fromTable:@"calendar_table"];
        if (calarr2) {
            monthArr = [NSMutableArray arrayWithArray:calarr2];
            [self dealWithWeekHoliday];
            [self handleCalInfo];
            [self.calendarTableView reloadData];
        }else
        {
            [self makeToast:@"日期获取失败"];
        }
    }
    
}

//获取指定月份并修改日期
-(void)getOriginalCalInfo:(int)year month:(int)month remainIndex:(int)remainIndex
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"originalcalendar.db"];
    NSString * dateStr = [NSString stringWithFormat:@"%d-%d-original",year,month];
    NSArray * calarr = [store getObjectById:dateStr fromTable:@"original_calendar_table"];
    if (calarr) {
        NSMutableArray * tempArr = [NSMutableArray arrayWithArray:calarr];
        int temp = 7-lastIndex;
        int temp2;
        if (temp == 7) {
            temp2 = remainIndex;
        }else
        {
            temp2 = temp+remainIndex;
        }
        for (int i = 0; i<temp2; i++) {
            NSMutableDictionary * tempDict = [NSMutableDictionary dictionaryWithDictionary:tempArr[i]];
            [tempDict setValue:@"1" forKey:@"is_choose"];
            NSMutableArray * temparr2 = [NSMutableArray arrayWithArray:tempArr];
            [temparr2 removeObjectAtIndex:i];
            [temparr2 insertObject:tempDict atIndex:i];
            tempArr = [NSMutableArray arrayWithArray:temparr2];
        }
        [self saveCalInfo:year month:month arr:tempArr];
    }
}



/**
 *  保存修改后的数据
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

-(void)saveCalInfo:(int)year month:(int)month arr:(NSArray*)arr
{
    NSString *tableName = @"calendar_table";
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"calendar.db"];
    [store createTableWithName:tableName];
    NSString * calendarID = [NSString stringWithFormat:@"%d-%d",year,month];
    NSArray * calendarInfoArr = [NSArray arrayWithArray:arr];
    [store putObject:calendarInfoArr withId:calendarID intoTable:tableName];
    
    NSArray * arr2 = [store getObjectById:calendarID fromTable:tableName];
    NSLog(@"query data result: %@", arr2);
}


/**
 *  保存接口最初所获取的数据
 */
-(void)saveOriginalCalInfo:(int)year month:(int)month arr:(NSArray*)arr
{
    NSString *tableName = @"original_calendar_table";
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"originalcalendar.db"];
    [store createTableWithName:tableName];
    NSString * calendarID = [NSString stringWithFormat:@"%d-%d-original",year,month];
    NSArray * calendarInfoArr = [NSArray arrayWithArray:arr];
    [store putObject:calendarInfoArr withId:calendarID intoTable:tableName];
    
    NSArray * arr2 = [store getObjectById:calendarID fromTable:tableName];
    NSLog(@"query data result: %@", arr2);
}

-(void)resetOldDb
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"calendar.db"];
    [store clearTable:@"calendar_table"];
}

#pragma mark - 获取日历信息
-(void)getCalInfoFunc:(int)year month:(int)month
{
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@order/calendar", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:self.park_id forKey:@"park_id"];
    [paramsDict setObject:[NSString stringWithFormat:@"%d",year] forKey:@"year"];
    [paramsDict setObject:[NSString stringWithFormat:@"%d",month] forKey:@"month"];
    [paramsDict setObject:self.park_type forKey:@"sale_type"];
    [paramsDict setObject:self.saletimes_id forKey:@"saletimes_id"];
    
  
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
      
        NSMutableDictionary *tempDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        NSLog(@"%@",paramsDict);
        if ([tempDict[@"status"] isEqualToString:@"200"]) {
            //            [monthArr removeAllObjects];
            monthArr = tempDict[@"data"];
            
            if (year == self.year&&month == self.month) {
                [dayArr removeAllObjects];
                self.num = (int)monthArr.count/7;
                
                [self handleCalInfo];
                [_calendarTableView reloadData];
            }
            //暂存
            [self saveOriginalCalInfo:year month:month arr:monthArr];
            
        }
        else if ([tempDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }else{
            [self makeToast:tempDict[@"message"]];
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
    self.num = (int)monthArr.count/7;
    
    [dayArr removeAllObjects];
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
    
    firstIndex = 0;
    lastIndex = 0;
    
    firstArr = dayArr[0];
    lastArr = dayArr[self.num-1];
    
    for (int i = 0; i<firstArr.count; i++) {
        NSString * str1 = [NSString stringWithFormat:@"%@",firstArr[i][@"month"]];
        NSString * str2 = [NSString stringWithFormat:@"%@",lastArr[i][@"month"]];

        if (![str1 isEqualToString:[NSString stringWithFormat:@"%d",self.month]]) {
            firstIndex++;
        }
        if (![str2 isEqualToString:[NSString stringWithFormat:@"%d",self.month]]) {
            lastIndex++;
        }
    }
    
}
/**
 *  删除数据库
 */
-(void)delCalDB
{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc]initDBWithName:@"calendar.db"];
    [store clearTable:@"calendar_table"];
    YTKKeyValueStore *store2 = [[YTKKeyValueStore alloc]initDBWithName:@"originalcalendar.db"];
    [store2 clearTable:@"original_calendar_table"];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        selectDate = calEditArrWM[0];
        [UIView animateWithDuration:0.3 animations:^{
            [self removeFromSuperview];
            [self delCalDB];
            [calEditArrWM removeAllObjects];
        } completion:^(BOOL finished) {
            self.wmJumpBlock(selectDate,_endDate);
        }];
         
     }
}

/**
 *  若类型为2或4将选中的周末和节假日变为白色
 */
#warning 此时节假日不可再放于is_buy判断   需要添加新字段is_holiday
-(void)dealWithWeekHoliday
{
    if ([self.park_type isEqualToString:@"2"]||[self.park_type isEqualToString:@"4"])
    {
        //将数组内is_choose变为0
        for (int i = 0; i<monthArr.count; i++) {
            NSString * is_weekend = [NSString stringWithFormat:@"%@",monthArr[i][@"is_weekend"]];
            NSString * is_holiday = [NSString stringWithFormat:@"%@",monthArr[i][@"is_holiday"]];
            NSString * is_choose = [NSString stringWithFormat:@"%@",monthArr[i][@"is_choose"]];

            if ([is_weekend isEqualToString:@"1"]||[is_holiday isEqualToString:@"1"]) {
                if ([is_choose isEqualToString:@"1"]) {
                    [self setStatusValue:0 index:i];
                }
            }
        }
    }

}

-(void)checkState
{
    if (calEditArrWM.count > 0) {
        self.submitBtn.backgroundColor = kNavigationBarBackGroundColor;
        self.submitBtn.enabled = YES;
    }else
    {
        self.submitBtn.backgroundColor = [UIColor lightGrayColor];
        self.submitBtn.enabled = NO;

    }

}
@end
