//
//  HNARightIconButton.h
//  MedicalNet
//
//  Created by gengliming on 16/1/28.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HNARightArrowButtonArrowDirection) {
    HNARightArrowButtonArrowDirectionDown,
    HNARightArrowButtonArrowDirectionUp
};

@interface HNARightArrowButton : UIButton
@property (nonatomic, assign) HNARightArrowButtonArrowDirection direction;
@end
