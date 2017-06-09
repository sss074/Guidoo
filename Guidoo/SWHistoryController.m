//
//  SWHistoryController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 07.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWHistoryController.h"
#import "SWHistoryView.h"
#import "SWTourController.h"
#import "TRCustomDatePicker.h"
#import "TRCustomPickerView.h"
#import <EventKit/EventKit.h>
#import "SWChatController.h"


@interface SWHistoryController () <SWHistoryViewDelegate,TRCustomDatePickerDelegate,TRCustomPickerViewDelegate>{
    TRCustomDatePicker* datePicker;
    TRCustomPickerView* timePicker;
    SWHistory* curContent;
}

@property (nonatomic,strong) IBOutlet SWHistoryView* historyView;
@end

@implementation SWHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    datePicker = [[TRCustomDatePicker alloc]initWithFrame:CGRectMake(0, 50, CGRectGetWidth([[UIScreen mainScreen] bounds]), 200.f)];
    datePicker.appearancePlace = TRPickerAppearancePlace_Bottom;
    datePicker.customDatePickerDelegate = self;
    
    timePicker = [[TRCustomPickerView alloc]initWithFrame:CGRectMake(0, 50, CGRectGetWidth([[UIScreen mainScreen] bounds]), 200.f)];
    timePicker.appearancePlace = TRPickerAppearancePlace_Bottom;
    timePicker.customPickerViewDelegate = self;
    NSMutableArray* temp = [NSMutableArray new];
    for(int i = 0; i < 24; i++){
        [temp addObject:[NSString stringWithFormat:@"%d",i + 1]];
    }
    timePicker.content = @[[NSArray arrayWithArray:temp]];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showChat" object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showChat:) name:@"showChat" object:nil];
    [self.navigationController setNavigationBarHidden:YES];
    _historyView.delegete = self;
}
#pragma mark -  NSNotification

- (void)showChat:(NSNotification*)notify{
    SWChatMessage* obj = notify.object;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWChatController* controller = [storyboard instantiateViewControllerWithIdentifier:@"ChatController"];
    controller.content = obj;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma  mark - SWHistoryView delegete methods
- (void)morePress:(SWHistoryView*)obj  withContent:(SWHistory*)content{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Set reminder" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             curContent = content;
             
             
             timePicker.params = @{key_pickerFontNameNSString : @"OpenSans-Light",
                                     key_pickerFontSizeNSNumber : @(14.f),
                                     key_pickerContentTextColorUIColor : [UIColor blackColor],
                                     key_pickerComponentsRowsBackgroundColorUIColor : [UIColor whiteColor],
                                     key_pickerBackgroundColorUIColor : [UIColor whiteColor],
                                     key_pickerSelectionLinesColorUIColor : [UIColor lightGrayColor],
                                     key_isToolBarExistNSNumber : @(YES),
                                     key_doneBtnTitleNSString : @"Done",
                                     key_cancelBtnTitleNSString : @"Cancel",
                                     key_horizEdgeOffsetsCancelDoneBtns  : @(10.f),
                                     key_toolBarTitleNSString : @"Time before tour start",
                                     key_pickerSelectedRowsNSArray : @[@(0)]};
             
             
             if(!timePicker.isShow){
                 if(timePicker.isShow && timePicker.isCompleted){
                     [timePicker hide];
                 } else if(!timePicker.isShow && timePicker.isCompleted){
                     [timePicker show];
                 }
             }

             
             
             /*datePicker.params = @{key_pickerFontNameNSString : @"OpenSans-Light",
                                   key_pickerFontSizeNSNumber : @(14.f),
                                   key_pickerContentTextColorUIColor : [UIColor blackColor],
                                   key_pickerComponentsRowsBackgroundColorUIColor : [UIColor whiteColor],
                                   key_pickerBackgroundColorUIColor : [UIColor whiteColor],
                                   key_pickerSelectionLinesColorUIColor : [UIColor lightGrayColor],
                                   key_isToolBarExistNSNumber : @(YES),
                                   key_doneBtnTitleNSString : @"Done",
                                   key_cancelBtnTitleNSString : @"Cancel",
                                   key_horizEdgeOffsetsCancelDoneBtns  : @(10.f),
                                   key_toolBarTitleNSString : @"Time before tour start",
                                   key_toolBarTitleColorUIColor:[UIColor whiteColor],
                                   key_pickerSelectedRowsNSArray : @[@(0)]};
             datePicker.datePickerMode = UIDatePickerModeTime;
             
             
             if(!datePicker.isShow){
                 if(datePicker.isShow && datePicker.isCompleted){
                     [datePicker hide];
                 } else if(!datePicker.isShow && datePicker.isCompleted){
                     [datePicker show];
                 }
             }*/

             
            
         });
    

    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel tour" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        SWLogin *objLogin = [self objectDataForKey:userLoginInfo];
        if(objLogin != nil){
            NSString* param = [NSString stringWithFormat:@"bookingId=%ld&userId=%ld&sessionToken=%@",((NSNumber*)content.bookingId).integerValue,((NSNumber*)objLogin.userId).integerValue,objLogin.sessionToken];
            [self showIndecator:YES];
            [[SWWebManager sharedManager]cancelTour:param success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHistory" object:nil];
                    [self cancelReminder:content];
                });
            }];
        }
        
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];

}

