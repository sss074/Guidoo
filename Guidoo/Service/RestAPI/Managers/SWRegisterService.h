//
//  SWRepoManager.h
//  SWGitHub
//
//  Created by Sergiy Bekker on 15.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWObjectManager.h"

@class SWRegister;


@interface SWRegisterService : SWObjectManager

- (void) registerUser:(NSString*)param success:(void (^)(SWLogin *obj))success failure:(void (^)(NSInteger statusCode))failure;


@end
