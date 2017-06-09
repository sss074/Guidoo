//
//  SWLocationService.h
//  Guidoo
//
//  Created by Sergiy Bekker on 03.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWObjectManager.h"
#import "SWLocation.h"

@interface SWLocationService : SWObjectManager

- (void) userLoaction:(NSString*)param success:(void (^)(SWLocation *obj))success failure:(void (^)(NSError *error))failure;
@end
