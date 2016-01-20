//
//  ViewController.m
//  MedicalNet
//
//  Created by gengliming on 16/1/16.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "HNAImageScrollBrowser.h"

@interface ViewController()
@property (weak, nonatomic) IBOutlet HNAImageScrollBrowser *scrollBrowser;
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSInteger i=0; i<20; i++) {
        [self.scrollBrowser.imageUrls addObject:@"https://www.baidu.com/img/bd_logo1.png"];
    }
}
@end
