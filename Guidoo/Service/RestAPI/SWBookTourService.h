//
//  SWBookTourService.h
//  Guidoo
//
//  Created by Sergiy Bekker on 09.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWObjectManager.h"
#import "SWBookTour.h"
#import "SWHistory.h"

@interface SWBookTourService : SWObjectManager

- (void) bookTour:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void) payTour:(NSString*)param   success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void) getPayTours:(NSString*)param   success:(void (^)(NSArray<SWPayInfo*>* obj))success failure:(void (^)(NSError *error))failure;
- (void) registerPaymentMethod:(NSString*)param   success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void) cancelTour:(NSString*)param   success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void) bookingActivityPast:(NSString*)param  success:(void (^)(NSArray<SWHistory*> *obj))success failure:(void (^)(NSError *error))failure;
- (void) bookingActivityFuture:(NSString*)param  success:(void (^)(NSArray<SWHistory*> *obj))success failure:(void (^)(NSError *error))failure;
- (void) bookmarks:(NSString*)param  success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void) bookmarksGuid:(NSString*)param  withGuideID:(NSNumber*)ID success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void) bookmarksTour:(NSString*)param  withGuideID:(NSNumber*)ID success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void) removeBookmarksGuid:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void) removeBookmarksTour:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

- (void) getTours:(NSString*)param withGuideID:(NSNumber*)ID success:(void (^)(NSArray<SWTour*>* obj))success failure:(void (^)(NSError *error))failure;
- (void) getTour:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(SWTour* obj))success failure:(void (^)(NSError *error))failure;
- (void) getUnratedTours:(NSString*)param success:(void (^)(NSArray<SWBookInfo*>* obj))success failure:(void (^)(NSError *error))failure;
- (void) rateTour:(NSString*)param success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
@end
