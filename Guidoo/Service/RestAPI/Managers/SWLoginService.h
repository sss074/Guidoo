//
//  SWLoginService.h
//  Guidoo
//
//  Created by Sergiy Bekker on 03.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWObjectManager.h"
#import "SWLogin.h"

@interface SWLoginService : SWObjectManager

- (void) login:(NSString*)param success:(void (^)(SWLogin *obj))success failure:(void (^)(NSError *error))failure;

@end
