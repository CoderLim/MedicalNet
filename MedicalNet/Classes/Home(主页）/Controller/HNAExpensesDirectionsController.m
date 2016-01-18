//
//  HNAExpensesDirectionsController.m
//  MedicalNet
//
//  Created by gengliming on 15/12/8.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAExpensesDirectionsController.h"
#import "HNAGetExpenseDirectionResult.h"
#import "HNAProjectCell.h"
#import "MJExtension.h"
#import "HNAInsuranceTool.h"
#import "HNAGetExpenseDirectionResult.h"
#import "HNAInsuranceTool.h"
#import "HNAUserTool.h"
#import "HNAUser.h"
#import "HNAInsuranceCompanyModel.h"
#import "MBProgressHUD+MJ.h"

// KeyPath
#define ContentSizeKeyPath @"contentSize"
// 默认显示医院个数
#define DefaultHospitalCount 3

@interface HNAExpensesDirectionsController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    BOOL _showMoreHospital;
}
/**
 *  保险公司信息
 */
@property (weak, nonatomic) IBOutlet UILabel *insuranceComNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceComAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceComContactLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceComCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceComPhoneLabel;

/**
 *  主ScrollView
 */
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
/**
 *  保障方案
 */
@property (weak, nonatomic) IBOutlet UITableView *projectTableView;
/**
 *  理赔所需材料
 */
@property (weak, nonatomic) IBOutlet UILabel *materialLabel;
/**
 *  可报销医院
 */
@property (weak, nonatomic) IBOutlet UITableView *hospitalTableView;

/**
 *  更多医院
 */
- (IBAction)moreHospitalBtnClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitButtonClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectTableViewConstraint_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hospitalTableViewConstraint_H;

@property (strong, nonatomic) NSMutableArray *materialArray;
@property (strong, nonatomic) NSMutableArray<HNASecurityProgram *> *projectArray;
@property (strong, nonatomic) NSMutableArray *hospitalArray;

@end

@implementation HNAExpensesDirectionsController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"报销说明";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _showMoreHospital = NO;
    
    // 根据数据量动态调整tableView的高度约束
    [self.projectTableView addObserver:self forKeyPath: ContentSizeKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [self.hospitalTableView addObserver:self forKeyPath: ContentSizeKeyPath options:NSKeyValueObservingOptionNew context:nil];
    
    // 加载数据
    [self loadDirectionData];
    [self loadInsuranceCompanyData];
    
    // 初始化［提交］按钮
    self.submitButton.layer.cornerRadius = self.submitButton.frame.size.height*0.5;
    self.submitButton.layer.shadowOffset = CGSizeMake(5, 5);
    self.submitButton.layer.shadowOpacity = 0.5;
    self.submitButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.submitButton.hidden = ![[self.navigationController.childViewControllers lastObject] isKindOfClass:[self class]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (IsEmbededInController(self)) {
        [self.mainScrollView setContentOffset:CGPointZero];
    }
}

#pragma mark - 数据
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

/**
 *  加载数据
 */
- (void)loadDirectionData{
    // 1.参数
    NSString *companyId = [HNAUserTool user].companyId;
    if (companyId == nil) {
        [MBProgressHUD showError:@"companyId为nil"];
        return;
    }
    // 2.请求
    WEAKSELF(weakSelf);
    [HNAInsuranceTool getExpenseDirectionsWithCompanyId:companyId success:^(HNAGetExpenseDirectionResult *result) {
        if (result.expenseDirection != nil) {
            HNAExpenseDirectionModel *direction = result.expenseDirection;
            weakSelf.projectArray = direction.securityPrograms;
            weakSelf.hospitalArray = direction.hospitals;
            [MBProgressHUD showSuccess:@"获取成功"];
            
            // 3.刷新数据
            [weakSelf.projectTableView reloadData];
            weakSelf.materialLabel.text = direction.materials;
            [weakSelf.hospitalTableView reloadData];
        } else {
            [MBProgressHUD showError:@"没有数据"];
            [DefaultCenter postNotificationName:ExpenseDierectionControllerHasNoData object:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求异常"];
        [DefaultCenter postNotificationName:ExpenseDierectionControllerHasNoData object:nil];
    }];
}
/**
 *  加载保险公司数据
 */
- (void)loadInsuranceCompanyData {
    [HNAInsuranceTool getInsuranceCompayWithId:[HNAUserTool user].insuranceCompanyId success:^(HNAInsuranceCompanyModel *insuranceCompany) {
        if (insuranceCompany != nil) {
            [MBProgressHUD showSuccess: MessageWhenSuccess];
            self.insuranceComNameLabel.text = insuranceCompany.name;
            self.insuranceComAddrLabel.text = insuranceCompany.addr;
            self.insuranceComCodeLabel.text = insuranceCompany.code;
            self.insuranceComContactLabel.text = @"没有这个字段";
            self.insuranceComPhoneLabel.text = insuranceCompany.phone;
        } else {
            [MBProgressHUD showError:@"没有数据"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError: MessageWhenFaild];
    }];
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.projectTableView){
        return self.projectArray.count;
    } else if (tableView == self.hospitalTableView) {
        if (_showMoreHospital == NO) {
            return MIN(3,self.hospitalArray.count);
        }
        return self.hospitalArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.projectTableView) { // 保障方案
        return [self projectCellForRowAtIndexPath:indexPath withTableView:tableView];
    } else if (tableView == self.hospitalTableView){  // 可报销医院
        return [self hospitalCellForRowAtIndexPath:indexPath withTableView:tableView];
    }
    return nil;
}

/**
 *   保障方案 cell
 */
- (HNAProjectCell *)projectCellForRowAtIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView{
    static NSString *projectIdentifier = @"projectCell";
    
    HNAProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:projectIdentifier];
    cell.model = self.projectArray[indexPath.row];
    return cell;
}
/**
 *   可报销医院 cell
 */
- (UITableViewCell *)hospitalCellForRowAtIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView{
    static NSString *hospitalIdentifier = @"hospitalCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hospitalIdentifier];
    cell.textLabel.text = self.hospitalArray[indexPath.row];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ExpenseDirectionControllerDidEndDraggingNotification object: nil];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (![keyPath isEqualToString: ContentSizeKeyPath])  return;
    
    CGSize contentSize;
    contentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
    if (object == self.projectTableView) {
        self.projectTableViewConstraint_H.constant = contentSize.height;
    } else if  (object == self.hospitalTableView) {
        self.hospitalTableViewConstraint_H.constant = contentSize.height;
    }

    [self.view layoutIfNeeded];
}
// 可报销医院－查看更多
- (IBAction)moreHospitalBtnClicked:(UIButton *)sender {
    _showMoreHospital = !_showMoreHospital;
    [self.hospitalTableView reloadData];
}
- (IBAction)submitButtonClicked:(UIButton *)sender {
}

- (void)dealloc{
    [self.projectTableView removeObserver:self forKeyPath: ContentSizeKeyPath];
    [self.hospitalTableView removeObserver:self forKeyPath: ContentSizeKeyPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
