//
//  HNAExpensesRecordsController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAExpensesRecordsController_old.h"
#import "HNAExpensesRecordCell.h"
#import "HNAExpenseRecordModel.h"

@interface HNAExpensesRecordsController_old() <UISearchDisplayDelegate>
@property (nonatomic,strong) NSMutableArray *records;
@property (nonatomic,strong) NSMutableArray *filterRecords;
@end
@implementation HNAExpensesRecordsController_old

-(void)viewDidLoad{
    [super viewDidLoad];
    // 设置navigationItem
    self.navigationItem.title = @"医保报销记录";
    
    // 设置searchBar数据源和代理
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    
    // 注册自定义Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAExpensesRecordCell" bundle:nil] forCellReuseIdentifier:RecordCellIdentifier];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"HNAExpensesRecordCell" bundle:nil] forCellReuseIdentifier:RecordCellIdentifier];
}

-(NSMutableArray *)records{
    if (_records == nil) {
        _records = [NSMutableArray array];
        for (NSInteger i = 0; i < 20; i++) {
            HNAExpenseRecordModel *model = [HNAExpenseRecordModel recordeWithAmount:[NSString stringWithFormat:@"%ld",(long)i] date:@"date" state:@"state"];
            if (i==0 || i==10) {
//                model.totalAmount = @"13414314314314313143143143143143143141";
//                model.date = @"13414314314314313143143143143143143141";
            }
            [self.records addObject:model];
        }
    }
    return _records;
}

- (NSMutableArray *)filterRecords{
    if (_filterRecords == nil) {
        _filterRecords = [NSMutableArray array];
    }
    return _filterRecords;
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return self.records.count;
    } else {
        // 过滤数据
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"totalAmount contains %@",self.searchDisplayController.searchBar.text];
        [self.filterRecords removeAllObjects];
        [self.filterRecords addObjectsFromArray:[self.records filteredArrayUsingPredicate:predicate]];
        return self.filterRecords.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HNAExpenseRecordModel *model;
    if (tableView == self.tableView) {
        model = self.records[indexPath.row];
    } else {
        model = self.filterRecords[indexPath.row];
    }
    HNAExpensesRecordCell *cell = [HNAExpensesRecordCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"HNAMedicalExpensesDetailController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
@end
