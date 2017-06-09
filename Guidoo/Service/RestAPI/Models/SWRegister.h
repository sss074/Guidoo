//
//  Repository.h
//  SWGitHub
//
//  Created by Sergiy Bekker on 15.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWBaseDataModel.h"

@class SWUser;

@interface SWRegister : SWBaseDataModel <SWRestKitMappableModel>

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *sessionToken;


@end
