//
//  ViewController.h
//  SWGitHub
//
//  Created by Sergiy Bekker on 15.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SWBaseController : UIViewController

@property (nonatomic,strong) UILabel *titleLabel;

- (void)btnBackPressed;
- (void)btnMorePressed;
- (void)btnApplyPressed;
- (void)btnSharePressed;
- (void)btnSavedPressed;
- (void)setupNavBtn:(NavBarType)type;
- (void)simpleTitle:(NSString*)title;

@end

