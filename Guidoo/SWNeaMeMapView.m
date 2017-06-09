//
//  SWNeaMeMapView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 30.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWNeaMeMapView.h"
#import "SWMapView.h"
#import "SWMapInfoView.h"
#import "SWPreferences.h"


@interface SWNeaMeMapView () <SWMapViewDelegate>{
    BOOL isFilter;
    BOOL isComplete;
    NSDictionary* filterContent;
    NSArray* guides;
    NSArray* guideViews;
}

@property (nonatomic, weak) IBOutlet SWMapView* mapView;
@property (nonatomic,strong)IBOutlet UIView* filterView;
@property (nonatomic,strong)IBOutlet UIScrollView* scrollInfoView;
@property (nonatomic,strong)IBOutlet UITextField* locField;
@property (nonatomic,strong)IBOutlet UITextField* intField;
@property (nonatomic,strong)IBOutlet UIButton* doneBut;
@property (nonatomic,strong)IBOutlet UIButton* clearBut;
@property (nonatomic,strong)IBOutlet NSLayoutConstraint* showConstaraint;

@end

@implementation SWNeaMeMapView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    filterContent  = nil;
  
    _mapView.mapDelegate = self;
    
    _showConstaraint.constant -= CGRectGetHeight(_filterView.frame);
    isFilter = NO;
    isComplete = YES;
    CGRect frame = _filterView.frame;
    frame.origin.y -= (CGRectGetHeight(frame) + frame.origin.y);
    [_filterView setFrame:frame];
    
    
    
    UIView *vwContainer = [[UIView alloc] init];
    [vwContainer setFrame:CGRectMake(0.0f, 0.0f, 30.0f, CGRectGetHeight(_locField.frame))];
    [vwContainer setBackgroundColor:[UIColor clearColor]];
    
    UIImage* image = [UIImage imageNamed:@"pointer2"];
    UIImageView *icon = [[UIImageView alloc] init];
    [icon setImage:image];
    [icon setFrame:CGRectMake(15.f - image.size.width / 2, CGRectGetHeight(_locField.frame) / 2 - image.size.height / 2, image.size.width, image.size.height)];
    [icon setBackgroundColor:[UIColor clearColor]];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [vwContainer addSubview:icon];
    
    [_locField setLeftView:vwContainer];
    [_locField setLeftViewMode:UITextFieldViewModeAlways];
    //[_locField setText:[self objectForKey:@"address"]];
    
    vwContainer = [[UIView alloc] init];
    [vwContainer setFrame:CGRectMake(0.0f, 0.0f, 30.0f, CGRectGetHeight(_intField.frame))];
    [vwContainer setBackgroundColor:[UIColor clearColor]];
    
    image = [UIImage imageNamed:@"eye"];
    icon = [[UIImageView alloc] init];
    [icon setImage:image];
    [icon setFrame:CGRectMake(15.f - image.size.width / 2, CGRectGetHeight(_intField.frame) / 2 - image.size.height / 2, image.size.width, image.size.height)];
    [icon setBackgroundColor:[UIColor clearColor]];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [vwContainer addSubview:icon];
    
    
    [_intField setLeftView:vwContainer];
    [_intField setLeftViewMode:UITextFieldViewModeAlways];
 
    if ([_locField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        _locField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Location" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:152.f / 255.f green:152.f / 255.f blue:152.f / 255.f alpha:1.f], NSFontAttributeName:[UIFont fontWithName:OPENSANS size:14.f]}];
    }
    if ([_intField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        _intField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Interest" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:152.f / 255.f green:152.f / 255.f blue:152.f / 255.f alpha:1.f], NSFontAttributeName:[UIFont fontWithName:OPENSANS size:14.f]}];
    }
  
}

- (void)getGuids{
    
    SWLogin *objLogin = [self objectDataForKey:userLoginInfo];
    if(objLogin != nil){
        NSString* param = nil;
        if(filterContent == nil){
            SWPreferences *objPref = [self objectDataForKey:userPreferences];
            if(objPref != nil){
                NSDictionary* locInfo = [self objectForKey:locationInfo];
                if(locInfo == nil){
                    locInfo = [self replaceValueForKey:locInfo withKey:@"latitude" withValue:[NSNumber numberWithFloat:0]];
                    locInfo = [self replaceValueForKey:locInfo withKey:@"longitude" withValue:[NSNumber numberWithFloat:0]];
                    [self setObjectForKey:locInfo forKey:locationInfo];
                }
                param = [NSString stringWithFormat:@"userId=%ld&distanceMeters=%ld&latitude=%f&longitude=%f&sessionToken=%@",((NSNumber*)objLogin.userId).integerValue,(long)((NSNumber*)objPref.maxDistance).integerValue,((NSNumber*)locInfo[@"latitude"]).floatValue,((NSNumber*)locInfo[@"longitude"]).floatValue,objLogin.sessionToken];
            }
        } else {
            param = [NSString stringWithFormat:@"userId=%ld&distanceMeters=%ld&latitude=%f&longitude=%f&sessionToken=%@",((NSNumber*)objLogin.userId).integerValue,((NSNumber*)filterContent[@"radius"]).integerValue,((NSNumber*)filterContent[@"latitude"]).floatValue,((NSNumber*)filterContent[@"longitude"]).floatValue,objLogin.sessionToken];
        }
       
        
        [[SWWebManager sharedManager]getNearbyGuides:param success:^(NSArray<SWGuide *> *obj) {
            NSLog(@"%@",obj);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for(int i = 0; i < guideViews.count; i++){
                    SWMapInfoView* view  = guideViews[i];
                    [view removeFromSuperview];
                }
                guideViews = nil;
                guides = nil;
                
                CGFloat posX = 10.f;
                NSMutableArray* tempViews = [NSMutableArray new];
                NSMutableArray* temp = [NSMutableArray new];
                NSMutableArray* results = [[NSMutableArray alloc]initWithCapacity:obj.count];
                SWGuide* guide = nil;
                for(int i = 0; i < obj.count; i++){
                    guide = obj[i];
                    [temp addObject:guide];
                    [results addObject:@{@"latitude":guide.latitude,
                                         @"longitude":guide.longitude,
                                         @"title":[NSString stringWithFormat:@"%@ %@",guide.firstName,guide.lastName]                                         }];
                    SWMapInfoView* view  = [[[NSBundle mainBundle] loadNibNamed:@"SWMapInfoView" owner:self options:nil] objectAtIndex:0];
                    [view setFrame:CGRectMake(posX, CGRectGetMinY(view.frame), CGRectGetWidth([UIScreen mainScreen].bounds) - 100.f, CGRectGetHeight(view.frame))];
                    view.content = guide;
                    [_scrollInfoView addSubview:view];
                    [tempViews addObject:view];
                    posX += (CGRectGetWidth([UIScreen mainScreen].bounds) - 90.f);
                }
                
                
                
               /* SWMapInfoView* view  = [[[NSBundle mainBundle] loadNibNamed:@"SWMapInfoView" owner:self options:nil] objectAtIndex:0];
                [view setFrame:CGRectMake(posX, CGRectGetMinY(view.frame), CGRectGetWidth([UIScreen mainScreen].bounds) - 100.f, CGRectGetHeight(view.frame))];
                SWGuide* guideAdd = [SWGuide new];
                guideAdd.distanceMeters = guide.distanceMeters;
                guideAdd.firstName = guide.firstName;
                guideAdd.guideId = guide.guideId;
                guideAdd.lastName = guide.lastName;
                guideAdd.pricePerHour = guide.pricePerHour;
                guideAdd.rating = guide.rating;
                guideAdd.regId = guide.regId;
                guideAdd.resume = guide.resume;
                guideAdd.tours = guide.tours;
                guideAdd.latitude = @(46.578431);
                guideAdd.longitude = @(30.794277);
                [results addObject:@{@"latitude":guideAdd.latitude,
                                     @"longitude":guideAdd.longitude,
                                     @"title":[NSString stringWithFormat:@"%@ %@",guide.firstName,guide.lastName]
                                     }];
                [temp addObject:guideAdd];
                view.content = guide;
                [_scrollInfoView addSubview:view];
                [tempViews addObject:view];
                posX += (CGRectGetWidth([UIScreen mainScreen].bounds) - 90.f);
  
                
                view  = [[[NSBundle mainBundle] loadNibNamed:@"SWMapInfoView" owner:self options:nil] objectAtIndex:0];
                [view setFrame:CGRectMake(posX, CGRectGetMinY(view.frame), CGRectGetWidth([UIScreen mainScreen].bounds) - 100.f, CGRectGetHeight(view.frame))];
                guideAdd = [SWGuide new];
                guideAdd.distanceMeters = guide.distanceMeters;
                guideAdd.firstName = guide.firstName;
                guideAdd.guideId = guide.guideId;
                guideAdd.lastName = guide.lastName;
                guideAdd.pricePerHour = guide.pricePerHour;
                guideAdd.rating = guide.rating;
                guideAdd.regId = guide.regId;
                guideAdd.resume = guide.resume;
                guideAdd.tours = guide.tours;
                guideAdd.latitude = @(46.583663);
                guideAdd.longitude = @(30.782870);
                [temp addObject:guideAdd];
                [results addObject:@{@"latitude":guideAdd.latitude,
                                     @"longitude":guideAdd.longitude,
                                     @"title":[NSString stringWithFormat:@"%@ %@",guide.firstName,guide.lastName]
                                     }];
                view.content = guide;
                [_scrollInfoView addSubview:view];
                [tempViews addObject:view];
                posX += (CGRectGetWidth([UIScreen mainScreen].bounds) - 90.f);
                
                view  = [[[NSBundle mainBundle] loadNibNamed:@"SWMapInfoView" owner:self options:nil] objectAtIndex:0];
                [view setFrame:CGRectMake(posX, CGRectGetMinY(view.frame), CGRectGetWidth([UIScreen mainScreen].bounds) - 100.f, CGRectGetHeight(view.frame))];
                guideAdd = [SWGuide new];
                guideAdd.distanceMeters = guide.distanceMeters;
                guideAdd.firstName = guide.firstName;
                guideAdd.guideId = guide.guideId;
                guideAdd.lastName = guide.lastName;
                guideAdd.pricePerHour = guide.pricePerHour;
                guideAdd.rating = guide.rating;
                guideAdd.regId = guide.regId;
                guideAdd.resume = guide.resume;
                guideAdd.tours = guide.tours;
                guideAdd.latitude = @(46.586359);
                guideAdd.longitude = @(30.781376);
                [temp addObject:guideAdd];
                [results addObject:@{@"latitude":guideAdd.latitude,
                                     @"longitude":guideAdd.longitude,
                                     @"title":[NSString stringWithFormat:@"%@ %@",guide.firstName,guide.lastName]
                                     }];
                view.content = guide;
                [_scrollInfoView addSubview:view];
                [tempViews addObject:view];
                posX += (CGRectGetWidth([UIScreen mainScreen].bounds) - 90.f);
                
                view  = [[[NSBundle mainBundle] loadNibNamed:@"SWMapInfoView" owner:self options:nil] objectAtIndex:0];
                [view setFrame:CGRectMake(posX, CGRectGetMinY(view.frame), CGRectGetWidth([UIScreen mainScreen].bounds) - 100.f, CGRectGetHeight(view.frame))];
                guideAdd = [SWGuide new];
                guideAdd.distanceMeters = guide.distanceMeters;
                guideAdd.firstName = guide.firstName;
                guideAdd.guideId = guide.guideId;
                guideAdd.lastName = guide.lastName;
                guideAdd.pricePerHour = guide.pricePerHour;
                guideAdd.rating = guide.rating;
                guideAdd.regId = guide.regId;
                guideAdd.resume = guide.resume;
                guideAdd.tours = guide.tours;
                guideAdd.latitude = @(46.574838);
                guideAdd.longitude = @(30.804146);
                [results addObject:@{@"latitude":guideAdd.latitude,
                                     @"longitude":guideAdd.longitude,
                                     @"title":[NSString stringWithFormat:@"%@ %@",guide.firstName,guide.lastName]
                                     }];
                [temp addObject:guideAdd];
                view.content = guide;
                [_scrollInfoView addSubview:view];
                [tempViews addObject:view];
                posX += (CGRectGetWidth([UIScreen mainScreen].bounds) - 90.f);*/
               
                [_scrollInfoView setContentSize:CGSizeMake(posX, CGRectGetHeight(_scrollInfoView.frame))];
                guides = [NSArray arrayWithArray:temp];
                guideViews = [NSArray arrayWithArray:tempViews];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMapAnnotation" object:[NSArray arrayWithArray:results]];
            });
        }];
        _locField.text = _intField.text = nil;
        filterContent = nil;
    }
    
}

