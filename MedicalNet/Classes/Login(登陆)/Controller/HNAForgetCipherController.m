//
//  HNAForgetCipherController.m
//  MedicalNet
//
//  Created by gengliming on 15/12/2.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 忘记密码

#import "HNAForgetCipherController.h"
#import "HNACountDownButton.h"
#import "HNAChangeCipherController.h"

#define ForgetCipher2ChangeCipherSegue @"forgetCipher2changeCipher"

@interface HNAForgetCipherController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *validationCodeField;

- (IBAction)getValidationCodeBtnClicked:(HNACountDownButton *)sender;
- (IBAction)submit:(UIButton *)sender;
@end

@implementation HNAForgetCipherController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";
}

#pragma mark - TextField 代理事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.returnKeyType == UIReturnKeyNext) {
        [self.validationCodeField becomeFirstResponder];
    } else if (textField.returnKeyType == UIReturnKeyDone || textField.returnKeyType == UIReturnKeyGo){
        [self submit:nil];
    }
    return YES;
}

#pragma mark - view事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - 按钮事件
/**
 *  获取验证码
 */
- (IBAction)getValidationCodeBtnClicked:(HNACountDownButton *)sender {
    HNALog(@"%s", __FUNCTION__);
}
/**
 *  提交－跳转到修改密码
 */
- (IBAction)submit:(UIButton *)sender {
    [self performSegueWithIdentifier:ForgetCipher2ChangeCipherSegue sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:ForgetCipher2ChangeCipherSegue]) {
        HNAChangeCipherController *changeCipherVc = segue.destinationViewController;
        changeCipherVc.type = HNAChangeCipherControllerTypeViaPhoneValidation;
    }
}

@end
