//
//  SWPushService.m
//  Guidoo
//
//  Created by Sergiy Bekker on 10.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWPushService.h"
#import "SWPush.h"

@implementation SWPushService

- (void) sendNotificationToken:(NSString*)param success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
  
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:[SWPush pathPattern]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    if (success) {
                        success();
                    }
                }
                
            });
        }
        
    }]resume];
}


@end
