//
//  SWPhoneProfileView.h
//  Guidoo
//
//  Created by Sergiy Bekker on 12.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWPhoneProfileView;

@protocol SWPhoneProfileViewDelegate <NSObject>

-(void)backPress:(SWPhoneProfileView*)obj;
-(void)alertMessage:(SWPhoneProfileView*)obj withMessage:(NSString*)message;

@end


@interface SWPhoneProfileView : UIView

@property (nonatomic,weak) id<SWPhoneProfileViewDelegate> delegate;

@end
