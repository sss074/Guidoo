//
//  SWStartLoaderController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 04.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWStartLoaderController.h"
#import <Firebase/Firebase.h>

@interface SWStartLoaderController ()

@end

@implementation SWStartLoaderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    TheApp;
    SWLogin *object = [self objectDataForKey:userLoginInfo];
    if(object != nil){
        dispatch_async(dispatch_get_main_queue(), ^{
   
            NSDictionary* currentFacebookProfile =[self objectForKey:FacebookProfile];
            NSLog(@"Current Profile %@", currentFacebookProfile);
            if(currentFacebookProfile != nil){
                 NSString *param = [NSString stringWithFormat:@"regId=%@&credential=%@",currentFacebookProfile[@"id"],currentFacebookProfile[@"fbtoken"]];
            
                [[SWWebManager sharedManager]login:param success:^(SWLogin *obj) {
                    NSLog(@"%@",obj);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setObjectDataForKey:obj forKey:userLoginInfo];
                        if ([[FIRInstanceID instanceID] token]) {
                            NSLog(@"[FIRInstanceID: %@",[[FIRInstanceID instanceID] token]);
                            SWLogin *object = [self objectDataForKey:userLoginInfo];
                            if(object != nil){
                                NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&notificationToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken,[[FIRInstanceID instanceID] token]];
                                [[SWWebManager sharedManager]sendNotificationToken:param  success:nil];
                                app.window.rootViewController =  [self checkPresentForClassDescriptor:@"TabbarController"];
                            }
                        }
                        
                    });
                }];
            } else {
                __block SWConfirmPhone *obj = [self objectDataForKey:userInfo];
                if(obj != nil){
                    __block NSString *param = [NSString stringWithFormat:@"regId=%@&userType=REGULAR&credentialType=PHONE&credential=%@",obj.phoneNumber,obj.token];
                    
                    [[SWWebManager sharedManager]registerUser:param success:^(SWLogin *user) {
                        NSLog(@"%@",obj);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self setObjectDataForKey:obj forKey:userLoginInfo];
                            if ([[FIRInstanceID instanceID] token]) {
                                NSLog(@"[FIRInstanceID: %@",[[FIRInstanceID instanceID] token]);
                                SWLogin *object = [self objectDataForKey:userLoginInfo];
                                if(object != nil){
                                    NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&notificationToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken,[[FIRInstanceID instanceID] token]];
                                    [[SWWebManager sharedManager]sendNotificationToken:param  success:nil];
                                    app.window.rootViewController =  [self checkPresentForClassDescriptor:@"TabbarController"];
                                }
                            }
                            
                        });
                    } failure:^(NSInteger statusCode) {
                        if(statusCode == ISPRESENT){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                param = [NSString stringWithFormat:@"regId=%@&credential=%@",obj.phoneNumber,obj.token];
                                [[SWWebManager sharedManager]login:param success:^(SWLogin *obj) {
                                    NSLog(@"%@",obj);
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self setObjectDataForKey:obj forKey:userLoginInfo];
                                        if ([[FIRInstanceID instanceID] token]) {
                                            NSLog(@"[FIRInstanceID: %@",[[FIRInstanceID instanceID] token]);
                                            SWLogin *object = [self objectDataForKey:userLoginInfo];
                                            if(object != nil){
                                                NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&notificationToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken,[[FIRInstanceID instanceID] token]];
                                                [[SWWebManager sharedManager]sendNotificationToken:param  success:nil];
                                                app.window.rootViewController =  [self checkPresentForClassDescriptor:@"TabbarController"];
                                            }
                                        }
                                        
                                    });
                                }];
                            });
                        }
                    }];
                }
            }
        });
    } else {
        app.window.rootViewController =  [self checkPresentForClassDescriptor:@"MainNavController"];
    }
}

@end
