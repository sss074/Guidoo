//
//  SWActiveTourView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 19.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWActiveTourView.h"
#import "SWGuidDetailController.h"

@interface SWActiveTourView (){
    SWBookInfo* content;
}

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
@property (nonatomic, strong) IBOutlet UIButton* sosBut;
@property (nonatomic, strong) IBOutlet UIButton* infoBut;
@property (nonatomic, strong) IBOutlet UIView* dateView;
@property (nonatomic, strong) IBOutlet UIView* timeView;


@end

@implementation SWActiveTourView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]) {
        SWLogin *object = [self objectDataForKey:userLoginInfo];
        if(object != nil){
            NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&bookingId=%ld",((NSNumber*)object.userId).integerValue,object.sessionToken,((NSNumber*)object.activeBookingId).integerValue];
            [[SWWebManager sharedManager]requestedBooking:param withBookingID:object.activeBookingId success:^(SWBookInfo *obj) {
                content = obj;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(content != nil){
                        _name.text = [self isParamValid:content.tour.name] ? content.tour.name : nil;
                        _descriptions.text = [self isParamValid:content.tour.descriptions] ? content.tour.descriptions : nil;
                        _group.text = [self isParamValid:content.tour.tourGroupSizeId] ?[self groupFromID:content.tour.tourGroupSizeId] : nil;
                        
                        if( [self isParamValid:content.tour.languageIds]){
                            NSMutableString* lg = [[NSMutableString alloc] init];
                            for(int i = 0; i < content.tour.languageIds.count; i++){
                                [lg appendString:[NSString stringWithFormat:@",%@",[self languageFromID:content.tour.languageIds[i]]]];
                            }
                            if(lg.length > 0)
                                _language.text = [lg substringWithRange:NSMakeRange(1, lg.length - 1)];
                        }
                        _additionalExpensesAmount.text = [self isParamValid:content.guide.pricePerHour] ? [NSString stringWithFormat:@"$ %ld per tour",(NSInteger)(((NSNumber*)content.guide.pricePerHour).integerValue *((NSNumber*)content.tour.durationHours).floatValue)] : nil;
                        
                        
                        if(content.guide.regId != nil){
                            NSLog(@"%@",[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)content.guide.regId).integerValue,kImageFBNextBaseApiUrl]);
                            NSURL *thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)content.guide.regId).integerValue,kImageFBNextBaseApiUrl]];
                            [_logoView sd_setImageWithURL:thumbnailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                if(image != nil){
                                    [_logoView setImage:image];
                                }
                            }];
                        }
                        
                        if([self isParamValid:content.startTime]){
                            NSTimeInterval seconds = [content.startTime longLongValue] / 1000;
                            NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
                            NSLog(@"%@", date);
                            _date.text = [NSDateFormatter localizedStringFromDate:date
                                                                        dateStyle:NSDateFormatterMediumStyle
                                                                        timeStyle:NSDateFormatterNoStyle];
                            _time.text = [NSDateFormatter localizedStringFromDate:date
                                                                        dateStyle:NSDateFormatterNoStyle
                                                                        timeStyle:NSDateFormatterShortStyle];
                        }
                        [_scrollView setContentSize:CGSizeMake(0, 780.f)];
                    }
                });
                

            }];
        }

    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    
    [_logoView setCornerRadius:CGRectGetHeight(_logoView.frame) / 2];
    [_logoView setClipsToBounds:YES];
    
    
   
}
#pragma  mark - Action methods

- (IBAction)clicked:(id)sender{
    
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_chatBut]){
        SWChatMessage* message = [SWChatMessage new];
        message.senderUserId = content.guide.guideId;
        message.firstName = content.guide.firstName;
        message.lastName = content.guide.lastName;
        message.regId = content.guide.regId;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showChat" object:message];
    } else if([button isEqual:_sosBut]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:911"]];
    } else if([button isEqual:_infoBut]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SWGuidDetailController* controller = [storyboard instantiateViewControllerWithIdentifier:@"GuidDetailController"];
        NSMutableArray* results = [[NSMutableArray alloc]init];
        [results addObject:content.guide];
        [results addObject:content.tour];
        controller.content = [NSArray arrayWithArray:results];

        TheApp;
        SWTabbarController* tabBarController =(SWTabbarController*)app.window.rootViewController;
        UINavigationController* nav = (UINavigationController*)[tabBarController selectedViewController];
        controller.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:controller animated:YES];
    }
}

@end
