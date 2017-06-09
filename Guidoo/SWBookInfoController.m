//
//  SWBookInfoController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 05.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBookInfoController.h"
#import "SWBookInfoView.h"
#import <MessageUI/MessageUI.h>
#import "SWChatController.h"

@interface SWBookInfoController ()<SWBookInfoViewDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic,strong)IBOutlet SWBookInfoView* bookView;

@end

@implementation SWBookInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavBtn:MARKTYPE];
    [self simpleTitle:@"Booking Info"];
    _bookView.delegate = self;
    [_bookView checkTour];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showChat:) name:@"showChat" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showChat" object:nil];

}
#pragma mark - SWBookInfoView delegate methods
-(void)backPress:(SWBookInfoView*)obj{
    [self btnBackPressed];
}
-(void)updateNavigation:(SWBookInfoView*)obj withState:(BOOL)state{
    [self setupNavBtn:state ? MARKSAVEDTYPE : MARKTYPE];
}
#pragma mark - Action methods

- (void)btnBackPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnSharePressed{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject: [NSString stringWithFormat:@"%@",[SWWebManager sharedManager].curBookInfo.tour.name]];
        //[mailCont setToRecipients:[NSArray arrayWithObject:@"joel@stackoverflow.com"]];
        [mailCont setMessageBody:[NSString stringWithFormat:@"%@",[SWWebManager sharedManager].curBookInfo.tour.descriptions] isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
        
    }
}
- (void)btnSavedPressed{
    [self showIndecator:YES];
    if([self checkTour:[SWWebManager sharedManager].curBookInfo.tour.tourId]){
        [[SWWebManager sharedManager]removeBookmarksTour:nil withTourID:[SWWebManager sharedManager].curBookInfo.tour.tourId success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupNavBtn:[self checkTour:[SWWebManager sharedManager].curBookInfo.tour.tourId] ? MARKSAVEDTYPE : MARKTYPE];
            });
        }];
    } else {
        [[SWWebManager sharedManager]bookmarksTour:nil withGuideID:[SWWebManager sharedManager].curBookInfo.tour.tourId success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupNavBtn:[self checkTour:[SWWebManager sharedManager].curBookInfo.tour.tourId] ? MARKSAVEDTYPE : MARKTYPE];
            });
        }];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -  NSNotification

- (void)showChat:(NSNotification*)notify{
    SWChatMessage* obj = notify.object;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWChatController* controller = [storyboard instantiateViewControllerWithIdentifier:@"ChatController"];
    controller.content = obj;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
