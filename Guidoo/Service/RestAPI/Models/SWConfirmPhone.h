//
//  SWConfirmPhone.h
//  Guidoo
//
//  Created by Sergiy Bekker on 28.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBaseDataModel.h"

@interface SWConfirmPhone : SWBaseDataModel <NSCoding>


@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *phoneNumber;

@end
