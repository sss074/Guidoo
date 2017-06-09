//
//  SWWebManager.h
//  SWGitHub
//
//  Created by Sergiy Bekker on 15.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWRegister.h"
#import "SWRegisterPhoneService.h"
#import "SWConfirmPhoneService.h"
#import "SWLoginService.h"
#import "SWLogin.h"
#import "SWLocation.h"
#import "SWLanguage.h"
#import "SWGuide.h"
#import "SWProfile.h"
#import "SWBookInfo.h"
#import "SWPreferences.h"
#import "SWHistory.h"
#import "SWChatMessage.h"

@interface SWWebManager : NSObject

@property (nonatomic, strong) UIView* curPopup;
@property (nonatomic, strong) SWBookInfo* curBookInfo;
@property (nonatomic, strong) NSDictionary* launchInfo;
@property (nonatomic, assign) BOOL isHistory;
@property (nonatomic, strong) NSArray* bookmarkGuids;
@property (nonatomic, strong) NSArray* bookmarkTours;
@property (nonatomic, strong) NSNumber* curChatID;

+ (instancetype) sharedManager;

- (void) registerUser:(NSString*)param success:(void (^)(SWLogin *user))success failure:(void (^)(NSInteger statusCode))failure;
- (void) registerPnone:(NSString*)param success:(void (^)(SWRegisterPhone *obj))success;
- (void) confirmPnone:(NSString*)param success:(void (^)(SWConfirmPhone *obj))success;
- (void) login:(NSString*)param success:(void (^)(SWLogin *obj))success;
- (void) location:(NSString*)param success:(void (^)(SWLocation *obj))success;
- (void) dictionaries:(void (^)(NSArray<SWLanguage*>*))success;
- (void) preferences:(NSString*)param success:(void (^)(void))success;
- (void) getTouristPreferences:(NSString*)param success:(void (^)(SWPreferences* obj))success;
- (void) getNearbyGuides:(NSString*)param success:(void (^)(NSArray<SWGuide*> *obj))success;
- (void) getGuidesByKeywords:(NSString*)param success:(void (^)(NSArray<SWGuide*> *obj))success;
- (void) getGuides:(NSString*)param success:(void (^)(NSArray<SWGuide*> *obj))success;
- (void) getGuideProfile:(NSString*)param withID:(NSNumber*)ID success:(void (^)(SWGuide *obj))success;
- (void) bookTour:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(void))success;
- (void) sendNotificationToken:(NSString*)param success:(void (^)(void))success;
- (void) profileUser:(NSString*)param success:(void (^)(SWProfile*))success;
- (void) setProfileUser:(NSString*)param success:(void (^)(void))success;
- (void) removeProfileUser:(NSString*)param success:(void (^)(void))success;
- (void) requestedBooking:(NSString*)param  withBookingID:(NSNumber*)ID success:(void (^)(SWBookInfo* obj))success;
- (void) payTour:(NSString*)param   success:(void (^)(void))success;
- (void) getPayTours:(NSString*)param   success:(void (^)(NSArray<SWPayInfo*>* obj))success;
- (void) registerPaymentMethod:(NSString*)param   success:(void (^)(void))success;
- (void) cancelTour:(NSString*)param   success:(void (^)(void))success;
- (void) bookingActivityPast:(NSString*)param  success:(void (^)(NSArray<SWHistory*> *obj))success;
- (void) bookingActivityFuture:(NSString*)param  success:(void (^)(NSArray<SWHistory*> *obj))success;
- (void) bookmarks:(NSString*)param  success:(void (^)(void))success;
- (void) bookmarksGuid:(NSString*)param  withGuideID:(NSNumber*)ID success:(void (^)(void))success;
- (void) bookmarksTour:(NSString*)param  withGuideID:(NSNumber*)ID success:(void (^)(void))success;
- (void) removeBookmarksGuid:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(void))success;
- (void) removeBookmarksTour:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(void))success;
- (void) getTours:(NSString*)param withGuideID:(NSNumber*)ID success:(void (^)(NSArray<SWTour*>* obj))success;
- (void) getTour:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(SWTour* obj))success;
- (void) getUnratedTours:(NSString*)param success:(void (^)(NSArray<SWBookInfo*>* obj))success;
- (void) rateTour:(NSString*)param success:(void (^)(void))success;
- (void)getUnreadMessages:(NSString*)param success:(void (^)(NSArray<SWChatMessage*>*obj))success;
- (void)confirmMessagesBefore:(NSString*)param success:(void (^)(void))success;
- (void)sendMessage:(NSString*)param success:(void (^)(void))success;
@end
