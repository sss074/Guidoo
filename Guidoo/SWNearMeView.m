//
//  SWNearMeView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 05.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWNearMeView.h"
#import "SWPreferences.h"
#import "SWGuideCell.h"
#import "SWTourCell.h"
#import "UIRefreshControl+UITableView.h"
#import "SWGuidDetailController.h"
#import "SWTourController.h"
#import "TRCustomDatePicker.h"

@interface SWNearMeView()<TRCustomDatePickerDelegate>{
    NSArray* content;
    NSArray* guidecontent;
    NSArray* tourcontent;
    UIRefreshControl *refreshControl;
    BOOL isFilter;
    BOOL isComplete;
    NSDictionary* filterContent;
    TRCustomDatePicker* datePicker;
    long long startTime;
}

@property (nonatomic,strong)IBOutlet UITableView* tableView;
@property (nonatomic,strong)IBOutlet UISegmentedControl* segmaent;
@property (nonatomic,strong)IBOutlet UIView* filterView;
@property (nonatomic,strong)IBOutlet UIView* filterInvView;
@property (nonatomic,strong)IBOutlet UITextField* locField;
@property (nonatomic,strong)IBOutlet UITextField* intField;
@property (nonatomic,strong)IBOutlet UITextField* locInvField;
@property (nonatomic,strong)IBOutlet UITextField* intInvField;
@property (nonatomic,strong)IBOutlet UIButton* doneInvBut;
@property (nonatomic,strong)IBOutlet UIButton* clearInvBut;
@property (nonatomic,strong)IBOutlet UIButton* dateBut;
@property (nonatomic,strong)IBOutlet UIButton* timeBut;
@property (nonatomic,strong)IBOutlet UIButton* doneBut;
@property (nonatomic,strong)IBOutlet UIButton* clearBut;
@property (nonatomic,strong)IBOutlet NSLayoutConstraint* showConstaraint;
@property (nonatomic,strong)IBOutlet NSLayoutConstraint* showInvConstaraint;
@property (nonatomic,strong)IBOutlet UILabel* emptyLabel;

@end

