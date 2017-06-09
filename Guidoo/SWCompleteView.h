//
//  SWCompleteView.h
//  Guidoo
//
//  Created by Sergiy Bekker on 19.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWCompleteView;

@protocol SWCompleteViewDelegate <NSObject>

-(void)backPress:(SWCompleteView*)obj;


@end

@interface SWCompleteView : UIView

@property (nonatomic,weak) id<SWCompleteViewDelegate> delegate;


@end
