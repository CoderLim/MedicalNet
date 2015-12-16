//
//  HNAMedicalInstitutionCell.m
//  MedicalNet
//
//  Created by gengliming on 15/12/2.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAMedicalInstitutionCell.h"

@interface HNAMedicalInstitutionCell()

@property (weak, nonatomic) IBOutlet UIButton *checkButton;
- (IBAction)dialButtonClicked:(UIButton *)sender;
- (IBAction)checkButton:(UIButton *)sender;

@end
@implementation HNAMedicalInstitutionCell

- (void)awakeFromNib {
}


- (void)setChecked:(BOOL)checked{
    _checked = checked;
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
    sender.selected = !sender.isSelected;
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
