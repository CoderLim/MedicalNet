//
//  HNAHCReserveHospitalTableView.m
//  MedicalNet
//
//  Created by gengliming on 16/1/26.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAHCReserveOrganTableView.h"
#import "HNAGetHCOrganListResult.h"

#define NumberOfDefaultInstitutionDisplay 3

@interface HNAHCReserveOrganTableView()
@property (weak, nonatomic) IBOutlet UIButton *expandButton;
- (IBAction)expandButtonClicked:(UIButton *)sender;
@end
@implementation HNAHCReserveOrganTableView

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
    [self registerCell];
    self.expanded = NO;
}
#pragma mark - 覆盖
- (void)reloadData {
    [super reloadData];
}

#pragma mark - 公开方法
- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    
    NSString *title = _expanded == YES?@"收起":@"展开";
    [self.expandButton setTitle:title forState:UIControlStateNormal];
}

- (void)setSelectedCell:(HNAMedicalInstitutionCell *)selectedCell {
    _selectedCell.checked = NO;
    _selectedCell = selectedCell;
    _selectedCell.checked = YES;
}

- (void)registerCell {
    [self registerNib:[UINib nibWithNibName:@"HNAMedicalInstitutionCell" bundle:nil] forCellReuseIdentifier:@"HNAMedicalInstitutionCell"];
}
#pragma mark - 单击事件
- (IBAction)expandButtonClicked:(UIButton *)sender {
    self.expanded = !self.expanded;
    [self reloadData];
}
@end
