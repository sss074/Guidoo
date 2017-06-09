 //
//  SWPreferencesService.m
//  Guidoo
//
//  Created by Sergiy Bekker on 04.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWPreferencesService.h"
#import "SWPreferences.h"

@implementation SWPreferencesService

- (void) preferences:(NSString*)param success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
    [self showIndecator:YES];
    

    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:[SWPreferences pathPattern]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                        success();
                    }
                }
                
            });
        }
        
    }]resume];


}
- (void) getTouristPreferences:(NSString*)param success:(void (^)(SWPreferences* obj))success failure:(void (^)(NSError *error))failure{

    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupGetRequestDescriptors:param withtype:[SWPreferences pathPattern]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    NSDictionary* result = [self setupResponseDescriptors:data];
                    SWPreferences* obj = [SWPreferences new];
                    obj.isProfessional = result[@"isProfessional"];
                    obj.languageIds = result[@"languageIds"];
                    obj.maxDistance = result[@"maxDistance"];
                    obj.maxPricePerHour = result[@"maxPricePerHour"];
                    obj.maxTourDuration = result[@"maxTourDuration"];
                    if (success) {
                        success(obj);
                    }
                }
                
            });
        }
        
    }]resume];
}
@end
