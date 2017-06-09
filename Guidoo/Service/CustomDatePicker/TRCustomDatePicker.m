//
//  TRCustomDatePicker.m
//  CustomDatePicker
//
//  Created by Developer on 30.09.15.
//  Copyright (c) 2015 DenisovaOlga. All rights reserved.
//

#import "TRCustomDatePicker.h"

@interface TRCustomDatePicker() {
    NSTimeInterval _showHideAnimDuration;
    UIDatePicker* _datePicker;
    CGFloat _toolBarHeight;
    UIToolbar* _toolBar;
    UIBarButtonItem* _doneBtn;
    UIBarButtonItem* _cancelBtn;
    UIWindow *window;
}
@end

@implementation TRCustomDatePicker
- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode{
   
    _datePickerMode = datePickerMode;
    _datePicker.datePickerMode = _datePickerMode;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        _showHideAnimDuration = 0.5f;
        self.appearancePlace = TRPickerAppearancePlace_Bottom;
        _datePicker = [[UIDatePicker alloc]init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [self addSubview:_datePicker];
        _isShow = NO;
        _isCompleted = YES;
        _params = @{};
        _datePicker.datePickerMode = _datePickerMode;

    }
    return self;
}

-(void) setParams:(NSDictionary *)params {
    //_params = params;
    NSMutableDictionary* dictTemp = [NSMutableDictionary dictionaryWithDictionary:_params];
    [dictTemp addEntriesFromDictionary:params];
    _params = dictTemp;
    
    _toolBarHeight = 40.f;
    _datePicker.backgroundColor = _params[key_datePickerBackgroundColorUIColor];
    [_datePicker setValue:_params[key_datePickerContentTextColorUIColor] forKeyPath:@"textColor"];
    _datePicker.minimumDate = _params[key_datePickerMinDateNSDate];
    _datePicker.maximumDate = _params[key_datePickerMaxDateNSDate];
 
    NSDate* selDate = _params[key_datePickerSelectedDateNSDate];
    NSString*  selDateStr = _params[key_datePickerSelectedDateNSString];
    
    if(selDateStr) {
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"dd-MM-yyyy"];
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        selDate = [df dateFromString:selDateStr];
        [_datePicker setDate:selDate animated:YES];
    }
    
    

    [_toolBar removeFromSuperview];
    
    if ([params[key_isToolBarExistNSNumber]boolValue]) {
        _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), _toolBarHeight)];
        _toolBar.barTintColor = [UIColor colorWithRed:71.f/255.f green:168.f/255.f blue:23.f/255.f alpha:1.f];
        
        UIBarButtonItem* fixSpaceEdges = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixSpaceEdges.width = [_params[key_horizEdgeOffsetsCancelDoneBtns] floatValue];
        
        UIBarButtonItem* flexibleSpaceCenter = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        _doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionButton:)];
        _doneBtn.tintColor = [UIColor whiteColor];

        
        _cancelBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionButton:)];
        _cancelBtn.tintColor = [UIColor whiteColor];

        UILabel* lb = [[UILabel alloc] initWithFrame:CGRectMake(0.f , 0.f, self.frame.size.width - 200.f, _toolBarHeight)];
        [lb setText:_params[key_toolBarTitleNSString]];
        lb.textColor = _params[key_toolBarTitleColorUIColor];
        lb.font = [UIFont fontWithName:_params[key_pickerFontNameNSString] size:((NSNumber*)_params[key_pickerFontSizeNSNumber]).floatValue];
        lb.textAlignment = NSTextAlignmentCenter;
        UIBarButtonItem* title =[[UIBarButtonItem alloc]initWithCustomView:lb];
        
        [_toolBar setItems:@[fixSpaceEdges, _cancelBtn, flexibleSpaceCenter, title, flexibleSpaceCenter, _doneBtn, fixSpaceEdges]];
        [self addSubview:_toolBar];
        
        _datePicker.frame = CGRectMake(0, CGRectGetMaxY(_toolBar.frame), CGRectGetWidth(self.bounds), 180.f);
    } else {
        _datePicker.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 180.f);
    }
    
    self.frame = CGRectMake(0, self.frame.origin.y, CGRectGetWidth(self.frame), CGRectGetMaxY(_datePicker.frame));
}


- (void)show {
  /*  UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:self];
    [window bringSubviewToFront:self];*/
   
    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    window.windowLevel = UIWindowLevelAlert + 1.0;
    window.backgroundColor = [UIColor clearColor];
    [window makeKeyAndVisible];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    _isCompleted = NO;
    if (self.appearancePlace == TRPickerAppearancePlace_Top) {
        self.frame =  CGRectMake(0, CGRectGetMinY(self.superview.bounds) - CGRectGetHeight(self.frame), CGRectGetWidth(self.superview.bounds), CGRectGetHeight(self.frame));
        
        [UIView animateWithDuration:_showHideAnimDuration
                              delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.frame = CGRectMake(0, CGRectGetMinY(self.superview.bounds) /*+ CGRectGetHeight(self.frame)*/, CGRectGetWidth(self.superview.bounds), CGRectGetHeight(self.frame));
                         }
                         completion:NULL];
    } else {
        self.frame = CGRectMake(0, CGRectGetMaxY(self.superview.bounds), CGRectGetWidth(self.superview.bounds), CGRectGetHeight(self.frame));
        [UIView animateWithDuration:_showHideAnimDuration
                              delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.frame = CGRectMake(0, CGRectGetMaxY(self.superview.bounds) - CGRectGetHeight(self.frame), CGRectGetWidth(self.superview.bounds), CGRectGetHeight(self.frame));
             
                         }
                         completion:^(BOOL finished) {
                             _isShow = _isCompleted = YES;
                         }];
    }
}

-(void) hide {
    _isCompleted = NO;
    if (self.appearancePlace == TRPickerAppearancePlace_Top) {
        
        [UIView animateWithDuration:_showHideAnimDuration
                              delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.frame = CGRectMake(0, CGRectGetMinY(self.superview.bounds) - CGRectGetHeight(self.frame), CGRectGetWidth(self.superview.bounds), CGRectGetHeight(self.frame));
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             window.hidden = YES;
                             window = nil;
                         }];
    } else {
        [UIView animateWithDuration:_showHideAnimDuration
                              delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.frame = CGRectMake(0, CGRectGetMaxY(self.superview.bounds) + CGRectGetHeight(self.frame), CGRectGetWidth(self.superview.bounds), CGRectGetHeight(self.frame));}
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             window.hidden = YES;
                             window = nil;
                             _isShow = NO;
                             _isCompleted = YES;
                         }];
    }
}


#pragma mark - Actions

-(void) actionButton:(UIBarButtonItem*)sender {
    if ([sender isEqual:_doneBtn]) {
        [self hide];
        
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"dd-MM-yyyy"];
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
   
        if ([self.customDatePickerDelegate respondsToSelector:@selector(inCustomDatePicker:selectedDateDictionary:)]) {
            [self.customDatePickerDelegate inCustomDatePicker:self selectedDateDictionary:@{@"selectedDateNSDate" : _datePicker.date,
                                                                                            @"selectedDateFormatNSString" :
                                                                                                [df stringFromDate:_datePicker.date]}];
        }
    } else if ([sender isEqual:_cancelBtn]) {
        [self hide];
        if ([self.customDatePickerDelegate respondsToSelector:@selector(cancelCustomDatePicker:)]) {
            [self.customDatePickerDelegate cancelCustomDatePicker:self];
        }
    }
}


@end
