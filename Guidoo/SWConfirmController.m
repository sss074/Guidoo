//
//  SWConfirmController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 18.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWConfirmController.h"
#import "SWConfirmView.h"

@interface SWConfirmController ()<SWConfirmViewDelegate>

@property (nonatomic,strong)IBOutlet SWConfirmView* confirmView;

@end

@implementation SWConfirmController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _confirmView.delegate = self;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
#pragma mark -  Action methods
- (IBAction)btnBackPressed:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
#pragma mark -  SWPhoneView delegate methods

-(void)backPress:(SWConfirmView*)obj{
    [self dismissViewControllerAnimated:YES completion:^{
        TheApp;
        app.window.rootViewController =  [self checkPresentForClassDescriptor:@"PhoneProfileNavController"];
    }];
}
-(void)alertMessage:(SWConfirmView*)obj withMessage:(NSString*)message{
    UIAlertController* alert= [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionOK];
    [self  presentViewController:alert animated:YES completion:nil];
    
}
@end
