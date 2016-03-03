//
//  HNAHCCheckedCell.m
//  MedicalNet
//
//  Created by gengliming on 16/1/11.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAHCCheckedCell.h"

@interface HNAHCCheckedCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation HNAHCCheckedCell

#pragma mark - SuperClass
- (void)setModel:(HNAHCStatusRecord *)model {
    [super setModel:model];
    self.dateLabel.text = model.date;
    self.descLabel.text = model.desc;
}

+ (NSString *)getIdentifier {
    static NSString *identifier = @"HNAHCCheckedCell";
    return identifier;
}

+ (instancetype)cellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath {
    HNAHCCheckedCell *cell = [super cellForTableView:tableView withIndexPath:indexPath];
    return cell;
}

@end
