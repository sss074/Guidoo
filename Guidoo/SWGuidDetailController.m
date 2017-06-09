//
//  SWGuidDetailController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 06.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWGuidDetailController.h"
#import "SWGuidDateilView.h"
#import "SWTourController.h"
#import <MessageUI/MessageUI.h>

@interface SWGuidDetailController ()<SWGuidDateilViewDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) IBOutlet SWGuidDateilView* detailView;
@end

@implementation SWGuidDetailController


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    [self.navigationController setNavigationBarHidden:YES];
    _detailView.content = _content;
    _detailView.delegate = self;

}
#pragma mark - SWGuidDateilView delegate methods

-(void)backPress:(SWGuidDateilView*)obj{
    [self btnBackPressed];
}
-(void)didSelectItem:(SWGuidDateilView*)obj withContent:(SWTour*)param{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWTourController* controller = [storyboard instantiateViewControllerWithIdentifier:@"TourController"];
    controller.content = param;
    [self.navigationController pushViewController:controller animated:YES];

}
-(void)sendMail:(SWGuidDateilView*)obj withContent:(SWGuide*)guide{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject: [NSString stringWithFormat:@"%@ %@",guide.firstName,guide.lastName]];
        //[mailCont setToRecipients:[NSArray arrayWithObject:@"joel@stackoverflow.com"]];
        [mailCont setMessageBody:[NSString stringWithFormat:@"%@",guide.resume] isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
      
    }

}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
