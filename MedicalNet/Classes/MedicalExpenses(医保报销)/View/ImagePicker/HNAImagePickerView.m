//
//  HNAImagePickerView.m
//  MedicalNet
//
//  Created by gengliming on 15/11/24.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAImagePickerView.h"
#import "UIView+HNA.h"

@interface HNAImagePickerView() <UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
/**
 *  选择图片 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *pickerBtn;
/**
 *  移除图片 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;
/**
 *  所属控制器，建议不要直接使用self.viewController
 */
@property (nonatomic, weak) UIViewController *viewControllerReduplicate;

- (IBAction)pickerBtnClicked:(UIButton *)sender;
- (IBAction)removeBtnClicked:(UIButton *)sender;
@end
@implementation HNAImagePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // 主动加载xib
    UIView *containerView = [[MainBundle loadNibNamed:@"HNAImagePickerView" owner:self options:nil] lastObject];
    // 设置view大小
    CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerView.frame = newFrame;
    [self addSubview:containerView];
    
    // 隐藏“移除”按钮
    self.removeBtn.hidden = YES;
    
    // 添加“长按”手势
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pickerBtnLongPressed:)];
    longPressRecognizer.minimumPressDuration = 1.f;
    [self.pickerBtn addGestureRecognizer:longPressRecognizer];
}

+ (instancetype)imagePicker {
    return [[HNAImagePickerView alloc] init];
}

#pragma mark - 属性
- (UIViewController *)viewControllerReduplicate {
    if (_viewControllerReduplicate == nil) {
        _viewControllerReduplicate = self.viewController;
    }
    return _viewControllerReduplicate;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    
    if (self.pickerBtn) {
        [self.pickerBtn setImage:image forState:UIControlStateNormal];
    }
}

#pragma mark - 按钮事件
- (IBAction)pickerBtnClicked:(UIButton *)sender {
    // 通知代理将要选择图片
    if ([self.delegate respondsToSelector:@selector(imagePickerViewWillSelectImage:)]) {
        [self.delegate imagePickerViewWillSelectImage:self];
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"删除" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [actionSheet showInView: self.viewControllerReduplicate.view];
}

- (IBAction)removeBtnClicked:(UIButton *)sender {
    // 问问代理让不让移除
    if ([self.delegate respondsToSelector:@selector(imagePickerViewWillRemoveImage:)]&&
        ![self.delegate imagePickerViewWillRemoveImage:self]) {
        return;
    }
    // 隐藏“移除”按钮
    sender.hidden = YES;
    // 删除pickerBtn的Image
    [self.pickerBtn setImage:nil forState: UIControlStateNormal];
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(imagePickerViewDidRemoveImage:)]) {
        [self.delegate imagePickerViewDidRemoveImage:self];
    }
}

#pragma mark - 手势
- (void)pickerBtnLongPressed:(UILongPressGestureRecognizer *)recognizer{
    if (self.image != nil) {
        self.removeBtn.hidden = NO;
    }
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
        default:{
            if ([self.delegate respondsToSelector:@selector(imagePickerViewDidCancel:)]) {
                [self.delegate imagePickerViewDidCancel:self];
            }
            break;
        }
    }
}

- (void)takeAPhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = sourceType;
        ipc.allowsEditing = YES;
        ipc.delegate = self;
        [self.viewControllerReduplicate presentViewController:ipc animated:YES completion:nil];
    }
}

- (void)pickALocalPicture{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self.viewControllerReduplicate presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
        self.image = image;
        
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(imagePickerViewDidSelectImage:)]) {
            [self.delegate imagePickerViewDidSelectImage:self];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
