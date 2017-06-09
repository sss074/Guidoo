//
//  SWTourController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 06.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWTourController.h"
#import "SWTourView.h"
#import <MessageUI/MessageUI.h>

@interface SWTourController ()<MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) IBOutlet SWTourView* tourView;
@end

@implementation SWTourController


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavBtn:[self checkTour:_content.tourId] ? MARKSAVEDTYPE : MARKTYPE];
    
    [self simpleTitle:_customTitle == nil ? _content.name : _customTitle];
    _tourView.content = _content;

}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.titleLabel removeFromSuperview];
    
}

#pragma mark - Action methods

- (void)btnSharePressed{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject: [NSString stringWithFormat:@"%@",_content.name]];
        //[mailCont setToRecipients:[NSArray arrayWithObject:@"joel@stackoverflow.com"]];
        [mailCont setMessageBody:[NSString stringWithFormat:@"%@",_content.descriptions] isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
        
    }
}
- (void)btnSavedPressed{
    [self showIndecator:YES];
    if([self checkTour:_content.tourId]){
        [[SWWebManager sharedManager]removeBookmarksTour:nil withTourID:_content.tourId success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupNavBtn:[self checkTour:_content.tourId] ? MARKSAVEDTYPE : MARKTYPE];
            });
        }];
    } else {
        [[SWWebManager sharedManager]bookmarksTour:nil withGuideID:_content.tourId success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupNavBtn:[self checkTour:_content.tourId] ? MARKSAVEDTYPE : MARKTYPE];
            });
        }];
    }

}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
