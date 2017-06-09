//
//  SWLogin.h
//  Guidoo
//
//  Created by Sergiy Bekker on 03.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBaseDataModel.h"

@interface SWLogin : SWBaseDataModel <NSCoding>


@property (nonatomic, strong) NSNumber* activeBookingId;
@property (nonatomic, assign) BOOL profileExists;
@property (nonatomic, strong) NSString* sessionToken;
@property (nonatomic, strong) NSNumber* userId;
@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@end
