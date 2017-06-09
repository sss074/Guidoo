//
//  SWBookInfoView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 05.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBookInfoView.h"
#import "SWMapView.h"

@interface SWBookInfoView()

@property (nonatomic, strong) IBOutlet SWMapView* mapView;
@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;
@property (nonatomic, strong) IBOutlet UIImageView* logoView;
@property (nonatomic, strong) IBOutlet UILabel* descriptions;
@property (nonatomic, strong) IBOutlet UILabel* additionalExpensesAmount;
@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UILabel* language;
@property (nonatomic, strong) IBOutlet UILabel* group;
@property (nonatomic, strong) IBOutlet UILabel* date;
@property (nonatomic, strong) IBOutlet UILabel* time;
@property (nonatomic, strong) IBOutlet UIButton* chatBut;
@property (nonatomic, strong) IBOutlet UIButton* cancelBut;
@property (nonatomic, strong) IBOutlet UIView* dateView;
@property (nonatomic, strong) IBOutlet UIView* timeView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* hideConstarint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* scrollConstarint;
@end

@implementation SWBookInfoView



- (void)awakeFromNib{
    [super awakeFromNib];
    
    [_logoView setCornerRadius:CGRectGetHeight(_logoView.frame) / 2];
    [_logoView setClipsToBounds:YES];
    
    if([SWWebManager sharedManager].curBookInfo != nil){
        
        
        _name.text = [self isParamValid:[SWWebManager sharedManager].curBookInfo.tour.name] ? [SWWebManager sharedManager].curBookInfo.tour.name : nil;
        _descriptions.text = [self isParamValid:[SWWebManager sharedManager].curBookInfo.tour.descriptions] ? [SWWebManager sharedManager].curBookInfo.tour.descriptions : nil;
        _group.text = [self isParamValid:[SWWebManager sharedManager].curBookInfo.tour.tourGroupSizeId] ?[self groupFromID:[SWWebManager sharedManager].curBookInfo.tour.tourGroupSizeId] : nil;
        _date.text = @"Parameter is missing";
        _time.text = @"Parameter is missing";
        _language.text = @"Parameter is missing";
        if( [self isParamValid:[SWWebManager sharedManager].curBookInfo.tour.languageIds]){
            NSMutableString* lg = [[NSMutableString alloc] init];
            for(int i = 0; i < [SWWebManager sharedManager].curBookInfo.tour.languageIds.count; i++){
                [lg appendString:[NSString stringWithFormat:@",%@",[self languageFromID:[SWWebManager sharedManager].curBookInfo.tour.languageIds[i]]]];
            }
            if(lg.length > 0)
                _language.text = [lg substringWithRange:NSMakeRange(1, lg.length - 1)];
        }
        _additionalExpensesAmount.text = [self isParamValid:[SWWebManager sharedManager].curBookInfo.guide.pricePerHour] ? [NSString stringWithFormat:@"$ %ld per tour",(NSInteger)(((NSNumber*)[SWWebManager sharedManager].curBookInfo.guide.pricePerHour).integerValue *((NSNumber*)[SWWebManager sharedManager].curBookInfo.tour.durationHours).floatValue)] : nil;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:((NSNumber*)[SWWebManager sharedManager].curBookInfo.startTime).longValue];
        NSLog(@"%@",date);
        
        if([SWWebManager sharedManager].curBookInfo.guide.regId != nil){
            NSLog(@"%@",[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)[SWWebManager sharedManager].curBookInfo.guide.regId).integerValue,kImageFBNextBaseApiUrl]);
            NSURL *thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)[SWWebManager sharedManager].curBookInfo.guide.regId).integerValue,kImageFBNextBaseApiUrl]];
            [_logoView sd_setImageWithURL:thumbnailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image != nil){
                    [_logoView setImage:image];
                }
            }];
        }
        
        if([self isParamValid:[SWWebManager sharedManager].curBookInfo.bookingType]){
            if([[SWWebManager sharedManager].curBookInfo.bookingType isEqualToString:@"ON_DEMAND"]){
                [_dateView setHidden:YES];
                [_timeView setHidden:YES];
                _hideConstarint.constant = 30.f;
                _scrollConstarint.constant -= 120.f;
            }
        }
        
        if([self isParamValid:[SWWebManager sharedManager].curBookInfo.tour.meetingPointLatitude] && [self isParamValid:[SWWebManager sharedManager].curBookInfo.tour.meetingPointLongitude]){
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(((NSNumber*)[SWWebManager sharedManager].curBookInfo.tour.meetingPointLatitude).floatValue, ((NSNumber*)[SWWebManager sharedManager].curBookInfo.tour.meetingPointLongitude).floatValue);
            _mapView.coord = coord;
            [_mapView updateMap];
         }
     
    }

}


#pragma mark - Action methods
- (void)checkTour{
    if([_delegate respondsToSelector:@selector(updateNavigation:withState:)]){
        [_delegate updateNavigation:self withState:[self checkTour:[SWWebManager sharedManager].curBookInfo.tour.tourId]];
    }

}
- (IBAction)clicked:(id)sender{
    
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_cancelBut]){
        SWLogin *objLogin = [self objectDataForKey:userLoginInfo];
        if(objLogin != nil){
            NSString* param = [NSString stringWithFormat:@"bookingId=%ld&userId=%ld&sessionToken=%@",((NSNumber*)[SWWebManager sharedManager].curBookInfo.bookingId).integerValue,((NSNumber*)objLogin.userId).integerValue,objLogin.sessionToken];
            [self showIndecator:YES];
            [[SWWebManager sharedManager]cancelTour:param success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([_delegate respondsToSelector:@selector(backPress:)]){
                        [_delegate backPress:self];
                    }
                });
            }];
        }
    } else if([button isEqual:_chatBut]){
        SWChatMessage* message = [SWChatMessage new];
        message.senderUserId = [SWWebManager sharedManager].curBookInfo.guide.guideId;
        message.firstName = [SWWebManager sharedManager].curBookInfo.guide.firstName;
        message.lastName = [SWWebManager sharedManager].curBookInfo.guide.lastName;
        message.regId = [SWWebManager sharedManager].curBookInfo.guide.regId;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showChat" object:message];
    }
}

@end
