//
//  SWDataManager.h
//  Guidoo
//
//  Created by Sergiy Bekker on 26.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWChatMessage.h"

@interface SWDataManager : NSObject

+ (instancetype) sharedManager;

- (NSArray*)searchItems:(NSNumber*)ID withSort:(BOOL)state;
- (void)updateChatItem:(SWChatMessage*)param;
- (void)resetChatItem:(NSNumber*)param;
- (SWChatMessage*)listChatItem:(NSNumber*)param;
- (void)updateBage:(BOOL)state;
- (NSArray*)chatItems;
- (void)resetAllChatItems;
@end
