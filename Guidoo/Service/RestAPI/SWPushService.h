//
//  SWPushService.h
//  Guidoo
//
//  Created by Sergiy Bekker on 10.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWObjectManager.h"

@interface SWPushService : SWObjectManager

- (void) sendNotificationToken:(NSString*)param success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end
