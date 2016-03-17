//
//  HNALoginController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 登录

#import "HNALoginController.h"
#import "HNAHomeController.h"
#import "UIView+HNA.h"
#import "HNAUser.h"
#import "HNAUserTool.h"
#import "MBProgressHUD+MJ.h"
#import "HNALoginInfoParam.h"
#import "HNALoginInfoResult.h"
#import "HNALoginTool.h"
#import "HNAForgetCipherController.h"
#import "HNAImagePickersScrollView.h"
#import "HNATabBarController.h"
#import "AppDelegate.h"
#import "HNAHttpTool.h"

/**
 *  正在编辑的textField距离键盘的间距
 */
#define CurrentTextField2KeyboardPadding 40
/**
 *  跳转到忘记密码 segue
 */
#define Login2ForgetCipherSegue @"login2forgetCipher"

@interface HNALoginController() <UITextFieldDelegate,NSURLSessionDelegate>{
    __weak UITextField *_currentEditTextField;
}

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *cipherTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginView_Leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginView_Trailing;

- (IBAction)loginBtnClick:(UIButton *)sender;

@end

@implementation HNALoginController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"登录";
    
    // 设置LoginView
    [self setupLoginView];
    
    // 设置通知
    [self setupNotification];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private
- (void)setupLoginView {
    CALayer *loginViewLayer = self.loginView.layer;
    loginViewLayer.cornerRadius = 20;
    loginViewLayer.frame = CGRectInset(self.loginView.frame, 20, 20);
    loginViewLayer.shadowOffset = CGSizeMake(0,5);
    loginViewLayer.shadowRadius = 5.0;
    loginViewLayer.shadowColor = [UIColor blackColor].CGColor;
    loginViewLayer.shadowOpacity = 0.8;
}

- (void)setupNotification {
    // 监听键盘的弹出与收回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 监听TextField的TextChange
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [self textFieldTextChanged:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];

    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSNumber *keyboardAnimationDuration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber  *keyboardAnimationCurve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    self.view.bounds = ({
        // 当前编辑的输入框frame(self.view坐标系）
        // 注意：下面的XX.superview不要写成XX
        CGRect currentTextFieldFrame = [_currentEditTextField.superview convertRect:_currentEditTextField.frame toView: KeyWindow];

        CGRect viewBounds = self.view.bounds;
        CGFloat deltaY = keyboardFrame.origin.y - currentTextFieldFrame.size.height - currentTextFieldFrame.origin.y - CurrentTextField2KeyboardPadding;
        viewBounds.origin.y += -deltaY;
        viewBounds;
    });
    
    // 设置动画
    WEAKSELF(weakSelf);
    [UIView setAnimationCurve:[keyboardAnimationCurve intValue]];
    [UIView animateWithDuration:[keyboardAnimationDuration doubleValue] animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    // 键盘动画持续时间
    NSNumber *keyboardAnimationDuration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    // 键盘动画曲线
    NSNumber  *keyboardAnimationCurve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    self.view.bounds = ({
        CGRect viewBounds = self.view.bounds;
        viewBounds.origin.y = 0;
        viewBounds;
    });
    
    WEAKSELF(weakSelf);
    [UIView setAnimationCurve:[keyboardAnimationCurve intValue]];
    [UIView animateWithDuration:[keyboardAnimationDuration doubleValue] animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _currentEditTextField = textField;
}

- (void)textFieldTextChanged:(NSNotification *)aNotification{
    self.loginBtn.enabled = self.phoneTextField.text.length > 0 && self.cipherTextField.text.length > 0;
}

#pragma mark - UIResponder
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - IBActions
- (IBAction)loginBtnClick:(UIButton *)sender {
    [MBProgressHUD showMessage:@"正在登录"];
    
    NSString *username = self.phoneTextField.text;
    NSString *password = self.cipherTextField.text;
    
    // 登录参数
    HNALoginInfoParam *param = [[HNALoginInfoParam alloc] init];
    param.username = username;
    param.password = password;
//    
//    if ([username isEqualToString:@"123"] && [password isEqualToString:@"123"]) {
//        HNATabBarController *tabBarController = ((AppDelegate *)SharedApplication.delegate).tabBarController;
//        KeyWindow.rootViewController = tabBarController;
//        
//        CATransition *ca = [CATransition animation];
//        ca.type= kCATransitionPush;
//        ca.subtype=kCATransitionFromRight;
//        ca.duration=.25;
//        ca.startProgress = 0.5;
//        [KeyWindow.layer addAnimation:ca forKey:nil];
//    } else {
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"账号或密码不正确"];
//        [self.loginView hna_shakeWithAmplitude:20];
//    }
//    return;
    
    WEAKSELF(weakSelf);
    [HNALoginTool loginWithParam:param
                         success:^(HNALoginInfoResult *result) {
                             [MBProgressHUD hideHUD];
                             if (result.success==HNARequestResultSUCCESS) {
                                 // 如果用下面这句会出现内存泄漏，没搞明白为什么
                                 //            HNATabBarController * tabBarController = [MainStoryboard instantiateViewControllerWithIdentifier:@"tabBarController"];
                                 HNATabBarController *tabBarController = ((AppDelegate *)SharedApplication.delegate).tabBarController;
                                 KeyWindow.rootViewController = tabBarController;
                                
                                 CATransition *ca = [CATransition animation];
                                 // 设置过度效果
                                 ca.type= kCATransitionPush;
                                 // 设置动画的过度方向（向右）
                                 ca.subtype=kCATransitionFromRight;
                                 // 设置动画的时间
                                 ca.duration=.25;
                                 // 设置动画的起点
                                 ca.startProgress = 0.5;
                                 [KeyWindow.layer addAnimation:ca forKey:nil];
                             } else {
                                 if (result.errorInfo!=nil) {
                                     [MBProgressHUD showError: result.errorInfo];
                                 } else {
                                     [MBProgressHUD showError:@"账号或密码不正确"];
                                 }
                                 [weakSelf.loginView hna_shakeWithAmplitude:20];
                             }
                         } failure:^(NSError *error) {
                             [MBProgressHUD hideHUD];
                             [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
                         }];
}

@end
