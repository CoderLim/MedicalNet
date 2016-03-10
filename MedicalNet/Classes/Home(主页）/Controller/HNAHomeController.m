//
//  HNAHomeController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAHomeController.h"
#import "HNATabBarController.h"
#import "HNAHomeTipView.h"
#import "UIImage+HNA.h"
#import "HNAChangeCipherController.h"
#import "HNAExpensesRecordsController.h"
#import "HNAExpensesDetailController.h"
#import "HNAExpensesDirectionsController.h"
#import "HNAHealthCheckController.h"
#import "HNAExpensesRecordCell.h"
#import "HNAProjectCell.h"
#import "HNAInsuranceTool.h"
#import "HNAGetInsuranceCompanyResult.h"
#import "HNAGetExpenseDirectionResult.h"
#import "HNAGetExpenseRecordsParam.h"
#import "HNAGetExpenseRecordsResult.h"

#define KeyPathContentSize @"contentSize"
#define KeyPathContentOffset @"contentOffset"
// 默认显示医院个数
#define DefaultHospitalCount 3
// 主页跳转到报销记录页面
#define SegueHome2MedicalRecords @"Home2MedicalRecords"
// 主页跳转到修改密码页面
#define SegueHome2ChangeCipher @"home2changeCipher"
// 主页跳转到申请报销页面
#define SegueHome2ApplyExpense @"home2applyExpense"
// 主页跳转到记录详情
#define SegueHome2RecordDetail @"home2recordDetail"

@interface HNAHomeController() <UITableViewDataSource,UITableViewDelegate> {
    BOOL _showMoreHospital;
}
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
/** 修改密码提示 view*/
@property (nonatomic,weak) HNAHomeTipView *tipView;
/** 没记录 view */
@property (weak, nonatomic) IBOutlet UIView *noRecordsView;
/** 有记录 view */
@property (weak, nonatomic) IBOutlet UIView *hasRecordsView;
/** 报销记录 */
@property (weak, nonatomic) IBOutlet UITableView *recordsTableView;
/** 报销记录 */
@property (nonatomic, strong) NSMutableArray<HNAExpenseRecordModel *> *records;
/** 申请按钮 */
- (IBAction)applyExpenseButtonClicked:(UIButton *)sender;
/** 报销记录按钮 */
- (IBAction)expensesRecordsBtnClicked:(UIButton *)sender;

///=============================================================================
/// 报销说明
///=============================================================================
/** 保险公司信息 */
// 公司名称
@property (weak, nonatomic) IBOutlet UILabel *insuranceComNameLabel;
// 公司地址
@property (weak, nonatomic) IBOutlet UILabel *insuranceComAddrLabel;
// 公司联系人
@property (weak, nonatomic) IBOutlet UILabel *insuranceComContactLabel;
// 公司邮编
@property (weak, nonatomic) IBOutlet UILabel *insuranceComCodeLabel;
// 公司电话
@property (weak, nonatomic) IBOutlet UILabel *insuranceComPhoneLabel;
/** 保障方案 */
@property (weak, nonatomic) IBOutlet UITableView *projectTableView;
/** 理赔所需材料 */
@property (weak, nonatomic) IBOutlet UILabel *materialLabel;
/** 可报销医院 */
@property (weak, nonatomic) IBOutlet UITableView *hospitalTableView;
/** 更多医院 */
- (IBAction)moreHospitalBtnClicked:(UIButton *)sender;
/** 保障方案 高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectTableViewConstraint_H;
/** 可报销医院 高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hospitalTableViewConstraint_H;
/** 保障方案 数据 */
@property (strong, nonatomic) NSMutableArray<HNASecurityProgram *> *projectArray;
/** 可报销医院 数据 */
@property (strong, nonatomic) NSMutableArray *hospitalArray;

@end

@implementation HNAHomeController

- (void)dealloc {
    [self.mainScrollView removeObserver:self forKeyPath: KeyPathContentOffset];
    [self.projectTableView removeObserver:self forKeyPath: KeyPathContentSize];
    [self.hospitalTableView removeObserver:self forKeyPath: KeyPathContentSize];
}

#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 1.设置控制器
    self.title = @"商业医保报销";
    
    // 2.设置tableView
    [self setupTableView];
    
    // 3.设置tipView
    [self setupTipView];
    
    // 4.设置kvo
    [self setupObserver];
    
    // 5.加载数据
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.tipView show];
}

