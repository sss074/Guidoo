//
//  SWGuideService.h
//  Guidoo
//
//  Created by Sergiy Bekker on 05.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWObjectManager.h"
#import "SWGuide.h"

@interface SWGuideService : SWObjectManager

- (void) getNearbyGuides:(NSString*)param success:(void (^)(NSArray<SWGuide*> *obj))success failure:(void (^)(NSError *error))failure;
- (void) getGuidesByKeywords:(NSString*)param success:(void (^)(NSArray<SWGuide*> *obj))success failure:(void (^)(NSError *error))failure;
- (void) getGuides:(NSString*)param success:(void (^)(NSArray<SWGuide*> *obj))success failure:(void (^)(NSError *error))failure;
- (void) getGuideProfile:(NSString*)param withID:(NSNumber*)ID success:(void (^)(SWGuide *obj))success failure:(void (^)(NSError *error))failure;
@end
