//
//  SWNearMeController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 03.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWNearMeController.h"
#import "SWMapController.h"
#import "SWNearMeView.h"
#import "SWMapController.h"
#import "SWTourPopup.h"
#import "SWInvitePopup.h"
#import "SWRatePopup.h"

@interface SWNearMeController () <SWNearMeViewDelegate>{
    BOOL isSegment;
    NSString* curtitle;
}
@property (nonatomic, strong) IBOutlet SWNearMeView* nearView;
@end

@implementation SWNearMeController

- (void)viewDidLoad {
    [super viewDidLoad];

    _nearView.delegate = self;
    isSegment = NO;

    
    [self getLocationFromAddress:@"Tel Aviv" success:^(CLLocation *obj) {
        NSLog(@"%f",obj.coordinate.latitude);
        NSLog(@"%f",obj.coordinate.longitude);
    }];
   
    SWLogin *object = [self objectDataForKey:userLoginInfo];
    if(object != nil){
        NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken];
        [[SWWebManager sharedManager]bookmarks:param success:nil];
    }
    
    SWProfile* profile = [self objectDataForKey:profileInfo];
    if(profile == nil){
        SWLogin *object = [self objectDataForKey:userLoginInfo];
        if(object != nil){
            NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken];
            [[SWWebManager sharedManager]profileUser:param success:^(SWProfile * profile) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setObjectDataForKey:profile forKey:profileInfo];
                });
            }];
        }
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlacesAfterLocation:) name:@"updatePlacesAfterLocation" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updatePlacesAfterLocation" object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];


    if(isSegment) {
        [self setupNavBtn:FILTERTYPE];
    } else {
        [self setupNavBtn:BASETYPE];
    }
    NSLog(@"%@",[self objectForKey:address]);
    if(curtitle == nil)
        [self simpleTitle:[self objectForKey:address]];
    else
        [self simpleTitle:curtitle];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[SWDataManager sharedManager] resetAllChatItems];
    
    if([SWWebManager sharedManager].launchInfo != nil){
        TheApp;
        NSString* type = [SWWebManager sharedManager].launchInfo[@"type"];
       
        if([type isEqualToString:@"INVITE"]){

            SWBookInfo* param = [SWBookInfo new];
            NSString* jsonString = [SWWebManager sharedManager].launchInfo[@"guide"];
            NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* guide = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            param.guide = [SWGuide new];
            param.guide.firstName = guide[@"firstName"];
            param.guide.lastName = guide[@"lastName"];
            param.guide.rating = guide[@"rating"];
            param.guide.guideId = guide[@"guideId"];
            param.guide.resume = guide[@"resume"];
            param.guide.pricePerHour = guide[@"pricePerHour"];
            param.guide.regId = guide[@"regId"];
            
            jsonString = [SWWebManager sharedManager].launchInfo[@"tour"];
            data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* tour = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            param.tour = [SWTour new];
            param.tour.durationHours = tour[@"durationHours"];
            param.tour.tourId = tour[@"tourId"];
            param.tour.name = tour[@"name"];
            param.tour.descriptions = tour[@"description"];
            param.tour.rating = guide[@"rating"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                SWInvitePopup *popup = [[[NSBundle mainBundle] loadNibNamed:@"SWInvitePopup" owner:self options:nil] firstObject];
                [SWWebManager sharedManager].curBookInfo = param;
                popup.content = param;
                [popup setFrame:[UIScreen mainScreen].bounds];
                [app.window addSubview:popup];
                [SWWebManager sharedManager].curPopup = popup;
            });
           

        } else if([type isEqualToString:@"CHAT"]) {
            NSString* jsonString = [SWWebManager sharedManager].launchInfo[@"message"];
            NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* message = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            SWChatMessage* obj = [SWChatMessage new];
            obj.senderUserId = message[@"senderUserId"];
            obj.regId = message[@"regId"];
            obj.firstName = message[@"firstName"];
            obj.lastName = message[@"lastName"];
            obj.message = message[@"message"];
            obj.sentTime = message[@"sentTime"];
            obj.messageId = message[@"messageId"];
            obj.isNew = @(YES);
            obj.isIncome = @(YES);
            
            [[SWDataManager sharedManager]updateChatItem:obj];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateListChat" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateChat" object:obj];
                [[SWDataManager sharedManager]updateBage:YES];
            });

        } else {
            __block NSString* bookingState = [SWWebManager sharedManager].launchInfo[@"bookingState"];
      
            SWLogin *object = [self objectDataForKey:userLoginInfo];
            if(object != nil){
                NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&bookingId=%ld",((NSNumber*)object.userId).integerValue,object.sessionToken,((NSNumber*)[SWWebManager sharedManager].launchInfo[@"bookingId"]).integerValue];
                [[SWWebManager sharedManager]requestedBooking:param withBookingID:[SWWebManager sharedManager].launchInfo[@"bookingId"] success:^(SWBookInfo *obj) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if([bookingState isEqualToString:@"COMPLETED"]){
                            SWRatePopup *popup = [[[NSBundle mainBundle] loadNibNamed:@"SWRatePopup" owner:self options:nil] firstObject];
                            [SWWebManager sharedManager].curBookInfo = obj;
                            popup.content = obj;
                            [popup setFrame:[UIScreen mainScreen].bounds];
                            [app.window addSubview:popup];
                            [SWWebManager sharedManager].curPopup = popup;
                        } else {
                            SWTourPopup *popup = [[[NSBundle mainBundle] loadNibNamed:@"SWTourPopup" owner:self options:nil] firstObject];
                            [SWWebManager sharedManager].curBookInfo = obj;
                            popup.content = obj;
                            [popup setFrame:[UIScreen mainScreen].bounds];
                            [app.window addSubview:popup];
                            [SWWebManager sharedManager].curPopup = popup;
                        }
                    });
                }];
            }
        }
        [SWWebManager sharedManager].launchInfo = nil;
        [SWWebManager sharedManager].curPopup = nil;
       /* UIAlertController* alert= [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",[SWWebManager sharedManager].launchInfo ] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionOK];
        [self presentViewController:alert animated:YES completion:nil];*/
    } else {
        SWLogin *object = [self objectDataForKey:userLoginInfo];
        if(object != nil){
            NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken];
            [[SWWebManager sharedManager]getUnratedTours:param success:^(NSArray<SWTour *> *obj) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"%@",obj);
                    if(obj.count > 0){
                        SWRatePopup *popup = [[[NSBundle mainBundle] loadNibNamed:@"SWRatePopup" owner:self options:nil] firstObject];
                        [SWWebManager sharedManager].curBookInfo = (SWBookInfo*)[obj firstObject];
                        popup.content = (SWBookInfo*)[obj firstObject];
                        [popup setFrame:[UIScreen mainScreen].bounds];
                        TheApp;
                        [app.window addSubview:popup];
                        [SWWebManager sharedManager].curPopup = popup;
                    }
                });
            }];
            
            [[SWDataManager sharedManager]updateBage:YES];
        }
        
    }
}
#pragma mark -  NSNotification

- (void)updatePlacesAfterLocation:(NSNotification*)notify{
   // NSLog(@"%@",[self objectForKey:address]);
    //[self simpleTitle:[self objectForKey:address]];
}

#pragma mark -  Action methods
- (void)btnMapPressed{
    UINavigationController* controller = [self checkPresentForClassDescriptor:@"MapNavController"];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMapAnnotation" object:_nearView.anotations];
    });*/
}
- (void)btnFilterPressed{
    [_nearView showFilter];
}

#pragma mark -  SWNearMeView delegate methods

- (void)titleChanged:(SWNearMeView*)obj withTitle:(NSString*)title{
    curtitle = title;
    [self simpleTitle:title];
}
- (void)segmentChanged:(SWNearMeView*)obj withState:(NSInteger)state{
    isSegment = state;
    if(state){
        [self setupNavBtn:FILTERTYPE];
    } else {
        [self setupNavBtn:BASETYPE];
    }
}
@end
