//
//  SWGuide.h
//  Guidoo
//
//  Created by Sergiy Bekker on 05.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBaseDataModel.h"

@interface SWTour : SWBaseDataModel

@property (nonatomic, strong) NSArray* additionalExpenseIds;
@property (nonatomic, strong) NSNumber* additionalExpensesAmount;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSNumber* countryId;
@property (nonatomic, strong) NSNumber* durationHours;
@property (nonatomic, strong) NSString* descriptions;
@property (nonatomic, strong) NSArray* imageIds;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSNumber* tourId;
@property (nonatomic, strong) NSString* importantInfo;
@property (nonatomic, strong) NSArray* pois;
@property (nonatomic, strong) NSNumber* meetingPointLatitude;
@property (nonatomic, strong) NSNumber* meetingPointLongitude;
@property (nonatomic, strong) NSString* meetingPointDescription;
@property (nonatomic, strong) NSArray* languageIds;
@property (nonatomic, strong) NSNumber* rating;
@property (nonatomic, strong) NSNumber* pricePerHour;
@property (nonatomic, strong) NSNumber* guideId;
@property (nonatomic, strong) NSNumber* tourGroupSizeId;
@property (nonatomic, strong) NSString* bookingState;
@property (nonatomic, strong) NSNumber* startTime;
@property (nonatomic, strong) NSNumber* bookingId;
@property (nonatomic, strong) NSNumber* imageId;
@end

@interface SWGuide : SWBaseDataModel

@property (nonatomic, strong) NSNumber* distanceMeters;
@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSNumber* guideId;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, strong) NSNumber* latitude;
@property (nonatomic, strong) NSNumber* longitude;
@property (nonatomic, strong) NSNumber* pricePerHour;
@property (nonatomic, strong) NSNumber* rating;
@property (nonatomic, strong) NSNumber* regId;
@property (nonatomic, strong) NSString* resume;
@property (nonatomic, strong) NSArray<SWTour*>* tours;

@end
