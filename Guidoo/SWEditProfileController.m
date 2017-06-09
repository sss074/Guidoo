//
//  SWEditProfileController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 11.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWEditProfileController.h"
#import "SWEditProfileView.h"
#import "SWChoseController.h"

@interface SWEditProfileController ()<SWEditProfileViewDelegate>

@property (nonatomic,strong)IBOutlet SWEditProfileView* profileView;

@end

@implementation SWEditProfileController

- (void)viewDidLoad {
    [super viewDidLoad];

    _profileView.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO];
}
#pragma mark -  Action methods

- (IBAction)btnBackPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -  SWEditProfileView delegate methods

- (void)chosePress:(SWEditProfileView*)obj withContent:(NSArray*)content title:(NSString*)title{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWChoseController* controller = [storyboard instantiateViewControllerWithIdentifier:@"ChoseController"];
    controller.content = content;
    controller.titleStr = title;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
