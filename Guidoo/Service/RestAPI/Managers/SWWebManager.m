//
//  SWWebManager.m
//  SWGitHub
//
//  Created by Sergiy Bekker on 15.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWWebManager.h"
#import "SWRegisterService.h"
#import "SWLocationService.h"
#import "SWLanguageService.h"
#import "SWPreferencesService.h"
#import "SWGuideService.h"
#import "SWBookTourService.h"
#import "SWPushService.h"
#import "SWProfileService.h"
#import "SWBookInfoService.h"
#import "SWChatService.h"

static SWWebManager *sharedManager = nil;


@implementation SWWebManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SWWebManager alloc]init];
    });
    
    return sharedManager;
}

#pragma mark - Public methods

- (void) registerUser:(NSString*)param success:(void (^)(SWLogin *user))success failure:(void (^)(NSInteger statusCode))failure{
  
    SWRegisterService *manager = [[SWRegisterService alloc]init];

    [manager registerUser:param success:^(SWLogin *user) {
    
        if(success)
            success(user);
    } failure:^(NSInteger stausCode) {
        failure(stausCode);
    }];
}
- (void) registerPnone:(NSString*)param success:(void (^)(SWRegisterPhone *obj))success{
 
    SWRegisterPhoneService *manager = [[SWRegisterPhoneService alloc]init];
    
    
    [manager registerPnone:param success:^(SWRegisterPhone *obj) {
        if(success)
            success(obj);
    } failure:^(NSError *error) {

    }];
}

