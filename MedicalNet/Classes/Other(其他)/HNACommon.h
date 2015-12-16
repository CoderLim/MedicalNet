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
#define RequestUrlDomain @"http://wwww.XXXXXXXX.com"
