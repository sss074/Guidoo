//
//  SWGuidDateilView.h
//  Guidoo
//
//  Created by Sergiy Bekker on 06.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWGuidDateilView;

@protocol SWGuidDateilViewDelegate <NSObject>

-(void)backPress:(SWGuidDateilView*)obj;
-(void)didSelectItem:(SWGuidDateilView*)obj withContent:(SWTour*)obj;
-(void)sendMail:(SWGuidDateilView*)obj withContent:(SWGuide*)obj;
@end

@interface SWGuidDateilView : UIView

@property (nonatomic,strong)NSArray * content;
@property (nonatomic,weak) id<SWGuidDateilViewDelegate> delegate;

@end
