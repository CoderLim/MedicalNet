//
//  HNAImagePickerView.m
//  MedicalNet
//
//  Created by gengliming on 15/11/24.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAImagePickerView.h"

@interface HNAImagePickerView()
@property (weak, nonatomic) IBOutlet UIButton *pickerBtn;
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;

- (IBAction)pickerBtnClicked:(UIButton *)sender;
- (IBAction)removeBtnClicked:(UIButton *)sender;
@end
@implementation HNAImagePickerView

- (void)setImage:(UIImage *)image{
    _image = image;
    
    if (self.pickerBtn) {
        [self.pickerBtn setImage:image forState:UIControlStateNormal];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
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
    return self;
}

- (void)pickerBtnLongPressed:(UILongPressGestureRecognizer *)recognizer{
    self.removeBtn.hidden = NO;
}

- (IBAction)pickerBtnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(imagePickerViewDidClickPickerBtn:)]) {
        [self.delegate imagePickerViewDidClickPickerBtn:self];
    }
}
- (IBAction)removeBtnClicked:(UIButton *)sender {
    // 隐藏“移除”按钮
    sender.hidden = YES;
    // 删除pickerBtn的Image
    [self.pickerBtn setImage:nil forState:UIControlStateNormal];
    // 代理方法
    if ([self.delegate respondsToSelector:@selector(imagePickerViewDidClickRemoveBtn:)]) {
        [self.delegate imagePickerViewDidClickRemoveBtn:self];
    }
}
@end
