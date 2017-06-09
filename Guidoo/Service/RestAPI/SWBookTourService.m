//
//  SWBookTourService.m
//  Guidoo
//
//  Created by Sergiy Bekker on 09.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBookTourService.h"

@implementation SWBookTourService


- (void) bookTour:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
  
    NSString* pattern = [NSString stringWithFormat:@"%@/%ld",[SWBookTour pathPattern],ID.integerValue];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:pattern] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                if(statusCode == ISBOOKTOUR){
                    [self showAlertMessage:@"You already ordered this tour"];
                    if (failure) {
                        failure(error);
                    }
                } else if(statusCode == SUCCSESS){
                    if (success) {
                        success();
                    }
                }
                
            });
        }
        
    }]resume];
}
- (void) getPayTours:(NSString*)param  success:(void (^)(NSArray<SWPayInfo*>* obj))success failure:(void (^)(NSError *error))failure{
    NSString* pattern = nil;
    SWLogin *object = [self objectDataForKey:currentLoginKey];
    if(object != nil){
        pattern = [NSString stringWithFormat:@"/guide/%ld/payments",((NSNumber*)object.userId).integerValue];
    }
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupGetRequestDescriptors:param withtype:pattern] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    if (success) {
                        success(nil);
                    }
                }
                
            });
        }
        
    }]resume];

}
- (void) registerPaymentMethod:(NSString*)param  success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:[SWPayInfo pathPattern]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    NSDictionary* result = (NSDictionary*)[self setupResponseDescriptors:data];
                    [self setObjectForKey:result forKey:@"payInfo"];
                    if (success) {
                        success();
                    }
                }
                
            });
        }
        
    }]resume];
}
- (void) payTour:(NSString*)param   success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
   
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:[SWBookInfo pathPatternExtrn]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    if (success) {
                        success();
                    }
                }
                
            });
        }
        
    }]resume];
}
- (void) cancelTour:(NSString*)param   success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
   
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:[SWBookTour pathPatternExtrn]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    if (success) {
                        success();
                    }
                }
                
            });
        }
        
    }]resume];
}
- (void) bookingActivityPast:(NSString*)param  success:(void (^)(NSArray<SWHistory*> *obj))success failure:(void (^)(NSError *error))failure{
    
    NSString* pathPattern = [NSString stringWithFormat:@"/bookingActivity/past"];
    
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
                        NSDictionary *param = result[i];
                        SWHistory* obj = [SWHistory new];
                        obj.bookingId = param[@"bookingId"];
                        obj.bookingState = param[@"bookingState"];
                        obj.bookingType = param[@"bookingType"];
                        obj.guideFirstName = param[@"guideFirstName"];
                        obj.guideId = param[@"guideId"];
                        obj.guideLastName = param[@"guideLastName"];
                        obj.guideRegId = param[@"guideRegId"];
                        obj.startTime = param[@"startTime"];
                        obj.tourDurationHours = param[@"tourDurationHours"];
                        obj.tourId = param[@"tourId"];
                        obj.tourName = param[@"tourName"];
                        obj.userId = param[@"userId"];
                        
                        [results addObject:obj];
                    }
                    
                    if (success) {
                        success([NSArray arrayWithArray:results]);
                    }
                }
            });
        }
        
    }]resume];
}
- (void) bookingActivityFuture:(NSString*)param  success:(void (^)(NSArray<SWHistory*> *obj))success failure:(void (^)(NSError *error))failure{
    
    NSString* pathPattern = [NSString stringWithFormat:@"/bookingActivity/future"];
    
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
                        NSDictionary *param = result[i];
                        SWHistory* obj = [SWHistory new];
                        obj.bookingId = param[@"bookingId"];
                        obj.bookingState = param[@"bookingState"];
                        obj.bookingType = param[@"bookingType"];
                        obj.guideFirstName = param[@"guideFirstName"];
                        obj.guideId = param[@"guideId"];
                        obj.guideLastName = param[@"guideLastName"];
                        obj.guideRegId = param[@"guideRegId"];
                        obj.startTime = param[@"startTime"];
                        obj.tourDurationHours = param[@"tourDurationHours"];
                        obj.tourId = param[@"tourId"];
                        obj.tourName = param[@"tourName"];
                        obj.userId = param[@"userId"];
                        
                        [results addObject:obj];
                    }
                    
                    if (success) {
                        success([NSArray arrayWithArray:results]);
                    }
                }
            });
        }
        
    }]resume];
}
- (void) bookmarks:(NSString*)param  success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
    
    SWLogin *object = [self objectDataForKey:userLoginInfo];
    
    NSString* pathPattern = [NSString stringWithFormat:@"/bookmarks/%ld",((NSNumber*)object.userId).integerValue];
    
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
                    
                    NSDictionary* result =[self setupResponseDescriptors:data];
                    NSArray* guides = result[@"guides"];
                    NSMutableArray* results = [[NSMutableArray alloc]initWithCapacity:result.count];
                    for(int i = 0; i < guides.count; i++){
                        NSDictionary *param = guides[i];
                        SWGuide* obj = [SWGuide new];
                        obj.guideId = param[@"guideId"];
                        obj.firstName = param[@"firstName"];
                        obj.lastName = param[@"lastName"];
                        obj.pricePerHour = param[@"pricePerHour"];
                        obj.rating = param[@"rating"];
                        obj.regId = param[@"regId"];

                        
                        [results addObject:obj];
                    }

                    [SWWebManager sharedManager].bookmarkGuids = [NSArray arrayWithArray:results];
                    
                    NSArray* tours = result[@"tours"];
                    [results removeAllObjects];
                    for(int i = 0; i < tours.count; i++){
                        NSDictionary *param = tours[i];
                        SWTour* obj = [SWTour new];
                        obj.guideId = param[@"guideId"];
                        obj.tourId = param[@"tourId"];
                        obj.name = param[@"name"];
                        obj.rating = param[@"rating"];
                        obj.imageId = param[@"imageId"];
                        obj.durationHours = param[@"durationHours"];
                        obj.pricePerHour = param[@"tourPrice"];

                        [results addObject:obj];
                    }
                    [SWWebManager sharedManager].bookmarkTours = [NSArray arrayWithArray:results];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBookmarks" object:nil];
                    
                    if (success) {
                        success();
                    }
                }
            });
        }
        
    }]resume];
}
- (void) bookmarksGuid:(NSString*)param withGuideID:(NSNumber*)ID success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
    SWLogin *object = [self objectDataForKey:userLoginInfo];
    
    NSString* pathPattern = [NSString stringWithFormat:@"/bookmarks/%ld/guide/%ld?sessionToken=%@",((NSNumber*)object.userId).integerValue,ID.integerValue,object.sessionToken];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:pathPattern] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                if(statusCode == SUCCSESS || statusCode == 400){
                    SWLogin *object = [self objectDataForKey:userLoginInfo];
                    if(object != nil){
                        NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken];
                        [[SWWebManager sharedManager]bookmarks:param success:^{
                            if (success) {
                                success();
                            }
                        }];
                    }
                }
                
            });
        }
        
    }]resume];

}
- (void) bookmarksTour:(NSString*)param  withGuideID:(NSNumber*)ID success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
    SWLogin *object = [self objectDataForKey:userLoginInfo];
    
    NSString* pathPattern = [NSString stringWithFormat:@"/bookmarks/%ld/tour/%ld?sessionToken=%@",((NSNumber*)object.userId).integerValue,ID.integerValue,object.sessionToken];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:pathPattern] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    SWLogin *object = [self objectDataForKey:userLoginInfo];
                    if(object != nil){
                        NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken];
                        [[SWWebManager sharedManager]bookmarks:param success:^{
                            if (success) {
                                success();
                            }
                        }];
                    }
                }
                
            });
        }
        
    }]resume];
}
- (void) removeBookmarksGuid:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
    SWLogin *object = [self objectDataForKey:userLoginInfo];
    
    NSString* pathPattern = [NSString stringWithFormat:@"/bookmarks/%ld/guide/%ld?sessionToken=%@",((NSNumber*)object.userId).integerValue,ID.integerValue,object.sessionToken];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupDeleteRequestDescriptors:param withtype:pathPattern] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    SWLogin *object = [self objectDataForKey:userLoginInfo];
                    if(object != nil){
                        NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken];
                        [[SWWebManager sharedManager]bookmarks:param success:^{
                            if (success) {
                                success();
                            }
                        }];
                    }
                }
                
            });
        }
        
    }]resume];
}
- (void) removeBookmarksTour:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
    SWLogin *object = [self objectDataForKey:userLoginInfo];
    
    NSString* pathPattern = [NSString stringWithFormat:@"/bookmarks/%ld/tour/%ld?sessionToken=%@",((NSNumber*)object.userId).integerValue,ID.integerValue,object.sessionToken];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupDeleteRequestDescriptors:param withtype:pathPattern] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    SWLogin *object = [self objectDataForKey:userLoginInfo];
                    if(object != nil){
                        NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken];
                        [[SWWebManager sharedManager]bookmarks:param success:^{
                            if (success) {
                                success();
                            }
                        }];
                    }
                   
                }
                
            });
        }
        
    }]resume];
}
- (void) getTours:(NSString*)param withGuideID:(NSNumber*)ID success:(void (^)(NSArray<SWTour*>* obj))success failure:(void (^)(NSError *error))failure{

  
    NSString* pathPattern = [NSString stringWithFormat:@"/guide/%ld/tours",ID.integerValue];
    
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
                    
                    NSArray* result =[self setupResponseDescriptors:data];
                    NSMutableArray* results = [[NSMutableArray alloc]initWithCapacity:result.count];
    
                    for(int i = 0; i < result.count; i++){
                        NSDictionary* obj1 = result[i];
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
                        tour.tourGroupSizeId = obj1[@"tourGroupSizeId"];
                        tour.meetingPointDescription = obj1[@"meetingPointDescription"];
                        tour.languageIds = obj1[@"languageIds"];
                        tour.importantInfo = obj1[@"importantInfo"];
                        tour.countryId = obj1[@"countryId"];
                        tour.city = obj1[@"city"];
                        tour.additionalExpensesAmount = obj1[@"additionalExpensesAmount"];
                        tour.additionalExpenseIds = obj1[@"additionalExpenseIds"];
                   
                        [results addObject:tour];
                    }
                    [SWWebManager sharedManager].bookmarkTours = [NSArray arrayWithArray:results];
                    
                    
                    if (success) {
                        success([NSArray arrayWithArray:results]);
                    }
                }
            });
        }
        
    }]resume];

}
- (void) getTour:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(SWTour* obj))success failure:(void (^)(NSError *error))failure{
 
    NSString* pathPattern = [NSString stringWithFormat:@"/tour/%ld",ID.integerValue];
    
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
                    
                    NSDictionary* param =[self setupResponseDescriptors:data];

                    SWTour* tour = [SWTour new];
                    tour.descriptions = param[@"description"];
                    tour.durationHours = param[@"durationHours"];
                    tour.imageIds = param[@"imageIds"];
                    tour.meetingPointLatitude = param[@"meetingPointLatitude"];
                    tour.meetingPointLongitude = param[@"meetingPointLongitude"];
                    tour.name = param[@"name"];
                    tour.pois = param[@"pois"];
                    tour.rating = param[@"rating"];
                    tour.tourId = param[@"tourId"];
                    tour.tourGroupSizeId = param[@"tourGroupSizeId"];
                    tour.meetingPointDescription = param[@"meetingPointDescription"];
                    tour.languageIds = param[@"languageIds"];
                    tour.importantInfo = param[@"importantInfo"];
                    tour.countryId = param[@"countryId"];
                    tour.city = param[@"city"];
                    tour.additionalExpensesAmount = param[@"additionalExpensesAmount"];
                    tour.additionalExpenseIds = param[@"additionalExpenseIds"];

       
                    if (success) {
                        success(tour);
                    }
                }
            });
        }
        
    }]resume];

}
- (void) getUnratedTours:(NSString*)param success:(void (^)(NSArray<SWBookInfo*>* obj))success failure:(void (^)(NSError *error))failure{
  
    NSString* pathPattern = [NSString stringWithFormat:@"/unratedTours"];
    
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
                    
                    NSArray* result =[self setupResponseDescriptors:data];
                    NSMutableArray* results = [[NSMutableArray alloc]initWithCapacity:result.count];
                    
                    for(int i = 0; i < result.count; i++){
                        NSDictionary* obj1 = result[i];
                        SWBookInfo* bookInfo = [SWBookInfo new];
                        bookInfo.bookingId = obj1[@"bookingId"];
                        bookInfo.startTime = obj1[@"completionTime"];
                        bookInfo.guide = [SWGuide new];
                        bookInfo.guide.firstName = obj1[@"guideFirstName"];
                        bookInfo.guide.lastName = obj1[@"guideLastName"];
                        bookInfo.guide.regId = obj1[@"guideRegId"];
                        bookInfo.tour = [SWTour new];
                        bookInfo.tour.name = obj1[@"tourName"];
                        
                        [results addObject:bookInfo];
                    }
                    
                    
                    if (success) {
                        success([NSArray arrayWithArray:results]);
                    }
                }
            });
        }
        
    }]resume];

}
- (void) rateTour:(NSString*)param success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
  
    NSString* pathPattern = [NSString stringWithFormat:@"/rateTour"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:pathPattern] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    if (success) {
                        success();
                    }
                }
                
            });
        }
        
    }]resume];
}
@end
