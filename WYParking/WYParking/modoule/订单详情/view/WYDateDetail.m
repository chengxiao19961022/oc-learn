//
//  WYDateDetail.m
//  WYParking
//
//  Created by 程潇 on 2017/7/12.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYDateDetail.h"

@interface WYDateDetail ()

@property (weak , nonatomic) UIScrollView *scrollView;
@property (copy, nonatomic) NSArray *LabArray;// 存放label

@end

@implementation WYDateDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetNaviBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //其中 ; 分号必须是 隔断字符串 的分隔符。否则 ; 就要更改成对应的 分隔符
    self.DateArray = [self.DateDetail componentsSeparatedByString:@";"];
    // 定义scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview: scrollView];
    //  scrollView.layer.contents = (id)
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView = scrollView;
    
    UIView *containerView = UIView.new;
    [scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.equalTo(containerView.superview);
    }];
    containerView.backgroundColor = [UIColor whiteColor];

//    UILabel * DateView1 = UILabel.new;
//    DateView1.text = [self.DateArray objectAtIndex:0];
//    [containerView addSubview:DateView1];
//    [DateView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(30);
//                make.left.equalTo(containerView.mas_left).with.offset(40);
//                make.top.equalTo(containerView.mas_top).with.offset(20);
//            }];
//    UILabel *pre = [UILabel alloc];
    unsigned long datecount;
    if (self.DateArray.count%2 == 0){
        datecount = self.DateArray.count/2;
    }else{
        datecount = self.DateArray.count/2 + 1;
    }
    for (int i = 0; i < datecount; i++) {
        UILabel * DateView = UILabel.new;
        NSString *date1 = [self.DateArray objectAtIndex:2*i];
        NSString *date2 = @"";
        if(i == datecount-1)
        {
            if (self.DateArray.count%2 == 0)
                date2 = [self.DateArray objectAtIndex:(2*i+1)];
        }else{
            date2 = [self.DateArray objectAtIndex:(2*i+1)];
        }
        DateView.text = [NSString stringWithFormat:@"%@     %@", date1, date2];

        [containerView addSubview:DateView];
        __block MASConstraint *isFirst = nil;
        __block MASConstraint *notFirst = nil;
        [DateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            isFirst = make.left.equalTo(containerView.mas_left).with.offset(34);
            notFirst = make.left.equalTo(containerView.mas_left).with.offset(25);
            make.top.equalTo(containerView.mas_top).with.offset(20*(i+1)+30*i);
        }];
        if (i == 0){
            [isFirst install];
            [notFirst uninstall];
        }else{
            [isFirst uninstall];
            [notFirst install];
        }
    }
//    pre = nil;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)SetNaviBar
{
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    
    self.title = @"租车时间";
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 27, 27)];
    [btn setImage:[UIImage imageNamed:@"back3"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)Back
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
