//
//  HNAHCReserveHospitalTableView.m
//  MedicalNet
//
//  Created by gengliming on 16/1/26.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAHCReserveOrganTableView.h"
#import "HNAGetHCOrganListResult.h"
#import "UIView+HNA.h"

#define NumberOfDefaultInstitutionDisplay 3
#define ExpandButtonFrame CGRectMake(0, 0, 100, 30)
#define BorderColor UIColorWithRGB(236, 236, 236).CGColor

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
    self.layer.borderWidth = 1;
    self.layer.borderColor = BorderColor;
    // 注册cell
    [self registerCell];
    
    // 默认不显示更多cell
    self.expanded = NO;
    
    // 设置tableFooterView
    UIButton *expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    expandButton.layer.borderWidth = 1;
    expandButton.layer.borderColor = BorderColor;
    [self setTitleAttributeString:@"查看更多" forButton:expandButton];
    expandButton.frame = ExpandButtonFrame;
    [expandButton addTarget:self action:@selector(expandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.tableFooterView = expandButton;
    self.expandButton = expandButton;
}

#pragma mark - Custom Accessors
- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    
    NSString *title = _expanded == YES?@"收起":@"查看更多";
    [self setTitleAttributeString:title forButton:self.expandButton];
}

- (void)setSelectedCell:(HNAMedicalInstitutionCell *)selectedCell {
    _selectedCell.checked = NO;
    _selectedCell = selectedCell;
    _selectedCell.checked = YES;
}

#pragma mark - Public
- (void)registerCell {
    [self registerNib:[UINib nibWithNibName:@"HNAMedicalInstitutionCell" bundle:nil] forCellReuseIdentifier:@"HNAMedicalInstitutionCell"];
}

#pragma mark - Private 
- (void)setTitleAttributeString:(NSString *)str forButton:(UIButton *)button {
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange titleRange = {0, title.length};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [title addAttribute:NSForegroundColorAttributeName value:UIColorWithRGB(234, 111, 75) range:titleRange];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:titleRange];
    [button setAttributedTitle:title forState:UIControlStateNormal];
}

#pragma mark - IBActions
- (IBAction)expandButtonClicked:(UIButton *)sender {
    self.expanded = !self.expanded;
    [self reloadData];
}

@end
