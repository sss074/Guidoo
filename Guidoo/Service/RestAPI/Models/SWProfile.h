//
//  SWProfile.h
//  Guidoo
//
//  Created by Sergiy Bekker on 11.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBaseDataModel.h"

@interface SWProfile : SWBaseDataModel


@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, strong) NSString* gender;
@property (nonatomic, strong) NSString* birthday;
@property (nonatomic, strong) NSString* birthdayStr;
@property (nonatomic, strong) NSNumber* countryId;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSArray* languageIds;
@property (nonatomic, strong) UIImage* avatar;
@property (nonatomic, strong) NSString* phoneNumber;
@property (nonatomic, strong) NSNumber* notifyState;

@end