@implementation SWNearMeView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    filterContent  = nil;
    startTime = -1;
    
    [self setBackgroundColor:[UIColor colorWithRed:71.f/255.f green:168.f/255.f blue:23.f/255.f alpha:1.f]];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshContent) forControlEvents:UIControlEventValueChanged];
    [refreshControl addToTableView:_tableView];
    [_tableView setTableHeaderView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 5.f)]];

    [_segmaent setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                        NSFontAttributeName:[UIFont fontWithName:OPENSANSSEMIBOLD size:15.f]} forState:UIControlStateNormal];
    [_segmaent setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                        NSFontAttributeName:[UIFont fontWithName:OPENSANSSEMIBOLD size:15.f]} forState:UIControlStateSelected];
    [_segmaent setTintColor:[UIColor colorWithRed:56.f/255.f green:150.f/255.f blue:44.f/255.f alpha:1.f]];
    
    _showConstaraint.constant -= CGRectGetHeight(_filterView.frame);
    isFilter = NO;
    isComplete = YES;
    CGRect frame = _filterView.frame;
    frame.origin.y -= (CGRectGetHeight(frame) + frame.origin.y);
    [_filterView setFrame:frame];
    
    _showInvConstaraint.constant -= CGRectGetHeight(_filterInvView.frame);
    frame = _filterInvView.frame;
    frame.origin.y -= (CGRectGetHeight(frame) + frame.origin.y);
    [_filterInvView setFrame:frame];
    
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
    
    
    vwContainer = [[UIView alloc] init];
    [vwContainer setFrame:CGRectMake(0.0f, 0.0f, 30.0f, CGRectGetHeight(_locField.frame))];
    [vwContainer setBackgroundColor:[UIColor clearColor]];
    
    image = [UIImage imageNamed:@"pointer2"];
    icon = [[UIImageView alloc] init];
    [icon setImage:image];
    [icon setFrame:CGRectMake(15.f - image.size.width / 2, CGRectGetHeight(_locField.frame) / 2 - image.size.height / 2, image.size.width, image.size.height)];
    [icon setBackgroundColor:[UIColor clearColor]];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [vwContainer addSubview:icon];
    
    [_locInvField setLeftView:vwContainer];
    [_locInvField setLeftViewMode:UITextFieldViewModeAlways];
    //[_locInvField setText:[self objectForKey:@"address"]];
    
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
    
    [_intInvField setLeftView:vwContainer];
    [_intInvField setLeftViewMode:UITextFieldViewModeAlways];
    
    if ([_locField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        _locField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Location" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:152.f / 255.f green:152.f / 255.f blue:152.f / 255.f alpha:1.f], NSFontAttributeName:[UIFont fontWithName:OPENSANS size:14.f]}];
    }
    if ([_intField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        _intField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Interest" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:152.f / 255.f green:152.f / 255.f blue:152.f / 255.f alpha:1.f], NSFontAttributeName:[UIFont fontWithName:OPENSANS size:14.f]}];
    }
    if ([_locInvField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        _locInvField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Location" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:152.f / 255.f green:152.f / 255.f blue:152.f / 255.f alpha:1.f], NSFontAttributeName:[UIFont fontWithName:OPENSANS size:14.f]}];
    }
    if ([_intInvField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        _intInvField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Interest" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:152.f / 255.f green:152.f / 255.f blue:152.f / 255.f alpha:1.f], NSFontAttributeName:[UIFont fontWithName:OPENSANS size:14.f]}];
    }
    
    datePicker = [[TRCustomDatePicker alloc]initWithFrame:CGRectMake(0, 50, CGRectGetWidth([[UIScreen mainScreen] bounds]), 200.f)];
    datePicker.appearancePlace = TRPickerAppearancePlace_Bottom;
    datePicker.customDatePickerDelegate = self;
    
    [_emptyLabel setHidden:YES];
    
    [_dateBut setTitle:@"Date" forState:UIControlStateNormal];
    [_dateBut setTitle:@"Date" forState:UIControlStateHighlighted];
    [_timeBut setTitle:@"Time"forState:UIControlStateNormal];
    [_timeBut setTitle:@"Time"forState:UIControlStateHighlighted];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSession:) name:@"updateSession" object:nil];
    
    [self showIndecator:YES];
    [self getGuids];
   
}
- (void)dealloc{
    if(datePicker.isShow)
        [datePicker hide];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateSession" object:nil];
}

#pragma mark -  NSNotification
- (void)updateSession:(NSNotification*)notify{
    [refreshControl beginRefreshing];
    [self refreshContent];
}

#pragma  mark - Service methods
- (void)refreshContent{
    filterContent = nil;
    if(_segmaent.selectedSegmentIndex == 0){
        _locField.text = _intField.text = nil;
        [self getGuids];
    } else {
        [refreshControl endRefreshing];
       /* _locInvField.text = _intInvField.text = nil;
        startTime = -1;
        [_dateBut setTitle:@"Date" forState:UIControlStateNormal];
        [_dateBut setTitle:@"Date" forState:UIControlStateHighlighted];
        [_timeBut setTitle:@"Time"forState:UIControlStateNormal];
        [_timeBut setTitle:@"Time"forState:UIControlStateHighlighted];*/
    }
    
}
- (void)getGuids{
    SWLogin *objLogin = [self objectDataForKey:userLoginInfo];
    if(objLogin != nil){
        
        NSString* param = nil;
        
        if(filterContent == nil){
            
            if(_segmaent.selectedSegmentIndex == 0){
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
                [[SWWebManager sharedManager]getNearbyGuides:param success:^(NSArray<SWGuide *> *obj) {
                    NSLog(@"%@",obj);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableArray* results = [[NSMutableArray alloc]initWithCapacity:obj.count];
                        
                        for(int i = 0; i < obj.count; i++){
                            SWGuide* guide = obj[i];
                            NSArray* tours = [NSArray arrayWithArray:guide.tours];
                            for(int j = 0; j < tours.count; j++){
                                [results addObject:@{@"guide":guide,
                                                     @"tours":tours[j]}];
                                
                            }
                        }
                        
                        if(_segmaent.selectedSegmentIndex == 0) {
                            guidecontent = [NSArray arrayWithArray:obj];
                            content = [NSArray arrayWithArray:guidecontent];
                        } else {
                            tourcontent = [NSArray arrayWithArray:results];
                            content = filterContent == nil ? nil : [NSArray arrayWithArray:tourcontent];
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [refreshControl endRefreshing];
                        });
                        [_tableView reloadData];
                        
                        [results removeAllObjects];
                        
                        for(int i = 0; i < obj.count; i++){
                            SWGuide* guide = obj[i];
                            [results addObject:@{@"latitude":guide.latitude,
                                                 @"longitude":guide.longitude
                                                 }];
                        }
                        
                        
                        
                        self.anotations = [NSArray arrayWithArray:results];
                        
                        [_emptyLabel setHidden:(BOOL)content.count];
                        if(_segmaent.selectedSegmentIndex == 1){
                            //if(filterContent == nil){
                                _emptyLabel.text = @"Sorry no available tours at this moment. Please change you filters or try another time.";
                            /*} else {
                                _emptyLabel.text = @"Currently unsupported area. Currently we are going to support: Israel, Ukraine.";
                            }*/
                            
                        } else {
                            if(filterContent == nil){
                                _emptyLabel.text = @"Sorry, no currently available guides. Please try agan later.";
                            } else {
                                _emptyLabel.text = @"Currently unsupported area. Currently we are going to support: Israel, Ukraine.";
                            }
                        }
                        
                    });
                }];
            } else {
                guidecontent = nil;
                content = nil;
                _emptyLabel.text = @"Sorry, no currently available guides. Please try agan later.";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [refreshControl endRefreshing];
                });
                [_tableView reloadData];
                [_emptyLabel setHidden:NO];
            }

        } else {
            if(_segmaent.selectedSegmentIndex == 0){
                param = [NSString stringWithFormat:@"userId=%ld&distanceMeters=%ld&latitude=%f&longitude=%f&sessionToken=%@",((NSNumber*)objLogin.userId).integerValue,((NSNumber*)filterContent[@"radius"]).integerValue,((NSNumber*)filterContent[@"latitude"]).floatValue,((NSNumber*)filterContent[@"longitude"]).floatValue,objLogin.sessionToken];
                
                [[SWWebManager sharedManager]getNearbyGuides:param success:^(NSArray<SWGuide *> *obj) {
                    NSLog(@"%@",obj);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableArray* results = [[NSMutableArray alloc]initWithCapacity:obj.count];
                        
                        for(int i = 0; i < obj.count; i++){
                            SWGuide* guide = obj[i];
                            NSArray* tours = [NSArray arrayWithArray:guide.tours];
                            for(int j = 0; j < tours.count; j++){
                                [results addObject:@{@"guide":guide,
                                                     @"tours":tours[j]}];
                                
                            }
                        }
                        
                        if(_segmaent.selectedSegmentIndex == 0) {
                            guidecontent = [NSArray arrayWithArray:obj];
                            content = [NSArray arrayWithArray:guidecontent];
                        } else {
                            tourcontent = [NSArray arrayWithArray:results];
                            content = filterContent == nil ? nil : [NSArray arrayWithArray:tourcontent];
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [refreshControl endRefreshing];
                        });
                        [_tableView reloadData];
                        
                        [results removeAllObjects];
                        
                        for(int i = 0; i < obj.count; i++){
                            SWGuide* guide = obj[i];
                            [results addObject:@{@"latitude":guide.latitude,
                                                 @"longitude":guide.longitude
                                                 }];
                        }
                                              self.anotations = [NSArray arrayWithArray:results];
                        
                        [_emptyLabel setHidden:(BOOL)content.count];
                        if(_segmaent.selectedSegmentIndex == 1){
                            //if(filterContent == nil){
                                _emptyLabel.text = @"Sorry no available tours at this moment. Please change you filters or try another time.";
                            //} else {
                            //    _emptyLabel.text = @"Currently unsupported area. Currently we are going to support: Israel, Ukraine.";
                            //}
                            
                        } else {
                            if(filterContent == nil){
                                _emptyLabel.text = @"Sorry, no currently available guides. Please try agan later.";
                            } else {
                                _emptyLabel.text = @"Currently unsupported area. Currently we are going to support: Israel, Ukraine.";
                            }
                        }
                        
                        
                    });
                }];
                _locField.text = _intField.text = nil;
                

            } else {
           
                if([self isParamValid:filterContent[@"keywords"]]){
                    
                    param = [NSString stringWithFormat:@"userId=%ld&distanceMeters=%ld&latitude=%f&longitude=%f&sessionToken=%@&startTime=%lld&keywords=%@",((NSNumber*)objLogin.userId).integerValue,((NSNumber*)filterContent[@"radius"]).integerValue,((NSNumber*)filterContent[@"latitude"]).floatValue,((NSNumber*)filterContent[@"longitude"]).floatValue,objLogin.sessionToken,((NSNumber*)filterContent[@"startTime"]).longLongValue,filterContent[@"keywords"]];
                    
                    
                    [[SWWebManager sharedManager]getGuidesByKeywords:param success:^(NSArray<SWGuide *> *obj) {
                        NSLog(@"%@",obj);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSMutableArray* results = [[NSMutableArray alloc]initWithCapacity:obj.count];
                            
                            for(int i = 0; i < obj.count; i++){
                                SWGuide* guide = obj[i];
                                NSArray* tours = [NSArray arrayWithArray:guide.tours];
                                for(int j = 0; j < tours.count; j++){
                                    [results addObject:@{@"guide":guide,
                                                         @"tours":tours[j]}];
                                    
                                }
                            }
                            
                            if(_segmaent.selectedSegmentIndex == 0) {
                                guidecontent = [NSArray arrayWithArray:obj];
                                content = [NSArray arrayWithArray:guidecontent];
                            } else {
                                tourcontent = [NSArray arrayWithArray:results];
                                content = filterContent == nil ? nil : [NSArray arrayWithArray:tourcontent];
                            }
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [refreshControl endRefreshing];
                            });
                            [_tableView reloadData];
                            
                            [results removeAllObjects];
                            
                            for(int i = 0; i < obj.count; i++){
                                SWGuide* guide = obj[i];
                                [results addObject:@{@"latitude":guide.latitude,
                                                     @"longitude":guide.longitude
                                                     }];
                            }
                          
                            
                            self.anotations = [NSArray arrayWithArray:results];
                            
                            [_emptyLabel setHidden:(BOOL)content.count];
                            if(_segmaent.selectedSegmentIndex == 1){
                                //if(filterContent == nil){
                                    _emptyLabel.text = @"Sorry no available tours at this moment. Please change you filters or try another time.";
                                /*} else {
                                    _emptyLabel.text = @"Currently unsupported area. Currently we are going to support: Israel, Ukraine.";
                                }*/
                                
                            } else {
                                if(filterContent == nil){
                                    _emptyLabel.text = @"Sorry, no currently available guides. Please try agan later.";
                                } else {
                                    _emptyLabel.text = @"Currently unsupported area. Currently we are going to support: Israel, Ukraine.";
                                }
                            }
                    
                            
                        });
                    }];
                    _locInvField.text = _intInvField.text = nil;
                    [_dateBut setTitle:@"Date" forState:UIControlStateNormal];
                    [_dateBut setTitle:@"Date" forState:UIControlStateHighlighted];
                    [_timeBut setTitle:@"Time"forState:UIControlStateNormal];
                    [_timeBut setTitle:@"Time"forState:UIControlStateHighlighted];

                } else {
                    
                    param = [NSString stringWithFormat:@"userId=%ld&distanceMeters=%ld&latitude=%f&longitude=%f&sessionToken=%@&startTime=%lld",((NSNumber*)objLogin.userId).integerValue,((NSNumber*)filterContent[@"radius"]).integerValue,((NSNumber*)filterContent[@"latitude"]).floatValue,((NSNumber*)filterContent[@"longitude"]).floatValue,objLogin.sessionToken,((NSNumber*)filterContent[@"startTime"]).longLongValue];
                    
                    
                    [[SWWebManager sharedManager]getGuides:param success:^(NSArray<SWGuide *> *obj) {
                        NSLog(@"%@",obj);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSMutableArray* results = [[NSMutableArray alloc]initWithCapacity:obj.count];
                            
                            for(int i = 0; i < obj.count; i++){
                                SWGuide* guide = obj[i];
                                NSArray* tours = [NSArray arrayWithArray:guide.tours];
                                for(int j = 0; j < tours.count; j++){
                                    [results addObject:@{@"guide":guide,
                                                         @"tours":tours[j]}];
                                    
                                }
                            }
                            
                            if(_segmaent.selectedSegmentIndex == 0) {
                                guidecontent = [NSArray arrayWithArray:obj];
                                content = [NSArray arrayWithArray:guidecontent];
                            } else {
                                tourcontent = [NSArray arrayWithArray:results];
                                content = filterContent == nil ? nil : [NSArray arrayWithArray:tourcontent];
                            }
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [refreshControl endRefreshing];
                            });
                            [_tableView reloadData];
                            
                            [results removeAllObjects];
                            
                            for(int i = 0; i < obj.count; i++){
                                SWGuide* guide = obj[i];
                                [results addObject:@{@"latitude":guide.latitude,
                                                     @"longitude":guide.longitude
                                                     }];
                            }
                          
                            
                            self.anotations = [NSArray arrayWithArray:results];
                            
                            [_emptyLabel setHidden:(BOOL)content.count];
                            if(_segmaent.selectedSegmentIndex == 1){
                                //if(filterContent == nil){
                                    _emptyLabel.text = @"Sorry no available tours at this moment. Please change you filters or try another time.";
                               /* } else {
                                    _emptyLabel.text = @"Currently unsupported area. Currently we are going to support: Israel, Ukraine.";
                                }*/
                                
                            } else {
                                if(filterContent == nil){
                                    _emptyLabel.text = @"Sorry, no currently available guides. Please try agan later.";
                                } else {
                                    _emptyLabel.text = @"Currently unsupported area. Currently we are going to support: Israel, Ukraine.";
                                }
                            }
                            
                        });
                    }];
                    _locInvField.text = _intInvField.text = nil;
                    [_dateBut setTitle:@"Date" forState:UIControlStateNormal];
                    [_dateBut setTitle:@"Date" forState:UIControlStateHighlighted];
                    [_timeBut setTitle:@"Time"forState:UIControlStateNormal];
                    [_timeBut setTitle:@"Time"forState:UIControlStateHighlighted];
                }

            }
        }
        
    }
    
}

