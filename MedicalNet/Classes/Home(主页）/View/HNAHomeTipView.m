//
//  HNAHomeTipView.m
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAHomeTipView.h"

@interface HNAHomeTipView()
- (IBAction)close:(id)sender;
- (IBAction)changeCipher:(UIButton *)sender;

@end
@implementation HNAHomeTipView

#pragma mark - 初始化
+ (instancetype)tipViewWithChangeCipher:(TipViewElementClick)changeCipher andClose:(TipViewElementClick)close{
    HNAHomeTipView *tipView = [[[NSBundle mainBundle] loadNibNamed:@"HNAHomeTipView" owner:nil options:nil] lastObject];
    
    tipView.changeCipher = changeCipher;
    tipView.close = close;
    return tipView;
}
-(void)awakeFromNib{
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark - 单击事件
- (IBAction)close:(id)sender {
    self.close();
}

- (IBAction)changeCipher:(UIButton *)sender {
    self.changeCipher();
}
@end
