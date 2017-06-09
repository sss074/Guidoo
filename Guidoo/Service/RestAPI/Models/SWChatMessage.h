//
//  SWChatMessage.h
//  Guidoo
//
//  Created by Sergiy Bekker on 26.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBaseDataModel.h"

@interface SWChatMessage : SWBaseDataModel <NSCoding>

@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,assign) NSNumber* isIncome;
@property (nonatomic,assign) NSNumber* isNew;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSNumber* regId;
@property (nonatomic,strong) NSNumber* senderUserId;
@property (nonatomic,strong) NSNumber* sentTime;
@property (nonatomic,strong) NSNumber* messageId;
@property (nonatomic,strong) NSNumber* badgeCout;
@end
