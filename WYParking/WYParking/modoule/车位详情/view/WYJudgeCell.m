//
//  WYJudgeCell.m
//  WYParking
//
//  Created by glavesoft on 17/2/16.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYJudgeCell.h"
#import "WYStarView.h"
#import "wyModel_Park_detail.h"

@interface WYJudgeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *labUserLog;
@property (weak, nonatomic) IBOutlet UILabel *labJudgeContent;
@property (weak, nonatomic) IBOutlet UILabel *labTme;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labTime;

@property (weak, nonatomic) IBOutlet UILabel *labContent;

@property (weak , nonatomic) WYStarView *starView;

@end

@implementation WYJudgeCell
- (void)awakeFromNib {
    [super awakeFromNib];
    WYLog(@"awakeFromNib");
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self layoutIfNeeded];
    CGFloat w = self.width;
    self.labContent.preferredMaxLayoutWidth = w - 2 * 20 - 5;
    WYStarView *starView = WYStarView.new;
    [self.contentView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(41);
    }];
    self.starView = starView;
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
    WYJudgeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}



- (void)renderViewWithModel:(wyModelJudge *)model{
    [self.labUserLog setImageWithURL:[NSURL URLWithString:model.logo] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
    }];
    self.labTime.text = model.created_date;
    self.labName.text = model.username;
    self.labContent.text = model.content;
    [self.starView renderViewWithMark:model.star];
}

@end
