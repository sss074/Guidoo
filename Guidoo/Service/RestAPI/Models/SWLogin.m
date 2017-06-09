//
//  SWLogin.m
//  Guidoo
//
//  Created by Sergiy Bekker on 03.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWLogin.h"

@implementation SWLogin
- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.activeBookingId forKey:@"activeBookingId"];
    [encoder encodeObject:self.activeBookingId forKey:@"profileExists"];
    [encoder encodeObject:self.sessionToken forKey:@"sessionToken"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.activeBookingId = [decoder decodeObjectForKey:@"activeBookingId"];
        self.activeBookingId = [decoder decodeObjectForKey:@"profileExists"];
        self.sessionToken = [decoder decodeObjectForKey:@"sessionToken"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
    }
    return self;
}

+ (NSDictionary *)attributesMapping {
    return @{@"userId": @"userId",
             @"sessionToken": @"sessionToken",
             @"activeBookingId": @"activeBookingId",
             @"profileExists": @"profileExists"
             };
}


+ (NSString *)pathPattern {
    return @"/login";
}

+ (NSString *)keyPath {
    return nil;
}

+ (NSDictionary *)parameters {
    return @{};
}


@end
