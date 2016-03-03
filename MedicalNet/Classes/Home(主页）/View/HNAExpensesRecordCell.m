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

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Custom Accessors
- (void)setModel:(HNAExpenseRecordModel *)model{
    _model = model;
    
    self.totalAmountLabel.text = model.amount;
    self.dateLabel.text = model.date;
    self.stateLabel.text = model.status;
}

#pragma mark - Public
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    HNAExpensesRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:RecordCellIdentifier];
    return cell;
}

@end
