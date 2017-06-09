//
//  SWObjectManager.m
//  SWGitHub
//
//  Created by Sergiy Bekker on 15.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWObjectManager.h"
#import "AppConstants.h"
#import "NSData+Base64.h"


static NSURLSession* sharedSessionMainQueue = nil;


@implementation SWObjectManager

- (instancetype)init{
 
    self = [super init];
    
    if(self){

        if(!sharedSessionMainQueue){
            sharedSessionMainQueue = [NSURLSession sessionWithConfiguration:nil delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        }

    }

    return self;
}

- (NSMutableURLRequest*) setupPostRequestDescriptors:(NSString*)param withtype:(NSString*)path{
    NSData *postData = [param dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%ld",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDevBaseApiUrl,path]]];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",kDevBaseApiUrl,path]);
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    return request;
}
- (NSMutableURLRequest*) setupGetRequestDescriptors:(NSString*)param withtype:(NSString*)path{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDevBaseApiUrl,path]]];
    if(param != nil){
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",kDevBaseApiUrl,path,param]]];
    }
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",kDevBaseApiUrl,path]);
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}
- (NSMutableURLRequest*) setupDeleteRequestDescriptors:(NSString*)param withtype:(NSString*)path{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kDevBaseApiUrl,path]]];
    if(param != nil){
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",kDevBaseApiUrl,path,param]]];
    }
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",kDevBaseApiUrl,path]);
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}
- (id) setupResponseDescriptors:(NSData*)data{
    NSError *parseError = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    NSLog(@"%@", result);
    
    return  result;
}
- (NSInteger)checkStatusCode:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSInteger statusCode = httpResponse.statusCode;
    if(statusCode == INVALIDTOKEN){
    
        NSDictionary* currentFacebookProfile =[self objectForKey:FacebookProfile];
        NSLog(@"Current Profile %@", currentFacebookProfile);
        if(currentFacebookProfile == nil){
            __block SWConfirmPhone *obj = [self objectDataForKey:userInfo];
            if(obj != nil){
                __block NSString *param = [NSString stringWithFormat:@"regId=%@&userType=REGULAR&credentialType=PHONE&credential=%@",obj.phoneNumber,obj.token];
                
                [[SWWebManager sharedManager]registerUser:param success:nil failure:^(NSInteger statusCode) {
                    if(statusCode == ISPRESENT){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            param = [NSString stringWithFormat:@"regId=%@&credential=%@",obj.phoneNumber,obj.token];
                            [[SWWebManager sharedManager]login:param success:^(SWLogin *obj) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self setObjectDataForKey:obj forKey:userLoginInfo];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSession" object:nil];
                                });
                            }];

                        });
                    }
                }];
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *param = [NSString stringWithFormat:@"regId=%@&credential=%@",currentFacebookProfile[@"id"],currentFacebookProfile[@"fbtoken"]];
                [[SWWebManager sharedManager]login:param success:^(SWLogin *obj) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [self setObjectDataForKey:obj forKey:userLoginInfo];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSession" object:nil];
                    });
                }];
            });
        }

    }

    return  statusCode;
}
@end
