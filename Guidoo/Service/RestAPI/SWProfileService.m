//
//  SWProfileService.m
//  Guidoo
//
//  Created by Sergiy Bekker on 11.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWProfileService.h"

@implementation SWProfileService


- (void) profileUser:(NSString*)param success:(void (^)(SWProfile* obj))success failure:(void (^)(NSError *error))failure{
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupGetRequestDescriptors:param withtype:[SWProfile pathPattern]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    NSDictionary* result = [self setupResponseDescriptors:data];
                    if(result != nil){
                        SWProfile* obj = [SWProfile new];
                        obj.firstName = result[@"firstName"];
                        obj.lastName = result[@"lastName"];
                        obj.birthday = result[@"birthday"];
                        obj.countryId = result[@"countryId"];
                        obj.email = result[@"email"];
                        obj.gender = result[@"gender"];
                        obj.languageIds = result[@"languageIds"];
                        
                        if (success) {
                            success(obj);
                        }
                    }
                }
                
            });
        }
        
    }]resume];

}

- (void) setProfileUser:(NSString*)param success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
    [self showIndecator:YES];
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:[SWProfile pathPattern]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode =  [self checkStatusCode:response];
        if (error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showIndecator:NO];
            if(statusCode != INVALIDTOKEN){
                if (failure) {
                    failure(error);
                }
            }
            });
        } else {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showIndecator:NO];
                if(statusCode == SUCCSESS){
                    if (success) {
                        success();
                    }
                }
                
            });
        }
        
    }]resume];
}
- (void) removeProfileUser:(NSString*)param success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
    [self showIndecator:YES];
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupDeleteRequestDescriptors:param withtype:[SWProfile pathPatternDelete]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger statusCode =  [self checkStatusCode:response];
        if (error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showIndecator:NO];
                if(statusCode != INVALIDTOKEN){
                    if (failure) {
                        failure(error);
                    }
                }
            });
        } else {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showIndecator:NO];
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
