//
//  wyJugeVC.m
//  TheGenericVersion
//
//  Created by glavesoft on 16/10/9.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "wyJugeVC.h"
#import "MyOrderViewController.h"
#import "UITextView+Placeholder.h"
#import "wyModelReason.h"

@interface wyJugeVC ()
@property (weak, nonatomic) IBOutlet UIView *judgeView;
@property (strong , nonatomic) NSMutableArray<UIButton *> *starBtnArr;
@property(weak , nonatomic) UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *describeTopView;
@property (copy , nonatomic) NSString *star;


@end

@implementation wyJugeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"animationDone" object:nil];
    [self configUI];
    self.title = @"评价";
}

- (void)configUI{
   //add five star
    NSMutableArray<UIButton *> *starBtnArr = [NSMutableArray array];
    int starCount = 5;
    for (int i = 0; i < starCount; i++) {
        UIButton * btn = UIButton.new;
        btn.tag = i;
        [btn setAdjustsImageWhenHighlighted:NO];
        [btn setBackgroundImage:[UIImage imageNamed:@"grey_star"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"yellow_star"] forState:UIControlStateSelected];
        btn.selected = YES;
        if (self.orderIsJudged == NO) {
             [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [starBtnArr addObject:btn];
        [self.judgeView addSubview:btn];
        self.star = [NSString stringWithFormat:@"%ld",btn.tag+1];
    }
    self.starBtnArr = starBtnArr;
    UIButton *lastBtn = starBtnArr.lastObject;
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastBtn.superview).offset(-10);
        make.centerY.equalTo(lastBtn.superview);
    }];
    [starBtnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx<starCount - 1) {
            UIButton *preBtn = [starBtnArr objectAtIndex:idx + 1];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(preBtn.mas_left).offset(-5);
                make.centerY.equalTo(obj.superview);
            }];
        }
    }];
    
    //describe juge words
    wyJudgeView *judgeV = wyJudgeView.new;
    [judgeV RenderViewWithType:self.type];
    __weak typeof(self) weakSelf = self;
    if (self.orderIsJudged == NO) {
        judgeV.click = ^(wyModelReason *model){
            if ([[weakSelf.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
                weakSelf.textView.text = [weakSelf.textView.text stringByAppendingString:model.content];
            }else{
                weakSelf.textView.text = [weakSelf.textView.text stringByAppendingString:[NSString stringWithFormat:@",%@",model.content]];
            }
            
        };
    }
    [self.view addSubview:judgeV];
    [judgeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.describeTopView.mas_bottom);
        make.left.equalTo(weakSelf.describeTopView.mas_left);
        make.right.mas_equalTo(-20);
    }];
    
    
    
    UIView *describeBottomViewLIne = UIView.new;
    describeBottomViewLIne.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:describeBottomViewLIne];
    [describeBottomViewLIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(judgeV.mas_bottom);
        make.left.equalTo(weakSelf.describeTopView.mas_left);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
    }];
    
    //uitextView
    UITextView *textView = UITextView.new;
    textView.placeholder = @"请输入您的评价";
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(describeBottomViewLIne.mas_left);
        make.right.equalTo(describeBottomViewLIne.mas_right);
        make.top.equalTo(describeBottomViewLIne.mas_bottom);
        make.height.mas_equalTo(180 * 480.0 / kScreenHeight);
    }];
    self.textView = textView;
    
    UIView *judgeViewBottomLIne = UIView.new;
    judgeViewBottomLIne.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:judgeViewBottomLIne];
    [judgeViewBottomLIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom);
        make.left.equalTo(textView.mas_left);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
    }];
    
    
    
    //animation
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.alpha = 0;
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault];
    __weak typeof(self) weakSelf = self;
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];

}

- (void)updateUI{
    if (self.orderIsJudged == NO) {
        //未评论
        [self.view layoutIfNeeded];
        [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            POPBasicAnimation *basicAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            basicAnimation.toValue = @1.0;
            basicAnimation.duration = 0.38;
            [obj pop_addAnimation:basicAnimation forKey:@"basicAnimationAlphaWyJudgeVc"];
            basicAnimation.beginTime = CACurrentMediaTime();
        }];
    }else{
        //已评论
        [self getPjFunc];
    }
    
}


