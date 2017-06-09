//
//  TRCustomPickerView.h
//  CustomPickerView
//
//  Created by Developer on 29.09.15.
//  Copyright (c) 2015 DenisovaOlga. All rights reserved.
//


@protocol TRCustomPickerViewDelegate;



@interface TRCustomPickerView : UIView
@property(weak, nonatomic) id <TRCustomPickerViewDelegate> customPickerViewDelegate;
@property(strong, nonatomic) NSArray* content;
@property(assign, nonatomic) NSUInteger appearancePlace;
@property(strong, nonatomic) NSDictionary* params;
@property(assign, nonatomic) BOOL isShow;
@property(assign, nonatomic) BOOL isCompleted;

-(void) show;
-(void) hide;
@end

@protocol TRCustomPickerViewDelegate <NSObject>
@optional
-(void) inCustomPickerView:(TRCustomPickerView*) customPickerView didSelectRows:(NSArray*) rows;
-(void) cancelCustomPickerView:(TRCustomPickerView*)customPickerView;
@end
