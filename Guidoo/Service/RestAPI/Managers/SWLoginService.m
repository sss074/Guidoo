//
//  SWLoginService.m
//  Guidoo
//
//  Created by Sergiy Bekker on 03.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWLoginService.h"
#import "SWLogin.h"

@implementation SWLoginService

- (void) login:(NSString*)param success:(void (^)(SWLogin *obj))success failure:(void (^)(NSError *error))failure{

    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:[SWLogin pathPattern]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    NSDictionary *result = [self setupResponseDescriptors:data];
                    SWLogin* obj = [SWLogin new];
                    obj.sessionToken = result[@"sessionToken"];
                    obj.userId = result[@"userId"];
                    obj.activeBookingId = result[@"activeBookingId"];
                    if (success) {
                        success(obj);
                    }
                }

            });
        }
        
    }]resume];


}

@end
