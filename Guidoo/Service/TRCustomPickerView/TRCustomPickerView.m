//
//  TRCustomPickerView.m
//  CustomPickerView
//
//  Created by Developer on 29.09.15.
//  Copyright (c) 2015 DenisovaOlga. All rights reserved.
//

#import "TRCustomPickerView.h"

@interface TRCustomPickerView () <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSTimeInterval _showHideAnimDuration;
    UIWindow *window;
    CGFloat _toolBarHeight;
    UIToolbar* _toolBar;
    UIButton* _doneBtn;
    UIButton* _cancelBtn;
    UIPickerView* _pickerView;
}
@end


@implementation TRCustomPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.content = @[];
        self.appearancePlace = TRPickerAppearancePlace_Bottom;
        
        _pickerView = [[UIPickerView alloc]init];
       [self addSubview:_pickerView];
        _isShow = NO;
        _isCompleted = YES;
        _pickerView.showsSelectionIndicator = YES;
        
        
        
        _showHideAnimDuration = 0.5f;
    }
    return self;
}

- (void) setParams:(NSDictionary *)params {
    _params = params;
    _toolBarHeight = 40.f;
    _pickerView.backgroundColor = _params[key_pickerBackgroundColorUIColor];
    
 
    [_toolBar removeFromSuperview];
    if ([[_params objectForKey:key_isToolBarExistNSNumber]boolValue]) {
        
        _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), _toolBarHeight)];
        _toolBar.barTintColor =  [UIColor colorWithRed:71.f/255.f green:168.f/255.f blue:23.f/255.f alpha:1.f];
        
        UIBarButtonItem* fixSpaceEdges = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixSpaceEdges.width = [_params[key_horizEdgeOffsetsCancelDoneBtns] floatValue];
        
        UIBarButtonItem* flexibleSpaceCenter = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        CGRect frame = [[UIScreen mainScreen]bounds];
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitleColor: [UIColor whiteColor]  forState:UIControlStateNormal];
        [_doneBtn setTitle:@"Done" forState:UIControlStateNormal];
        [_doneBtn setTitle:@"Done" forState:UIControlStateHighlighted];
        [_doneBtn addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        [_doneBtn setFrame:CGRectMake(0, 0, CGRectGetWidth(frame) / 5 , CGRectGetHeight(_toolBar.frame))];
        _doneBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
        UIBarButtonItem* doneBtnItem = [[UIBarButtonItem alloc]initWithCustomView:_doneBtn];
     
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor: [UIColor whiteColor]  forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"Cancel" forState:UIControlStateHighlighted];
        [_cancelBtn addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setFrame:CGRectMake(0, 0, CGRectGetWidth(frame) / 5 , CGRectGetHeight(_toolBar.frame))];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
        UIBarButtonItem* cancelBtnItem = [[UIBarButtonItem alloc]initWithCustomView:_cancelBtn];
     

        UILabel* lb = [[UILabel alloc] initWithFrame:CGRectMake(0.f , 0.f, self.frame.size.width - 200.f, _toolBarHeight)];
        [lb setText:_params[key_toolBarTitleNSString]];
        lb.textColor = [UIColor whiteColor];
        lb.font = [UIFont fontWithName:_params[key_pickerFontNameNSString] size:((NSNumber*)_params[key_pickerFontSizeNSNumber]).floatValue];
        lb.textAlignment = NSTextAlignmentCenter;
        UIBarButtonItem* title =[[UIBarButtonItem alloc]initWithCustomView:lb];

        
        [_toolBar setItems:@[fixSpaceEdges, cancelBtnItem, flexibleSpaceCenter, title, flexibleSpaceCenter, doneBtnItem, fixSpaceEdges]];
        [self addSubview:_toolBar];
        
        _pickerView.frame = CGRectMake(0, CGRectGetMaxY(_toolBar.frame), CGRectGetWidth(self.bounds), 180.f);

    } else {
         _pickerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 180.f);
    }
    
    self.frame = CGRectMake(0, self.frame.origin.y, CGRectGetWidth(self.frame), CGRectGetMaxY(_pickerView.frame));

    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView reloadAllComponents];

    
    NSArray* selectedRows = _params[key_pickerSelectedRowsNSArray];
    if (selectedRows) {
        for(int  i = 0; i < [self.content count]; ++i) {
            [_pickerView selectRow:[selectedRows[i] unsignedIntegerValue] inComponent:i animated:YES];
        }
    }

    
}
- (void)show {
 
   /* NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
 
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
                             self.frame = CGRectMake(0, CGRectGetMaxY(self.superview.bounds) - CGRectGetHeight(self.frame), CGRectGetWidth(self.superview.bounds), CGRectGetHeight(self.frame));}
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
        if ([self.content count] > 0) {
            NSMutableArray* selRows = [NSMutableArray array];
            for (int i = 0; i < [self.content count]; ++i) {
                [selRows addObject:@([_pickerView selectedRowInComponent:i])];
            }
            
            if ([self.customPickerViewDelegate respondsToSelector:@selector(inCustomPickerView:didSelectRows:)]) {
                [self.customPickerViewDelegate inCustomPickerView:self didSelectRows:selRows];
            }
        }
    } else if ([sender isEqual:_cancelBtn]) {
        [self hide];
        if ([self.customPickerViewDelegate respondsToSelector:@selector(cancelCustomPickerView:)]) {
            [self.customPickerViewDelegate cancelCustomPickerView:self];
        }
    }
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if ([self.content count] == 2) {
        return CGRectGetWidth(_pickerView.frame) / 3;
    } else return CGRectGetWidth(_pickerView.frame) / [self.content count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* reuseView = (UILabel*)view;
    
    if (!reuseView){
        reuseView = [[UILabel alloc] init];
        [reuseView setFont:[UIFont fontWithName:_params[key_pickerFontNameNSString] size:[_params[key_pickerFontSizeNSNumber] floatValue]]];
        
        [reuseView setTextColor:_params[key_pickerContentTextColorUIColor]];
    }
    reuseView.textAlignment = NSTextAlignmentCenter;
    reuseView.backgroundColor = _params[key_pickerComponentsRowsBackgroundColorUIColor];

    
    reuseView.text = ((NSArray*)self.content[component])[row];
    
    UIColor* selColor = _params[key_pickerSelectionLinesColorUIColor];
    [[pickerView.subviews objectAtIndex:1] setBackgroundColor:selColor];
    [[pickerView.subviews objectAtIndex:2] setBackgroundColor:selColor];
    
    return reuseView;
}

#pragma mark - UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [self.content count];
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [((NSArray*)self.content[component]) count];
}

@end
