//
//  SWChatService.h
//  Guidoo
//
//  Created by Sergiy Bekker on 27.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWObjectManager.h"
#import "SWChatMessage.h"

@interface SWChatService : SWObjectManager

- (void)getUnreadMessages:(NSString*)param success:(void (^)(NSArray<SWChatMessage*>*obj))success failure:(void (^)(NSError *error))failure;
- (void)confirmMessagesBefore:(NSString*)param success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void)sendMessage:(NSString*)param success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end
