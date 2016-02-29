//
//  HNAChangeBaseController.h
//  MedicalNet
//
//  Created by gengliming on 15/11/30.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNAMutiStateButton;

typedef void(^keyboardReturnButtonClicked)();

@interface HNAChangeBaseController : UIViewController

/**
 *  软键盘Return为Next按钮时事件
 */
@property (nonatomic,copy) keyboardReturnButtonClicked keyboardNextBtnClicked;
/**
 *  软键盘Return为Done或Go
 */
@property (nonatomic,copy) keyboardReturnButtonClicked keyboardDoneOrGoBtnClicked;
/**
 *  导航栏右按钮是否可用
 */
@property (nonatomic,assign)  BOOL navRightBtnEnabled;

@end
