//
//  SWInboxController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 27.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWInboxController.h"
#import "SWInboxView.h"
#import "SWChatController.h"

@interface SWInboxController ()<SWInboxViewDelegate>

@property (nonatomic,strong) IBOutlet SWInboxView* inboxView;

@end

@implementation SWInboxController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _inboxView.delegete = self;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [[SWDataManager sharedManager]updateBage:NO];
}

#pragma  mark - SWInboxView delegete methods
- (void)didSelectItem:(SWInboxView*)obj withContent:(SWChatMessage*)content{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWChatController* controller = [storyboard instantiateViewControllerWithIdentifier:@"ChatController"];
    controller.content = content;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
