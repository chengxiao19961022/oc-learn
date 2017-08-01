//
//  WYJiaGeCell.m
//  WYParking
//
//  Created by glavesoft on 17/2/21.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYJiaGeCell.h"
#import "WYModelJiaGe.h"

@interface WYJiaGeCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *lineMiddle;
@property (weak, nonatomic) IBOutlet UILabel *labTypeName;
@property (weak, nonatomic) IBOutlet UIImageView *arroImage;
@property (weak, nonatomic) IBOutlet UITextField *TFPrice;

@property (weak, nonatomic) IBOutlet UIView *lineBottom;//下面的那条线

@property (strong , nonatomic) WYModelJiaGe *model;
@property (strong , nonatomic) NSIndexPath *indexpath;

@end

@implementation WYJiaGeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.TFPrice.delegate = self;
     [self.isOnSwitch addTarget:self action:@selector(switchClickWithIndexPath:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    return [[self alloc] initWithTableView:tableView indexPath:indexPath];
}

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    WYJiaGeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
   
    cell.indexpath = indexPath;
    return cell;
}



- (void)renderViewWithModel:(WYModelJiaGe *)model{
    if (model) {
        self.model = model;
    }
    self.labTypeName.text = model.typeName;
    self.TFPrice.text = model.price;
    [self.isOnSwitch setOn:model.isOn];
    if (!self.isOnSwitch.isOn) {
        //开关关闭
        self.TFPrice.hidden =  self.arroImage.hidden =  self.lineMiddle.hidden = YES;
    }else{
        self.TFPrice.hidden = self.arroImage.hidden = self.lineMiddle.hidden = NO;
    }
    
}
- (void)switchClickWithIndexPath:(UISwitch *)sender{
    
    self.model.isOn = !self.model.isOn;
    if (self.jiageBlock) {
        self.jiageBlock(self.model,_indexpath);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *str = textField.text;
    
    if (str.length != 0) {
        self.model.price = str;
        if (self.jiageBlock) {
            self.jiageBlock(self.model,_indexpath);
        }
    }
   
}



@end
