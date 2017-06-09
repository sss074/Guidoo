//
//  SWFTSController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 03.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWFTSController.h"

@interface SWFTSController ()

@end

@implementation SWFTSController

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
  
    [super viewWillAppear:animated];
    [self setupNavBtn:NONTYPE];
    
}

@end
