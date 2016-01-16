//
//  HNAProjectCell.m
//  MedicalNet
//
//  Created by gengliming on 15/12/9.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAProjectCell.h"

@interface HNAProjectCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@end
@implementation HNAProjectCell

- (void)setModel:(HNASecurityProgram *)model{
    _model = model;
    
    self.nameLabel.text = model.project;
    self.moneyLabel.text = model.amount;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
