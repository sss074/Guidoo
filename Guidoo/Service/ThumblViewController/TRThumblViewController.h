//
//  TRThumblViewController.h
//  Guidoo
//
//  Created by Sergiy Bekker on 28.03.17.
//  Copyright © 2016 Sergiy Bekker. All rights reserved.
//

#import "SWBaseController.h"

@protocol TRThumblViewControllerDelegate;

@interface TRThumblViewController : SWBaseController.h

@property (nonatomic,weak) id<TRThumblViewControllerDelegate> delegate;
@property (nonatomic,strong) NSDictionary* content;

@end

@protocol TRThumblViewControllerDelegate <NSObject>

@required

- (void)thumblViewController:(TRThumblViewController *)controller didFinishCroppingImage:(NSArray*)data;

@end
