//
//  SWBookTour.m
//  Guidoo
//
//  Created by Sergiy Bekker on 09.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBookTour.h"

@interface SWBookTour ()

@end

@implementation SWBookTour

+ (NSDictionary *)attributesMapping {
    return @{
             };
}
+ (NSString *)pathPatternExtrn{
    return @"/cancelTour";
}
+ (NSString *)pathPattern {
    return @"/bookTour";
}

+ (NSString *)keyPath {
    return nil;
}

+ (NSDictionary *)parameters {
    return @{};
}



@end