#pragma mark - Custom Accessors
- (NSMutableArray<HNAExpenseRecordModel *> *)records {
    if (_records == nil) {
        _records = [NSMutableArray array];
    }
    return _records;
}

- (NSMutableArray<HNASecurityProgram *> *)projectArray{
    if (_projectArray == nil) {
        _projectArray = [NSMutableArray array];
    }
    return _projectArray;
}

- (NSMutableArray *)hospitalArray{
    if (_hospitalArray == nil) {
        _hospitalArray = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 10; i++) {
            [_hospitalArray addObject: [NSString stringWithFormat:@"医院%ld",(long)i]];
        }
    }
    return _hospitalArray;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.projectTableView){
        return self.projectArray.count;
    } else if (tableView == self.hospitalTableView) {
        if (_showMoreHospital == NO) {
            return MIN(DefaultHospitalCount,self.hospitalArray.count);
        }
        return self.hospitalArray.count;
    } else {
        return self.records.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.projectTableView) { // 保障方案
        return [self projectCellForRowAtIndexPath:indexPath withTableView:tableView];
    } else if (tableView == self.hospitalTableView){  // 可报销医院
        return [self hospitalCellForRowAtIndexPath:indexPath withTableView:tableView];
    } else { // 报销记录
        return [self recordCellForRowAtIndexPath:indexPath withTableView:tableView];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView != self.recordsTableView) {
        return;
    }
    
    HNAExpenseRecordModel *model = self.records[indexPath.row];
    [self performSegueWithIdentifier:SegueHome2RecordDetail sender:model.id];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - Private
- (void)setupTipView{
    if ([HNAHomeTipView avaliable]) {
        HNAHomeTipView *tipView = [HNAHomeTipView tipViewWithChangeCipher:^{
            [self performSegueWithIdentifier:SegueHome2ChangeCipher sender:nil];
        }];
        tipView.superViewDuplicate = self.view;
        self.tipView = tipView;
    }
}

- (void)setupTableView {
    [self.recordsTableView registerNib:[UINib nibWithNibName:@"HNAExpensesRecordCell" bundle:nil] forCellReuseIdentifier:@"HNAExpensesRecordCell"];
    
    _showMoreHospital = NO;
}

- (void)setupObserver {
    [self.mainScrollView addObserver:self forKeyPath:KeyPathContentOffset options:NSKeyValueObservingOptionNew context:nil];
    
    [self.projectTableView addObserver:self forKeyPath: KeyPathContentSize options:NSKeyValueObservingOptionNew context:nil];
    [self.hospitalTableView addObserver:self forKeyPath: KeyPathContentSize options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark 加载数据
- (void)loadData {
    [self loadExpenseRecords];
    //    [self loadDirectionData];
    [self loadInsuranceCompanyData];
}

/** 报销记录 */
- (void)loadExpenseRecords {
    HNAGetExpenseRecordsParam *param = [HNAGetExpenseRecordsParam param];
    [HNAInsuranceTool getExpenseRecordsWithParam:param success:^(HNAGetExpenseRecordsResult *result) {
        if (result == nil || result.records.count < 1) {
            self.hasRecordsView.hidden = YES;
        } else {
            self.records = result.records;
            [self.recordsTableView reloadData];
            self.hasRecordsView.hidden = NO;
        }
    } failure:^(NSError *error) {
        self.hasRecordsView.hidden = YES;
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"加载报销记录失败"];
    }];
}

/** 报销说明 */
- (void)loadDirectionData{
    [MBProgressHUD showMessage: MessageWhenLoadingData];
    // 1.参数
    NSString *companyId = [HNAUserTool user].companyId;
    if (companyId == nil) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"companyId为nil"];
        return;
    }
    // 2.请求
    WEAKSELF(weakSelf);
    [HNAInsuranceTool getExpenseDirectionsWithCompanyId:companyId
                                                success:^(HNAGetExpenseDirectionResult *result) {
                                                    [MBProgressHUD hideHUD];
                                                    if (result.success==HNARequestResultSUCCESS && result.expenseDirection!=nil) {
                                                        HNAExpenseDirectionModel *direction = result.expenseDirection;
                                                        weakSelf.projectArray = direction.securityPrograms;
                                                        weakSelf.hospitalArray = direction.hospitals;
                                                        
                                                        // 刷新数据
                                                        [weakSelf.projectTableView reloadData];
                                                        weakSelf.materialLabel.text = direction.materials;
                                                        [weakSelf.hospitalTableView reloadData];
                                                    } else {
                                                        [MBProgressHUD showError:result.errorInfo];
                                                    }
                                                } failure:^(NSError *error) {
                                                    [MBProgressHUD hideHUD];
                                                    [MBProgressHUD showError:@"请求异常"];
                                                }];
}

