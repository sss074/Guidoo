//
//  SWHistoryCell.m
//  Guidoo
//
//  Created by Sergiy Bekker on 17.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWHistoryCell.h"

@interface SWHistoryCell ()

@property (nonatomic, strong) IBOutlet UIImageView* imgTourView;
@property (nonatomic, strong) IBOutlet UIImageView* imgView;
@property (nonatomic, strong) IBOutlet UILabel* nameTour;
@property (nonatomic, strong) IBOutlet UILabel* nameGuid;
@property (nonatomic, strong) IBOutlet UILabel* professional;
@property (nonatomic, strong) IBOutlet UILabel* deatil;
@property (nonatomic, strong) IBOutlet UILabel* startTime;
@property (nonatomic, strong) IBOutlet UILabel* priceTour;
@property (nonatomic, strong) IBOutlet UIButton* moreBut;

@end

@implementation SWHistoryCell

- (void)setContent:(SWHistory*) content{
   
    _content = content;
    
    if(_content != nil){
        [_imgTourView setImage:nil];
        [_imgView setImage:nil];
        
        if(_content.guideRegId != nil){
            NSLog(@"%@",[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)_content.guideRegId).integerValue,kImageFBNextBaseApiUrl]);
            NSURL *thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)_content.guideRegId).integerValue,kImageFBNextBaseApiUrl]];
            [_imgView sd_setImageWithURL:thumbnailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image != nil){
                    [_imgView setImage:image];
                }
            }];
        }
        _nameGuid.text = [NSString stringWithFormat:@"%@ %@",_content.guideFirstName,_content.guideLastName];
        _nameTour.text = ([_content.tourName isEqualToString:@""] || _content.tourName == nil)  ? nil : _content.tourName;
        if([self isParamValid:_content.startTime]){
            NSTimeInterval seconds = [_content.startTime longLongValue] / 1000;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
            NSLog(@"%@", date);
            _startTime.text = [NSDateFormatter localizedStringFromDate:date
                                                                 dateStyle:NSDateFormatterMediumStyle
                                                                 timeStyle:NSDateFormatterNoStyle];
            NSLog(@"%@", _startTime.text);
        }
        
        SWLogin *object = [self objectDataForKey:userLoginInfo];
        if(object != nil && [SWWebManager sharedManager].curPopup == nil){
            NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&bookingId=%ld",((NSNumber*)object.userId).integerValue,object.sessionToken,((NSNumber*)_content.bookingId).integerValue];
            [[SWWebManager sharedManager]requestedBooking:param withBookingID:_content.bookingId success:^(SWBookInfo *obj) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(obj.tour.imageIds.count > 0){
                        NSLog(@"%@",[NSString stringWithFormat:@"%@%ld/tour/%ld/image/%ld",kImageBaseApiUrl,((NSNumber*)obj.guide.guideId).integerValue,((NSNumber*)obj.tour.tourId).integerValue,((NSNumber*)obj.tour.imageIds[0]).integerValue]);
                        NSURL *thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld/tour/%ld/image/%ld",kImageBaseApiUrl,((NSNumber*)obj.guide.guideId).integerValue,((NSNumber*)obj.tour.tourId).integerValue,((NSNumber*)obj.tour.imageIds[0]).integerValue]];
                        [_imgTourView sd_setImageWithURL:thumbnailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if(image != nil){
                                [_imgTourView setImage:image];
                            } else {
                                [_imgTourView setImage:[UIImage imageNamed:@"tour_bg"]];
                            }
                        }];
                    } else {
                       [_imgTourView setImage:[UIImage imageNamed:@"tour_bg"]];
                    }
                    _deatil.text = ([obj.tour.descriptions isEqualToString:@""] || obj.tour.descriptions == nil)  ? nil : obj.tour.descriptions;
                    if([self isParamValid:obj.guide.pricePerHour]){
                        _priceTour.text =  [NSString stringWithFormat:@"%ld $",(NSInteger)(((NSNumber*)obj.guide.pricePerHour).integerValue* ((NSNumber*)obj.tour.durationHours).floatValue)];
                    }
                    _content.tour = [SWTour new];
                    _content.tour.additionalExpenseIds = obj.tour.additionalExpenseIds;
                    _content.tour.additionalExpensesAmount = obj.tour.additionalExpensesAmount;
                    _content.tour.city = obj.tour.city;
                    _content.tour.countryId = obj.tour.countryId;
                    _content.tour.durationHours = obj.tour.durationHours;
                    _content.tour.descriptions = obj.tour.descriptions;
                    _content.tour.imageIds = obj.tour.imageIds;
                    _content.tour.name = obj.tour.name;
                    _content.tour.tourId = obj.tour.tourId;
                    _content.tour.importantInfo = obj.tour.importantInfo;
                    _content.tour.pois = obj.tour.pois;
                    _content.tour.meetingPointLatitude = obj.tour.meetingPointLatitude;
                    _content.tour.meetingPointLongitude = obj.tour.meetingPointLongitude;
                    _content.tour.meetingPointDescription = obj.tour.meetingPointDescription;
                    _content.tour.languageIds = obj.tour.languageIds;
                    _content.tour.rating = obj.tour.rating;
                    _content.tour.pricePerHour = obj.tour.pricePerHour;
                    _content.tour.guideId = obj.tour.guideId;
                    _content.tour.tourGroupSizeId = obj.tour.tourGroupSizeId;
                    _content.tour.bookingState = _content.bookingState;
                    _content.tour.startTime = _content.startTime;
                    _content.tour.pricePerHour = obj.guide.pricePerHour;
                    _content.tour.guideId = _content.guideId;
                    _content.tour.bookingId = _content.bookingId;
                });
            }];
        }
        [_moreBut setHidden:_isMore];
        _professional.text = @"Parameter is miss";
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [_imgView setCornerRadius:CGRectGetHeight(_imgView.frame) / 2];
    [_imgView setClipsToBounds:YES];
}
#pragma  mark - Action methods
- (IBAction)clicked:(id)sender{
    
    
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_moreBut]){
        if([_delegete respondsToSelector:@selector(morePress:)]){
            [_delegete morePress:self];
        }
    }
}
@end
