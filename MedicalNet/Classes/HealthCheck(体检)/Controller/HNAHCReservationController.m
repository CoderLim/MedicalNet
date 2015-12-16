//
//  HNAHCReservationController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/30.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 预约体检

#import "HNAHCReservationController.h"
#import "HNAPackageButtonScrollView.h"
#import "HNAMedicalInstitutionCell.h"
#import "CKCalendarView.h"

#define NumberOfDefaultInstitutionDisplay 3

@interface HNAHCReservationController () {
    // 标记tableView是否已经展开
    BOOL _tableViewExpanded;
}
@property (weak, nonatomic) IBOutlet CKCalendarView *calendarView;
@property (weak, nonatomic) IBOutlet HNAPackageButtonScrollView *packageBtnScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *medicalInstitutions;
- (IBAction)tableViewFooterClicked:(UIButton *)sender;

@end

@implementation HNAHCReservationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // tableView
    _tableViewExpanded = NO;
    // 注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAMedicalInstitutionCell" bundle:nil] forCellReuseIdentifier:@"HNAMedicalInstitutionCell"];
    
    // 设置calendarView
    self.calendarView.backgroundColor = [UIColor lightGrayColor];
    self.calendarView.locale = [NSLocale currentLocale];
    
    // 添加button 到 packageBtnScrollView
    NSMutableArray *buttons = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor lightGrayColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"1341" forState:UIControlStateNormal];
        [buttons addObject:button];
    }
    self.packageBtnScrollView.items = buttons;
}

- (NSMutableArray *)medicalInstitutions{
    if (_medicalInstitutions == nil) {
        _medicalInstitutions = [NSMutableArray array];
    }
    return _medicalInstitutions;
}
/**
 *  tableView：医疗机构 查看更多
 */
- (IBAction)tableViewFooterClicked:(UIButton *)sender {
    _tableViewExpanded = YES;
    sender.enabled = NO;
    [self.tableView reloadData];
}

#pragma mark -  tableView 代理事件
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableViewExpanded?self.medicalInstitutions.count:NumberOfDefaultInstitutionDisplay;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"HNAMedicalInstitutionCell";
    HNAMedicalInstitutionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
@end
