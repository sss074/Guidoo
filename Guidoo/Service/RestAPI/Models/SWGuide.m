//
//  SWGuide.m
//  Guidoo
//
//  Created by Sergiy Bekker on 05.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWGuide.h"

@implementation SWTour



@end


@implementation SWGuide


+ (NSDictionary *)attributesMapping {
    return @{
             };
}

+ (NSString *)pathPatternExtrn{
    return @"/guidesByKeywords";
}

+ (NSString *)pathPattern {
    return @"/guidesOnDemand";
}

+ (NSString *)keyPath {
    return nil;
}

+ (NSDictionary *)parameters {
    return @{};
}


@end
