//
//  SWRegisterPhoneService.h
//  Guidoo
//
//  Created by Sergiy Bekker on 28.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWObjectManager.h"
#import "SWRegisterPhone.h"

@interface SWRegisterPhoneService : SWObjectManager

- (void) registerPnone:(NSString*)param success:(void (^)(SWRegisterPhone *obj))success failure:(void (^)(NSError *error))failure;

@end
