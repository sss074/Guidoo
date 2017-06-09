//
//  SWLanguageService.m
//  Guidoo
//
//  Created by Sergiy Bekker on 03.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWLanguageService.h"

@implementation SWLanguageService

- (void) dictionaries:(void (^)(NSArray<SWLanguage*> *obj))success failure:(void (^)(NSError *error))failure{

   
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupGetRequestDescriptors:nil withtype:[SWLanguage pathPattern]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    
                    NSArray* additionalExpenses = result[@"additionalExpenses"];
                    NSMutableArray* temp = [[NSMutableArray alloc]initWithCapacity:additionalExpenses.count];
                    for(int i =0 ; i < additionalExpenses.count; i++){
                        NSDictionary* param = additionalExpenses[i];
                        SWAdditionalExpenses* obj = [SWAdditionalExpenses new];
                        obj.value = param[@"value"];
                        obj.ID = param[@"id"];
                        [temp addObject:obj];
                    }
                    [self setObjectDataForKey:[NSArray arrayWithArray:temp] forKey:@"additionalExpenses"];
                    
                    NSArray* countries = result[@"countries"];
                    [temp removeAllObjects];
                    for(int i =0 ; i < countries.count; i++){
                        NSDictionary* param = countries[i];
                        SWCountries* obj = [SWCountries new];
                        obj.name = param[@"name"];
                        obj.ID = param[@"id"];
                        [temp addObject:obj];
                    }
                    [self setObjectDataForKey:[NSArray arrayWithArray:temp] forKey:@"countries"];
                    
                    
                    NSArray* tourGroupSizes = result[@"tourGroupSizes"];
                    [temp removeAllObjects];
                    for(int i =0 ; i < tourGroupSizes.count; i++){
                        NSDictionary* param = tourGroupSizes[i];
                        SWTourGroupSizes* obj = [SWTourGroupSizes new];
                        obj.value = param[@"value"];
                        obj.ID = param[@"id"];
                        [temp addObject:obj];
                    }
                    [self setObjectDataForKey:[NSArray arrayWithArray:temp] forKey:@"tourGroupSizes"];

                    
                    
                    NSArray* languages = result[@"languages"];
                    [temp removeAllObjects];
                    for(int i =0 ; i < languages.count; i++){
                        NSDictionary* param = languages[i];
                        SWLanguage* obj = [SWLanguage new];
                        obj.name = param[@"name"];
                        obj.ID = param[@"id"];
                        [temp addObject:obj];
                    }
    
                    if (success) {
                        success([NSArray arrayWithArray:temp]);
                    }
                }
                
            });
        }
        
    }]resume];


}

@end
