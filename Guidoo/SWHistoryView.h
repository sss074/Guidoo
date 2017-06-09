//
//  SWHistoryView.h
//  Guidoo
//
//  Created by Sergiy Bekker on 07.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWHistoryView;

@protocol SWHistoryViewDelegate <NSObject>

- (void)morePress:(SWHistoryView*)obj withContent:(SWHistory*)content;
- (void)didSelectItem:(SWHistoryView*)obj withContent:(SWHistory*)content;

@end

@interface SWHistoryView : UIView

@property (nonatomic,weak) id<SWHistoryViewDelegate> delegete;

@end
