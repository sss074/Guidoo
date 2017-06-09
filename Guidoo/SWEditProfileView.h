//
//  SWEditProfileView.h
//  Guidoo
//
//  Created by Sergiy Bekker on 11.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWEditProfileController.h"

@class SWEditProfileView;

@protocol SWEditProfileViewDelegate <NSObject>

- (void)chosePress:(SWEditProfileView*)obj withContent:(NSArray*)content title:(NSString*)title;


@end

@interface SWEditProfileView : UIView

@property (nonatomic,weak) id<SWEditProfileViewDelegate> delegate;

@end
