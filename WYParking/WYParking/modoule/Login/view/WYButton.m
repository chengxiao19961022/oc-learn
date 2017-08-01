//
//  WYButton.m
//  WYParking
//
//  Created by Leon on 17/2/7.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "WYButton.h"

@interface WYButton ()

#pragma mark - private property
@property (copy , nonatomic) NSString *normalTitle;

@property (copy , nonatomic) NSString *SelectedTitle;

@property (weak , nonatomic) UIImage *normalImage;

@property (weak , nonatomic) UIImage *selectedImage;

@end

@implementation WYButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){

    }
    return self;
}



- (void)renderWithNormalTitle:(NSString *)normalTitle SelectedTitle:(NSString *)selectedTitle normalImage:(UIImage *)normalImag SelectedImage:(UIImage *)SelectedImage{
    UILabel *LabTitle = UILabel.new;
    LabTitle.text = @"Button";
    [self addSubview:LabTitle];
    LabTitle.font = [UIFont systemFontOfSize:15];
    self.LabTitle = LabTitle;
    self.LabTitle.textColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;
    //只有文字的时候
    if (!(!normalTitle||[normalTitle isEqualToString:@""])&&(normalImag == nil || SelectedImage == nil)) {
        [LabTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
    }
    //只有图片的时候
    if ((normalImag != nil && SelectedImage != nil)&&(normalTitle == nil || selectedTitle == nil)) {
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
   
    self.normalImage = normalImag;
    self.selectedImage = SelectedImage;
    self.normalTitle = normalTitle;
    self.SelectedTitle = selectedTitle;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        //选中状态
        if (self.LabTitle) {
            self.LabTitle.text = self.SelectedTitle ?:@"";
        }
        if (self.imageView) {
             self.imageView.image = self.selectedImage;
        }
       
    }else{
        if (self.LabTitle) {
           self.LabTitle.text = self.normalTitle ?:@"";
        }
        if (self.imageView) {
            self.imageView.image = self.normalImage;
        }
        
    }
}

@end
