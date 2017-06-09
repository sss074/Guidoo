//
//  Repository.m
//  SWGitHub
//
//  Created by Sergiy Bekker on 15.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWRegister.h"


@implementation SWRegister

+ (NSDictionary *)attributesMapping {
    return @{@"userId": @"userId",
             @"sessionToken": @"sessionToken"
             };
}

+ (NSString *)pathPattern {
    return @"/register";
}

+ (NSString *)keyPath {
    return nil;
}

+ (NSDictionary *)parameters {
    return @{};
}


@end
