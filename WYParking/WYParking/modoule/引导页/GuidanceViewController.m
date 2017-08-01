//
//  GuidanceViewController.m
//  qczh
//
//  Created by glavesoft on 17/2/22.
//  Copyright © 2017年 LHX. All rights reserved.
//

#import "GuidanceViewController.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"

#define GuidanceCount 4

@interface GuidanceViewController ()<UIScrollViewDelegate>

@end

@implementation GuidanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [wyLogInCenter shareInstance].loginstate = wyLogInStateNotLogin;
    // Do any additional setup after loading the view.
    // 1.创建scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    // 2.添加图片到scrollView中
        CGFloat scrollW = scrollView.width;
        CGFloat scrollH = scrollView.height;
    for (int i = 0; i < GuidanceCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i * scrollW, 0, scrollW, scrollH);
        NSString *name = [NSString stringWithFormat:@"欢迎0%d", i+1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        if (i == GuidanceCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    scrollView.contentSize = CGSizeMake(GuidanceCount * scrollW, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
   
}

- (void)setupLastImageView:(UIImageView *)imageView
{
    
    
    imageView.userInteractionEnabled = YES;

    
    /*****按钮进入******/
    
    // 立即使用
    UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 150)/2, kScreenHeight - 150, 150, 50)];
    startBtn.backgroundColor = RGBACOLOR(90, 129, 211, 1);
    startBtn.layer.cornerRadius = 3;
    startBtn.layer.masksToBounds = YES;
    [startBtn setTitle:@"立即开启" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
    
    

}


#pragma mark 发送通知进入APP
- (void)startClick
{
  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToHome" object:nil];

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

@end
