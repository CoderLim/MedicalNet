//
//  HNAExpensesRecordsController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 医保报销纪录

#import "HNAExpensesRecordsController.h"
#import "HNAExpensesRecordCell.h"
#import "HNAGetExpenseRecordsResult.h"
#import "HNADatePickButton.h"
#import "HNAExpensesDetailController.h"

#import "HNAInsuranceTool.h"
#import "HNAGetExpenseRecordsParam.h"
#import "MBProgressHUD+MJ.h"
#import "HNAUserTool.h"
#import "HNAUser.h"

/**
 *  报销记录页跳转到记录详情
 */
#define ExpenseRecord2RecordDetailSegue @"expenseRecord2recordDetail"

@interface HNAExpensesRecordsController() <HNADatePickButtonDelegate>{
    NSDate *_selectedDate;
}
/**
 *  报销记录 数据
 */
@property (nonatomic,strong) NSMutableArray *records;

@property (nonatomic,strong) NSMutableArray *filterRecords;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet HNADatePickButton *datePickButton;
@end
@implementation HNAExpensesRecordsController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"报销记录";
    
    // 注册自定义Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAExpensesRecordCell" bundle:nil] forCellReuseIdentifier:RecordCellIdentifier];
}

#pragma mark - 数据
-(NSMutableArray *)records{
    if (_records == nil) {
        _records = [NSMutableArray array];
        //加载本月数据
        [self loadDataWithDate:nil];
    }
    return _records;
}
/**
 *  加载指定日期的数据
 */
- (void)loadDataWithDate:(NSDate *)date{
    [MBProgressHUD showMessage: MessageWhenLoadingData];
    // 1.参数
    HNAGetExpenseRecordsParam *param = [HNAGetExpenseRecordsParam param];
    
    if (date!=nil) {
        NSDateComponents *components = [date components];
        param.year = components.year;
        param.month = components.month;
    }
    
    // 2.请求数据
    WEAKSELF(weakSelf);
    [HNAInsuranceTool getExpenseRecordsWithParam:param success:^(HNAGetExpenseRecordsResult *result) {
        [weakSelf.records removeAllObjects];
        [weakSelf.records addObjectsFromArray: result.records];
        [self.tableView reloadData];
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"获取报销纪录失败:%@", error]];
    }];
    
    // 3.刷新表格
    [self.tableView reloadData];
}

#pragma mark - datePickButtonDelegate
- (void)datePickButton:(HNADatePickButton *)button dateChanged:(NSDate *)date{
    _selectedDate = date;
}

- (void)datePickButton:(HNADatePickButton *)button didFinishSelectDate:(NSDate *)date{
    [self loadDataWithDate:_selectedDate];
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HNAExpenseRecordModel *model;
    model = self.records[indexPath.row];
    HNAExpensesRecordCell *cell = [HNAExpensesRecordCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HNAExpenseRecordModel *model = self.records[indexPath.row];
    [self performSegueWithIdentifier:ExpenseRecord2RecordDetailSegue sender:model];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HNAExpensesDetailController *destVc = segue.destinationViewController;
    destVc.recordId = ((HNAExpenseRecordModel *)sender).id;
}
@end
