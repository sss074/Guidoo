//
//  SWTourView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 06.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWTourView.h"


@interface SWTourView ()

@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;
@property (nonatomic, strong) IBOutlet UIScrollView* scrollImgView;
@property (nonatomic, strong) IBOutlet UIPageControl* pageControll;
@property (nonatomic, strong) IBOutlet UILabel* descriptions;
@property (nonatomic, strong) IBOutlet UILabel* additionalExpensesAmount;
@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UILabel* language;
@property (nonatomic, strong) IBOutlet UILabel* city;
@property (nonatomic, strong) IBOutlet UILabel* group;
@property (nonatomic, strong) IBOutlet UILabel* date;
@property (nonatomic, strong) IBOutlet UILabel* time;
@property (nonatomic, strong) IBOutlet UIButton* bookBut;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *stars;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* buttonY;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* hideConstarint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* scrollConstarint;
@property (nonatomic, strong) IBOutlet UIView* dateView;
@property (nonatomic, strong) IBOutlet UIView* timeView;

@end

@implementation SWTourView

- (void)setContent:(SWTour*) content{
    _content = content;
    
    if(_content != nil){

        
        _name.text = [self isParamValid:_content.name] ? _content.name : nil;
        _descriptions.text = [self isParamValid:_content.descriptions] ? _content.descriptions : nil;
        NSInteger star = ((NSNumber*)_content.rating).integerValue;
        for(UIImageView* obj in _stars){
            [obj setImage:[UIImage imageNamed:@"star_normal"]];
        }
        for(int i = 0; i < star; i++){
            UIImageView* obj = _stars[i];
            [obj setImage:[UIImage imageNamed:@"star_act"]];
        }
        _city.text = [self isParamValid:_content.city] ? _content.city : nil;
        _group.text = [self isParamValid:_content.tourGroupSizeId] ?[self groupFromID:_content.tourGroupSizeId] : nil;
        _language.text = @"Parameter is missing";
        if( [self isParamValid:_content.languageIds]){
            NSMutableString* lg = [[NSMutableString alloc] init];
            for(int i = 0; i < _content.languageIds.count; i++){
                [lg appendString:[NSString stringWithFormat:@",%@",[self languageFromID:_content.languageIds[i]]]];
            }
            if(lg.length > 0)
                _language.text = [lg substringWithRange:NSMakeRange(1, lg.length - 1)];
        }
        _additionalExpensesAmount.text = [self isParamValid:_content.pricePerHour] ? [NSString stringWithFormat:@"$ %ld per tour",(NSInteger)(((NSNumber*)_content.pricePerHour).integerValue * ((NSNumber*)_content.durationHours).floatValue)] : nil;
        
        if(_content.imageIds.count > 0){
            CGFloat posX = 0;

            for(int i = 0; i < _content.imageIds.count; i++){
                UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(posX, CGRectGetMinY(_scrollImgView.frame), CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(_scrollImgView.frame))];
              
                NSLog(@"%@",[NSString stringWithFormat:@"%@%ld/tour/%ld/image/%ld",kImageBaseApiUrl,((NSNumber*)_content.guideId).integerValue,((NSNumber*)_content.tourId).integerValue,((NSNumber*)_content.imageIds[0]).integerValue]);
                NSURL *thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld/tour/%ld/image/%ld",kImageBaseApiUrl,((NSNumber*)_content.guideId).integerValue,((NSNumber*)_content.tourId).integerValue,((NSNumber*)_content.imageIds[i]).integerValue]];
                
                [imgView sd_setImageWithURL:thumbnailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image != nil){
                        [imgView setImage:image];
                    } else {
                        UIImage* image = [UIImage imageNamed:@"tour_bg"];
                        [imgView setImage:image];
                    }
                }];

                [_scrollImgView addSubview:imgView];
                posX += CGRectGetWidth([UIScreen mainScreen].bounds);
            }
            [_scrollImgView setContentSize:CGSizeMake(posX, CGRectGetHeight(_scrollImgView.frame))];
            [_pageControll setHidden:!(_content.imageIds.count > 1)];
            _pageControll.numberOfPages = _content.imageIds.count;
        } else {
            UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(_scrollImgView.frame), CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(_scrollImgView.frame))];
            UIImage* image = [UIImage imageNamed:@"tour_bg"];
            [imgView setImage:image];
             [_scrollImgView addSubview:imgView];
            [_scrollImgView setContentSize:CGSizeMake(0, CGRectGetHeight(_scrollImgView.frame))];
            [_pageControll setHidden:YES];
        }
        
        /*if(_content.meetingPointLatitude != nil && _content.meetingPointLongitude != nil){
         NSDictionary* location = @{@"latitude":_content.meetingPointLatitude,
         @"longitude":_content.meetingPointLongitude
         };
         NSArray* annotation = [NSArray arrayWithObject:location];
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
         [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMapAnnotation" object:annotation];
         });
         }*/
        
        if([self isParamValid:_content.bookingState]){
            [_bookBut setHidden:NO];
            if([_content.bookingState isEqualToString:@"PAID"] || [_content.bookingState isEqualToString:@"CANCELED"] || [_content.bookingState isEqualToString:@"COMPLETED"] || [_content.bookingState isEqualToString:@"STARTING"] || [_content.bookingState isEqualToString:@"PENDING"]){
                [_bookBut setHidden:YES];
                _buttonY.constant = 20.f;
                _scrollConstarint.constant -= 30.f;
            } else {
                [_bookBut setTitle:@"Payment tour" forState:UIControlStateNormal];
                [_bookBut setTitle:@"Payment tour" forState:UIControlStateHighlighted];
                SWLogin *object = [self objectDataForKey:userLoginInfo];
                if(object != nil){
                    if([self isParamValid:object.activeBookingId]){
                        [_bookBut setHidden:YES];
                        _buttonY.constant = 20.f;
                        _scrollConstarint.constant -= 30.f;
                    }
                }
            }
            if([self isParamValid:_content.startTime]){
                NSTimeInterval seconds = [_content.startTime longLongValue] / 1000;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
                NSLog(@"%@", date);
                _date.text = [NSDateFormatter localizedStringFromDate:date
                                                                 dateStyle:NSDateFormatterMediumStyle
                                                                 timeStyle:NSDateFormatterNoStyle];
                _time.text = [NSDateFormatter localizedStringFromDate:date
                                                            dateStyle:NSDateFormatterNoStyle
                                                            timeStyle:NSDateFormatterShortStyle];

                if([[NSCalendar currentCalendar] compareDate:date toDate:[NSDate date] toUnitGranularity:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay] == NSOrderedAscending){
                    [_bookBut setHidden:YES];
                    _buttonY.constant = 20.f;
                    _scrollConstarint.constant -= 30.f;
                }
            }
        } else {
            [_dateView setHidden:YES];
            [_timeView setHidden:YES];
            _hideConstarint.constant = 30.f;
            _scrollConstarint.constant -= 140.f;
            
            SWLogin *object = [self objectDataForKey:userLoginInfo];
            if(object != nil){
                if([self isParamValid:object.activeBookingId]){
                    [_bookBut setHidden:YES];
                    _buttonY.constant = 20.f;
                    _scrollConstarint.constant -= 30.f;
                }
            }
        }
        
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    
    //UIImage* image = [UIImage imageNamed:@"tour_bg"];
    //[self resizeImage:image withContainer:_imgView];
    
}
#pragma mark - ScrollView delegate methods