/** 保险公司数据 */
- (void)loadInsuranceCompanyData {
    //NSInteger insuranceCompanyId = [HNAUserTool user].insuranceCompanyId;
    NSInteger insuranceCompanyId = 1;
    [HNAInsuranceTool getInsuranceCompayWithId:insuranceCompanyId
                                       success:^(HNAGetInsuranceCompanyResult *result) {
                                           [MBProgressHUD hideHUD];
                                           if (result.success==HNARequestResultSUCCESS && result.insuranceCompany.insuranceCompanyId!=nil) {
                                               HNAInsuranceCompanyModel *insuranceCompany = result.insuranceCompany;
                                               self.insuranceComNameLabel.text = insuranceCompany.name;
                                               self.insuranceComAddrLabel.text = insuranceCompany.addr;
                                               self.insuranceComCodeLabel.text = insuranceCompany.code;
                                               self.insuranceComContactLabel.text = @"没有这个字段";
                                               self.insuranceComPhoneLabel.text = insuranceCompany.phone;
                                           }
                                       } failure:^(NSError *error) {
                                           [MBProgressHUD hideHUD];
                                           [MBProgressHUD showError: MessageWhenFaild];
                                       }];
}

#pragma mark 生成cell
- (UITableViewCell *)recordCellForRowAtIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView {
    static NSString *idenfitifer = @"HNAExpensesRecordCell";
    HNAExpensesRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfitifer];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.model = self.records[indexPath.row];
    return cell;
}

- (HNAProjectCell *)projectCellForRowAtIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView{
    static NSString *projectIdentifier = @"projectCell";
    
    HNAProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:projectIdentifier];
    cell.model = self.projectArray[indexPath.row];
    return cell;
}

- (UITableViewCell *)hospitalCellForRowAtIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView{
    static NSString *hospitalIdentifier = @"hospitalCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hospitalIdentifier];
    cell.textLabel.text = self.hospitalArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma mark - IBActions
- (IBAction)applyExpenseButtonClicked:(UIButton *)sender {
    [self performSegueWithIdentifier:SegueHome2ApplyExpense sender:nil];
}

- (IBAction)expensesRecordsBtnClicked:(UIButton *)sender {
    [self performSegueWithIdentifier:SegueHome2MedicalRecords sender:nil];
}

- (IBAction)moreHospitalBtnClicked:(UIButton *)sender {
    _showMoreHospital = !_showMoreHospital;
    
    NSString *title = @"查看更多";
    if (_showMoreHospital) {
        title = @"收起";
    }
    [sender setTitle:title forState:UIControlStateNormal];
    
    [self.hospitalTableView reloadData];
}

#pragma mark - UIViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: SegueHome2RecordDetail]) {
        HNAExpensesDetailController *destVc = segue.destinationViewController;
        destVc.recordId = sender;
    }
}

#pragma mark - NSObject
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString: KeyPathContentSize]) {
        CGSize contentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
        if (object == self.projectTableView) {
            self.projectTableViewConstraint_H.constant = contentSize.height;
        } else if  (object == self.hospitalTableView) {
            self.hospitalTableViewConstraint_H.constant = contentSize.height;
        }
        [self.view layoutIfNeeded];
    } else if ([keyPath isEqualToString:KeyPathContentOffset]) {
        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        [((HNATabBarController *)self.tabBarController) setTarbarHidden:(contentOffset.y>100)
                                                                animate:YES];
    }
}

@end
