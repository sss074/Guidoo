//
//  SWConfirmPhone.m
//  Guidoo
//
//  Created by Sergiy Bekker on 28.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWConfirmPhone.h"

@implementation SWConfirmPhone

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.token = [decoder decodeObjectForKey:@"token"];
        self.phoneNumber= [decoder decodeObjectForKey:@"phoneNumber"];

    }
    return self;
}
+ (NSDictionary *)attributesMapping {
    return @{@"token": @"token",
             @"phone": @"phone"};
}


+ (NSString *)pathPattern {
    return @"/confirmPhone";
}

+ (NSString *)keyPath {
    return nil;
}

+ (NSDictionary *)parameters {
    return @{};
}



@end
