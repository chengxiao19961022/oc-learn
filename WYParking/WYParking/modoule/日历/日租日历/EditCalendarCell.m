//
//  EditCalendarCell.m
//  TheGenericVersion
//
//  Created by liuqiang on 16/6/30.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "EditCalendarCell.h"
//#define kLabelWidth (kScreenWidth-(2*10))/7
#define kLabelWidth (kScreenWidth - 6)/7

#define kLabelHeight kLabelWidth + 18


@implementation EditCalendarCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.33f alpha:0.5];

        
        int y = 0;
        
//        UIView * bgView1 = [[UIView alloc]initWithFrame:CGRectMake(10, y, kLabelWidth, kLabelHeight)];
        UIView * bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, y, kLabelWidth, kLabelHeight)];

        _bgView1 = bgView1;
        
        [self addSubview:_bgView1];
        //-----------leftbg
        UIImageView * leftbg1 = [[UIImageView alloc]init];
        _leftbg1 = leftbg1;
        
        _leftbg1.tag = 3001;
//        _leftbg1.image = [UIImage imageNamed:@"51_zty-0"];

        _leftbg1.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _leftbg1.hidden = YES;
        [_bgView1 addSubview:_leftbg1];
        //-----------centerbg
        UIImageView * centerbg1 = [[UIImageView alloc]init];
        _centerbg1 = centerbg1;
        _centerbg1.tag = 2001;
//        _centerbg1.image = [UIImage imageNamed:@"51_ty"];
        _centerbg1.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _centerbg1.hidden = YES;
        [_bgView1 addSubview:_centerbg1];
        //-----------rightbg
        UIImageView * rightbg1 = [[UIImageView alloc]init];
        _rightbg1 = rightbg1;
        
        _rightbg1.tag = 4001;
//        _rightbg1.image = [UIImage imageNamed:@"51_yty-0"];
        
        _rightbg1.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _rightbg1.hidden = YES;
        [_bgView1 addSubview:_rightbg1];
        //-----------btn
        UIButton * btn1 = [[UIButton alloc]init];
        _btn1 = btn1;
        _btn1.tag = 1001;
        _btn1.frame = CGRectMake(4, 4, kLabelWidth-8, kLabelWidth-8);
        [_btn1.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btn1 setTitle:@"30" forState:UIControlStateNormal];
        
       //        [btn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
        [_bgView1 addSubview:_btn1];
        
        // ------- 下方剩余剩余
        UILabel *labLeft1 = UILabel.new;
        labLeft1.text = @"余:10";

        labLeft1.textAlignment = NSTextAlignmentCenter;
        labLeft1.frame = CGRectMake(_btn1.left, _btn1.bottom + 2, _btn1.width, 20);
        self.labLeft1 = labLeft1;
        [_bgView1 addSubview:labLeft1];
        

        //-----------line1
        UIView * lineView1 = [[UIView alloc]init];
        _lineView1 = lineView1;
        _lineView1.frame = CGRectMake(0, kLabelWidth/2-0.5, kLabelWidth, 1);
        _lineView1.hidden = YES;
        [_bgView1 addSubview:_lineView1];

        
        
//        UIView * bgView2 = [[UIView alloc]initWithFrame:CGRectMake(kLabelWidth+10, y, kLabelWidth, kLabelHeight)];
        UIView * bgView2 = [[UIView alloc]initWithFrame:CGRectMake( 1 +kLabelWidth, y, kLabelWidth, kLabelHeight)];

        _bgView2 = bgView2;
        [self addSubview:_bgView2];
        //-----------leftbg
        UIImageView * leftbg2 = [[UIImageView alloc]init];
        _leftbg2 = leftbg2;
        _leftbg2.tag = 3002;
//        _leftbg2.image = [UIImage imageNamed:@"51_zty-0"];
        _leftbg2.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _leftbg2.hidden = YES;
        [_bgView2 addSubview:_leftbg2];
        //-----------centerbg
        UIImageView * centerbg2 = [[UIImageView alloc]init];
        _centerbg2 = centerbg2;
        _centerbg2.tag = 2002;
//        _centerbg2.image = [UIImage imageNamed:@"51_ty"];
        _centerbg2.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _centerbg2.hidden = YES;
        [_bgView2 addSubview:_centerbg2];
        //-----------rightbg
        UIImageView * rightbg2 = [[UIImageView alloc]init];
        _rightbg2 = rightbg2;
        _rightbg2.tag = 4002;
