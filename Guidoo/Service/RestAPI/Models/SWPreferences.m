//
//  SWPreferences.m
//  Guidoo
//
//  Created by Sergiy Bekker on 04.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWPreferences.h"

@implementation SWPreferences
- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.maxPricePerHour forKey:@"maxPricePerHour"];
    [encoder encodeObject:self.maxDistance forKey:@"maxDistance"];
    [encoder encodeObject:self.maxTourDuration forKey:@"maxTourDuration"];
    [encoder encodeObject:self.isProfessional forKey:@"isProfessional"];
    [encoder encodeObject:self.sessionToken forKey:@"sessionToken"];
    [encoder encodeObject:self.languageIds forKey:@"languageIds"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.sessionToken = [decoder decodeObjectForKey:@"sessionToken"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.maxPricePerHour = [decoder decodeObjectForKey:@"maxPricePerHour"];
        self.maxDistance = [decoder decodeObjectForKey:@"maxDistance"];
        self.maxTourDuration = [decoder decodeObjectForKey:@"maxTourDuration"];
        self.isProfessional = [decoder decodeObjectForKey:@"isProfessional"];
        self.languageIds = [decoder decodeObjectForKey:@"languageIds"];
    }
    return self;
}
+ (NSDictionary *)attributesMapping {
    return nil;
}

+ (NSString *)pathPattern {
    NSString* pattern = nil;
    SWLogin *object = [self objectDataForKey:currentLoginKey];
    if(object != nil){
        pattern = [NSString stringWithFormat:@"/tourist/%ld/preferences",((NSNumber*)object.userId).integerValue];
    }
    return pattern;
}

+ (NSString *)keyPath {
    return nil;
}

+ (NSDictionary *)parameters {
    return @{};
}



@end
