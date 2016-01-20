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

@interface HNAChangePortraitController () <UINavigationControllerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate>
- (IBAction)pickImageClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *pickImageBtn;
@end

@implementation HNAChangePortraitController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)pickImageClick:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [actionSheet showInView:self.view];
}

- (void)saveOperation{
    [MBProgressHUD showMessage:@"正在保存头像"];
    // 1.拼修改头像的参数
    HNAChangePortraitParam *param = [HNAChangePortraitParam param];
    param.theNewIcon = self.pickImageBtn.currentImage;
    // 2.请求地址
    [HNAUserTool changePortraitWithParam:param success:^(HNAResult *result) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"修改成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}
#pragma mark - actionSheet代理方法
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
// 照一张
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
// 选择本地相册
- (void)pickALocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController 代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.pickImageBtn setImage:[image circleImageWithDiameter:self.pickImageBtn.frame.size.width] forState:UIControlStateNormal];
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
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    HNALog(@"取消选择头像");
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
}
@end
