//
//  SWPush.m
//  Guidoo
//
//  Created by Sergiy Bekker on 10.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWPush.h"

@implementation SWPush

+ (NSDictionary *)attributesMapping {
    return @{
             };
}

+ (NSString *)pathPattern {
    return @"/notificationToken";
}

+ (NSString *)keyPath {
    return nil;
}

+ (NSDictionary *)parameters {
    return @{};
}

@end
