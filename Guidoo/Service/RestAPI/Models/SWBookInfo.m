//
//  SWBookInfo.m
//  Guidoo
//
//  Created by Sergiy Bekker on 15.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBookInfo.h"

@implementation SWPayInfo
+ (NSDictionary *)attributesMapping {
    return @{
             };
}

+ (NSString *)pathPattern {
    return @"/registerPaymentMethod";
}
+ (NSString *)pathPatternExtrn{
    return @"/pay";
}
+ (NSString *)keyPath {
    return nil;
}

+ (NSDictionary *)parameters {
    return @{};
}


@end

@implementation SWBookInfo

+ (NSDictionary *)attributesMapping {
    return @{
             };
}

+ (NSString *)pathPattern {
    return @"/requestedBooking";
}
+ (NSString *)pathPatternExtrn{
    return @"/pay";
}
+ (NSString *)keyPath {
    return nil;
}

+ (NSDictionary *)parameters {
    return @{};
}



@end
