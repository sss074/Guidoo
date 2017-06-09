//
//  AppDelegate.m
//  Guidoo
//
//  Created by Sergiy Bekker on 27.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "DLLocationTracker.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Firebase/Firebase.h>
#import "SWPaymentController.h"
#import "SWTourPopup.h"
#import "SWInvitePopup.h"
#import "SWRatePopup.h"

@interface AppDelegate ()<FIRMessagingDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
    if(launchOptions != nil){
        NSDictionary* params = (NSDictionary*)launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        if([self isParamValid:params]){
            [SWWebManager sharedManager].launchInfo = params;
            [SWWebManager sharedManager].curPopup = [UIView new];
        }
    }
   
    
    /*for (NSString *familyName in [UIFont familyNames]) {
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSLog(@"%@", fontName);
        }
     }*/
     
     
    [FBSDKLoginButton class];
    [self customizeAppearance];
    
    [Fabric with:@[[Crashlytics class]]];
    [FIRApp configure];

    [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:stripeKey];
    
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
   

    [[DLLocationTracker sharedInstance] startMonitoringLocation];
    
    //SWLogin* obj = [SWLogin new];
    //obj.userId = @(9);
    //obj.sessionToken = @"f1752ec6-5fef-4545-8c32-c3a13840bb21";
    //[self setObjectDataForKey:obj forKey:userLoginInfo];

    
    //[self removeObjectForKey:userLoginInfo];
    //[self removeObjectForKey:userPreferences];
    //[self removeObjectForKey:locationInfo];
    //[self removeObjectForKey:FacebookProfile];
    
    return YES;
}
- (void)customizeAppearance{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:71.f / 255.f green:168.f / 255.f blue:23.f / 255.f alpha:1.f]];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                           NSFontAttributeName:[UIFont fontWithName:OPENSANS size:18.f]
                                                           }];
    
    [[UINavigationBar appearance] setBackgroundImage: [UIImage new]
                                       forBarMetrics: UIBarMetricsDefault];
    
    [UINavigationBar appearance].shadowImage = [UIImage new];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];

    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor colorWithRed:18.f/255.f green:28.f/255.f blue:73.f/255.f alpha:1.f],
       NSFontAttributeName:[UIFont fontWithName:OPENSANSSEMIBOLD size:11.f]}
                                           forState:UIControlStateNormal];
    

    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor colorWithRed:71.f/255.f green:168.f/255.f blue:23.f/255.f alpha:1.f],
       NSFontAttributeName:[UIFont fontWithName:OPENSANSSEMIBOLD size:11.f]}
                                           forState:UIControlStateSelected];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
 
    NSDictionary* aps = userInfo[@"aps"];
    [self showAlertMessage:aps[@"alert"]];
    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    
   // NSDictionary* aps = userInfo[@"aps"];
    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    NSLog(@"%@", userInfo);
    /*UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    localNotification.alertBody = @"Your alert message";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];*/
    
    NSString* type = userInfo[@"type"];
    
    NSString* bookingState = userInfo[@"bookingState"];
    if([bookingState isEqualToString:@"STARTED"]){
        SWLogin *object = [self objectDataForKey:userLoginInfo];
        if(object != nil){
            object.activeBookingId = userInfo[@"bookingId"];
            [self setObjectDataForKey:object forKey:userLoginInfo];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSegment" object:object];
             });
        }
    } else if([bookingState isEqualToString:@"CANCELED"]){
        SWLogin *object = [self objectDataForKey:userLoginInfo];
        if(object != nil){
            object.activeBookingId = nil;
            [self setObjectDataForKey:object forKey:userLoginInfo];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSegment" object:object];
            });
        }
           
    } else if([bookingState isEqualToString:@"COMPLETED"]){
        if([SWWebManager sharedManager].curPopup == nil){
            
            SWLogin *object = [self objectDataForKey:userLoginInfo];
            if(object != nil){
                NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&bookingId=%ld",((NSNumber*)object.userId).integerValue,object.sessionToken,((NSNumber*)userInfo[@"bookingId"]).integerValue];
                [[SWWebManager sharedManager]requestedBooking:param withBookingID:userInfo[@"bookingId"] success:^(SWBookInfo *obj) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SWRatePopup *popup = [[[NSBundle mainBundle] loadNibNamed:@"SWRatePopup" owner:self options:nil] firstObject];
                        [SWWebManager sharedManager].curBookInfo = obj;
                        popup.content = obj;
                        [popup setFrame:[UIScreen mainScreen].bounds];
                        [self.window addSubview:popup];
                        [SWWebManager sharedManager].curPopup = popup;
                    });
                }];
            }
            return;
        }
    }
    
    if([type isEqualToString:@"INVITE"]){
        
        if([SWWebManager sharedManager].curPopup == nil){
            SWBookInfo* param = [SWBookInfo new];
            NSString* jsonString = userInfo[@"guide"];
            NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* guide = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            param.guide = [SWGuide new];
            param.guide.firstName = guide[@"firstName"];
            param.guide.lastName = guide[@"lastName"];
            param.guide.rating = guide[@"rating"];
            param.guide.guideId = guide[@"guideId"];
            param.guide.resume = guide[@"resume"];
            param.guide.pricePerHour = guide[@"pricePerHour"];
            param.guide.regId = guide[@"regId"];
            
            jsonString = userInfo[@"tour"];
            data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* tour = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            param.tour = [SWTour new];
            param.tour.durationHours = tour[@"durationHours"];
            param.tour.tourId = tour[@"tourId"];
            param.tour.name = tour[@"name"];
            param.tour.descriptions = tour[@"description"];
            param.tour.rating = guide[@"rating"];

            dispatch_async(dispatch_get_main_queue(), ^{
                SWInvitePopup *popup = [[[NSBundle mainBundle] loadNibNamed:@"SWInvitePopup" owner:self options:nil] firstObject];
                [SWWebManager sharedManager].curBookInfo = param;
                popup.content = param;
                [popup setFrame:[UIScreen mainScreen].bounds];
                [self.window addSubview:popup];
                [SWWebManager sharedManager].curPopup = popup;
            });
        }
    } else if([type isEqualToString:@"CHAT"]){
       if([SWWebManager sharedManager].curPopup == nil){
            NSString* jsonString = userInfo[@"message"];
            NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* message = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            SWChatMessage* obj = [SWChatMessage new];
            obj.senderUserId = message[@"senderUserId"];
            obj.regId = message[@"regId"];
            obj.firstName = message[@"firstName"];
            obj.lastName = message[@"lastName"];
            obj.message = message[@"message"];
            obj.sentTime = message[@"sentTime"];
            obj.messageId = message[@"messageId"];
            obj.isNew = @(YES);
            obj.isIncome = @(YES);
            
            [[SWDataManager sharedManager]updateChatItem:obj];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateListChat" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if([SWWebManager sharedManager].curChatID == obj.senderUserId){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateChat" object:obj];
                } else {
                    [[SWDataManager sharedManager]updateBage:YES];
                }
            });
           
       }
    } else {
        SWLogin *object = [self objectDataForKey:userLoginInfo];
        if(object != nil && [SWWebManager sharedManager].curPopup == nil){
            NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&bookingId=%ld",((NSNumber*)object.userId).integerValue,object.sessionToken,((NSNumber*)userInfo[@"bookingId"]).integerValue];
            [[SWWebManager sharedManager]requestedBooking:param withBookingID:userInfo[@"bookingId"] success:^(SWBookInfo *obj) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SWTourPopup *popup = [[[NSBundle mainBundle] loadNibNamed:@"SWTourPopup" owner:self options:nil] firstObject];
                    [SWWebManager sharedManager].curBookInfo = obj;
                    popup.content = obj;
                    [popup setFrame:[UIScreen mainScreen].bounds];
                    [self.window addSubview:popup];
                    [SWWebManager sharedManager].curPopup = popup;
                });
            }];
        }
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {

    NSLog(@"%@", remoteMessage.appData);
    SWLogin *object = [self objectDataForKey:userLoginInfo];
    if(object != nil){
        __block NSNumber* ID = remoteMessage.appData[@"bookingId"];
        NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&bookingId=%ld",((NSNumber*)object.userId).integerValue,object.sessionToken,ID.integerValue];
        [[SWWebManager sharedManager]requestedBooking:param withBookingID:ID success:^(SWBookInfo *obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString* message = [NSString stringWithFormat:@"%@\n%@ %@\n%ld star\n%@\n%@\n%@",obj.tour.name,obj.guide.firstName,obj.guide.lastName,((NSNumber*)obj.guide.rating).integerValue,obj.tour.city,obj.tour.descriptions,obj.bookingState];
                UIAlertController* alert= [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if([obj.bookingState isEqualToString:ACCEPTED]){
                        UINavigationController* controller = [self checkPresentForClassDescriptor:@"PaymentNavController"];
                        SWTabbarController* tabBarController =(SWTabbarController*)self.window.rootViewController;
                        UINavigationController* nav = (UINavigationController*)[tabBarController selectedViewController];
                        [nav presentViewController: controller animated: YES completion: nil];
                    }
                }];
                [alert addAction:actionOK];
                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            });
        }];
    }
   
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
    //[[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeProd];
    NSLog(@"[deviceToken: %@",deviceToken);
    if ([[FIRInstanceID instanceID] token]) {
        NSLog(@"[FIRInstanceID: %@",[[FIRInstanceID instanceID] token]);
        SWLogin *object = [self objectDataForKey:userLoginInfo];
        if(object != nil){
            NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&notificationToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken,[[FIRInstanceID instanceID] token]];
            [[SWWebManager sharedManager]sendNotificationToken:param  success:nil];
        }
        [self connectToFcm];
    }
    
    
}
- (void)connectToFcm {
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    
    // Disconnect previous FCM connection if it exists.
    [[FIRMessaging messaging] disconnect];
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{

    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler{

    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
   
    [DLLocationTracker sharedInstance].bgTask = [[UIApplication sharedApplication]
                                                 beginBackgroundTaskWithExpirationHandler:
                                                 ^{
                                                     [[UIApplication sharedApplication] endBackgroundTask:[DLLocationTracker sharedInstance].bgTask];
                                                 }];
     [[DLLocationTracker sharedInstance] restartMonitoringLocation];
    [[DLLocationTracker sharedInstance].locationManager startMonitoringSignificantLocationChanges];
    [[FIRMessaging messaging] disconnect];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([DLLocationTracker sharedInstance].bgTask != UIBackgroundTaskInvalid){
        [[DLLocationTracker sharedInstance] endBackgroundTask];
        [DLLocationTracker sharedInstance].bgTask = UIBackgroundTaskInvalid;
    }
    [[DLLocationTracker sharedInstance] startMonitoringLocation];
    [[DLLocationTracker sharedInstance].locationManager stopMonitoringSignificantLocationChanges];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKSettings setAppID:FacebookID];
    [FBSDKAppEvents activateApp];
    if ([DLLocationTracker sharedInstance].bgTask != UIBackgroundTaskInvalid){
        [[DLLocationTracker sharedInstance] endBackgroundTask];
        [DLLocationTracker sharedInstance].bgTask = UIBackgroundTaskInvalid;
    }
    [self connectToFcm];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    if([DLLocationTracker sharedInstance].locationManager != nil){
        [[DLLocationTracker sharedInstance]releaseMonitoringLocation];
        
    }
    [self removeObjectForKey:address];

}


@end