//        _rightbg2.image = [UIImage imageNamed:@"51_yty-0"];
        _rightbg2.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _rightbg2.hidden = YES;
        [_bgView2 addSubview:_rightbg2];
        //-----------btn
        UIButton * btn2 = [[UIButton alloc]init];
        _btn2 = btn2;
        _btn2.tag = 1002;
        _btn2.frame = CGRectMake(4, 4, kLabelWidth-8, kLabelWidth-8);
        [_btn2.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btn2 setTitle:@"30" forState:UIControlStateNormal];
        [_bgView2 addSubview:_btn2];
        // ------- 下方剩余剩余
        UILabel *labLeft2 = UILabel.new;
        labLeft2.text = @"余:10";
        labLeft2.frame = CGRectMake(_btn2.left, _btn2.bottom + 2, _btn2.width, 20);
        self.labLeft2 = labLeft2;
        [_bgView2 addSubview:labLeft2];
        //-----------line2
        UIView * lineView2 = [[UIView alloc]init];
        _lineView2 = lineView2;
        _lineView2.frame = CGRectMake(0, kLabelWidth/2-0.5, kLabelWidth, 1);
        _lineView2.hidden = YES;
        [_bgView2 addSubview:_lineView2];
        
        
//        UIView * bgView3 = [[UIView alloc]initWithFrame:CGRectMake(2*kLabelWidth+10, y, kLabelWidth, kLabelHeight)];
        UIView * bgView3 = [[UIView alloc]initWithFrame:CGRectMake(2*kLabelWidth + 2, y, kLabelWidth, kLabelHeight)];

        _bgView3 = bgView3;
        [self addSubview:_bgView3];
        //-----------leftbg
        UIImageView * leftbg3 = [[UIImageView alloc]init];
        _leftbg3 = leftbg3;
        _leftbg3.tag = 3003;
//        _leftbg3.image = [UIImage imageNamed:@"51_zty-0"];
        _leftbg3.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _leftbg3.hidden = YES;
        [_bgView3 addSubview:_leftbg3];
        //-----------centerbg
        UIImageView * centerbg3 = [[UIImageView alloc]init];
        _centerbg3 = centerbg3;
        _centerbg3.tag = 2003;
//        _centerbg3.image = [UIImage imageNamed:@"51_ty"];
        _centerbg3.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _centerbg3.hidden = YES;
        [_bgView3 addSubview:_centerbg3];
        //-----------rightbg
        UIImageView * rightbg3 = [[UIImageView alloc]init];
        _rightbg3 = rightbg3;
        _rightbg3.tag = 4003;
//        _rightbg3.image = [UIImage imageNamed:@"51_yty-0"];
        _rightbg3.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _rightbg3.hidden = YES;
        [_bgView3 addSubview:_rightbg3];
        //-----------btn
        UIButton * btn3 = [[UIButton alloc]init];
        _btn3 = btn3;
        _btn3.tag = 1003;
        _btn3.frame = CGRectMake(4, 4, kLabelWidth-8, kLabelWidth-8);
        [_btn3.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_btn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btn3 setTitle:@"30" forState:UIControlStateNormal];
        [_bgView3 addSubview:_btn3];
        // ------- 下方剩余剩余
        UILabel *labLeft3 = UILabel.new;
        labLeft3.text = @"余:10";
        labLeft3.frame = CGRectMake(_btn2.left, _btn2.bottom + 2, _btn2.width, 20);
        self.labLeft3 = labLeft3;
        [_bgView3 addSubview:labLeft3];
        //-----------line3
        UIView * lineView3 = [[UIView alloc]init];
        _lineView3 = lineView3;
        _lineView3.frame = CGRectMake(0, kLabelWidth/2-0.5, kLabelWidth, 1);
        _lineView3.hidden = YES;
        [_bgView3 addSubview:_lineView3];

        
//        UIView * bgView4 = [[UIView alloc]initWithFrame:CGRectMake(3*kLabelWidth+10, y, kLabelWidth, kLabelHeight)];
        UIView * bgView4 = [[UIView alloc]initWithFrame:CGRectMake(3*kLabelWidth + 3, y, kLabelWidth, kLabelHeight)];

        _bgView4 = bgView4;
        [self addSubview:_bgView4];
        //-----------leftbg
        UIImageView * leftbg4 = [[UIImageView alloc]init];
        _leftbg4 = leftbg4;
        _leftbg4.tag = 3004;
