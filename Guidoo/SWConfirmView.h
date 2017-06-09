//
//  SWConfirmView.h
//  Guidoo
//
//  Created by Sergiy Bekker on 18.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWConfirmView;

@protocol SWConfirmViewDelegate <NSObject>

-(void)backPress:(SWConfirmView*)obj;
-(void)alertMessage:(SWConfirmView*)obj withMessage:(NSString*)message;

@end

@interface SWConfirmView : UIView

@property (nonatomic,weak) id<SWConfirmViewDelegate> delegate;

@end
