//
//  HNAHCReservationController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/30.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 预约体检

#import "HNAHCReservationController.h"
#import "HNAHCPackageDetailController.h"
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

#import "HNAHCReserveOrganTableView.h"

#define NumberOfDefaultInstitutionDisplay 3

#define CKCalendarDisableLegendColor UIColorWithRGB(228.0f, 228.0f, 228.0f)
#define CKCalendarEnableLegendColor [UIColor whiteColor]
#define CKCalendarSelectedLegendColor UIColorWithRGB(255.0f, 153.0f, 153.0f)

// 跳转到 套餐详情
#define HCReserve2HCPackageSegue @"hcReserve2hcPackage"

@interface HNAHCReservationController () <UITableViewDataSource,UITableViewDelegate,HNAHCReservePackageScrollViewDelegate, CKCalendarDelegate>

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
@property (weak, nonatomic) IBOutlet HNAHCReserveOrganTableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_H;
/**
 *  体检机构数据
 */
@property (strong, nonatomic) NSMutableArray<HNAHCOrgan *> *medicalInstitutions;
/**
 *  选择的体检日期
 */
@property (nonatomic, copy) NSString *selectedDate;
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
    // 注册Cell
    [self.tableView registerCell];
    
    // 添加监听contentSize
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark -
- (NSString *)selectedDate {
    if (self.calendarView.selectedDate != nil) {
        return [self.calendarView.selectedDate stringWithFormat:@"yyyy-MM-dd"];
    }
    return nil;
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
        if (result != nil && result.success == HNARequestResultSUCCESS) {
            self.packageScrollView.models = result.packageList;
            for (NSInteger i=0; i<5; i++) {
                HNAPackageListItem *item = [[HNAPackageListItem alloc] init];
                item.packageId = i + 1000;
                item.packageName = [NSString stringWithFormat:@"TC%ld",(long)i];
                [self.packageScrollView addItemWithModel:item];
            }
            // 选中第一条
            [self.packageScrollView selectAtIndex:0];
            [self loadInstitutionsWithPackageId:self.packageScrollView.selectedPackageId];
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
- (void)loadInstitutionsWithPackageId:(NSInteger)packageId {
    // 重新加载
    HNAGetHCOrganListParam *param = [[HNAGetHCOrganListParam alloc] init];
    param.packageId = packageId;
    [HNAHealthCheckTool getHCOrganListWithParam:param success:^(HNAGetHCOrganListResult *result) {
        if (result.success==HNARequestResultSUCCESS && result.organList != nil) {
            self.medicalInstitutions = result.organList;
            [self.medicalInstitutions firstObject].checked = YES;
            
            [self.medicalInstitutions removeAllObjects];
            for (NSInteger i=0; i<2+self.packageScrollView.selectedPackageId; i++) {
                HNAHCOrgan *organ = [[HNAHCOrgan alloc] init];
                organ.id = [NSString stringWithFormat:@"%ld",(long)i];
                organ.name = @"雍和宫医院";
                organ.addr = @"雍和航行园";
                organ.openHour = @"2015-10-1 10:30:00";
                [self.medicalInstitutions addObject:organ];
            }
            
            [self.medicalInstitutions firstObject].checked = YES;
            self.tableView.expanded = NO;
            // 刷新表格
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求错误"];
    }];
}

#pragma mark -  tableView 代理事件
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableView.expanded ? self.medicalInstitutions.count: MIN(self.medicalInstitutions.count,NumberOfDefaultInstitutionDisplay);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HNAMedicalInstitutionCell *cell = [HNAMedicalInstitutionCell cellForTableView:tableView];
    // 设置数据
    cell.model = self.medicalInstitutions[indexPath.row];

    if (cell.model.checked) {
        self.tableView.selectedCell = cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row <= NumberOfDefaultInstitutionDisplay) {
        return;
    }
    CGRect toframe = cell.frame;
    CGRect fromFrame = toframe;
    fromFrame.origin.x = -toframe.size.width;
    cell.frame = fromFrame;
    [UIView animateWithDuration:0.5f animations:^{
        cell.frame = toframe;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

#pragma mark - HNAHCReservePackageScrollViewDelegate
- (BOOL)packageScrollView:(HNAHCReservePackageScrollView *)scrollView willClickAtIndex:(NSInteger)index {
    NSString *packageIdStr = [NSString stringWithFormat:@"%ld",[scrollView packageIdAtIndex:index]];
    [self performSegueWithIdentifier:HCReserve2HCPackageSegue sender: packageIdStr];
    return NO;
}

#pragma mark - CKCalendarViewDelegate 
/**
 *  控制日期是否可选
 */
- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    if (date != nil) {
        if ([self canSelectTheDate:date]) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}
/**
 *  选择日期后
 */
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
}
/**
 *  配置
 */
- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    if (date != nil) {
        if ([self canSelectTheDate:date]) {
            dateItem.backgroundColor = CKCalendarEnableLegendColor;
            dateItem.selectedBackgroundColor = CKCalendarSelectedLegendColor;
        } else {
            dateItem.backgroundColor = CKCalendarDisableLegendColor;
            dateItem.selectedBackgroundColor = CKCalendarDisableLegendColor;
        }
    }
}
/**
 *  判断该日期是否可选
 */
- (BOOL)canSelectTheDate:(NSDate *)date {
    return [date compare:[NSDate date]] == NSOrderedDescending
            || [date isEqualYMDTo:[NSDate date]];
}

#pragma mark - 按钮事件
- (IBAction)submit:(id)sender {
    [MBProgressHUD showMessage:@"正在提交..."];
    // 参数
    HNAReserveHCParam *param = [HNAReserveHCParam param];
    param.packageId = self.packageScrollView.selectedPackageId;
    param.organId = self.tableView.selectedCell.model.id;
    param.reserveDate = self.selectedDate;
    // 网络请求
    [HNAHealthCheckTool reserveHCWithParam:param success:^(HNAReserveHCResult *result) {
        [MBProgressHUD hideHUD];
        if (result != nil) {
            [MBProgressHUD showSuccess: @"申请成功"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError: @"申请失败"];
    }];
}

#pragma mark -
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: HCReserve2HCPackageSegue]) {
        HNAHCPackageDetailController *packageVc = segue.destinationViewController;
        packageVc.type = HNAHCPackageDetailControllerChoose;
        packageVc.packageId = [sender integerValue];
        packageVc.selectBlock = ^(NSInteger packageId){
            [self.packageScrollView selectWithPackageId: packageId];
            // 加载套餐对应的体检机构
            [self loadInstitutionsWithPackageId: packageId];
        };
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString: @"contentSize"]) {
        CGSize contentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
        self.tableView_H.constant = contentSize.height;
    }
}
- (void)dealloc {
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    HNALog(@"%s", __FUNCTION__);
}

@end