- (void)btnClick:(UIButton *)sender{
    __block NSInteger index = sender.tag;
    [self.starBtnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx <= index) {
            obj.selected = YES;
            self.star = [NSString stringWithFormat:@"%ld",idx + 1];
        }else{
            obj.selected = NO;
        }
    }];
}


- (IBAction)btnTiJiaoClick:(id)sender {
    if (self.textView.text.length == 0) {
        [self.view makeToast:@"请输入评价"];
        return;
    }
    if (self.textView.text.length > 100) {
        [self.view makeToast:@"评价不能超过100字"];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@comment/add", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    
    [paramsDict setObject:self.textView.text forKey:@"content"];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token  forKey:@"token"];
    [paramsDict setObject:self.star forKey:@"star"];
    //    order_id
    [paramsDict setObject:self.order_id forKey:@"order_id"];
    
    
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSMutableDictionary *tempDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([tempDict[@"status"] isEqualToString:@"200"]) {
            [self.view makeToast:@"评价成功"];
             [[NSNotificationCenter defaultCenter] postNotificationName:WYHomeVCNeedReFresh object:nil];
            if (self.orderIsJudged == NO) {
                self.orderIsJudged = YES;
                if (self.isDone) {
                    self.isDone(YES);
                }
            }
        __block BOOL toMyORderVC = NO;
        [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[MyOrderViewController class]]) {
                [Utils setNavigationControllerPopWithAnimation:self timingFunction:KYNaviAnimationTimingFunctionEaseInEaseOut type:KYNaviAnimationTypeReveal subType:KYNaviAnimationDirectionDefault duration:0.38 target:obj];
                toMyORderVC = YES;
            }
        }];
        if (toMyORderVC == NO) {
            [[NSNotificationCenter defaultCenter] postNotificationName:WYHomeVCNeedReFresh object:@""];
            // pop到根目录下
             [self.navigationController popToRootViewControllerAnimated:YES];
        }
       
        }else if ([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            [self.view makeToast:tempDict[@"message"]];
        }
        
        
    } failuer:^(NSError *error) {
        [self.view makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)getPjFunc
{
    
//    NSString *urlString = [[NSString alloc] initWithFormat:@"%@/parking/api/web/index.php/v2/comment/ordercomment", KSERVERADDRESS];
//    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
//    
//    [paramsDict setObject:[[Utils readDataFromPlist] objectForKey:@"token"] forKey:@"token"];
//    [paramsDict setObject:self.order_id forKey:@"order_id"];
//    
//  
//    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//       
//        NSMutableDictionary *tempDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
//        NSLog(@"%@",paramsDict);
//        if ([tempDict[@"status"] isEqualToString:@"200"]) {
//            self.textView.text = tempDict[@"data"][@"content"];
//            self.textView.userInteractionEnabled = NO;
//            NSString *str = tempDict[@"data"][@"star"];
//            int index = [str intValue];
//            [self.starBtnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (idx < index ) {
//                    obj.selected = YES;
//                }else{
//                    obj.selected = NO;
//                }
//            }];
//            [self.view layoutIfNeeded];
//            [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                POPBasicAnimation *basicAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
//                basicAnimation.toValue = @1.0;
//                basicAnimation.duration = 0.38;
//                [obj pop_addAnimation:basicAnimation forKey:@"basicAnimationAlphaWyJudgeVc"];
//                basicAnimation.beginTime = CACurrentMediaTime();
//            }];
//            
//            
//        }
//        else if ([tempDict[@"status"] isEqualToString:@"104"])
//        {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
//        }else
//        {
//            [self.view makeToast:tempDict[@"message"]];
//        }
//
//    } failuer:^(NSError *error) {
//        [self.view makeToast:@"请检查网络"];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
    
    
}





@end
