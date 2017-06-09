//
//  SWChatMessage.m
//  Guidoo
//
//  Created by Sergiy Bekker on 26.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWChatMessage.h"

@implementation SWChatMessage

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.senderUserId forKey:@"senderUserId"];
    [encoder encodeObject:self.regId forKey:@"regId"];
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.message forKey:@"message"];
    [encoder encodeObject:self.sentTime forKey:@"sentTime"];
    [encoder encodeBool:self.isIncome forKey:@"isIncome"];
    [encoder encodeBool:self.isNew forKey:@"isNew"];
    [encoder encodeBool:self.messageId forKey:@"messageId"];
    [encoder encodeBool:self.badgeCout forKey:@"badgeCout"];
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.senderUserId = [decoder decodeObjectForKey:@"senderUserId"];
        self.regId = [decoder decodeObjectForKey:@"regId"];
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
        self.message = [decoder decodeObjectForKey:@"message"];
        self.sentTime = [decoder decodeObjectForKey:@"sentTime"];
        self.isIncome = [decoder decodeObjectForKey:@"isIncome"];
        self.isNew = [decoder decodeObjectForKey:@"isNew"];
        self.messageId = [decoder decodeObjectForKey:@"messageId"];
        self.badgeCout = [decoder decodeObjectForKey:@"badgeCout"];

    }
    return self;
}


@end
