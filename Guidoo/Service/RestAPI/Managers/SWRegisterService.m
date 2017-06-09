//
//  SWRepoManager.m
//  SWGitHub
//
//  Created by Sergiy Bekker on 15.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWRegisterService.h"
#import "SWRegister.h"


@implementation SWRegisterService


- (void) registerUser:(NSString*)param success:(void (^)(SWLogin *obj))success failure:(void (^)(NSInteger statusCode))failure{

    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:[SWRegister pathPattern]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSInteger statusCode =  [self checkStatusCode:response];
        if (error){
            if(statusCode != INVALIDTOKEN){
                if (failure) {
                    failure(INVALIDTOKEN);
                }
            }
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(statusCode == SUCCSESS){
                    NSError *parseError = nil;
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                    NSLog(@"%@", result);
                    SWLogin* obj = [SWLogin new];
                    obj.userId = result[@"userId"];
                    obj.sessionToken = result[@"sessionToken"];
                    [self setObjectDataForKey:obj forKey:currentLoginKey];
            
                    if (success) {
                        success(obj);
                    }
                } else {
                    if (failure)
                        failure(statusCode);
                   // [self showAlertMessage:@"This user is already registered!"];
                }
                
            });
        }
        
    }]resume];
   
}



@end
