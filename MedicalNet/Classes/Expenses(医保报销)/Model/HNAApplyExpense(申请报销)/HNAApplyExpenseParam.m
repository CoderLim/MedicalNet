//
//  HNAApplyExpenseModel.m
//  MedicalNet
//
//  Created by gengliming on 15/12/11.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAApplyExpenseParam.h"

@implementation HNAApplyExpenseParam
+ (instancetype)param {
    HNAUser *currentUser = [HNAUserTool user];
    
    HNAApplyExpenseParam *param = [[HNAApplyExpenseParam alloc] init];
    param.insuranceCompanyId = currentUser.insuranceCompanyId;
    param.id = currentUser.id;
    param.name = currentUser.name;
    param.companyId = currentUser.companyId;
    param.companyName = currentUser.companyName;
    param.phoneNum = currentUser.phoneNum;
    return param;
}

- (NSDictionary *)toDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"insuranceCompanyId"] = @(self.insuranceCompanyId);
    dict[@"name"] = self.name;
    dict[@"companyId"] = self.companyId;
    dict[@"companyName"] = self.companyName;
    dict[@"phoneNum"] = self.phoneNum;
    dict[@"cardNum"] = self.cardNum;
    
    if (self.IDcards!=nil&&self.IDcards.count>0) {
        for (NSInteger i=0; i<self.IDcards.count; i++) {
            NSString *paramName = [NSString stringWithFormat:@"IDcard_%ld",i];
            dict[paramName] = self.IDcards[i];
        }
    }
    if (self.medicalCards!=nil&&self.medicalCards.count>0) {
        for (NSInteger i=0; i<self.medicalCards.count; i++) {
            NSString *paramName = [NSString stringWithFormat:@"medicalCard_%ld",i];
            dict[paramName] = self.medicalCards[i];
        }
    }
    if (self.cases!=nil&&self.cases.count>0) {
        for (NSInteger i=0; i<self.cases.count; i++) {
            NSString *paramName = [NSString stringWithFormat:@"cases_%ld",i];
            dict[paramName] = self.cases[i];
        }
    }
    if (self.charges!=nil&&self.charges.count>0) {
        for (NSInteger i=0; i<self.charges.count; i++) {
            NSString *paramName = [NSString stringWithFormat:@"charges_%ld",i];
            dict[paramName] = self.charges[i];
        }
    }
    return dict;
}
@end
