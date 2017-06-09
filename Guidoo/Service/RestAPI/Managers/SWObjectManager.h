//
//  SWObjectManager.h
//  SWGitHub
//
//  Created by Sergiy Bekker on 15.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//



@interface SWObjectManager : NSObject

- (NSMutableURLRequest*) setupPostRequestDescriptors:(NSString*)param withtype:(NSString*)path;
- (NSMutableURLRequest*) setupGetRequestDescriptors:(NSString*)param withtype:(NSString*)path;
- (NSMutableURLRequest*) setupDeleteRequestDescriptors:(NSString*)param withtype:(NSString*)path;
- (id) setupResponseDescriptors:(NSData*)data;
- (NSInteger)checkStatusCode:(NSURLResponse *)response;
@end
