//
//  HNAMedicalInstitutionCell.m
//  MedicalNet
//
//  Created by gengliming on 15/12/2.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAMedicalInstitutionCell.h"
#import "HNAHCReserveOrganTableView.h"
#import "UIView+HNA.h"

@interface HNAMedicalInstitutionCell()

@property (weak, nonatomic) IBOutlet UILabel *institutionNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addrButton;
@property (weak, nonatomic) IBOutlet UIButton *dialButton;
@property (weak, nonatomic) IBOutlet UIButton *openHourButton;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;

- (IBAction)addrButtonClicked:(UIButton *)sender;
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

#pragma mark - Custom Accessors
- (void)setModel:(HNAHCOrgan *)model {
    _model = model;
    
    self.checked = model.checked;
    self.institutionNameLabel.text = model.name;
    [self.addrButton setTitle:model.addr forState:UIControlStateNormal];
    [self.openHourButton setTitle:model.openHour forState:UIControlStateNormal];
}

- (void)setChecked: (BOOL)checked{
    _checked = checked;
    self.model.checked = checked;
    // 设置 checkBox
    self.checkButton.selected = checked;
}

- (BOOL)checked{
    return self.checkButton.isSelected;
}

#pragma mark - IBActions
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
    // 拼接打电话url
    NSString *phoneNum = self.model.phone;
    if (phoneNum==nil || [phoneNum isEqualToString:@""]) {
        phoneNum = @"10086";
    }
    NSString *urlStr = [NSString stringWithFormat:@"telprompt://%@", phoneNum];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}
/**
 *  打开地图
 */
- (IBAction)addrButtonClicked:(UIButton *)sender {
    [self.hna_viewController performSegueWithIdentifier:@"reserve2map" sender:nil];
}

@end