//        _leftbg4.image = [UIImage imageNamed:@"51_zty-0"];
        _leftbg4.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _leftbg4.hidden = YES;
        [_bgView4 addSubview:_leftbg4];
        //-----------centerbg
        UIImageView * centerbg4 = [[UIImageView alloc]init];
        _centerbg4 = centerbg4;
        _centerbg4.tag = 2004;
//        _centerbg4.image = [UIImage imageNamed:@"51_ty"];
        _centerbg4.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _centerbg4.hidden = YES;
        [_bgView4 addSubview:_centerbg4];
        //-----------rightbg
        UIImageView * rightbg4 = [[UIImageView alloc]init];
        _rightbg4 = rightbg4;
        _rightbg4.tag = 4004;
//        _rightbg4.image = [UIImage imageNamed:@"51_yty-0"];
        _rightbg4.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _rightbg4.hidden = YES;
        [_bgView4 addSubview:_rightbg4];
        //-----------btn
        UIButton * btn4 = [[UIButton alloc]init];
        _btn4 = btn4;
        _btn4.tag = 1004;
        _btn4.frame = CGRectMake(4, 4, kLabelWidth-8, kLabelWidth-8);
        [_btn4.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_btn4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btn4 setTitle:@"40" forState:UIControlStateNormal];
        [_bgView4 addSubview:_btn4];
        //-----------line4
        UIView * lineView4 = [[UIView alloc]init];
        _lineView4 = lineView4;
        _lineView4.frame = CGRectMake(0, kLabelWidth/2-0.5, kLabelWidth, 1);
        _lineView4.hidden = YES;
        [_bgView4 addSubview:_lineView4];
        
        UILabel *labLeft4 = UILabel.new;
        labLeft4.text = @"余:10";
        labLeft4.frame = CGRectMake(_btn4.left, _btn4.bottom + 2, _btn4.width, 20);
        self.labLeft4 = labLeft4;
        [_bgView4 addSubview:labLeft4];
        
        
//        UIView * bgView5 = [[UIView alloc]initWithFrame:CGRectMake(4*kLabelWidth+10, y, kLabelWidth, kLabelHeight)];
        UIView * bgView5 = [[UIView alloc]initWithFrame:CGRectMake(4*kLabelWidth + 4, y, kLabelWidth, kLabelHeight)];

        _bgView5 = bgView5;
        [self addSubview:_bgView5];
        //-----------leftbg
        UIImageView * leftbg5 = [[UIImageView alloc]init];
        _leftbg5 = leftbg5;
        _leftbg5.tag = 3005;
//        _leftbg5.image = [UIImage imageNamed:@"51_zty-0"];
        _leftbg5.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _leftbg5.hidden = YES;
        [_bgView5 addSubview:_leftbg5];
        //-----------centerbg
        UIImageView * centerbg5 = [[UIImageView alloc]init];
        _centerbg5 = centerbg5;
        _centerbg5.tag = 2005;
//        _centerbg5.image = [UIImage imageNamed:@"51_ty"];
        _centerbg5.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _centerbg5.hidden = YES;
        [_bgView5 addSubview:_centerbg5];
        //-----------rightbg
        UIImageView * rightbg5 = [[UIImageView alloc]init];
        _rightbg5 = rightbg5;
        _rightbg5.tag = 4005;
//        _rightbg5.image = [UIImage imageNamed:@"51_yty-0"];
        _rightbg5.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _rightbg5.hidden = YES;
        [_bgView5 addSubview:_rightbg5];
        //-----------btn
        UIButton * btn5 = [[UIButton alloc]init];
        _btn5 = btn5;
        _btn5.tag = 1005;
        _btn5.frame = CGRectMake(4, 4, kLabelWidth-8, kLabelWidth-8);
        [_btn5.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_btn5 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btn5 setTitle:@"50" forState:UIControlStateNormal];
        [_bgView5 addSubview:_btn5];
        //-----------line5
        UIView * lineView5 = [[UIView alloc]init];
        _lineView5 = lineView5;
        _lineView5.frame = CGRectMake(0, kLabelWidth/2-0.5, kLabelWidth, 1);
        _lineView5.hidden = YES;
        [_bgView5 addSubview:_lineView5];
        

        
        UILabel *labLeft5 = UILabel.new;
        labLeft5.text = @"余:10";
        labLeft5.frame = CGRectMake(_btn5.left, _btn5.bottom + 2, _btn5.width, 20);
        self.labLeft5 = labLeft5;
        [_bgView5 addSubview:labLeft5];


        
        
