//
//  HNAMedicalInstitutionCell.m
//  MedicalNet
//
//  Created by gengliming on 15/12/2.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAMedicalInstitutionCell.h"
#import "HNAHCReserveOrganTableView.h"

@interface HNAMedicalInstitutionCell()
@property (weak, nonatomic) IBOutlet UILabel *institutionNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addrButton;
@property (weak, nonatomic) IBOutlet UIButton *dialButton;
@property (weak, nonatomic) IBOutlet UIButton *openHourButton;


@property (weak, nonatomic) IBOutlet UIButton *checkButton;
- (IBAction)dialButtonClicked:(UIButton *)sender;
- (IBAction)checkButton:(UIButton *)sender;
@end

@implementation HNAMedicalInstitutionCell

+ (instancetype)cellForTableView:(HNAHCReserveOrganTableView *)tableView {
    static NSString *identifier = @"HNAMedicalInstitutionCell";
    HNAMedicalInstitutionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak __typeof(HNAMedicalInstitutionCell*) weakCell = cell;
    cell.selectedBlock = ^{
        tableView.selectedCell = weakCell;
    };
    return cell;
}

- (void)setModel:(HNAHCOrgan *)model {
    _model = model;
    
    self.institutionNameLabel.text = model.name;
    [self.addrButton setTitle:model.addr forState:UIControlStateNormal];
    [self.openHourButton setTitle:model.openHour forState:UIControlStateNormal];
}

- (void)setChecked:(BOOL)checked{
    _checked = checked;
    // 设置 checkBox
    self.checkButton.selected = checked;
}

- (BOOL)checked{
    return self.checkButton.isSelected;
}

#pragma mark - 单击事件
/**
 *  选中
 */
- (IBAction)checkButton:(UIButton *)sender {
    self.checked = !sender.isSelected;
    
    if (self.selectedBlock != nil) {
        self.selectedBlock();
    }
}
/**
 *  打电话
 */
- (IBAction)dialButtonClicked:(UIButton *)sender {
    HNALog(@"打电话");
    // 拼接打电话url
    NSString *urlStr = [NSString stringWithFormat:@"telprompt://%@", @"10086"];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}
@end
