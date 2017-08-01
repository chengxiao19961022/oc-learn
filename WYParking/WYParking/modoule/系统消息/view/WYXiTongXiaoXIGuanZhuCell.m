//
//  WYXiTongXiaoXIGuanZhuCell.m
//  WYParking
//
//  Created by glavesoft on 17/3/6.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYXiTongXiaoXIGuanZhuCell.h"
#import "WYModelMessage.h"

@interface WYXiTongXiaoXIGuanZhuCell ()
@property (weak, nonatomic) IBOutlet UILabel *labIsRead;
@property (weak, nonatomic) IBOutlet UILabel *labTIme;
@property (weak, nonatomic) IBOutlet UILabel *labUser;

@end

@implementation WYXiTongXiaoXIGuanZhuCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.labIsRead.layer.cornerRadius = 2.0f;
    self.labIsRead.layer.masksToBounds = YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    return [[self alloc] initWithTableView:tableView indexPath:indexPath];
}

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    WYXiTongXiaoXIGuanZhuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}



- (void)renderViewWithModel:(WYModelMessage *)model{
    self.labTIme.text = model.add_time;
    self.labUser.text = model.username;
    
    
    //    self.labIsRead.hidden = [model.is_read boolValue];
    if ([model.is_deal isEqualToString:@"0"]) {
        self.labIsRead.hidden = YES;
    }else{
        self.labIsRead.hidden = NO;
    }
}
@end
