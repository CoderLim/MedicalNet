//
//  HNAApplyExpensesController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/23.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAApplyExpensesController.h"
#import "HNAImagePickerView.h"
#import "HNAApplyExpenseParam.h"
#import "HNAInsuranceTool.h"
#import "MBProgressHUD+MJ.h"
#import "HNAApplySuccessController.h"
#import "HNAResult.h"
#import "MJExtension.h"
#import "HNAImagePickersScrollView.h"
#import "UIImage+HNA.h"
#import "MedicalNet-swift.h"

#define TextField2KeyboardMargin 40

#define ApplyExpense2ApplySuccessSegue @"applyExpense2applySuccess"


@interface HNAApplyExpensesController() <UITextFieldDelegate,HNAImagePickersScrollViewDelegate>{
    UITextField *_currentEditTextField;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
/**
 *   保险公司名称
 */
@property (weak, nonatomic) IBOutlet UILabel *insuranceComNameLabel;
/**
 *  申请人姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *applicantNameLabel;
/**
 *  联系方式
 */
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
/**
 *  提交按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
/**
 *  图片选择控件
 */
// 身份证
@property (weak, nonatomic) IBOutlet HNAImagePickersScrollView *IDCardImagePickersScrollView;
// 医保卡
@property (weak, nonatomic) IBOutlet HNAImagePickersScrollView *medicalCardImagePickersScrollView;
// 就医
@property (weak, nonatomic) IBOutlet HNAImagePickersScrollView *casesImagePickersScrollView;
// 缴费
@property (weak, nonatomic) IBOutlet HNAImagePickersScrollView *chargesImagePickersScrollView;
/**
 *  花费总额
 */
@property (weak, nonatomic) IBOutlet UITextField *amountField;
 /**
 *  银行卡号
 */
@property (weak, nonatomic) IBOutlet UITextField *cardNumField;

/**
 *  提交
 */
- (IBAction)submit:(UIButton *)sender;

@end

@implementation HNAApplyExpensesController

- (void)dealloc {
    [DefaultCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [DefaultCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [DefaultCenter removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [DefaultCenter removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // contentView添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView:)];
    [self.contentView addGestureRecognizer: tap];
    
    // 设置通知
    [self setupNotification];
    
    // 设置基本信息
    [self setupBasicInfo];
    
    [self setupSubmitButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions
- (IBAction)submit:(UIButton *)sender {
    // 构造网络请求参数
    HNAApplyExpenseParam *param = [HNAApplyExpenseParam param];
    param.cardNum = self.cardNumField.text;
    param.cardNum = @"00000000000";
    param.IDcards = self.IDCardImagePickersScrollView.imageUrls;
    param.medicalCards = self.medicalCardImagePickersScrollView.imageUrls;
    param.cases = self.casesImagePickersScrollView.imageUrls;
    param.charges = self.chargesImagePickersScrollView.imageUrls;
    
    // 网络请求
    [HNAInsuranceTool applyExpenseWithParam:param success:^(HNAResult *result) {
        if (result.success == HNARequestResultSUCCESS) {
            [self performSegueWithIdentifier:ApplyExpense2ApplySuccessSegue sender:nil];
        } else {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",result.errorInfo]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"error:%@",error]];
    }];
}

#pragma mark - Private
- (void)setupBasicInfo {
    HNAUser *user = [HNAUserTool user];
    self.applicantNameLabel.text = user.name;
    self.contactLabel.text = user.phoneNum;
    self.insuranceComNameLabel.text = [NSString stringWithFormat:@"%ld", (long)user.insuranceCompanyId];
}

- (void)setupNotification {
    // 监听键盘的弹出与收回
    [DefaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [DefaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // TextField
    [DefaultCenter addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [DefaultCenter addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setupSubmitButton {
    [self.submitButton setBackgroundImage:[UIImage hna_imageWithColor:[UIColor orangeColor] andSize:self.submitButton.bounds.size] forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage hna_imageWithColor:[UIColor grayColor] andSize:self.submitButton.bounds.size] forState:UIControlStateDisabled];
    [self.submitButton setEnabled:NO];
}

- (void)tapContentView:(UITapGestureRecognizer *)tap {
    [self.contentView endEditing:YES];
}

#pragma mark - HNAImagePickersScrollViewDelegate
- (BOOL)imagePickersScrollViewWillSelectImage:(HNAImagePickersScrollView *)imagePickerScrollView {
    [self.contentView endEditing:YES];
    return YES;
}

#pragma mark - 通知
- (void)textFieldDidBeginEditing:(NSNotification *)aNotification {
    _currentEditTextField = aNotification.object;
}

- (void)textFieldDidChange:(NSNotification *)aNotification {
    if (self.cardNumField.text && self.amountField.text && self.cardNumField.text.length>0 && self.amountField.text.length>0) {
        [self.submitButton setEnabled:YES];
    } else {
        [self.submitButton setEnabled:NO];
    }
}

- (void)keyboardWillShow:(NSNotification *)aNotification{
    self.contentView.transform = CGAffineTransformIdentity;
    
    NSDictionary *userInfo = [aNotification userInfo];
    // 键盘frame
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 当前编辑的输入框frame(self.view坐标系）
    CGRect currentTextFieldFrame = [_currentEditTextField.superview convertRect:_currentEditTextField.frame toView: KeyWindow];
    // 计算self.view需要移动的距离
    CGFloat deltaY = keyboardFrame.origin.y - (currentTextFieldFrame.size.height+currentTextFieldFrame.origin.y) - TextField2KeyboardMargin;
    
    self.contentView.transform = CGAffineTransformMakeTranslation(0, deltaY);
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    self.contentView.transform = CGAffineTransformIdentity;
}

@end
