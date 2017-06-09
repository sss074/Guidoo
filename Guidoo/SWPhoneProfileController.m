//
//  SWPhoneProfileController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 12.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWPhoneProfileController.h"
#import "SWPhoneProfileView.h"

@interface SWPhoneProfileController () <SWPhoneProfileViewDelegate>

@property (nonatomic,strong)IBOutlet SWPhoneProfileView* phoneProfileView;

@end

@implementation SWPhoneProfileController

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _phoneProfileView.delegate = self;
}

#pragma mark -  SWPhoneProfileViewDelegate delegate methods

-(void)backPress:(SWPhoneProfileView*)obj{

    TheApp;
    app.window.rootViewController = [self checkPresentForClassDescriptor:@"FTSNavController"];
    
}
-(void)alertMessage:(SWPhoneProfileView*)obj withMessage:(NSString*)message{
    UIAlertController* alert= [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionOK];
    [self  presentViewController:alert animated:YES completion:nil];
    
}


@end
