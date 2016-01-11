//
//  HNACommon.h
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 0.application screen
#define SharedApplication [UIApplication sharedApplication]
#define MainScreen [UIScreen mainScreen]

// 1.自定义Log
#ifdef DEBUG
#define HNALog(...) NSLog(__VA_ARGS__)
#else
#define HNALog(...)
#endif

// 2.获取applicatin
#define KeyWindow [UIApplication sharedApplication].keyWindow

// 3.weakSelf
#define WEAKSELF(weakSelf) __weak __typeof(&*self) weakSelf = self

// 4.bundle
#define MainBundle [NSBundle mainBundle]

// 5.Main Storyboard
#define MainStoryboard [UIStoryboard storyboardWithName:@"Main" bundle:nil]

// 6. greater or equal than 7
#define IOS7 [[UIDevice currentDevice].systemVersion doubleValue] >= 7.0

// 7. 数据请求地址的domain
#define RequestUrlDomain @"http://mdm.bestchain.net"

// 8.加载数据时的提示信息
/**
 *  正在加载
 */
#define MessageWhenLoadingData @"正在抓紧加载..."
/**
 *  加载成功
 */
#define MessageWhenSuccess @"加载成功"
/**
 *  没有数据
 */
#define MessageWhenNoData @"没有数据"
/**
 *  加载报错
 */
#define MessageWhenFaild @"加载出错"

// 9.定义颜色
#define UIColorWithRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:0.0f]

// 10.机型
/**
 *  是否是iphone
 */
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
/**
 *  iphone6 或 iphone6s
 */
#define IS_IPHONE_6X (IS_IPHONE && [[UIScreen mainScreen] nativeScale] == 2.0f && [UIScreen mainScreen].bounds.size.width == 375.0f)
/**
 *  iphone6 plus 或 iphone6s plus
 */
#define IS_IPHONE_6X_PLUS (IS_IPHONE && [[UIScreen mainScreen] nativeScale] == 3.0f)


