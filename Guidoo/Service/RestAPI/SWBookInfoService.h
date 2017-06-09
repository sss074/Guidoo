//
//  SWBookInfoService.h
//  Guidoo
//
//  Created by Sergiy Bekker on 15.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWObjectManager.h"
#import "SWBookInfo.h"

@interface SWBookInfoService : SWObjectManager

- (void) requestedBooking:(NSString*)param  withBookingID:(NSNumber*)ID success:(void (^)(SWBookInfo* obj))success failure:(void (^)(NSError *error))failure;

@end
