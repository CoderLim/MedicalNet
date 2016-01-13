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
#import "HNAReserveHCParam.h"
#import "HNAReserveHCResult.h"
#import "HNAHealthCheckTool.h"

#define NumberOfDefaultInstitutionDisplay 3

#define CKCalendarDisableLegendColor UIColorWithRGB(228.0f, 228.0f, 228.0f)
#define CKCalendarEnableLegendColor [UIColor whiteColor]
#define CKCalendarSelectedLegendColor UIColorWithRGB(255.0f, 153.0f, 153.0f)

@interface HNAHCReservationController () <UITableViewDataSource,UITableViewDelegate,HNAHCReservePackageScrollViewDelegate, CKCalendarDelegate>{
    // 标记tableView是否已经展开
    BOOL _tableViewExpanded;
}
/**
 *  日历
 */
@property (weak, nonatomic) IBOutlet CKCalendarView *calendarView;
/**
 *  套餐列表
 */
@property (weak, nonatomic) IBOutlet HNAHCReservePackageScrollView *packageScrollView;
/**
 *  体检机构 tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_H;
/**
 *  体检机构数据
 */
@property (strong, nonatomic) NSMutableArray<HNAHCOrgan *> *medicalInstitutions;

/**
 *  选择的套餐id
 */
@property (nonatomic, copy) NSString *selectedPackageId;
/**
 *  选择的体检机构cell
 */
@property (nonatomic, weak) HNAMedicalInstitutionCell *selectedInstitutionCell;
/**
 *  选择的体检日期
 */
@property (nonatomic, copy) NSString *selectedDate;

/**
 *  体检机构（tableView）展开更多
 */
- (IBAction)tableViewFooterClicked:(UIButton *)sender;

/**
 *  提交 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submit:(id)sender;
@end

@implementation HNAHCReservationController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    
    // 设置calendarView
    [self setupCalendarView];
    
    // 加载“体检套餐”列表
    [self loadPackagesData];
}

/**
 *  设置套餐列表
 */
- (void)setupPackageScrollView {
}
/**
 *  设置日历
 */
- (void)setupCalendarView {
    self.calendarView.delegate = self;
    self.calendarView.backgroundColor = [UIColor lightGrayColor];
    self.calendarView.locale = [NSLocale currentLocale];
    
    self.calendarView.disableLegendColor = CKCalendarDisableLegendColor;
    self.calendarView.enableLegendColor = CKCalendarEnableLegendColor;
    self.calendarView.selectedLegendColor = CKCalendarSelectedLegendColor;
    
    // 默认选中当天
    [self.calendarView selectDate:[NSDate date] makeVisible:YES];
}
/**
 *  设置tableView
 */
- (void)setupTableView {
    // tableView
    _tableViewExpanded = NO;
    
    // 注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAMedicalInstitutionCell" bundle:nil] forCellReuseIdentifier:@"HNAMedicalInstitutionCell"];
    
    // 添加监听contentSize
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 
- (NSString *)selectedOrganId {
    return nil;
}

- (NSString *)selectedDate {
    if (self.calendarView.selectedDate != nil) {
        return [self.calendarView.selectedDate stringWithFormat:@"yyyy-MM-dd"];
    }
    return nil;
}

- (void)setSelectedInstitutionCell:(HNAMedicalInstitutionCell *)selectedInstitutionCell {
    _selectedInstitutionCell = selectedInstitutionCell;
    selectedInstitutionCell.checked = YES;
}

#pragma mark - 数据
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
            self.packageScrollView.modelItems = result.packageList;
            for (NSInteger i=0; i<5; i++) {
                HNAPackageListItem *item = [[HNAPackageListItem alloc] init];
                item.packageId = [NSString stringWithFormat:@"%ld",(long)i];
                item.packageName = item.packageId;
                [self.packageScrollView addButtonWithModel:item];
            }
            // 选中第一条
            [self.packageScrollView itemClicked:nil];
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
    // 设置数据
    cell.model = self.medicalInstitutions[indexPath.row];
    // 设置block（更新当前选中的cell）
    WEAKSELF(weakSelf);
    __weak __typeof(HNAMedicalInstitutionCell*) weakCell = cell;
    cell.selectedBlock = ^{
        weakSelf.selectedInstitutionCell.checked = NO;
        weakSelf.selectedInstitutionCell = weakCell;
    };
    
    if (indexPath.row == 0) {
        self.selectedInstitutionCell = cell;
    }
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
    self.selectedPackageId = scrollView.selectedPackageId;
    // 加载套餐对应的体检机构
    [self loadInstitutionsWithPackageId:[NSString stringWithFormat:@"%ld",(long)index]];
}

#pragma mark - CKCalendarViewDelegate 
/**
 *  控制日期是否可选
 */
- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    if (date != nil) {
        if ([self canSelectedTheDate:date]) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}
/**
 *  选择日期
 */
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
//    HNALog(@"%s", __FUNCTION__);
//    self.selectedDate = [date stringWithFormat:@"yyyy-MM-dd"];
}
/**
 *  配置
 */
- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    if (date != nil) {
        if ([self canSelectedTheDate:date]) {
            dateItem.backgroundColor = CKCalendarEnableLegendColor;
            dateItem.selectedBackgroundColor = CKCalendarSelectedLegendColor;
        } else {
            dateItem.backgroundColor = CKCalendarDisableLegendColor;
            dateItem.selectedBackgroundColor = CKCalendarDisableLegendColor;
        }
    }
}
/**
 *  自定义：判断该日期是否可选
 */
- (BOOL)canSelectedTheDate:(NSDate *)date {
    return [date compare:[NSDate date]] == NSOrderedDescending
            || [date isEqualYMDTo:[NSDate date]];
}

#pragma mark - 
- (IBAction)submit:(id)sender {
    [MBProgressHUD showMessage:@""];
    // 参数
    HNAReserveHCParam *param = [HNAReserveHCParam param];
    param.packageId = self.selectedPackageId;
    param.organId = self.selectedInstitutionCell.model.id;
    param.reserveDate = self.selectedDate;
    
    // 网络请求
    [HNAHealthCheckTool reserveHCWithParam:param success:^(HNAReserveHCResult *result) {
        if (result != nil) {
            [MBProgressHUD showSuccess: MessageWhenSuccess];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError: MessageWhenFaild];
    }];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString: @"contentSize"]) {
        CGSize contentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
        self.tableView_H.constant = contentSize.height;
        [UIView animateWithDuration:0.25f animations:^{
            [self.view layoutIfNeeded];
        }];
        
    }
}

- (void)dealloc {
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}
@end
