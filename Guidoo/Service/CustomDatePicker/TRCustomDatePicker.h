//
//  TRCustomDatePicker.h
//  CustomDatePicker
//
//  Created by Developer on 30.09.15.
//  Copyright (c) 2015 DenisovaOlga. All rights reserved.
//


static NSString* key_datePickerContentTextColorUIColor = @"datePickerContentTextColorUIColor";
static NSString* key_datePickerBackgroundColorUIColor = @"datePickerBackgroundColorUIColor";
static NSString* key_datePickerMaxDateNSDate = @"datePickerMaxDateNSDate";
static NSString* key_datePickerMinDateNSDate = @"datePickerminDateNSDate";


@protocol TRCustomDatePickerDelegate;

@interface TRCustomDatePicker : UIView
@property(weak, nonatomic) id <TRCustomDatePickerDelegate> customDatePickerDelegate;
@property(assign, nonatomic) NSUInteger appearancePlace;
@property(strong, nonatomic) NSDictionary* params;
@property(assign, nonatomic) BOOL isShow;
@property(assign, nonatomic) BOOL isCompleted;
@property(assign, nonatomic) UIDatePickerMode datePickerMode;

-(void) show;
-(void) hide;
@end

@protocol TRCustomDatePickerDelegate <NSObject>

-(void) inCustomDatePicker:(TRCustomDatePicker*) customDatePicker selectedDateDictionary:(NSDictionary*)selectedDateDict;
-(void) cancelCustomDatePicker:(TRCustomDatePicker*)customDatePicker;
@end