//        UIView * bgView6 = [[UIView alloc]initWithFrame:CGRectMake(5*kLabelWidth+10, y, kLabelWidth, kLabelHeight)];
        UIView * bgView6 = [[UIView alloc]initWithFrame:CGRectMake(5*kLabelWidth + 5, y, kLabelWidth, kLabelHeight)];

        _bgView6 = bgView6;
        [self addSubview:_bgView6];
        //-----------leftbg
        UIImageView * leftbg6 = [[UIImageView alloc]init];
        _leftbg6 = leftbg6;
        _leftbg6.tag = 3006;
//        _leftbg6.image = [UIImage imageNamed:@"51_zty-0"];
        _leftbg6.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _leftbg6.hidden = YES;
        [_bgView6 addSubview:_leftbg6];
        //-----------centerbg
        UIImageView * centerbg6 = [[UIImageView alloc]init];
        _centerbg6 = centerbg6;
        _centerbg6.tag = 2006;
//        _centerbg6.image = [UIImage imageNamed:@"51_ty"];
        _centerbg6.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _centerbg6.hidden = YES;
        [_bgView6 addSubview:_centerbg6];
        //-----------rightbg
        UIImageView * rightbg6 = [[UIImageView alloc]init];
        _rightbg6 = rightbg6;
        _rightbg6.tag = 4006;
//        _rightbg6.image = [UIImage imageNamed:@"51_yty-0"];
        _rightbg6.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _rightbg6.hidden = YES;
        [_bgView6 addSubview:_rightbg6];
        //-----------btn
        UIButton * btn6 = [[UIButton alloc]init];
        _btn6 = btn6;
        _btn6.tag = 1006;
        _btn6.frame = CGRectMake(4, 4, kLabelWidth-8, kLabelWidth-8);
        [_btn6.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_btn6 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btn6 setTitle:@"60" forState:UIControlStateNormal];
        [_bgView6 addSubview:_btn6];
        //-----------line6
        UIView * lineView6 = [[UIView alloc]init];
        _lineView6 = lineView6;
        _lineView6.frame = CGRectMake(0, kLabelWidth/2-0.6, kLabelWidth, 1);
        _lineView6.hidden = YES;
        [_bgView6 addSubview:_lineView6];
        
        UILabel *labLeft6 = UILabel.new;
        labLeft6.text = @"余:10";
        labLeft6.frame = CGRectMake(_btn6.left, _btn6.bottom + 2, _btn6.width, 20);
        self.labLeft6 = labLeft6;
        [_bgView6 addSubview:labLeft6];
        
        
//        UIView * bgView7 = [[UIView alloc]initWithFrame:CGRectMake(6*kLabelWidth+10, y, kLabelWidth, kLabelHeight)];
        UIView * bgView7 = [[UIView alloc]initWithFrame:CGRectMake(6*kLabelWidth + 6, y, kLabelWidth, kLabelHeight)];

        _bgView7 = bgView7;
        [self addSubview:_bgView7];
        //-----------leftbg
        UIImageView * leftbg7 = [[UIImageView alloc]init];
        _leftbg7 = leftbg7;
        _leftbg7.tag = 3007;
//        _leftbg7.image = [UIImage imageNamed:@"51_zty-0"];
        _leftbg7.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _leftbg7.hidden = YES;
        [_bgView7 addSubview:_leftbg7];
        //-----------centerbg
        UIImageView * centerbg7 = [[UIImageView alloc]init];
        _centerbg7 = centerbg7;
        _centerbg7.tag = 2007;
//        _centerbg7.image = [UIImage imageNamed:@"51_ty"];
        _centerbg7.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _centerbg7.hidden = YES;
        [_bgView7 addSubview:_centerbg7];
        //-----------rightbg
        UIImageView * rightbg7 = [[UIImageView alloc]init];
        _rightbg7 = rightbg7;
        _rightbg7.tag = 4007;
