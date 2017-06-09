//
//  SWProfile.m
//  Guidoo
//
//  Created by Sergiy Bekker on 11.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWProfile.h"

@implementation SWProfile

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.countryId forKey:@"countryId"];
    [encoder encodeObject:self.languageIds forKey:@"languageIds"];
    [encoder encodeObject:self.avatar forKey:@"avatar"];
    [encoder encodeObject:self.birthdayStr forKey:@"birthdayStr"];
    [encoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    [encoder encodeObject:self.notifyState forKey:@"notifyState"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.birthday = [decoder decodeObjectForKey:@"birthday"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.countryId = [decoder decodeObjectForKey:@"countryId"];
        self.languageIds = [decoder decodeObjectForKey:@"languageIds"];
        self.avatar = [decoder decodeObjectForKey:@"avatar"];
        self.birthdayStr = [decoder decodeObjectForKey:@"birthdayStr"];
        self.phoneNumber = [decoder decodeObjectForKey:@"phoneNumber"];
        self.notifyState = [decoder decodeObjectForKey:@"notifyState"];
    }
    return self;
}

+ (NSDictionary *)attributesMapping {
    return @{};
}

+ (NSString *)pathPatternDelete{
    NSString* pattern = nil;
    SWLogin *object = [self objectDataForKey:userLoginInfo];
    if(object != nil){
        pattern = [NSString stringWithFormat:@"/user/%ld",((NSNumber*)object.userId).integerValue];
    } else {
        object = [self objectDataForKey:currentLoginKey];
        if(object != nil)
            pattern = [NSString stringWithFormat:@"/user/%ld",((NSNumber*)object.userId).integerValue];
    }
    return pattern;
}
+ (NSString *)pathPattern {
    NSString* pattern = nil;
    SWLogin *object = [self objectDataForKey:userLoginInfo];
    if(object != nil){
        pattern = [NSString stringWithFormat:@"/tourist/%ld/profile",((NSNumber*)object.userId).integerValue];
    } else {
        object = [self objectDataForKey:currentLoginKey];
        if(object != nil)
            pattern = [NSString stringWithFormat:@"/tourist/%ld/profile",((NSNumber*)object.userId).integerValue];
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
