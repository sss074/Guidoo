//
//  SWInboxView.h
//  Guidoo
//
//  Created by Sergiy Bekker on 27.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWInboxView;

@protocol SWInboxViewDelegate <NSObject>


- (void)didSelectItem:(SWInboxView*)obj withContent:(SWChatMessage*)content;

@end

@interface SWInboxView : UIView

@property (nonatomic,weak) id<SWInboxViewDelegate> delegete;

@end
