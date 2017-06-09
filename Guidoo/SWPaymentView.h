//
//  SWPaymentView.h
//  Guidoo
//
//  Created by Sergiy Bekker on 04.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWPaymentView;

@protocol SWPaymentViewDelegate <NSObject>

-(void)backPress:(SWPaymentView*)obj;

@end

@interface SWPaymentView : UIView

@property (nonatomic,weak) id<SWPaymentViewDelegate> delegate;

@end
