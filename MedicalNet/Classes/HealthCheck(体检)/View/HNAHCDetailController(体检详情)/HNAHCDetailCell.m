//
//  HNAHCDetailCell.m
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAHCDetailCell.h"
#import "HNAHCReportController.h"

@interface HNAHCDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *descButton;
- (IBAction)descButtonClicked:(UIButton *)sender;

@end

@implementation HNAHCDetailCell

- (void)setModel:(HNAHCStatusRecord *)model {
    [super setModel:model];

    self.dateLabel.text = model.date;
    [self.descButton setTitle:model.desc forState:UIControlStateNormal];
}

+ (NSString *)getIdentifier {
    static NSString *identifier = @"HNAHCDetailCell";
    return identifier;
}

+ (instancetype)cellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HNAHCDetailCell *cell = [super cellForTableView:tableView withIndexPath:indexPath];
    cell.descBlock = nil;
    return cell;
}

+ (instancetype)cellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath descBlock:(HNAHCDetailCellBtnClicked)descBlock {
    HNAHCDetailCell *cell = [super cellForTableView:tableView withIndexPath:indexPath];
    cell.descBlock = descBlock;
    return cell;
}

- (IBAction)descButtonClicked:(UIButton *)sender {
    [super descBtnClicked:sender];
    
    if (self.descBlock != nil) {
        self.descBlock();
    }
}

@end
