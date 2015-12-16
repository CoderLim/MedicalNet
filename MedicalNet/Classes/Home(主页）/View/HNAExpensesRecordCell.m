//
//  HNAExpensesRecordCell.m
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAExpensesRecordCell.h"

@interface HNAExpensesRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end
@implementation HNAExpensesRecordCell

- (void)setModel:(HNAExpenseRecordModel *)model{
    _model = model;
    
    self.totalAmountLabel.text = model.amount;
    self.dateLabel.text = model.date;
    self.stateLabel.text = model.status;
}

- (void)awakeFromNib{
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    HNAExpensesRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:RecordCellIdentifier];
    return cell;
}

@end
