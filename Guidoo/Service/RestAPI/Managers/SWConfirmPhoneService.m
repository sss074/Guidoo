//
//  SWConfirmPhoneService.m
//  Guidoo
//
//  Created by Sergiy Bekker on 28.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWConfirmPhoneService.h"

@implementation SWConfirmPhoneService


- (void) confirmPnone:(NSString*)param success:(void (^)(SWConfirmPhone *obj))success failure:(void (^)(NSError *error))failure{
    
    [self showIndecator:YES];
    

    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:[SWConfirmPhone pathPattern]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    NSDictionary *result = [self setupResponseDescriptors:data];
                    SWConfirmPhone* obj = [SWConfirmPhone new];
                    obj.token = result[@"token"];
                    
                    if (success) {
                        success(obj);
                    }
                }
            });
        }
        
    }]resume];
 
}


@end
