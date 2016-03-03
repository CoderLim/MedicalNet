//
//  HNAChangePortraitController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAChangePortraitController.h"
#import "UIImage+HNA.h"
#import "HNAChangePortraitParam.h"
#import "HNAUserTool.h"
#import "HNAUser.h"
#import "MBProgressHUD+MJ.h"
#import "HNAChangePortraitResult.h"

@interface HNAChangePortraitController () <UINavigationControllerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *pickImageBtn;
- (IBAction)pickImageClick:(UIButton *)sender;

@end

@implementation HNAChangePortraitController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Private
- (void)saveOperation{
    [MBProgressHUD showMessage:@"正在保存头像"];
    // 1.拼修改头像的参数
    HNAChangePortraitParam *param = [HNAChangePortraitParam param];
    param.theNewIcon = self.pickImageBtn.currentImage;
    // 2.请求地址
    [HNAUserTool changePortraitWithParam:param success:^(HNAChangePortraitResult *result) {
        [MBProgressHUD hideHUD];
        if (result.success==HNARequestResultSUCCESS) {
            [MBProgressHUD showSuccess:@"修改成功"];
            
            HNAUser *user = [HNAUserTool user];
            user.icon = result.theNewIconUrl;
            [HNAUserTool saveUser:user];
        } else {
            [MBProgressHUD showError:@"修改失败"];
            HNALog(@"%@",result.description);
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)takeAPhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    NSAssert([UIImagePickerController isSourceTypeAvailable:sourceType], @"不能使用相机");
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // 设置拍照后图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)pickALocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) return;
    
    switch (buttonIndex) {
        case 0:
            [self takeAPhoto];
            break;
        case 1:
            [self pickALocalPhoto];
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.pickImageBtn setImage:[image hna_circleImageWithDiameter:self.pickImageBtn.frame.size.width] forState:UIControlStateNormal];
        self.navRightBtnEnabled = YES;
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1.0);
        } else {
            data = UIImagePNGRepresentation(image);
        }
        // 图片保存路径
        
        // 返回控制器
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    HNALog(@"取消选择头像");
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
}

#pragma mark - IBActions
- (IBAction)pickImageClick:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [actionSheet showInView:self.view];
}

@end
