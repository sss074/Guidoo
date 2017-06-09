//
//  SWGuideService.m
//  Guidoo
//
//  Created by Sergiy Bekker on 05.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWGuideService.h"

@implementation SWGuideService


- (void) getNearbyGuides:(NSString*)param success:(void (^)(NSArray<SWGuide*> *obj))success failure:(void (^)(NSError *error))failure{
   
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupGetRequestDescriptors:param withtype:[SWGuide pathPattern]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode =  [self checkStatusCode:response];
        if (error){
            [self showIndecator:NO];
            if(statusCode != INVALIDTOKEN){
                if (failure) {
                    failure(error);
                }
            }
        } else {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showIndecator:NO];
                if(statusCode == SUCCSESS){
                    NSArray* result = (NSArray*)[self setupResponseDescriptors:data];
                    NSMutableArray* results = [[NSMutableArray alloc]initWithCapacity:result.count];
                    for(int i = 0; i < result.count; i++){
                        NSDictionary* obj = result[i];
                        SWGuide* guide = [SWGuide new];
                        guide.distanceMeters = obj[@"distanceMeters"];
                        guide.firstName = obj[@"firstName"];
                        guide.guideId = obj[@"guideId"];
                        guide.lastName = obj[@"lastName"];
                        guide.latitude = obj[@"latitude"];
                        guide.longitude = obj[@"longitude"];
                        guide.pricePerHour = obj[@"pricePerHour"];
                        guide.rating = obj[@"rating"];
                        guide.regId = obj[@"regId"];
                        guide.resume = obj[@"resume"];
                        NSArray* tours = obj[@"tours"];
                        NSMutableArray* temp = [[NSMutableArray alloc]initWithCapacity:tours.count];
                        for(int j =0; j < tours.count; j++){
                            NSDictionary* obj1 = tours[j];
                            SWTour* tour = [SWTour new];
                            tour.descriptions = obj1[@"description"];
                            tour.durationHours = obj1[@"durationHours"];
                            tour.imageIds = obj1[@"imageIds"];
                            tour.meetingPointLatitude = obj1[@"meetingPointLatitude"];
                            tour.meetingPointLongitude = obj1[@"meetingPointLongitude"];
                            tour.name = obj1[@"name"];
                            tour.pois = obj1[@"pois"];
                            tour.rating = obj1[@"rating"];
                            tour.tourId = obj1[@"tourId"];
                            tour.pricePerHour = guide.pricePerHour;
                            tour.guideId = guide.guideId;
                            tour.tourGroupSizeId = obj1[@"tourGroupSizeId"];
                            tour.meetingPointDescription = obj1[@"meetingPointDescription"];
                            tour.languageIds = obj1[@"languageIds"];
                            tour.importantInfo = obj1[@"importantInfo"];
                            tour.countryId = obj1[@"countryId"];
                            tour.city = obj1[@"city"];
                            tour.additionalExpensesAmount = obj1[@"additionalExpensesAmount"];
                            tour.additionalExpenseIds = obj1[@"additionalExpenseIds"];
                            [temp addObject:tour];
                        }
                        guide.tours = [NSArray arrayWithArray:temp];
                        [results addObject:guide];
                    }
                    
                    if (success) {
                        success([NSArray arrayWithArray:results]);
                    }
                }
            });
        }
        
    }]resume];

}
- (void) getGuidesByKeywords:(NSString*)param success:(void (^)(NSArray<SWGuide*> *obj))success failure:(void (^)(NSError *error))failure{
    
    NSString* pathPattern = [NSString stringWithFormat:@"/guidesByKeywords"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupGetRequestDescriptors:param withtype:pathPattern] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode =  [self checkStatusCode:response];
        if (error){
            [self showIndecator:NO];
            if(statusCode != INVALIDTOKEN){
                if (failure) {
                    failure(error);
                }
            }
        } else {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showIndecator:NO];
                if(statusCode == SUCCSESS){
                    NSArray* result = (NSArray*)[self setupResponseDescriptors:data];
                    NSMutableArray* results = [[NSMutableArray alloc]initWithCapacity:result.count];
                    for(int i = 0; i < result.count; i++){
                        NSDictionary* obj = result[i];
                        SWGuide* guide = [SWGuide new];
                        guide.distanceMeters = obj[@"distanceMeters"];
                        guide.firstName = obj[@"firstName"];
                        guide.guideId = obj[@"guideId"];
                        guide.lastName = obj[@"lastName"];
                        guide.latitude = obj[@"latitude"];
                        guide.longitude = obj[@"longitude"];
                        guide.pricePerHour = obj[@"pricePerHour"];
                        guide.rating = obj[@"rating"];
                        guide.regId = obj[@"regId"];
                        guide.resume = obj[@"resume"];
                        NSArray* tours = obj[@"tours"];
                        NSMutableArray* temp = [[NSMutableArray alloc]initWithCapacity:tours.count];
                        for(int j =0; j < tours.count; j++){
                            NSDictionary* obj1 = tours[j];
                            SWTour* tour = [SWTour new];
                            tour.descriptions = obj1[@"description"];
                            tour.durationHours = obj1[@"durationHours"];
                            tour.imageIds = obj1[@"imageIds"];
                            tour.meetingPointLatitude = obj1[@"meetingPointLatitude"];
                            tour.meetingPointLongitude = obj1[@"meetingPointLongitude"];
                            tour.name = obj1[@"name"];
                            tour.pois = obj1[@"pois"];
                            tour.rating = obj1[@"rating"];
                            tour.tourId = obj1[@"tourId"];
                            tour.pricePerHour = guide.pricePerHour;
                            tour.guideId = guide.guideId;
                            tour.tourGroupSizeId = obj1[@"tourGroupSizeId"];
                            tour.meetingPointDescription = obj1[@"meetingPointDescription"];
                            tour.languageIds = obj1[@"languageIds"];
                            tour.importantInfo = obj1[@"importantInfo"];
                            tour.countryId = obj1[@"countryId"];
                            tour.city = obj1[@"city"];
                            tour.additionalExpensesAmount = obj1[@"additionalExpensesAmount"];
                            tour.additionalExpenseIds = obj1[@"additionalExpenseIds"];
                            [temp addObject:tour];
                        }
                        guide.tours = [NSArray arrayWithArray:temp];
                        [results addObject:guide];
                    }
                    
                    if (success) {
                        success([NSArray arrayWithArray:results]);
                    }
                }
            });
        }
        
    }]resume];

}
- (void) getGuides:(NSString*)param success:(void (^)(NSArray<SWGuide*> *obj))success failure:(void (^)(NSError *error))failure{
   
    NSString* pathPattern = [NSString stringWithFormat:@"/guides"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupGetRequestDescriptors:param withtype:pathPattern] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode =  [self checkStatusCode:response];
        if (error){
            [self showIndecator:NO];
            if(statusCode != INVALIDTOKEN){
                if (failure) {
                    failure(error);
                }
            }
        } else {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showIndecator:NO];
                if(statusCode == SUCCSESS){
                    NSArray* result = (NSArray*)[self setupResponseDescriptors:data];
                    NSMutableArray* results = [[NSMutableArray alloc]initWithCapacity:result.count];
                    for(int i = 0; i < result.count; i++){
                        NSDictionary* obj = result[i];
                        SWGuide* guide = [SWGuide new];
                        guide.distanceMeters = obj[@"distanceMeters"];
                        guide.firstName = obj[@"firstName"];
                        guide.guideId = obj[@"guideId"];
                        guide.lastName = obj[@"lastName"];
                        guide.latitude = obj[@"latitude"];
                        guide.longitude = obj[@"longitude"];
                        guide.pricePerHour = obj[@"pricePerHour"];
                        guide.rating = obj[@"rating"];
                        guide.regId = obj[@"regId"];
                        guide.resume = obj[@"resume"];
                        NSArray* tours = obj[@"tours"];
                        NSMutableArray* temp = [[NSMutableArray alloc]initWithCapacity:tours.count];
                        for(int j =0; j < tours.count; j++){
                            NSDictionary* obj1 = tours[j];
                            SWTour* tour = [SWTour new];
                            tour.descriptions = obj1[@"description"];
                            tour.durationHours = obj1[@"durationHours"];
                            tour.imageIds = obj1[@"imageIds"];
                            tour.meetingPointLatitude = obj1[@"meetingPointLatitude"];
                            tour.meetingPointLongitude = obj1[@"meetingPointLongitude"];
                            tour.name = obj1[@"name"];
                            tour.pois = obj1[@"pois"];
                            tour.rating = obj1[@"rating"];
                            tour.tourId = obj1[@"tourId"];
                            tour.pricePerHour = guide.pricePerHour;
                            tour.guideId = guide.guideId;
                            tour.tourGroupSizeId = obj1[@"tourGroupSizeId"];
                            tour.meetingPointDescription = obj1[@"meetingPointDescription"];
                            tour.languageIds = obj1[@"languageIds"];
                            tour.importantInfo = obj1[@"importantInfo"];
                            tour.countryId = obj1[@"countryId"];
                            tour.city = obj1[@"city"];
                            tour.additionalExpensesAmount = obj1[@"additionalExpensesAmount"];
                            tour.additionalExpenseIds = obj1[@"additionalExpenseIds"];
                            [temp addObject:tour];
                        }
                        guide.tours = [NSArray arrayWithArray:temp];
                        [results addObject:guide];
                    }
                    
                    if (success) {
                        success([NSArray arrayWithArray:results]);
                    }
                }
            });
        }
        
    }]resume];

}
- (void) getGuideProfile:(NSString*)param withID:(NSNumber*)ID success:(void (^)(SWGuide *obj))success failure:(void (^)(NSError *error))failure{
   
    NSString* pathPattern = [NSString stringWithFormat:@"guide/%ld/profile",ID.integerValue];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupGetRequestDescriptors:param withtype:pathPattern] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode =  [self checkStatusCode:response];
        if (error){
            [self showIndecator:NO];
            if(statusCode != INVALIDTOKEN){
                if (failure) {
                    failure(error);
                }
            }
        } else {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showIndecator:NO];
                if(statusCode == SUCCSESS){
                    SWGuide* guide = [SWGuide new];
                    NSArray* result = (NSArray*)[self setupResponseDescriptors:data];
                    NSMutableArray* results = [[NSMutableArray alloc]initWithCapacity:result.count];
                    for(int i = 0; i < result.count; i++){
                        NSDictionary* obj = result[i];
                        
                        guide.distanceMeters = obj[@"distanceMeters"];
                        guide.firstName = obj[@"firstName"];
                        guide.guideId = obj[@"guideId"];
                        guide.lastName = obj[@"lastName"];
                        guide.latitude = obj[@"latitude"];
                        guide.longitude = obj[@"longitude"];
                        guide.pricePerHour = obj[@"pricePerHour"];
                        guide.rating = obj[@"rating"];
                        guide.regId = obj[@"regId"];
                        guide.resume = obj[@"resume"];
                        NSArray* tours = obj[@"tours"];
                        NSMutableArray* temp = [[NSMutableArray alloc]initWithCapacity:tours.count];
                        for(int j =0; j < tours.count; j++){
                            NSDictionary* obj1 = tours[j];
                            SWTour* tour = [SWTour new];
                            tour.descriptions = obj1[@"description"];
                            tour.durationHours = obj1[@"durationHours"];
                            tour.imageIds = obj1[@"imageIds"];
                            tour.meetingPointLatitude = obj1[@"meetingPointLatitude"];
                            tour.meetingPointLongitude = obj1[@"meetingPointLongitude"];
                            tour.name = obj1[@"name"];
                            tour.pois = obj1[@"pois"];
                            tour.rating = obj1[@"rating"];
                            tour.tourId = obj1[@"tourId"];
                            tour.pricePerHour = guide.pricePerHour;
                            tour.guideId = guide.guideId;
                            tour.tourGroupSizeId = obj1[@"tourGroupSizeId"];
                            tour.meetingPointDescription = obj1[@"meetingPointDescription"];
                            tour.languageIds = obj1[@"languageIds"];
                            tour.importantInfo = obj1[@"importantInfo"];
                            tour.countryId = obj1[@"countryId"];
                            tour.city = obj1[@"city"];
                            tour.additionalExpensesAmount = obj1[@"additionalExpensesAmount"];
                            tour.additionalExpenseIds = obj1[@"additionalExpenseIds"];
                            [temp addObject:tour];
                        }
                        guide.tours = [NSArray arrayWithArray:temp];
                        [results addObject:guide];
                    }
                    
                    if (success) {
                        success(guide);
                    }
                }
            });
        }
        
    }]resume];
}

@end