#pragma  mark - Action methods
- (void)showFilter{
    
    if(!isComplete)
        return;
    
    isComplete = NO;
    
    if(!isFilter){
        [UIView animateWithDuration:0.5
                              delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             [_filterView setFrame:CGRectMake(CGRectGetMinX(_filterView.frame), CGRectGetMinY(_filterView.frame) + CGRectGetHeight(_filterView.frame), CGRectGetWidth(_filterView.frame), CGRectGetHeight(_filterView.frame))];
                         }
                         completion:^(BOOL finished) {
                            _showConstaraint.constant = 0.f;
                             isFilter = YES;
                             isComplete = YES;
                             
                         }];
    } else {
        [UIView animateWithDuration:0.5
                              delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             [_filterView setFrame:CGRectMake(CGRectGetMinX(_filterView.frame), CGRectGetMinY(_filterView.frame) - CGRectGetHeight(_filterView.frame), CGRectGetWidth(_filterView.frame), CGRectGetHeight(_filterView.frame))];
                             
                         }
                         completion:^(BOOL finished) {
                             _locField.text = _intField.text = nil;
                             [_locField resignFirstResponder];
                             [_intField resignFirstResponder];
                             _showConstaraint.constant -= CGRectGetHeight(_filterView.frame);
                             isFilter = NO;
                             isComplete = YES;
                         }];
    }
    
    
}
- (IBAction)clicked:(id)sender{
    
    
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_doneBut]){
        [self showFilter];
        if(_locField.text == nil || [_locField.text isEqualToString:@""])
            return;
        [self  getLocationFromAddress:_locField.text success:^(CLLocation *obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                filterContent = nil;
                
                if(obj != nil){
                    filterContent = @{@"latitude":@(obj.coordinate.latitude),
                                      @"longitude":@(obj.coordinate.longitude),
                                      @"radius":@(50000)};
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showIndecator:YES];
                    [self getGuids];
                });
            });
        }];
        
        
    } else if([button isEqual:_clearBut]){
        _locField.text = _intField.text = nil;
        filterContent = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showIndecator:YES];
            [self getGuids];
        });
    }
}

