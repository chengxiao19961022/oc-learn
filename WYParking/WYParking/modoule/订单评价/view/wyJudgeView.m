//
//  wyJudgeView.m
//  TheGenericVersion
//
//  Created by glavesoft on 16/9/20.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "wyJudgeView.h"
#import "wyModelReason.h"
#import "wyBtnJudge.h"
#import "pop.h"
#import "UIView+Extension.h"

#define btnpadding 10
#define btnLineSpace 10
#define btnHeight 25

@interface wyJudgeView ()

@property (strong , nonatomic) NSMutableArray<wyModelReason *> *judges;

@end

@implementation wyJudgeView




//lazy
- (NSMutableArray *)judges{
    if (_judges == nil) {
        _judges = [NSMutableArray array];
    }
    return _judges;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)RenderViewWithType:(judgeReasonType)type{
    self.type = type;
    [self fetchData];
}


- (void)configUI{
    //element in scrollView
    //--create
    NSMutableArray<wyBtnJudge *> *btnArr = [NSMutableArray array];
    for (int i = 0; i < self.judges.count; i++) {
        wyBtnJudge *judgeBtn = [[wyBtnJudge alloc] init];
        judgeBtn.alpha = 0;
        judgeBtn.selected = NO;
        judgeBtn.tag = i;
        wyModelReason *reason = [self.judges objectAtIndex:i];
        judgeBtn.labelTitle.text = reason.content;
        [judgeBtn addTarget:self action:@selector(wyBtnJudgeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:judgeBtn];
        [btnArr addObject:judgeBtn];
    }
    //--布局
    [btnArr.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btnpadding);
        make.top.mas_equalTo(btnLineSpace);
    }];
    [self layoutIfNeeded];
    __block wyBtnJudge *preLineBtn = nil;
    __block NSInteger precountInter = 1;
    wyBtnJudge *firstJudgeBtn = btnArr.firstObject;
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
    CGSize firstS = [firstJudgeBtn.labelTitle.text boundingRectWithSize:CGSizeMake(MAXFLOAT, btnHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    __block CGFloat totalSizeW = firstS.width;
    [btnArr enumerateObjectsUsingBlock:^(wyBtnJudge * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            [self layoutIfNeeded];
            wyBtnJudge *preBtn = [btnArr objectAtIndex:(idx-1)];
            //剩下的宽度
            CGFloat selfWidth = (kScreenWidth - 20 * 2);
             NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
             CGSize size = [obj.labelTitle.text boundingRectWithSize:CGSizeMake(MAXFLOAT, btnHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
            CGFloat leftWidth = selfWidth - (btnpadding + 10)*precountInter - btnpadding - totalSizeW;
            if (size.width > leftWidth) {
                //放不下，另启一行
                precountInter = 1;
                totalSizeW = size.width;
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (preLineBtn == nil) {
                        make.top.mas_equalTo(btnLineSpace);
                    }else{
                        make.top.equalTo(preLineBtn.mas_bottom).offset(btnLineSpace);
                    }
                    make.left.mas_equalTo(btnpadding);
                }];
                preBtn = obj;
                [self layoutIfNeeded];
            }else{
                precountInter += 1;
                totalSizeW += size.width;
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(preBtn.mas_right).offset(btnpadding);
                    make.top.equalTo(preBtn.mas_top);
                }];
                preLineBtn = obj;
                [self layoutIfNeeded];
            }
        }
    }];
    
    [btnArr.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-btnLineSpace);
    }];
    
//    self.height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
      CGFloat selfWidth = (KscreenWidth - 20 * 2);
    POPBasicAnimation *sacleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
    sacleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(selfWidth, [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height)];
    sacleAnimation.duration = 0.1;
    sacleAnimation.completionBlock = ^(POPAnimation *anim,BOOL isCoplete){
        if (isCoplete) {
            POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            alphaAnimation.toValue = @1.0;
            alphaAnimation.duration = 0.1;
            [btnArr enumerateObjectsUsingBlock:^(wyBtnJudge * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj pop_addAnimation:alphaAnimation forKey:@"alphaAnimation1"];
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"animationDone" object:nil userInfo:nil];
        }
    };
    [self pop_addAnimation:sacleAnimation forKey:@"sacleAnimation"];

    
   
    
}

//配置数据源
- (void)fetchData{

    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@content/getcontents", KSERVERADDRESS];
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [paramsDict setObject:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%ld",(long)self.type]] forKey:@"type"];
    
    [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
       
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            NSLog(@"aa");
            self.judges = [wyModelReason mj_objectArrayWithKeyValuesArray:paramsDict[@"data"]];
            [self configUI];
        }else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }else
        {
            [self makeToast:paramsDict[@"message"]];
        }

    } failuer:^(NSError *error) {
        [self makeToast:@"请检查网络"];

    }];
  
    
}


//点击事件
- (void)wyBtnJudgeClick:(wyBtnJudge *)sender{
    wyModelReason *model = [self.judges objectAtIndex:sender.tag];
    if (self.click) {
        self.click(model);
    }
}

@end
