//
//  SWLanguage.m
//  Guidoo
//
//  Created by Sergiy Bekker on 03.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWLanguage.h"

@implementation SWAdditionalExpenses
- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.value forKey:@"value"];
    [encoder encodeObject:self.ID forKey:@"ID"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.ID = [decoder decodeObjectForKey:@"ID"];
        self.value = [decoder decodeObjectForKey:@"value"];
    }
    return self;
}
@end

@implementation SWCountries
- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.ID forKey:@"ID"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.ID = [decoder decodeObjectForKey:@"ID"];
        self.name = [decoder decodeObjectForKey:@"name"];
    }
    return self;
}
@end


@implementation SWTourGroupSizes
- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.value forKey:@"value"];
    [encoder encodeObject:self.ID forKey:@"ID"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.ID = [decoder decodeObjectForKey:@"ID"];
        self.value = [decoder decodeObjectForKey:@"value"];
    }
    return self;
}
@end

@implementation SWLanguage

+ (NSDictionary *)attributesMapping {
    return @{@"ID": @"id",
             @"name": @"name"};
}


+ (NSString *)pathPattern {
    return @"/dictionaries";
}

+ (NSString *)keyPath {
    return nil;
}

+ (NSDictionary *)parameters {
    return @{};
}



@end
