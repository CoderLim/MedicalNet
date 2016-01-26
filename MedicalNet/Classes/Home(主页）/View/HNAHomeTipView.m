//
//  HNAHomeTipView.m
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAHomeTipView.h"

#define HomeTipViewHeight 30
#define HomeTipViewAnimationDuration 1.f

@interface HNAHomeTipView()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeCipherBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

- (IBAction)close:(id)sender;
- (IBAction)changeCipher:(UIButton *)sender;

@end
@implementation HNAHomeTipView

#pragma mark - 初始化
+ (instancetype)tipViewWithChangeCipher:(TipViewElementClick)changeCipher{
    HNAHomeTipView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"HNAHomeTipView" owner:nil options:nil] lastObject];
    tipView.changeCipher = changeCipher;
    tipView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    tipView.translatesAutoresizingMaskIntoConstraints = YES;
    [tipView setupFontSize];
    return tipView;
}

- (void)setupFontSize {
    if (IS_IPHONE_6X) {
        self.tipLabel.font = [UIFont systemFontOfSize:13.f];
    } else if (IS_IPHONE_6X_PLUS) {
        self.tipLabel.font = [UIFont systemFontOfSize:15.f];
    }
}
#pragma mark - 属性
- (void)setFrame:(CGRect)frame {
    frame.size.height = HomeTipViewHeight;
    frame.size.width = MainScreen.bounds.size.width;
    [super setFrame:frame];
}
- (void)setSuperViewDuplicate:(UIView *)superViewDuplicate {
    _superViewDuplicate = superViewDuplicate;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = MainScreen.bounds.size.width;
    CGFloat h = HomeTipViewHeight;
    if (IOS7) {
        y = 64 - HomeTipViewHeight;
    } else {
        y = 0 - HomeTipViewHeight;
    }
    self.frame = CGRectMake(x, y, w, h);
    [_superViewDuplicate addSubview: self];
}

#pragma mark - 公开方法
- (void)show {
    [UIView animateWithDuration:HomeTipViewAnimationDuration animations:^{
        CGFloat x = 0;
        CGFloat y = IOS7?64:0;
        CGFloat w = MainScreen.bounds.size.width;
        CGFloat h = HomeTipViewHeight;
        self.frame = CGRectMake(x, y, w, h);
    }];
}

#pragma mark - 单击事件
- (IBAction)close:(UIButton *)sender {
    // 点击close后tipView将不再显示
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UserDefaultsShouldHideTipView];
    
    sender.enabled = NO;
    [UIView animateWithDuration:HomeTipViewAnimationDuration animations:^{
        CGRect frame = self.frame;
        frame.origin.y -= self.frame.size.height;
        self.frame = frame;
    } completion:^(BOOL finished) {
        sender.enabled = YES;
    }];
}
- (IBAction)changeCipher:(UIButton *)sender {
    self.changeCipher();
}
@end
