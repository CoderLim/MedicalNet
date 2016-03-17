//
//  HNAMedicalExpensesDetailController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/27.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAExpensesDetailController.h"
#import "HNAExpenseDetailCell.h"
#import "HNAInsuranceTool.h"
#import "HNAGetExpenseDetailResult.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "HNARightArrowButton.h"
#import "HNAImageScrollBrowser.h"

#import "HNAGetExpenseDirectionResult.h"

@interface HNAExpensesDetailController () <UITableViewDelegate, UITableViewDataSource> {
    CGFloat _detailViewHeight;
}

@property (weak, nonatomic) IBOutlet UILabel *amoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *applicantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceComLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailView_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_H;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet HNAImageScrollBrowser *IDCardBrowser;
@property (weak, nonatomic) IBOutlet HNAImageScrollBrowser *casesBrowser;
@property (weak, nonatomic) IBOutlet HNAImageScrollBrowser *chargeBrowser;


@property (strong, nonatomic) NSMutableArray<HNAExpenseDetailStatusRecord *> *statusRecords;

@property (weak, nonatomic) IBOutlet HNARightArrowButton *checkDetailBtn;
- (IBAction)checkDetailBtnClick:(UIButton *)sender;

@end

@implementation HNAExpensesDetailController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"报销详情";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAExpenseDetailCell" bundle:nil] forCellReuseIdentifier:@"HNAExpenseDetailCell"];
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _detailViewHeight = self.detailView_H.constant;
    
    self.tableView_H.constant = self.tableView.contentSize.height;
    [self.view layoutIfNeeded];
}

#pragma mark - Custom Accessors
- (NSMutableArray *)statusRecords{
    if (_statusRecords == nil) {
        _statusRecords = [NSMutableArray array];
        
//        HNAExpenseDetailStatusRecord *record1 = [[HNAExpenseDetailStatusRecord alloc] init];
//        record1.date = @"2015-11-11";
//        record1.desc = @"已报销￥1,800";
//        [_statusRecords addObject:record1];
    }
    return _statusRecords;
}

#pragma mark - Private
- (void)loadData {
    [MBProgressHUD showMessage: kMessageWhenLoadingData];
    
    [HNAInsuranceTool getExpenseDetailsWithRecordId:self.recordId success:^(HNAGetExpenseDetailResult *result) {
        [MBProgressHUD hideHUD];
        
        if (result.success == HNARequestResultSUCCESS) {
            HNAExpenseDetailModel *expenseDetail = result.expenseDetail;
            self.amoutLabel.text = expenseDetail.amount;
            self.insuranceComLabel.text = expenseDetail.insuranceCompanyName;
            self.applicantNameLabel.text = expenseDetail.name;
            self.bankNoLabel.text = expenseDetail.cardNum;
            
            self.IDCardBrowser.imageUrls = expenseDetail.IDcard;
            self.casesBrowser.imageUrls = expenseDetail.cases;
            self.chargeBrowser.imageUrls = expenseDetail.charges;
            
            self.statusRecords = expenseDetail.statusRecords;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError: kMessageWhenFaild];
    }];
}

#pragma  mark - IBActions
- (IBAction)checkDetailBtnClick:(UIButton *)sender {
    if (self.detailView.hidden) {
        [self spreadDetailView];
    } else {
        [self closeDetailView];
    }
}

- (void)spreadDetailView{
    CGFloat height = _detailViewHeight;
    // 隐藏detailView
    self.detailView.hidden = NO;
    // 设置“查看明细”文字
    self.checkDetailBtn.direction = HNARightArrowButtonArrowDirectionUp;
    
    WEAKSELF(weakSelf);
    self.detailView_H.constant = height;
    [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
}

- (void)closeDetailView{
    self.checkDetailBtn.direction = HNARightArrowButtonArrowDirectionDown;

    WEAKSELF(weakSelf);
    self.detailView_H.constant = 0;
    [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.detailView.hidden = YES;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.statusRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HNAExpenseDetailCell *cell = [HNAExpenseDetailCell cellWithTableView:tableView];
    
    cell.model = self.statusRecords[indexPath.row];
    cell.showTip = indexPath.row == 2;
    
    if (indexPath.row == 0) {
        cell.isSelected = YES;
        cell.positionType = HNAProgressCellPositionTypeBegin;
    } else if (indexPath.row == self.statusRecords.count-1) {
        cell.positionType = HNAProgressCellPositionTypeEnd;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
