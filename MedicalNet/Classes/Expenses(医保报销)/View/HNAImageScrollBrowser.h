//
//  HNAImageScrollBrowser.h
//  MedicalNet
//
//  Created by gengliming on 16/1/20.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNAImageScrollBrowser : UIView

@property (nonatomic, strong) NSMutableArray<NSString *> *imageUrls;

@end

@interface HNAImageScrollBrowserLayout : UICollectionViewLayout

@end
