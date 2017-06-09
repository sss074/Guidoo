//
//  SWPhoneView.h
//  Guidoo
//
//  Created by Sergiy Bekker on 28.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWPhoneView;

@protocol SWPhoneViewDelegate <NSObject>

-(void)backPress:(SWPhoneView*)obj;
-(void)alertMessage:(SWPhoneView*)obj withMessage:(NSString*)message;

@end

@interface SWPhoneView : UIView

@property (nonatomic,weak) id<SWPhoneViewDelegate> delegate;
@end
