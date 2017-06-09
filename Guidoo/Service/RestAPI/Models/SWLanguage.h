//
//  SWLanguage.h
//  Guidoo
//
//  Created by Sergiy Bekker on 03.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBaseDataModel.h"



@interface SWLanguage : SWBaseDataModel

@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSNumber* ID;

@end

@interface SWAdditionalExpenses : SWBaseDataModel <NSCoding>

@property (nonatomic,strong) NSString* value;
@property (nonatomic,strong) NSNumber* ID;

@end

@interface SWCountries : SWBaseDataModel <NSCoding>

@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSNumber* ID;

@end

@interface SWTourGroupSizes : SWBaseDataModel <NSCoding>

@property (nonatomic,strong) NSString* value;
@property (nonatomic,strong) NSNumber* ID;

@end
