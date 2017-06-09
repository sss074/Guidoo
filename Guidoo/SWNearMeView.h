//
//  SWNearMeView.h
//  Guidoo
//
//  Created by Sergiy Bekker on 05.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  SWNearMeView;

@protocol SWNearMeViewDelegate <NSObject>

- (void)segmentChanged:(SWNearMeView*)obj withState:(NSInteger)state;
- (void)titleChanged:(SWNearMeView*)obj withTitle:(NSString*)title;
@end

@interface SWNearMeView : UIView

@property(nonatomic, weak) id<SWNearMeViewDelegate> delegate;
@property (nonatomic, strong) NSArray* anotations;

- (void)showFilter;

@end
