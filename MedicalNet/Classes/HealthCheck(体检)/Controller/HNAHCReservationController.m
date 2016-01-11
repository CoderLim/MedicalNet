//
//  HNAHCReservationController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/30.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 预约体检

#import "HNAHCReservationController.h"
#import "HNAHCReservePackageScrollView.h"
#import "HNAMedicalInstitutionCell.h"
#import "CKCalendarView.h"

#import "HNAGetPackageListParam.h"
#import "HNAGetPackageListResult.h"
#import "HNAGetHCOrganListParam.h"
#import "HNAGetHCOrganListResult.h"
#import "HNAHealthCheckTool.h"

#define NumberOfDefaultInstitutionDisplay 3

@interface HNAHCReservationController () <HNAHCReservePackageScrollViewDelegate>{
    // 标记tableView是否已经展开
    BOOL _tableViewExpanded;
}
@property (weak, nonatomic) IBOutlet CKCalendarView *calendarView;
@property (weak, nonatomic) IBOutlet HNAHCReservePackageScrollView *packageScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<HNAHCOrgan *> *medicalInstitutions;
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
    
    self.packageScrollView.delegate = self;
    // 加载package列表
    [self loadPackagesData];
}

- (NSMutableArray *)medicalInstitutions{
    if (_medicalInstitutions == nil) {
        _medicalInstitutions = [NSMutableArray array];
    }
    return _medicalInstitutions;
}

/**
 *  加载体检套餐列表数据
 */
- (void)loadPackagesData {
    [MBProgressHUD showMessage: MessageWhenLoadingData];
    
    HNAGetPackageListParam *param = [HNAGetPackageListParam param];
    [HNAHealthCheckTool getPackageListWithParam: param success:^(HNAGetPackageListResult *result) {
        [MBProgressHUD hideHUD];
        
        if (result != nil) {
            self.packageScrollView.items = result.packageList;
            for (NSInteger i=0; i<5; i++) {
                HNAPackageListItem *item = [[HNAPackageListItem alloc] init];
                item.packageId = [NSString stringWithFormat:@"%ld",(long)i];
                item.packageName = item.packageId;
                [self.packageScrollView addButtonWithModel:item];
            }
            [MBProgressHUD showSuccess: MessageWhenSuccess];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError: MessageWhenFaild];
    }];
}

/**
 *  加载医疗机构数据
 */
- (void)loadInstitutionsWithPackageId:(NSString *)packageId {
    HNAGetHCOrganListParam *param = [[HNAGetHCOrganListParam alloc] init];
    param.packageId = packageId;
    [HNAHealthCheckTool getHCOrganListWithParam:param success:^(HNAGetHCOrganListResult *result) {
        if (result.organs != nil) {
            self.medicalInstitutions = result.organs;
        }
        
        HNALog(@"--");
        [self.medicalInstitutions removeAllObjects];
        for (NSInteger i=0; i<10; i++) {
            HNAHCOrgan *organ = [[HNAHCOrgan alloc] init];
            organ.name = @"雍和宫医院";
            organ.addr = @"雍和航行园";
            organ.openHour = @"2015-10-1 10:30:00";
            [self.medicalInstitutions addObject:organ];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -  tableView 代理事件
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableViewExpanded ? self.medicalInstitutions.count: MIN(self.medicalInstitutions.count,NumberOfDefaultInstitutionDisplay);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HNAMedicalInstitutionCell *cell = [HNAMedicalInstitutionCell cellForTableView:tableView];
    cell.model = self.medicalInstitutions[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

/**
 *  tableView：医疗机构 查看更多
 */
- (IBAction)tableViewFooterClicked:(UIButton *)sender {
    _tableViewExpanded = YES;
    sender.enabled = NO;
    [self.tableView reloadData];
}

#pragma mark - HNAHCReservePackageScrollViewDelegate
- (void)packageScrollView:(HNAHCReservePackageScrollView *)scrollView didClickedAtIndex:(NSInteger)index {
    [self loadInstitutionsWithPackageId:[NSString stringWithFormat:@"%ld",(long)index]];
}
@end
