//
//  HNAGetHCRecordsResult.h
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNAResult.h"

@class HNAHealthCheckRecordModel;

@interface HNAGetHCRecordsResult : HNAResult

/**
 *  是否有新体检项目，1= 是z 0= 否
 * 
 *  对应节点 newProject
 */
@property (nonatomic,assign) NSInteger hasNewProject;
@property (nonatomic,copy) NSString *year;
@property (nonatomic,copy) NSString *month;
@property(nonatomic,strong) NSMutableArray<HNAHealthCheckRecordModel *> *records;

@end


