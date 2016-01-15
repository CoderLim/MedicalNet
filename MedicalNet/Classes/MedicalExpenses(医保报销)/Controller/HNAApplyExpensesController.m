//
//  HNAApplyExpensesController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/23.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAApplyExpensesController.h"
#import "HNAImagePickerView.h"
#import "HNAUser.h"
#import "HNAUserTool.h"
#import "HNAApplyExpenseParam.h"
#import "HNAInsuranceTool.h"
#import "MBProgressHUD+MJ.h"
#import "HNAApplySuccessController.h"
#import "HNAResult.h"
#import "MJExtension.h"

#import "MedicalNet-swift.h"



@interface HNAApplyExpensesController()<HNAImagePickerViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    HNAImagePickerView *_currentImagePickerView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

/**
 *  选取图片按钮
 */
@property (strong, nonatomic) IBOutletCollection(HNAImagePickerView) NSArray *imagePickerViews;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置imagePickerView代理
    for (HNAImagePickerView *ipv in self.imagePickerViews) {
        ipv.delegate = self;
    }
    
    // 监听scrollView的contentOffset
    [self.mainScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

#pragma mark HNAImagePickerView代理方法
// 选择图片
- (void)imagePickerViewDidClickPickerBtn:(HNAImagePickerView *)imagePickerView{
    // 记录点击的imagePickerView
    _currentImagePickerView = imagePickerView;
    // 弹出actionSheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [actionSheet showInView:self.view];
}

// 移除图片
- (void)imagePickerViewDidClickRemoveBtn:(HNAImagePickerView *)imagePickerView{
    //  TODO:.....
}

#pragma mark - UIActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (buttonIndex) {
        case 0:
            // 打开相机
            [self takeAPhoto];
            break;
        case 1:
            // 打开相册
            [self pickALocalPicture];
            break;
        default:
            break;
    }
}

- (void)takeAPhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = sourceType;
        ipc.allowsEditing = YES;
        ipc.delegate = self;
        [self presentViewController:ipc animated:YES completion:nil];
    }
}

- (void)pickALocalPicture{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        _currentImagePickerView.image = image;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    if ([keyPath isEqualToString:@"contentOffset"]) {
//        CGPoint newContentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
//        CGFloat alpha = 1.0;
//        
//        alpha = - newContentOffset.y / 64;
//
//        self.navigationController.navigationBar.alpha = alpha;
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
}

/**
 *  提交
 */
- (IBAction)submit:(UIButton *)sender {
    // 得到当前user信息
    HNAUser *currentUser = [HNAUserTool user];
    
    // 构造网络请求参数
    HNAApplyExpenseParam *param = [[HNAApplyExpenseParam alloc] init];
    param.insuranceCompanyId = currentUser.insuranceCompanyId;
    param.id = currentUser.id;
    param.name = currentUser.name;
    param.companyId = currentUser.companyId;
    param.companyName = currentUser.companyName;
    param.phoneNum = currentUser.phoneNum;
//    param.cardNum = self.cardNumField.text;
    param.cardNum = @"00000000";
    
    [self.imagePickerViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HNAImagePickerView *pickerView = obj;
        if (pickerView.tag == 11) {
            param.IDcard_1 = pickerView.image;
        } else if (pickerView.tag == 12){
            param.IDcard_2 = pickerView.image;
        } else if (pickerView.tag == 21) {
            param.medicalCard_1 = pickerView.image;
        } else if (pickerView.tag == 22) {
            param.medicalCard_2 = pickerView.image;
        } else if (pickerView.tag == 31) {
            param.cases_1 = pickerView.image;
        } else if (pickerView.tag == 32) {
            param.cases_2 = pickerView.image;
        } else if (pickerView.tag == 41) {
            param.charges_1 = pickerView.image;
        } else if (pickerView.tag == 42) {
            param.charges_2 = pickerView.image;
        }
    }];
    HNALog(@"%@",param.companyId);
    
    // 网络请求
    [HNAInsuranceTool applyExpenseWithParam:param success:^(HNAResult *result) {
        if (result.success == HNARequestResultSUCCESS) {
            HNAApplySuccessController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"HNAApplySuccessController"];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",result.errorInfo]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"error:%@",error]];
    }];
}

- (void)dealloc{
    [self.mainScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - 触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
