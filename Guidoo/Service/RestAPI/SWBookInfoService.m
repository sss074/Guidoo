//
//  SWBookInfoService.m
//  Guidoo
//
//  Created by Sergiy Bekker on 15.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBookInfoService.h"

@implementation SWBookInfoService


- (void) requestedBooking:(NSString*)param withBookingID:(NSNumber*)ID success:(void (^)(SWBookInfo* obj))success failure:(void (^)(NSError *error))failure{
    
    NSString* pattern = [NSString stringWithFormat:@"%@/%ld",[SWBookInfo pathPattern],ID.integerValue];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupGetRequestDescriptors:param withtype:pattern] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode =  [self checkStatusCode:response];
        if (error){
  
            if(statusCode != INVALIDTOKEN){
                if (failure) {
                    failure(error);
                }
            }
        } else {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{

                if(statusCode == SUCCSESS){
                    NSDictionary* result = (NSDictionary*)[self setupResponseDescriptors:data];
                    SWBookInfo* obj = [SWBookInfo new];
                    if(result != nil){
                        obj.bookingId = result[@"bookingId"];
                        obj.bookingState = result[@"bookingState"];
                        obj.startTime =  result[@"startTime"];
                        obj.bookingType = result[@"bookingType"];
                        
                        NSDictionary* guide = result[@"guide"];
                        SWGuide* guideObj = [SWGuide new];
                        guideObj.firstName = guide[@"firstName"];
                        guideObj.guideId = guide[@"guideId"];
                        guideObj.lastName = guide[@"lastName"];
                        guideObj.pricePerHour = guide[@"pricePerHour"];
                        guideObj.rating = guide[@"rating"];
                        guideObj.regId = guide[@"regId"];
                        obj.guide = guideObj;
                        
                        NSDictionary* tour = result[@"tour"];
                        SWTour* tourObj = [SWTour new];
                        tourObj.additionalExpenseIds = tour[@"additionalExpenseIds"];
                        tourObj.additionalExpensesAmount = tour[@"additionalExpensesAmount"];
                        tourObj.city = tour[@"city"];
                        tourObj.countryId = tour[@"countryId"];
                        tourObj.descriptions = tour[@"description"];
                        tourObj.durationHours = tour[@"durationHours"];
                        tourObj.imageIds = tour[@"imageIds"];
                        tourObj.importantInfo = tour[@"importantInfo"];
                        tourObj.languageIds = tour[@"languageIds"];
                        tourObj.meetingPointDescription = tour[@"meetingPointDescription"];
                        tourObj.meetingPointLatitude = tour[@"meetingPointLatitude"];
                        tourObj.meetingPointLongitude = tour[@"meetingPointLongitude"];
                        tourObj.name = tour[@"name"];
                        tourObj.rating = tour[@"rating"];
                        tourObj.tourGroupSizeId = tour[@"tourGroupSizeId"];
                        tourObj.tourId = tour[@"tourId"];
                        obj.tour = tourObj;
                        
                    }
                    if (success) {
                        success(obj);
                    }
                }
                
            });
        }
        
    }]resume];
}
@end
