//
//  SWChatController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 27.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWChatController.h"
#import "SWChatView.h"

@interface SWChatController ()
@property (nonatomic,strong) IBOutlet SWChatView* chatView;
@end

@implementation SWChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavBtn:BACKTYPE];
    [self simpleTitle:[NSString stringWithFormat:@"%@ %@",_content.firstName,_content.lastName]];
    _chatView.content = _content;
    [SWWebManager sharedManager].curChatID = _content.senderUserId;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SWWebManager sharedManager].curChatID = nil;
    
}
@end
