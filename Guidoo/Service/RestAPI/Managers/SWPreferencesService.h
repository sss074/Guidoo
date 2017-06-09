//
//  SWPreferencesService.h
//  Guidoo
//
//  Created by Sergiy Bekker on 04.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWObjectManager.h"
#import "SWPreferences.h"

@interface SWPreferencesService : SWObjectManager

- (void) preferences:(NSString*)param success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
- (void) getTouristPreferences:(NSString*)param success:(void (^)(SWPreferences* obj))success failure:(void (^)(NSError *error))failure;

@end