-(void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    CGFloat pageWidth = _scrollImgView.frame.size.width;
    int page = floor((_scrollImgView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [_pageControll setCurrentPage:page];
}
#pragma mark - Action methods

- (IBAction)clicked:(id)sender{
    
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_bookBut]){
        if([self isParamValid:_content.bookingState]){
            [SWWebManager sharedManager].isHistory = YES;
            [SWWebManager sharedManager].curBookInfo = [SWBookInfo new];
            [SWWebManager sharedManager].curBookInfo.bookingId = _content.bookingId;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController* controller = [storyboard instantiateViewControllerWithIdentifier:@"PaymentNavController"];
            SWTabbarController* tabBarController =(SWTabbarController*)self.window.rootViewController;
            UINavigationController* nav = (UINavigationController*)[tabBarController selectedViewController];
            nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [nav presentViewController: controller animated: YES completion:nil];
            
        } else {
            [SWWebManager sharedManager].isHistory = NO;
            SWLogin *objLogin = [self objectDataForKey:userLoginInfo];
            if(objLogin != nil){
                NSString* param = [NSString stringWithFormat:@"tourId=%ld&userId=%ld&sessionToken=%@",((NSNumber*)_content.tourId).integerValue,((NSNumber*)objLogin.userId).integerValue,objLogin.sessionToken];
                [[SWWebManager sharedManager]bookTour:param withTourID:_content.tourId success:^{
                    [self showAlertMessage:[NSString stringWithFormat:@"%@ successfully ordered",_content.name]];
                }];
            }
        }
    }
}

@end
