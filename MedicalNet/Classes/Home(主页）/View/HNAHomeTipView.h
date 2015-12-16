//
//  HNAHomeTipView.h
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TipViewElementClick)();

@interface HNAHomeTipView : UIView
@property (nonatomic,copy) TipViewElementClick changeCipher;
@property (nonatomic,copy) TipViewElementClick close;

+ (instancetype)tipViewWithChangeCipher:(TipViewElementClick)changeCipher andClose:(TipViewElementClick)close;
@end
