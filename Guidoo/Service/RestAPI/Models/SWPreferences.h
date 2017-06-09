//
//  SWPreferences.h
//  Guidoo
//
//  Created by Sergiy Bekker on 04.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBaseDataModel.h"

@interface SWPreferences : SWBaseDataModel  <NSCoding>

@property (nonatomic,strong) NSNumber* userId;
@property (nonatomic,strong) NSNumber* maxPricePerHour;
@property (nonatomic,strong) NSNumber* maxDistance;
@property (nonatomic,strong) NSNumber* maxTourDuration;
@property (nonatomic,assign) NSNumber* isProfessional;
@property (nonatomic,strong) NSString* sessionToken;
@property (nonatomic,strong) NSArray* languageIds;


@end
