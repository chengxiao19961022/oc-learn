//
//  wyReasonCell.m
//  TheGenericVersion
//
//  Created by glavesoft on 16/9/6.
//  Copyright © 2016年 李杰. All rights reserved.
//

#import "wyReasonCell.h"
#import "wyModelReason.h"

@interface wyReasonCell ()
@property (weak, nonatomic) IBOutlet UILabel *labReason;
@property (weak, nonatomic) IBOutlet UIButton *btnState;

@end

@implementation wyReasonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
     [self.btnState setImage:[UIImage imageNamed:@"51Reason_0"] forState:UIControlStateNormal];
     [self.btnState setImage:[UIImage imageNamed:@"51Reason_1"] forState:UIControlStateSelected];
    self.btnState.userInteractionEnabled = NO;
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    return [[self alloc] initWithTableView:tableView indexPath:indexPath];
}


- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    wyReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)renderViewWithModel:(wyModelReason *)model{
    self.labReason.text = model.content;
    self.btnState.selected = model.isSelected;
   
}

@end
