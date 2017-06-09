//
//  SWPhoneController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 28.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWPhoneController.h"
#import "SWPhoneView.h"
@interface SWPhoneController () <SWPhoneViewDelegate>

@property (nonatomic,strong)IBOutlet SWPhoneView* phoneView;
@end

@implementation SWPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _phoneView.delegate = self;
    
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark -  SWPhoneView delegate methods
-(void)alertMessage:(SWPhoneView*)obj withMessage:(NSString*)message{
    UIAlertController* alert= [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionOK];
    [self  presentViewController:alert animated:YES completion:nil];
}
-(void)backPress:(SWPhoneView*)obj{
     [self dismissViewControllerAnimated:YES completion:^{
       
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         SWPhoneController* controller = [storyboard instantiateViewControllerWithIdentifier:@"ConfirmController"];
         TheApp;
         UINavigationController* rootController = (UINavigationController*)app.window.rootViewController;
         controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
         [rootController presentViewController:controller animated:YES completion:nil];
         
     }];
    
}
@end
