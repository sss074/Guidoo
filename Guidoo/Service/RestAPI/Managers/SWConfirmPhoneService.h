//
//  SWConfirmPhoneService.h
//  Guidoo
//
//  Created by Sergiy Bekker on 28.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWObjectManager.h"
#import "SWConfirmPhone.h"

@interface SWConfirmPhoneService : SWObjectManager

- (void) confirmPnone:(NSString*)param success:(void (^)(SWConfirmPhone *obj))success failure:(void (^)(NSError *error))failure;

@end
