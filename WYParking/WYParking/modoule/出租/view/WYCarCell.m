//
//  WYCarCell.m
//  WYParking
//
//  Created by glavesoft on 17/2/15.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYCarCell.h"
#import "WYModelMineSpot.h"

@interface WYCarCell ()
@property (weak, nonatomic) IBOutlet UILabel *labPark_title;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPark;


@end

@implementation WYCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    WYCarCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)renderViewWithModel:(WYModelMineSpot *)model{
    self.labPark_title.text = model.park_title;
    if ([model.is_success isEqualToString:@"1"]&&[model.is_pass isEqualToString:@"1"]) {
        self.labStatus.text = @"审核通过";
        self.labStatus.hidden = YES;
    }else if ([model.is_success isEqualToString:@"1"]&&[model.is_pass isEqualToString:@"0"]){
         self.labStatus.text = @" 审核中 ";
        self.labStatus.hidden = NO;
        self.labStatus.backgroundColor = [UIColor orangeColor];
    }else{
        self.labStatus.text = @" 审核失败 ";
        self.labStatus.backgroundColor = [UIColor redColor];
        self.labStatus.hidden = NO;
    }
    [self.imageViewPark setImageWithURL:[NSURL URLWithString:model.pic] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
    }];
}


@end
