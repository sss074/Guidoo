//
//  SWBookmarksView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 22.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWBookmarksView.h"
#import "SWGuideCell.h"
#import "SWTourCell.h"
#import "UIRefreshControl+UITableView.h"
#import "SWGuidDetailController.h"
#import "SWTourController.h"

@interface SWBookmarksView (){
    NSArray * content;
    UIRefreshControl *refreshControl;
}

@property (nonatomic,strong)IBOutlet UISegmentedControl* segmaent;
@property (nonatomic,strong)IBOutlet UITableView* tableView;

@end

@implementation SWBookmarksView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [_segmaent setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                        NSFontAttributeName:[UIFont fontWithName:OPENSANSSEMIBOLD size:15.f]} forState:UIControlStateNormal];
    [_segmaent setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                        NSFontAttributeName:[UIFont fontWithName:OPENSANSSEMIBOLD size:15.f]} forState:UIControlStateSelected];
    [_segmaent setTintColor:[UIColor colorWithRed:56.f/255.f green:150.f/255.f blue:44.f/255.f alpha:1.f]];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshContent) forControlEvents:UIControlEventValueChanged];
    [refreshControl addToTableView:_tableView];
    [_tableView setTableHeaderView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 5.f)]];
    
    content =[ NSArray arrayWithArray:[SWWebManager sharedManager].bookmarkGuids];
    [_tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBookmarks:) name:@"updateBookmarks" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSession:) name:@"updateSession" object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateBookmarks" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateSession" object:nil];
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
        Cell.content = content[indexPath.row];
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
    
    TheApp;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSString* param = nil;
    
    if(_segmaent.selectedSegmentIndex == 0){

        SWLogin *object = [self objectDataForKey:userLoginInfo];
        if(object != nil){
            SWGuide* guide = content[indexPath.row];
            param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&guideId=%ld",((NSNumber*)object.userId).integerValue,object.sessionToken,((NSNumber*)guide.guideId).integerValue];
            [self showIndecator:YES];
            [[SWWebManager sharedManager]getTours:param withGuideID:guide.guideId success:^(NSArray<SWTour *> *obj) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    SWGuidDetailController* controller = [storyboard instantiateViewControllerWithIdentifier:@"GuidDetailController"];
                    NSMutableArray* results = [[NSMutableArray alloc]init];
                    [results addObject:guide];
                    [results addObjectsFromArray:obj];
                    for(int i = 0; i < results.count; i++){
                        SWTour* tour = results[i];
                        tour.guideId = guide.guideId;
                        tour.pricePerHour = guide.pricePerHour;
                        [results replaceObjectAtIndex:i withObject:tour];
                    }
                    controller.content = [NSArray arrayWithArray:results];
                    
                    SWTabbarController* tabBarController =(SWTabbarController*)app.window.rootViewController;
                    UINavigationController* nav = (UINavigationController*)[tabBarController selectedViewController];
                    controller.hidesBottomBarWhenPushed = YES;
                    [nav pushViewController:controller animated:YES];

                });
            }];
        }
    } else {
        SWLogin *object = [self objectDataForKey:userLoginInfo];
        if(object != nil){
            SWTour* tour = content[indexPath.row];
            param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&tourId=%ld",((NSNumber*)object.userId).integerValue,object.sessionToken,((NSNumber*)tour.tourId).integerValue];
            [self showIndecator:YES];
            [[SWWebManager sharedManager]getTour:param withTourID:tour.tourId success:^(SWTour *obj) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    SWTourController* controller = [storyboard instantiateViewControllerWithIdentifier:@"TourController"];
                    obj.guideId = tour.guideId;
                    obj.pricePerHour = tour.pricePerHour;
                    controller.content = obj;
                    SWTabbarController* tabBarController =(SWTabbarController*)app.window.rootViewController;
                    UINavigationController* nav = (UINavigationController*)[tabBarController selectedViewController];
                    controller.hidesBottomBarWhenPushed = YES;
                    [nav pushViewController:controller animated:YES];
                    
                });
            }];
        }
    }
    
}
#pragma mark -  NSNotification

- (void)updateBookmarks:(NSNotification*)notify{
    if(_segmaent.selectedSegmentIndex == 0 ){
        content =[ NSArray arrayWithArray:[SWWebManager sharedManager].bookmarkGuids];
    } else {
        content =[ NSArray arrayWithArray:[SWWebManager sharedManager].bookmarkTours];
    }
    
    [_tableView reloadData];
}
- (void)updateSession:(NSNotification*)notify{
    [refreshControl beginRefreshing];
    [self refreshContent];
}

#pragma  mark - Service methods
- (void)refreshContent{
    
    SWLogin *object = [self objectDataForKey:userLoginInfo];
    if(object != nil){
        NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken];
        [[SWWebManager sharedManager]bookmarks:param success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if(_segmaent.selectedSegmentIndex == 0 ){
                        content =[ NSArray arrayWithArray:[SWWebManager sharedManager].bookmarkGuids];
                    } else {
                        content =[ NSArray arrayWithArray:[SWWebManager sharedManager].bookmarkTours];
                    }
                    
                    [_tableView reloadData];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [refreshControl endRefreshing];
                    });
                });
            });
        }];
    }
 
}
#pragma  mark - Action methods

-(IBAction)segmentValueChanged:(UISegmentedControl *)control{

    if(control.selectedSegmentIndex == 0 ){
        content =[ NSArray arrayWithArray:[SWWebManager sharedManager].bookmarkGuids];
    } else {
        content =[ NSArray arrayWithArray:[SWWebManager sharedManager].bookmarkTours];
    }
    
    [_tableView reloadData];
    
    
}
@end
