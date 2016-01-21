//
//  HNAForgetCipherController.m
//  MedicalNet
//
//  Created by gengliming on 15/12/2.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

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
}

/**
 *  获取验证码单击事件
 */
- (IBAction)getValidationCodeBtnClicked:(HNACountDownButton *)sender {
    HNALog(@"%s", __FUNCTION__);
}

- (IBAction)submit:(UIButton *)sender {
    [self performSegueWithIdentifier:ForgetCipher2ChangeCipherSegue sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:ForgetCipher2ChangeCipherSegue]) {
        HNAChangeCipherController *changeCipherVc = segue.destinationViewController;
        changeCipherVc.type = HNAChangeCipherControllerTypeViaPhoneValidation;
    }
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

#pragma mark - view触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
