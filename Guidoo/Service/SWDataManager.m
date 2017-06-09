//
//  SWDataManager.m
//  Guidoo
//
//  Created by Sergiy Bekker on 26.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWDataManager.h"
#import <CoreData/CoreData.h>
#import <Security/Security.h>
#import <Foundation/Foundation.h>
#import "SWChatData+CoreDataProperties.h"


static SWDataManager *sharedManager = nil;

@interface SWDataManager ()

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end


@implementation SWDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SWDataManager alloc]init];
    });
    
    return sharedManager;
}

#pragma mark - Public methods

- (void)updateChatItem:(SWChatMessage*)param{
    if(param != nil){
        
        //NSArray *filtered = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(BAR == %@)", @"foo"]];
        NSError *requestError = nil;
        SWChatData* item = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"SWChatData"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"senderUserId == %ld AND messageId == %ld",((NSNumber*)param.senderUserId).integerValue,((NSNumber*)param.messageId).integerValue]];
        NSArray *data = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
        if(data != nil && data.count > 0){
            item = [data lastObject];
        } else {
            item = [NSEntityDescription insertNewObjectForEntityForName:@"SWChatData" inManagedObjectContext:self.managedObjectContext];
        }
        
        if([self isParamValid:item]){
            item.firstName = param.firstName;
            item.lastName = param.lastName;
            item.senderUserId = ((NSNumber*)param.senderUserId).intValue;
            item.regId = ((NSNumber*)param.regId).integerValue;
            item.message = param.message;
            item.isIncome = (((NSNumber*)param.isIncome).integerValue == 1) ? 1 : 0;
            item.isNew = (((NSNumber*)param.isNew).integerValue == 1) ? 1 : 0;;
            item.sentTime = ((NSNumber*)param.sentTime).integerValue;
            item.messageId = ((NSNumber*)param.messageId).integerValue;
        }
        [self.managedObjectContext save:&requestError];
        [self saveContext];

    }
}
- (SWChatMessage*)listChatItem:(NSNumber*)param{
  
    SWChatMessage* message = nil;
    
    NSError *requestError = nil;
    SWChatData* obj = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"SWChatData"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"senderUserId == %ld",((NSNumber*)param).integerValue]];
    NSSortDescriptor *createdSort =[[NSSortDescriptor alloc] initWithKey:@"sentTime" ascending:YES];
    fetchRequest.sortDescriptors = @[createdSort];
    NSArray *data = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    if(data != nil && data.count > 0){
        obj = [data lastObject];
        message = [SWChatMessage new];
        message.regId = @(obj.regId);
        message.sentTime = @(obj.sentTime);
        message.firstName = obj.firstName;
        message.lastName = obj.lastName;
        message.isIncome = (obj.isNew == 1) ? [NSNumber numberWithInteger:YES] : [NSNumber numberWithInteger:NO];
        message.messageId = @(obj.messageId);
        message.message = obj.message;
        message.isNew = (obj.isNew == 1) ? [NSNumber numberWithInteger:YES] : [NSNumber numberWithInteger:NO];
        message.senderUserId = @(obj.senderUserId);
        message.badgeCout = @([self getNewMessageCout:param]);
    }
    
    return message;
    
}
- (void)resetChatItem:(NSNumber*)ID{
    NSError *requestError = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"SWChatData"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"senderUserId == %ld",((NSNumber*)ID).integerValue]];
    NSArray *data = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    if(data != nil && data.count > 0){
        for (SWChatData *item in data) {
            item.isNew = NO;
        }
    }
    [self.managedObjectContext save:&requestError];
    [self saveContext];

}

- (NSArray*)searchItems:(NSNumber*)ID withSort:(BOOL)state{
   
    NSError *requestError = nil;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"SWChatData"];

    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"senderUserId == %ld",((NSNumber*)ID).integerValue]];
    NSSortDescriptor *createdSort =[[NSSortDescriptor alloc] initWithKey:@"sentTime" ascending:state];
    fetchRequest.sortDescriptors = @[createdSort];
    
    NSMutableArray* temp = [NSMutableArray new];
    NSArray *data = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    if(data != nil && data.count > 0){
        for (SWChatData *obj in data) {
            SWChatMessage* message = [SWChatMessage new];
            message.senderUserId = @(obj.senderUserId);
            message.regId = @(obj.regId);
            message.sentTime = @(obj.sentTime);
            message.firstName = obj.firstName;
            message.lastName = obj.lastName;
            message.isIncome = (obj.isIncome == 1) ? [NSNumber numberWithInteger:YES] : [NSNumber numberWithInteger:NO];
            message.messageId = @(obj.messageId);
            message.message = obj.message;
            message.isNew = (obj.isNew == 1) ? [NSNumber numberWithInteger:YES] : [NSNumber numberWithInteger:NO];;
            [temp addObject:message];
            
        }
    }
    return  [NSArray arrayWithArray:temp];
}
- (NSArray*)chatItems{
 
    NSError *requestError = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"SWChatData"];
    NSArray *data = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
    return  data;
}
- (void)resetAllChatItems{
    
    NSError *requestError = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"SWChatData"];
    NSArray *data = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    if(data != nil && data.count > 0){
        for (SWChatData *item in data) {
            item.isNew = NO;
        }
    }
    [self.managedObjectContext save:&requestError];
    [self saveContext];

}
#pragma mark - Private methods

- (NSInteger)getNewMessageCout:(NSNumber*)param{
    
    NSInteger result = 0;
    
    NSError *requestError = nil;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"SWChatData"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"senderUserId == %ld AND isNew == 1",((NSNumber*)param).integerValue]];
    NSArray *data = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    if(data != nil && data.count > 0){
        result = data.count;
    }
    
    return  result;
}
- (void)updateBage:(BOOL)state{
    
    NSError *requestError = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"SWChatData"];
  
    NSInteger bageCount = 0;
    
    NSArray *data = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    if(data != nil && data.count > 0){
        for (SWChatData *obj in data) {
            if(obj.isNew){
                bageCount++;
            }
        }
    }
 
    TheApp;
    SWTabbarController* tabBarController =(SWTabbarController*)app.window.rootViewController;
    [tabBarController updateBage:bageCount withState:state];
    
    
}


- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Core Data methods

#pragma mark - Core Data stack

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            //abort();
            NSLog(@"");
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Guido[SWDataManager sharedInstance].sqlite"];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        
        abort();
    }
    
    return _persistentStoreCoordinator;
}

@end
