//
//  SWRegisterPhoneService.m
//  Guidoo
//
//  Created by Sergiy Bekker on 28.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWRegisterPhoneService.h"

@implementation SWRegisterPhoneService


- (void) registerPnone:(NSString*)param success:(void (^)(SWRegisterPhone *obj))success failure:(void (^)(NSError *error))failure{
   
    [self showIndecator:YES];

    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:[SWRegisterPhone pathPattern]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                     NSLog(@"%@",[self setupResponseDescriptors:data]);
                     if (success) {
                         success(nil);
                     }
                 }
             });
         }

     }]resume];


}

@end