//        _rightbg7.image = [UIImage imageNamed:@"51_yty-0"];
        _rightbg7.frame = CGRectMake(0, 0, kLabelWidth, kLabelWidth);
        _rightbg7.hidden = YES;
        [_bgView7 addSubview:_rightbg7];
        //-----------btn
        UIButton * btn7 = [[UIButton alloc]init];
        _btn7 = btn7;
        _btn7.tag = 1007;
        _btn7.frame = CGRectMake(4, 4, kLabelWidth-8, kLabelWidth-8);
        [_btn7.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_btn7 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btn7 setTitle:@"70" forState:UIControlStateNormal];
        [_bgView7 addSubview:_btn7];
        //-----------line7
        UIView * lineView7 = [[UIView alloc]init];
        _lineView7 = lineView7;
        _lineView7.frame = CGRectMake(0, kLabelWidth/2-0.7, kLabelWidth, 1);
        _lineView7.hidden = YES;
        [_bgView7 addSubview:_lineView7];
        
        UILabel *labLeft7 = UILabel.new;
        labLeft7.text = @"余:10";
        labLeft7.frame = CGRectMake(_btn7.left, _btn7.bottom + 2, _btn7.width, 20);
        self.labLeft7 = labLeft7;
        [_bgView7 addSubview:labLeft7];
        
        
        _bgView1.backgroundColor = [UIColor whiteColor];
        _bgView2.backgroundColor = [UIColor whiteColor];
        _bgView3.backgroundColor = [UIColor whiteColor];
        _bgView4.backgroundColor = [UIColor whiteColor];
        _bgView5.backgroundColor = [UIColor whiteColor];
        _bgView6.backgroundColor = [UIColor whiteColor];
        _bgView7.backgroundColor = [UIColor whiteColor];

        _bgView1.tag = 10001;
        _bgView2.tag = 10002;
        _bgView3.tag = 10003;
        _bgView4.tag = 10004;
        _bgView5.tag = 10005;
        _bgView6.tag = 10006;
        _bgView7.tag = 10007;

        _btn1.titleLabel.font = [UIFont systemFontOfSize:13];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:13];
        _btn3.titleLabel.font = [UIFont systemFontOfSize:13];
        _btn4.titleLabel.font = [UIFont systemFontOfSize:13];
        _btn5.titleLabel.font = [UIFont systemFontOfSize:13];
        _btn6.titleLabel.font = [UIFont systemFontOfSize:13];
        _btn7.titleLabel.font = [UIFont systemFontOfSize:13];

        
        _btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _btn2.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _btn3.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _btn4.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _btn5.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _btn6.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _btn7.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);

        labLeft1.textAlignment = NSTextAlignmentRight;
        labLeft2.textAlignment = NSTextAlignmentRight;
        labLeft3.textAlignment = NSTextAlignmentRight;
        labLeft4.textAlignment = NSTextAlignmentRight;
        labLeft5.textAlignment = NSTextAlignmentRight;
        labLeft6.textAlignment = NSTextAlignmentRight;
        labLeft7.textAlignment = NSTextAlignmentRight;
        
        labLeft1.textColor = RGBACOLOR(201, 202, 203, 1);
        labLeft2.textColor = RGBACOLOR(201, 202, 203, 1);
        labLeft3.textColor = RGBACOLOR(201, 202, 203, 1);
        labLeft4.textColor = RGBACOLOR(201, 202, 203, 1);
        labLeft5.textColor = RGBACOLOR(201, 202, 203, 1);
        labLeft6.textColor = RGBACOLOR(201, 202, 203, 1);
        labLeft7.textColor = RGBACOLOR(201, 202, 203, 1);

        labLeft1.font = [UIFont systemFontOfSize:11];
        labLeft2.font = [UIFont systemFontOfSize:11];
        labLeft3.font = [UIFont systemFontOfSize:11];
        labLeft4.font = [UIFont systemFontOfSize:11];
        labLeft5.font = [UIFont systemFontOfSize:11];
        labLeft6.font = [UIFont systemFontOfSize:11];
        labLeft7.font = [UIFont systemFontOfSize:11];

 
        _lineView1.backgroundColor = RGBACOLOR(20, 62, 159, 1);
        _lineView2.backgroundColor = RGBACOLOR(20, 62, 159, 1);
        _lineView3.backgroundColor = RGBACOLOR(20, 62, 159, 1);
        _lineView4.backgroundColor = RGBACOLOR(20, 62, 159, 1);
        _lineView5.backgroundColor = RGBACOLOR(20, 62, 159, 1);
        _lineView6.backgroundColor = RGBACOLOR(20, 62, 159, 1);
        _lineView7.backgroundColor = RGBACOLOR(20, 62, 159, 1);

        
    }
    return self;
}


@end
