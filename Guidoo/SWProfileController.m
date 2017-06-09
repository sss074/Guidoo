//
//  SWProfileController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 06.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWProfileController.h"

@interface SWProfileController ()

@end

@implementation SWProfileController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO];
}
@end
