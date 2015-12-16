//
//  HNAUser.m
//  MedicalNet
//
//  Created by gengliming on 15/12/9.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAUser.h"
#import "HNALoginInfoResult.h"

@implementation HNAUser


- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)user{
    return [[self alloc] init];
}

+ (instancetype)userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

+ (instancetype)userWithLoginInfoResult:(HNALoginInfoResult *)result{
    HNAUser *user = [HNAUser user];
    user.id = result.id;
    user.name = result.name;
    user.phoneNum = result.phoneNum;
    user.medicalId = result.medicalId;
    user.icon = result.icon;
    user.companyId = result.companyId;
    user.companyName = result.companyName;
    user.insuranceCompanyId = result.insuranceCompanyId;
    return user;
}

#pragma mark - NSCoding 重写
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.phoneNum = [aDecoder decodeObjectForKey:@"phoneNum"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.companyId = [aDecoder decodeObjectForKey:@"companyId"];
        self.companyName = [aDecoder decodeObjectForKey:@"companyName"];
        self.insuranceCompanyId = [aDecoder decodeObjectForKey:@"insuranceCompanyId"];
        self.medicalId = [aDecoder decodeObjectForKey:@"medicalId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.phoneNum forKey:@"phoneNum"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.companyId forKey:@"companyId"];
    [aCoder encodeObject:self.companyName forKey:@"companyName"];
    [aCoder encodeObject:self.insuranceCompanyId forKey:@"insuranceCompanyId"];
    [aCoder encodeObject:self.medicalId forKey:@"medicalId"];
}

@end