#pragma mark - UITextField Delegate methods

- (BOOL)textField:(UITextField *) __textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSArray *currents = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currents firstObject];
    if ([[current primaryLanguage] isEqualToString:@"emoji"] ) {
        return NO;
    }
    
    BOOL returnKey = YES;
    NSCharacterSet *nameCharSet = [NSCharacterSet characterSetWithCharactersInString:charSet];
    
    
    for (int i = 0; i < [string length]; i++){
        unichar c = [string characterAtIndex:i];
        if ([nameCharSet characterIsMember:c]){
            return NO;
        }
    }
    
    NSUInteger oldLength = [__textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    
    returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    return newLength <= 50 || returnKey;
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)__textField{
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)_textField{
    
    [_textField resignFirstResponder];
    
    return  YES;
}

#pragma mark -  SWMapViewDelegate methods
- (void)showInfo:(SWMapView*)param withCoord:(CLLocationCoordinate2D) coord{
 
    CGFloat curlatitude = coord.latitude;
    CGFloat curlongitude = coord.longitude;
    NSLog(@"curlatitude:%f",curlatitude);
    NSLog(@"curlongitude:%f",curlongitude);
    for(int i = 0; i < guides.count; i++){
        SWGuide* obj = guides[i];
        NSNumber* latitude = obj.latitude;
        NSNumber* longitude = obj.longitude;
        NSLog(@"latitude:%f",latitude.floatValue);
        NSLog(@"longitude:%f",longitude.floatValue);
        if(latitude.floatValue == curlatitude && longitude.floatValue == curlongitude){
            [_scrollInfoView setContentOffset:CGPointMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 90.f) * i, 0) animated:YES];
            break;
        }
    }
}

@end
