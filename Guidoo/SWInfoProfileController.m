//
//  SWInfoProfileController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 11.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWInfoProfileController.h"

@interface SWInfoProfileController ()

@end

@implementation SWInfoProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updatePlacesAfterLocation" object:nil];
}



#pragma mark -  Action methods

- (IBAction)btnBackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