#pragma  mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return content.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = nil;
    UITableViewCell* cell = nil;

    if(_segmaent.selectedSegmentIndex == 1){
        simpleTableIdentifier = @"TourCell";
        SWTourCell *Cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        NSDictionary* obj = content[indexPath.row];
        Cell.content = obj[@"tours"];
        Cell.guidInfo = obj[@"guide"];
        cell = Cell;
    } else {
        simpleTableIdentifier = @"GuideCell";
        SWGuideCell *Cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        Cell.isMore = NO;
        Cell.content = content[indexPath.row];
        cell = Cell;
    }

    return cell;
}
#pragma  mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_segmaent.selectedSegmentIndex == 0)
        return 100.f;
    return 355.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
    UIViewController* controller = nil;
    
    if(_segmaent.selectedSegmentIndex == 0){
        SWGuide* guide = content[indexPath.row];
        /*if(guide.tours.count == 1){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SWTourController* Controller = [storyboard instantiateViewControllerWithIdentifier:@"TourController"];
            Controller.content = guide.tours[0];
            controller = Controller;
        } else {*/
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SWGuidDetailController* Controller = [storyboard instantiateViewControllerWithIdentifier:@"GuidDetailController"];
            NSMutableArray* results = [[NSMutableArray alloc]init];
            [results addObject:guide];
            [results addObjectsFromArray:guide.tours];
            Controller.content = [NSArray arrayWithArray:results];
            controller = Controller;
        //}
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SWTourController* Controller = [storyboard instantiateViewControllerWithIdentifier:@"TourController"];
        NSDictionary* obj = content[indexPath.row];
        Controller.content = obj[@"tours"];
        controller = Controller;
    }
    
    TheApp;
    SWTabbarController* tabBarController =(SWTabbarController*)app.window.rootViewController;
    UINavigationController* nav = (UINavigationController*)[tabBarController selectedViewController];
    controller.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:controller animated:YES];
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
#pragma mark - TRCustomDatePickerDelegate delegate methods

