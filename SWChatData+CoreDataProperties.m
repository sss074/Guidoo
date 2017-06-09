//
//  SWChatData+CoreDataProperties.m
//  
//
//  Created by Sergiy Bekker on 27.05.17.
//
//

#import "SWChatData+CoreDataProperties.h"

@implementation SWChatData (CoreDataProperties)

+ (NSFetchRequest<SWChatData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SWChatData"];
}

@dynamic firstName;
@dynamic isIncome;
@dynamic isNew;
@dynamic lastName;
@dynamic message;
@dynamic messageId;
@dynamic regId;
@dynamic senderUserId;
@dynamic sentTime;

@end
