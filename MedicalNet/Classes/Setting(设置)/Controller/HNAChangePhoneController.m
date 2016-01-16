//
//  HNAChangePhoneController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAChangePhoneController.h"
#import "HNAChangePhoneParam.h"
#import "HNAUserTool.h"
#import "HNAUser.h"
#import "MBProgressHUD+MJ.h"

@interface HNAChangePhoneController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *validationCodeField;
@property (weak, nonatomic) IBOutlet UIButton *getValidationCodeBtn;
- (IBAction)getValidationCodeBtnClicked:(UIButton *)sender;

@end

@implementation HNAChangePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 响应键盘Return按钮
    WEAKSELF(weakSelf);
    self.keyboardNextBtnClicked = ^{
        [weakSelf.validationCodeField becomeFirstResponder];
    };
}

- (IBAction)getValidationCodeBtnClicked:(UIButton *)sender {

}

- (void)textFieldTextChanged:(NSNotification *)notification{
    self.getValidationCodeBtn.enabled = self.phoneField.text.length > 0;
    self.navRightBtnEnabled = self.phoneField.text.length > 0 && self.validationCodeField.text.length > 0;
}

- (void)saveOperation{
    // 1.获取登录用户信息
    HNAUser *user = [HNAUserTool user];
    if (user == nil) {
        [MBProgressHUD showError:@"账号没有正常登录"];
        return;
    }
    
    // 2.拼修改手机号的参数
    HNAChangePhoneParam *param = [[HNAChangePhoneParam alloc] init];
    param.id = user.id;
    param.theNewPhoneNum = self.phoneField.text;
    
    // 3.请求地址
    [HNAUserTool changePhoneWithParam:param success:^(HNAResult *result) {
        [MBProgressHUD showSuccess:@"修改手机号成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}


@end
