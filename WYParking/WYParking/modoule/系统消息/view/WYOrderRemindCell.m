//
//  WYOrderRemindCell.m
//  WYParking
//
//  Created by glavesoft on 17/3/6.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYOrderRemindCell.h"
#import "WYModelMessage.h"

@interface WYOrderRemindCell ()
@property (weak, nonatomic) IBOutlet UILabel *labIsRead;
@property (weak, nonatomic) IBOutlet UILabel *labTIme;

@end

@implementation WYOrderRemindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self layoutIfNeeded];
    self.labContent.preferredMaxLayoutWidth = self.width - 2 * 10;
    self.labContent.numberOfLines = 0;
    self.labIsRead.layer.cornerRadius = 2.0f;
    self.labIsRead.layer.masksToBounds = YES;
    
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    return [[self alloc] initWithTableView:tableView indexPath:indexPath];
}

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    WYOrderRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}



- (void)renderViewWithModel:(WYModelMessage *)model{
    self.labContent.text = model.content;
    
//    self.labIsRead.hidden = [model.is_read boolValue];

    if ([model.is_read isEqualToString:@"0"]) {
        self.labIsRead.hidden = NO;
    }else{
        self.labIsRead.hidden = YES;
    }
    
    self.labTIme.text = model.add_time;
}

@end
