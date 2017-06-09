//
//  ViewController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 27.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWMainController.h"

@interface SWMainController ()

@end

@implementation SWMainController

- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}



@end
