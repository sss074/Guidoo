//
//  SWHistory.h
//  Guidoo
//
//  Created by Sergiy Bekker on 17.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBaseDataModel.h"
#import "SWGuide.h"

@interface SWHistory : SWBaseDataModel <NSCoding>

@property (nonatomic, strong) NSNumber* bookingId;
@property (nonatomic, strong) NSString* bookingState;
@property (nonatomic, strong) NSString* bookingType;
@property (nonatomic, strong) NSString* guideFirstName;
@property (nonatomic, strong) NSNumber* guideId;
@property (nonatomic, strong) NSString* guideLastName;
@property (nonatomic, strong) NSNumber* guideRegId;
@property (nonatomic, strong) NSNumber* startTime;
@property (nonatomic, strong) NSString* tourDurationHours;
@property (nonatomic, strong) NSNumber* tourId;
@property (nonatomic, strong) NSString* tourName;
@property (nonatomic, strong) NSNumber* userId;
@property (nonatomic, strong) SWTour* tour;
@end
