//
//  SWHistory.m
//  Guidoo
//
//  Created by Sergiy Bekker on 17.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWHistory.h"

@implementation SWHistory
- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.bookingId forKey:@"bookingId"];
    [encoder encodeObject:self.bookingState forKey:@"bookingState"];
    [encoder encodeObject:self.bookingType forKey:@"bookingType"];
    [encoder encodeObject:self.guideFirstName forKey:@"guideFirstName"];
    [encoder encodeObject:self.guideId forKey:@"guideId"];
    [encoder encodeObject:self.guideLastName forKey:@"guideLastName"];
    [encoder encodeObject:self.guideRegId forKey:@"guideRegId"];
    [encoder encodeObject:self.startTime forKey:@"startTime"];
    [encoder encodeObject:self.tourDurationHours forKey:@"tourDurationHours"];
    [encoder encodeObject:self.tourId forKey:@"tourId"];
    [encoder encodeObject:self.tourName forKey:@"tourName"];
    [encoder encodeObject:self.tourName forKey:@"tourName"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.bookingId = [decoder decodeObjectForKey:@"bookingId"];
        self.bookingState = [decoder decodeObjectForKey:@"bookingState"];
        self.bookingType = [decoder decodeObjectForKey:@"bookingType"];
        self.guideFirstName = [decoder decodeObjectForKey:@"guideFirstName"];
        self.guideId = [decoder decodeObjectForKey:@"guideId"];
        self.guideLastName = [decoder decodeObjectForKey:@"guideLastName"];
        self.guideRegId = [decoder decodeObjectForKey:@"guideRegId"];
        self.startTime = [decoder decodeObjectForKey:@"startTime"];
        self.tourDurationHours = [decoder decodeObjectForKey:@"tourDurationHours"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.tourId = [decoder decodeObjectForKey:@"tourId"];
        self.tourName = [decoder decodeObjectForKey:@"tourName"];
    }
    return self;
}


@end
