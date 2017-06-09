//
//  SWCompleteController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 19.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWCompleteController.h"
#import "SWCompleteView.h"

@interface SWCompleteController ()<SWCompleteViewDelegate>

@property (nonatomic,strong)IBOutlet SWCompleteView* completeView;

@end

@implementation SWCompleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _completeView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

#pragma mark -  SWCompleteView delegate methods

-(void)backPress:(SWCompleteView*)obj{
    
    TheApp;
    app.window.rootViewController =  [self checkPresentForClassDescriptor:@"TabbarController"];
    
}
@end
