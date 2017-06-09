//
//  SWLocationService.m
//  Guidoo
//
//  Created by Sergiy Bekker on 03.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWLocationService.h"

@implementation SWLocationService

- (void) userLoaction:(NSString*)param success:(void (^)(SWLocation *obj))success failure:(void (^)(NSError *error))failure{

    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:[SWLocation pathPattern]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