- (void)didSelectItem:(SWHistoryView*)obj withContent:(SWHistory*)content{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWTourController* controller = [storyboard instantiateViewControllerWithIdentifier:@"TourController"];
    controller.content = content.tour;
    controller.customTitle = content.bookingState;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - TRCustomPickerViewDelegate delegate methods

-(void) cancelCustomPickerView:(TRCustomPickerView*)customPickerView{
    
}
-(void) inCustomPickerView:(TRCustomPickerView*) customPickerView didSelectRows:(NSArray*) rows {
    
    NSInteger curCountryRow = ((NSNumber*)rows[0]).integerValue + 1;
    
    NSTimeInterval seconds = [curContent.startTime longLongValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDate *startDate = date;
    NSDate *endDate = [date dateByAddingTimeInterval:3600];
    __block NSTimeInterval alarmOffset = -curCountryRow*60*60;

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:startDate];
    
    [components setHour:components.hour - curCountryRow];

    NSDate *fireDate = [gregorian dateFromComponents:components];
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.alertTitle = @"Time has come!";
    localNotification.userInfo = @{@"id":curContent.bookingId};
    localNotification.alertBody = [NSString stringWithFormat:@"You have a tour with  %@ in %@",([curContent.tourName isEqualToString:@""] || curContent.tourName == nil)  ? nil : curContent.tourName,[NSDateFormatter localizedStringFromDate:date
                                                                                                                                                                                                                                     dateStyle:NSDateFormatterMediumStyle
                                                                                                                                                                                                                                     timeStyle:NSDateFormatterShortStyle]];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        EKEvent *calendarEvent = [EKEvent eventWithEventStore:store];
        calendarEvent.title = [NSString stringWithFormat:@"You have a tour with  %@ in %@",([curContent.tourName isEqualToString:@""] || curContent.tourName == nil)  ? nil : curContent.tourName,[NSDateFormatter localizedStringFromDate:date
                                                                                                                                                                                                                                 dateStyle:NSDateFormatterMediumStyle
                                                                                                                                                                                                                                 timeStyle:NSDateFormatterShortStyle]];
        calendarEvent.startDate = startDate;
        calendarEvent.endDate = endDate;
        calendarEvent.calendar = [store defaultCalendarForNewEvents];
        //alarmOffset = -curCountryRow*60*60;
        EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:alarmOffset];
        [calendarEvent addAlarm:alarm];
        NSError *err = nil;
        [store saveEvent:calendarEvent span:EKSpanThisEvent commit:YES error:&err];
        
        
        
        
        
    }];
    
    [self showAlertMessage:@"Reminder successfully installed"];

    
    
}

#pragma mark - TRCustomDatePickerDelegate delegate methods

-(void) cancelCustomDatePicker:(TRCustomDatePicker*)customDatePicker{
    
}
-(void) inCustomDatePicker:(TRCustomDatePicker*) customDatePicker selectedDateDictionary:(NSDictionary*)selectedDateDict{
    
    
    //NSDate* curDate = (NSDate*)selectedDateDict[@"selectedDateNSDate"];
    
}

@end
