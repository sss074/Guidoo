//
//  SWLanguageService.h
//  Guidoo
//
//  Created by Sergiy Bekker on 03.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWObjectManager.h"
#import "SWLanguage.h"


@interface SWLanguageService : SWObjectManager

- (void) dictionaries:(void (^)(NSArray<SWLanguage*> *obj))success failure:(void (^)(NSError *error))failure;

@end
