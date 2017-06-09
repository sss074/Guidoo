//
//  SWChatService.m
//  Guidoo
//
//  Created by Sergiy Bekker on 27.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWChatService.h"

@implementation SWChatService

- (void)getUnreadMessages:(NSString*)param success:(void (^)(NSArray<SWChatMessage*>*obj))success failure:(void (^)(NSError *error))failure{
    NSString* pattern = [NSString stringWithFormat:@"/unreadMessages"];

    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupGetRequestDescriptors:param withtype:pattern] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    NSArray* result = (NSArray*)[self setupResponseDescriptors:data];
                    NSMutableArray* results = [[NSMutableArray alloc]initWithCapacity:result.count];
                    for(int i = 0; i < result.count; i++){
                        NSDictionary *param = result[i];
                        SWChatMessage* obj = [SWChatMessage new];
                        obj.firstName = param[@"firstName"];
                        obj.lastName = param[@"lastName"];
                        obj.regId = param[@"regId"];
                        obj.messageId = param[@"messageId"];
                        obj.message = param[@"message"];
                        obj.senderUserId = param[@"senderUserId"];
                        obj.sentTime = param[@"sentTime"];
                        
                        [results addObject:obj];
                    }
                    
                    if (success) {
                        success([NSArray arrayWithArray:results]);
                    }
                }
                
            });
        }
        
    }]resume];

}
- (void)confirmMessagesBefore:(NSString*)param success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
   
    NSString* pattern = [NSString stringWithFormat:@"/messageRead"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:pattern] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                    if (success) {
                        success();
                    }
                }
                
            });
        }
        
    }]resume];
}
- (void)sendMessage:(NSString*)param success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
   
    NSString* pattern = [NSString stringWithFormat:@"/message"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:[self setupPostRequestDescriptors:param withtype:pattern] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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


@end
