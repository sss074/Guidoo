//
//  SWBookInfo.h
//  Guidoo
//
//  Created by Sergiy Bekker on 15.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBaseDataModel.h"
#import "SWGuide.h"

@interface SWPayInfo : SWBaseDataModel

@property (nonatomic, strong) NSNumber* amount;
@property (nonatomic, strong) NSNumber* bookingId;
@property (nonatomic, strong) NSNumber* created;
@property (nonatomic, strong) NSString* currency;
@property (nonatomic, strong) NSString* firstNamePayer;
@property (nonatomic, strong) NSNumber* guideId;
@property (nonatomic, strong) NSString* lastNamePayer;
@property (nonatomic, strong) NSString* regIdPayer;
@property (nonatomic, strong) NSNumber* tourId;
@property (nonatomic, strong) NSString* tourName;
@property (nonatomic, strong) NSNumber* touristId;


@end

@interface SWBookInfo : SWBaseDataModel

@property (nonatomic, strong) NSNumber* bookingId;
@property (nonatomic, strong) NSNumber* startTime;
@property (nonatomic, strong) NSString* bookingState;
@property (nonatomic, strong) NSString* bookingType;
@property (nonatomic, strong) SWGuide* guide;
@property (nonatomic, strong) SWTour* tour;

@end