-(void) cancelCustomDatePicker:(TRCustomDatePicker*)customDatePicker{
    
}
-(void) inCustomDatePicker:(TRCustomDatePicker*) customDatePicker selectedDateDictionary:(NSDictionary*)selectedDateDict{

    NSDate* curDate = (NSDate*)selectedDateDict[@"selectedDateNSDate"];
    startTime = (long long)([curDate timeIntervalSince1970] * 1000.0);

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if(customDatePicker.datePickerMode == UIDatePickerModeDate){
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
       
        [_dateBut setTitle: [dateFormatter stringFromDate:curDate] forState:UIControlStateNormal];
        [_dateBut setTitle: [dateFormatter stringFromDate:curDate] forState:UIControlStateHighlighted];

    } else {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:curDate];
        NSString* str = [NSString stringWithFormat:@"%ld:%ld",[components hour],[components minute]];
        if([components hour] < 10 && [components minute] < 10){
            str = [NSString stringWithFormat:@"0%ld:0%ld",[components hour],[components minute]];
        } else if([components hour] >= 10 && [components minute] < 10){
            str = [NSString stringWithFormat:@"%ld:0%ld",[components hour],[components minute]];
        } else if([components hour] < 10 && [components minute] >= 10){
            str = [NSString stringWithFormat:@"0%ld:%ld",[components hour],[components minute]];
        }
        
        [_timeBut setTitle:str forState:UIControlStateNormal];
        [_timeBut setTitle:str forState:UIControlStateHighlighted];
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
                             if (_segmaent.selectedSegmentIndex == 0){
                                 [_filterView setFrame:CGRectMake(CGRectGetMinX(_filterView.frame), CGRectGetMinY(_filterView.frame) + CGRectGetHeight(_filterView.frame), CGRectGetWidth(_filterView.frame), CGRectGetHeight(_filterView.frame))];
                             } else {
                                 [_filterInvView setFrame:CGRectMake(CGRectGetMinX(_filterInvView.frame), CGRectGetMinY(_filterInvView.frame) + CGRectGetHeight(_filterInvView.frame), CGRectGetWidth(_filterInvView.frame), CGRectGetHeight(_filterInvView.frame))];
                             }
                         }
                         completion:^(BOOL finished) {
                             

                             if (_segmaent.selectedSegmentIndex == 0){
                                 _showConstaraint.constant = 0.f;
                                 
                             } else {
                                 _showInvConstaraint.constant = 0.f;
                                 
                             }
                             isFilter = YES;
                             isComplete = YES;
                         }];
    } else {
        [UIView animateWithDuration:0.5
                              delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionLayoutSubviews
                         animations:^{
                             if (_segmaent.selectedSegmentIndex == 0){
                                 [_filterView setFrame:CGRectMake(CGRectGetMinX(_filterView.frame), CGRectGetMinY(_filterView.frame) - CGRectGetHeight(_filterView.frame), CGRectGetWidth(_filterView.frame), CGRectGetHeight(_filterView.frame))];
                             } else {
                                 [_filterInvView setFrame:CGRectMake(CGRectGetMinX(_filterInvView.frame), CGRectGetMinY(_filterInvView.frame) - CGRectGetHeight(_filterInvView.frame), CGRectGetWidth(_filterInvView.frame), CGRectGetHeight(_filterInvView.frame))];
                             }
                         }
                         completion:^(BOOL finished) {
                             if (_segmaent.selectedSegmentIndex == 0){
                                 _locField.text = _intField.text = nil;
                                 [_locField resignFirstResponder];
                                 [_intField resignFirstResponder];
                                 _showConstaraint.constant -= CGRectGetHeight(_filterView.frame);
                             } else {
                                 _locInvField.text = _intInvField.text = nil;
                                 [_locInvField resignFirstResponder];
                                 [_intInvField resignFirstResponder];
                                 [_dateBut setTitle:@"Date" forState:UIControlStateNormal];
                                 [_dateBut setTitle:@"Date" forState:UIControlStateHighlighted];
                                 [_timeBut setTitle:@"Time"forState:UIControlStateNormal];
                                 [_timeBut setTitle:@"Time"forState:UIControlStateHighlighted];
                                 _showInvConstaraint.constant -= CGRectGetHeight(_filterInvView.frame);
                             }
                             
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
                if([_delegate respondsToSelector:@selector(titleChanged:withTitle:)]){
                    [_delegate titleChanged:self withTitle:_locField.text];
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
        if([_delegate respondsToSelector:@selector(titleChanged:withTitle:)]){
            [_delegate titleChanged:self withTitle:@""];
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showIndecator:YES];
            [self getGuids];
        });
    } else if([button isEqual:_doneInvBut]){

        if((_locInvField.text == nil || [_locInvField.text isEqualToString:@""])){
            [self showAlertMessage:@"The location, date and time be mandatory fields"];
            return;
        }
        if([_dateBut.titleLabel.text isEqualToString:@"Date"]){
            [self showAlertMessage:@"The location, date and time be mandatory fields"];
            return;
        }
        if([_timeBut.titleLabel.text isEqualToString:@"Time"]){
            [self showAlertMessage:@"The location, date and time be mandatory fields"];
            return;
        }

        [self showFilter];
        [self  getLocationFromAddress:_locInvField.text success:^(CLLocation *obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                filterContent = nil;
                
                if(obj != nil){
                    filterContent = @{@"latitude":@(obj.coordinate.latitude),
                                      @"longitude":@(obj.coordinate.longitude),
                                      @"radius":@(50000),
                                      @"startTime":startTime > 0 ?  @(startTime): @(0),
                                      @"keywords":([_intInvField.text isEqualToString:@""] || _intInvField.text == nil) ?  [NSNull null] : _intInvField.text};
                    
                }
                if([_delegate respondsToSelector:@selector(titleChanged:withTitle:)]){
                    [_delegate titleChanged:self withTitle:_locInvField.text];
                }

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showIndecator:YES];
                    [self getGuids];
                });
            });
        }];
        
        
    } else if([button isEqual:_clearInvBut]){
        _locInvField.text = _intInvField.text = nil;
        startTime = -1;
        [_dateBut setTitle:@"Date" forState:UIControlStateNormal];
        [_dateBut setTitle:@"Date" forState:UIControlStateHighlighted];
        [_timeBut setTitle:@"Time"forState:UIControlStateNormal];
        [_timeBut setTitle:@"Time"forState:UIControlStateHighlighted];
        filterContent = nil;
        if([_delegate respondsToSelector:@selector(titleChanged:withTitle:)]){
            [_delegate titleChanged:self withTitle:@""];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getGuids];
        });
    } else if([button isEqual:_dateBut] || [button isEqual:_timeBut]){
        datePicker.params = @{key_pickerFontNameNSString : @"OpenSans-Light",
                              key_pickerFontSizeNSNumber : @(18.f),
                              key_pickerContentTextColorUIColor : [UIColor blackColor],
                              key_pickerComponentsRowsBackgroundColorUIColor : [UIColor whiteColor],
                              key_pickerBackgroundColorUIColor : [UIColor whiteColor],
                              key_pickerSelectionLinesColorUIColor : [UIColor lightGrayColor],
                              key_isToolBarExistNSNumber : @(YES),
                              key_doneBtnTitleNSString : @"Done",
                              key_cancelBtnTitleNSString : @"Cancel",
                              key_horizEdgeOffsetsCancelDoneBtns  : @(10.f),
                              key_toolBarTitleColorUIColor:[UIColor whiteColor],
                              key_toolBarTitleNSString :[button isEqual:_dateBut] ? @"Select date" : @"Select time",
                              key_pickerSelectedRowsNSArray : @[@(0)]};
        
        datePicker.datePickerMode = [button isEqual:_dateBut] ? UIDatePickerModeDate : UIDatePickerModeTime;
        
        if(!datePicker.isShow){
            if(datePicker.isShow && datePicker.isCompleted){
                [datePicker hide];
            } else if(!datePicker.isShow && datePicker.isCompleted){
                [datePicker show];
            }
        }

    }
}
-(IBAction)segmentValueChanged:(UISegmentedControl *)control{
    
    if(control.selectedSegmentIndex == 0){
        content = [NSArray arrayWithArray:guidecontent];
    } else {
        content = filterContent == nil ? nil : [NSArray arrayWithArray:tourcontent];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showFilter];
        });
    }

    [_emptyLabel setHidden:YES];
    [self getGuids];
    
    if([_delegate respondsToSelector:@selector(segmentChanged:withState:)]){
        [_delegate segmentChanged:self withState:_segmaent.selectedSegmentIndex];
    }
}
@end