- (void) confirmPnone:(NSString*)param success:(void (^)(SWConfirmPhone *obj))success{
    SWConfirmPhoneService *manager = [[SWConfirmPhoneService alloc]init];
  
    [manager confirmPnone:param success:^(SWConfirmPhone *obj) {
        if(success)
            success(obj);
    } failure:^( NSError *error) {

    }];
}
- (void) login:(NSString*)param success:(void (^)(SWLogin *obj))success{
    SWLoginService *manager = [[SWLoginService alloc]init];
    
    [manager login:param success:^(SWLogin *obj) {
        if(success)
            success(obj);
    } failure:^( NSError *error) {
        
    }];
}
- (void) location:(NSString*)param success:(void (^)(SWLocation *obj))success{
    SWLocationService *manager = [[SWLocationService alloc]init];
    
    [manager  userLoaction:param success:^(SWLocation *obj) {
        if(success)
            success(obj);
    } failure:^( NSError *error) {
        
    }];
}
- (void) dictionaries:(void (^)(NSArray<SWLanguage*>*))success{
    SWLanguageService *manager = [[SWLanguageService alloc]init];
    
    [manager  dictionaries:^(NSArray<SWLanguage *> *obj) {
        if(success)
            success(obj);
    } failure:^(NSError *error) {
        
    }];
}
- (void) preferences:(NSString*)param success:(void (^)(void))success{
    SWPreferencesService* manager = [[SWPreferencesService alloc]init];
    
    [manager preferences:param success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
- (void) getTouristPreferences:(NSString*)param success:(void (^)(SWPreferences* obj))success{
    SWPreferencesService* manager = [[SWPreferencesService alloc]init];
    
    [manager getTouristPreferences:param success:^(SWPreferences *obj) {
        if(success)
            success(obj);
    } failure:^(NSError *error) {
        
    }];
}
- (void) getNearbyGuides:(NSString*)param success:(void (^)(NSArray<SWGuide*> *obj))success{
    SWGuideService* manager = [[SWGuideService alloc]init];
    
    [manager getNearbyGuides:param success:^(NSArray<SWGuide *> *obj) {
        if(success)
            success(obj);
    } failure:^(NSError *error) {
        
    }];
}
- (void) getGuidesByKeywords:(NSString*)param success:(void (^)(NSArray<SWGuide*> *obj))success{
   
    SWGuideService* manager = [[SWGuideService alloc]init];
    
    [manager getGuidesByKeywords:param success:^(NSArray<SWGuide *> *obj) {
        if(success)
            success(obj);
    } failure:^(NSError *error) {
        
    }];
}
- (void) getGuides:(NSString*)param success:(void (^)(NSArray<SWGuide*> *obj))success{
    SWGuideService* manager = [[SWGuideService alloc]init];
    
    [manager getGuides:param success:^(NSArray<SWGuide *> *obj) {
        if(success)
            success(obj);
    } failure:^(NSError *error) {
        
    }];
}
- (void) getGuideProfile:(NSString*)param withID:(NSNumber*)ID success:(void (^)(SWGuide *obj))success{
    SWGuideService* manager = [[SWGuideService alloc]init];
    
    [manager getGuideProfile:param withID:ID success:^(SWGuide *obj) {
        if(success)
            success(obj);
    } failure:^(NSError *error) {
        
    }];
}
- (void) bookTour:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(void))success{
  
    SWBookTourService* manager = [[SWBookTourService alloc]init];
    
    [manager bookTour:param withTourID:ID success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
- (void) payTour:(NSString*)param success:(void (^)(void))success{
    
    SWBookTourService* manager = [[SWBookTourService alloc]init];
    
    [manager payTour:param success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
- (void) getPayTours:(NSString*)param   success:(void (^)(NSArray<SWPayInfo*>* obj))success{
    SWBookTourService* manager = [[SWBookTourService alloc]init];
   
    [manager getPayTours:param success:^(NSArray<SWPayInfo *> *obj) {
        if(success)
            success(obj);
    } failure:^(NSError *error) {
        
    }];
}
- (void) registerPaymentMethod:(NSString*)param   success:(void (^)(void))success{
    SWBookTourService* manager = [[SWBookTourService alloc]init];
    
    [manager registerPaymentMethod:param success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
- (void) cancelTour:(NSString*)param   success:(void (^)(void))success{
    SWBookTourService* manager = [[SWBookTourService alloc]init];
    
    [manager cancelTour:param success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
- (void) bookingActivityPast:(NSString*)param  success:(void (^)(NSArray<SWHistory*> *obj))success{
    SWBookTourService* manager = [[SWBookTourService alloc]init];
    
    [manager bookingActivityPast:param success:^(NSArray<SWHistory *> *obj) {
        if(success)
            success(obj);
    } failure:^(NSError *error) {
        
    }];
}
- (void) bookingActivityFuture:(NSString*)param  success:(void (^)(NSArray<SWHistory*> *obj))success{
    SWBookTourService* manager = [[SWBookTourService alloc]init];
    
    [manager bookingActivityFuture:param success:^(NSArray<SWHistory *> *obj) {
        if(success)
            success(obj);
    } failure:^(NSError *error) {
        
    }];
}
- (void) sendNotificationToken:(NSString*)param success:(void (^)(void))success{
   
    SWPushService* manager = [[SWPushService alloc]init];
    
    [manager sendNotificationToken:param success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
- (void)profileUser:(NSString*)param success:(void (^)(SWProfile*))success{
    SWProfileService* manager = [[SWProfileService alloc]init];
    
    [manager profileUser:param success:^(SWProfile *obj){
        if(success)
            success(obj);
    } failure:^(NSError *error) {
        
    }];
}
- (void) setProfileUser:(NSString*)param success:(void (^)(void))success{
     SWProfileService* manager = [[SWProfileService alloc]init];
    
    [manager setProfileUser:param success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
- (void) removeProfileUser:(NSString*)param success:(void (^)(void))success{
    SWProfileService* manager = [[SWProfileService alloc]init];
    
    [manager removeProfileUser:param success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
- (void) requestedBooking:(NSString*)param  withBookingID:(NSNumber*)ID success:(void (^)(SWBookInfo* obj))success{
    SWBookInfoService* manager = [[SWBookInfoService alloc]init];
    
    [manager requestedBooking:param withBookingID:ID success:^(SWBookInfo *obj) {
        if(success)
            success(obj);
    } failure:^(NSError *error) {
        
    }];
}
- (void) bookmarks:(NSString*)param  success:(void (^)(void))success{
    SWBookTourService* manager = [[SWBookTourService alloc]init];

    [manager bookmarks:param success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
- (void) bookmarksGuid:(NSString*)param  withGuideID:(NSNumber*)ID success:(void (^)(void))success{
    SWBookTourService* manager = [[SWBookTourService alloc]init];
    
    [manager bookmarksGuid:param withGuideID:ID success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
- (void) bookmarksTour:(NSString*)param  withGuideID:(NSNumber*)ID success:(void (^)(void))success{
    SWBookTourService* manager = [[SWBookTourService alloc]init];
    
    [manager bookmarksTour:param withGuideID:ID success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
- (void) removeBookmarksGuid:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(void))success{
    SWBookTourService* manager = [[SWBookTourService alloc]init];
    
    [manager removeBookmarksGuid:param withTourID:ID success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
- (void) removeBookmarksTour:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(void))success{
    SWBookTourService* manager = [[SWBookTourService alloc]init];
    
    [manager removeBookmarksTour:param withTourID:ID success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
- (void) getTours:(NSString*)param withGuideID:(NSNumber*)ID success:(void (^)(NSArray<SWTour*>* obj))success{
    SWBookTourService* manager = [[SWBookTourService alloc]init];
    
    [manager getTours:param withGuideID:ID success:^(NSArray<SWTour*>* obj) {
        if(success)
            success(obj);
    } failure:^(NSError *error) {
        
    }];

}
- (void) getTour:(NSString*)param withTourID:(NSNumber*)ID success:(void (^)(SWTour* obj))success{
    SWBookTourService* manager = [[SWBookTourService alloc]init];
    
    [manager getTour:param withTourID:ID success:^(SWTour *obj) {
        if(success)
            success(obj);
    } failure:^(NSError *error) {
        
    }];

}
- (void) getUnratedTours:(NSString*)param success:(void (^)(NSArray<SWBookInfo*>* obj))success{
   
    SWBookTourService* manager = [[SWBookTourService alloc]init];
    
    [manager getUnratedTours:param success:^(NSArray<SWBookInfo *> *obj) {
        if(success)
            success(obj);

    } failure:^(NSError *error) {
        
    }];
}
- (void) rateTour:(NSString*)param success:(void (^)(void))success{
    SWBookTourService* manager = [[SWBookTourService alloc]init];
    
    [manager rateTour:param success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
- (void)getUnreadMessages:(NSString*)param success:(void (^)(NSArray<SWChatMessage*>*obj))success{
   
    SWChatService* manager = [[SWChatService alloc]init];
    
    [manager getUnreadMessages:param success:^(NSArray<SWChatMessage *> *obj) {
        if(success)
            success(obj);
    } failure:^(NSError *error) {
        
    }];
}
- (void)confirmMessagesBefore:(NSString*)param success:(void (^)(void))success{
    SWChatService* manager = [[SWChatService alloc]init];
    
    [manager confirmMessagesBefore:param success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
- (void)sendMessage:(NSString*)param success:(void (^)(void))success{
    SWChatService* manager = [[SWChatService alloc]init];
    
    [manager sendMessage:param success:^{
        if(success)
            success();
    } failure:^(NSError *error) {
        
    }];
}
@end
