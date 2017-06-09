//
//  SWChatData+CoreDataProperties.h
//  
//
//  Created by Sergiy Bekker on 27.05.17.
//
//

#import "SWChatData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SWChatData (CoreDataProperties)

+ (NSFetchRequest<SWChatData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *firstName;
@property (nonatomic) int32_t isIncome;
@property (nonatomic) int32_t isNew;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *message;
@property (nonatomic) int64_t messageId;
@property (nonatomic) int64_t regId;
@property (nonatomic) int64_t senderUserId;
@property (nonatomic) int64_t sentTime;

@end

NS_ASSUME_NONNULL_END
