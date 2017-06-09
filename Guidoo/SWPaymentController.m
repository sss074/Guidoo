//
//  SWPaymentController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 15.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWPaymentController.h"
#import "SWPaymentView.h"
#import "SWBookInfoController.h"

@interface SWPaymentController ()<SWPaymentViewDelegate>

@property (nonatomic,strong)IBOutlet SWPaymentView* paymentView;
@end

@implementation SWPaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self setupNavBtn:BACKTYPE];
    [self simpleTitle:@"Payment tour"];
    _paymentView.delegate = self;
}

#pragma mark - SWPaymentView delegate methods
-(void)backPress:(SWPaymentView*)obj{
    TheApp;
    [self dismissViewControllerAnimated:YES completion:^{
        //if(![SWWebManager sharedManager].isHistory){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController* navcontroller = [storyboard instantiateViewControllerWithIdentifier:@"BookInfoNavController"];
            SWTabbarController* tabBarController =(SWTabbarController*)app.window.rootViewController;
            UINavigationController* nav = (UINavigationController*)[tabBarController selectedViewController];
            navcontroller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [nav presentViewController: navcontroller animated: YES completion:nil];
        //}
        //[SWWebManager sharedManager].isHistory = NO;
    }];
    
}
#pragma mark - Action methods

- (void)btnBackPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
