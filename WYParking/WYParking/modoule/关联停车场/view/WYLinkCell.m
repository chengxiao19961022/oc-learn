//
//  WYLinkCell.m
//  WYParking
//
//  Created by glavesoft on 17/2/24.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "WYLinkCell.h"
#import "WYModelGuanLianCheWei.h"
#import <UIKit/UIKit.h>

@interface WYLinkCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewUserlogo;


@property (weak, nonatomic) IBOutlet UILabel *labAddress;

@property (strong, nonatomic) WYModelGuanLianCheWei *model;

@end

@implementation WYLinkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.btnGuanLian.layer.borderColor = RGBACOLOR(138, 161, 222, 1).CGColor;
    self.btnGuanLian.layer.borderWidth = 1.0f;
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    return [[self alloc] initWithTableView:tableView indexPath:indexPath];
}

- (instancetype)initWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    WYLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)renderViewWithModel:(WYModelGuanLianCheWei *)model{
    self.model = model;
    [self.imageViewUserlogo setImageWithURL:[NSURL URLWithString:model.logo] placeholder:KPlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        ;
    }];
    self.labAddress.text = model.building;
    
}
- (IBAction)btnGuanLIan:(id)sender {
    if (self.block) {
        self.block(_model);
    }
}

@end
