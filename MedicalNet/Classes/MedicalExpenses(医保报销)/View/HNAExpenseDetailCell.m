//
//  HNAMedicalExpenseDetailCell.m
//  MedicalNet
//
//  Created by gengliming on 15/12/21.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAExpenseDetailCell.h"
#import "UILabel+HNA.h"

@interface HNAExpenseDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLabel_H;
@end
@implementation HNAExpenseDetailCell

- (void)setModel:(HNAExpenseDetailStatusRecord *)model{
    _model = model;
    
    self.dateLabel.text = _model.date;
    self.statusLabel.text = _model.desc;
}

- (void)setShowTip:(BOOL)showTip{
    _showTip = showTip;
    
    self.tipLabel_H.constant = showTip ? [self.tipLabel correctHeight] : 0;
    [self layoutIfNeeded];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"HNAExpenseDetailCell";
    HNAExpenseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    return cell;
}

- (void)awakeFromNib {
}

@end
