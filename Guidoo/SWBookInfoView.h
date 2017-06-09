//
//  SWBookInfoView.h
//  Guidoo
//
//  Created by Sergiy Bekker on 05.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWBookInfoView;

@protocol SWBookInfoViewDelegate <NSObject>

-(void)backPress:(SWBookInfoView*)obj;
-(void)updateNavigation:(SWBookInfoView*)obj withState:(BOOL)state;

@end

@interface SWBookInfoView : UIView

@property (nonatomic,weak) id<SWBookInfoViewDelegate> delegate;

- (void)checkTour;
@end
