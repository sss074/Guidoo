//
//  SWHistoryView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 07.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWHistoryView.h"
#import "SWHistoryCell.h"
#import "UIRefreshControl+UITableView.h"
#import "SWActiveTourView.h"

@interface SWHistoryView ()<SWHistoryCellDelegate>{
    NSArray* futureContent;
    NSArray* pastContent;
    NSArray * content;
    UIRefreshControl *refreshControl;
    SWActiveTourView* activeView;
}

@property (nonatomic,strong)IBOutlet UISegmentedControl* segmaent;
@property (nonatomic,strong)IBOutlet UITableView* tableView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* buttonY;

@end

@implementation SWHistoryView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [_segmaent setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                        NSFontAttributeName:[UIFont fontWithName:OPENSANSSEMIBOLD size:15.f]} forState:UIControlStateNormal];
    [_segmaent setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                        NSFontAttributeName:[UIFont fontWithName:OPENSANSSEMIBOLD size:15.f]} forState:UIControlStateSelected];
    [_segmaent setTintColor:[UIColor colorWithRed:56.f/255.f green:150.f/255.f blue:44.f/255.f alpha:1.f]];
    
    SWLogin *object = [self objectDataForKey:userLoginInfo];
    if(object != nil){
        if([self isParamValid:object.activeBookingId]){
            [_segmaent insertSegmentWithTitle:@"Active" atIndex:2 animated:NO];
            activeView = [[[NSBundle mainBundle] loadNibNamed:@"SWActiveTourView" owner:self options:nil] firstObject];
            [activeView setFrame:CGRectMake(0, CGRectGetMinY(_tableView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMinY(_tableView.frame))];
            [self addSubview:activeView];
            [activeView setHidden:YES];
        }
    }
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshContent) forControlEvents:UIControlEventValueChanged];
    [refreshControl addToTableView:_tableView];
    [_tableView setTableHeaderView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 5.f)]];
    
    [self showIndecator:YES];
    [self bookingActivityFuture];
 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHistory:) name:@"updateHistory" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSegment:) name:@"updateSegment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSession:) name:@"updateSession" object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateHistory" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateSegment" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateSession" object:nil];
}
#pragma mark -  NSNotification
- (void)updateSession:(NSNotification*)notify{
    [refreshControl beginRefreshing];
    [self refreshContent];
}
- (void)updateHistory:(NSNotification*)notify{
    pastContent = nil;
    [self bookingActivityFuture];
}
- (void)updateSegment:(NSNotification*)notify{
    SWLogin *object = notify.object;
    if(object != nil){
        if([self isParamValid:object.activeBookingId]){
            if(_segmaent.numberOfSegments == 2){
                [_segmaent insertSegmentWithTitle:@"Active" atIndex:2 animated:NO];
                activeView = [[[NSBundle mainBundle] loadNibNamed:@"SWActiveTourView" owner:self options:nil] firstObject];
                [activeView setFrame:CGRectMake(0, CGRectGetMinY(_tableView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMinY(_tableView.frame))];
                [self addSubview:activeView];
                [activeView setHidden:YES];
                pastContent = nil;
                [self bookingActivityFuture];
            }
        } else {
            if(_segmaent.numberOfSegments == 3){
                if(_segmaent.selectedSegmentIndex == 2){
                    _segmaent.selectedSegmentIndex = 0;
                    [_segmaent sendActionsForControlEvents:UIControlEventValueChanged];
                }
                [_segmaent removeSegmentAtIndex:2 animated:NO];
                [activeView removeFromSuperview];
                activeView = nil;
            }
        }
    }
}
#pragma  mark - Service methods
- (void)refreshContent{

    if(_segmaent.selectedSegmentIndex == 0){
        [self bookingActivityFuture];
    } else {
        [self bookingActivityPast];
    }
    
}
- (void)bookingActivityFuture{
    
    SWLogin *objLogin = [self objectDataForKey:userLoginInfo];
    if(objLogin != nil){
        NSString *param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@",((NSNumber*)objLogin.userId).integerValue,objLogin.sessionToken];
        [[SWWebManager sharedManager]bookingActivityFuture:param success:^(NSArray<SWBookInfo *> *obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                futureContent = [NSArray arrayWithArray:obj];
                content = [NSArray arrayWithArray:futureContent];
                [_tableView reloadData];
                if(pastContent == nil)
                    [self bookingActivityPast];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [refreshControl endRefreshing];
                });
            });
        }];
    }
    
}
- (void)bookingActivityPast{
    
    
    SWLogin *objLogin = [self objectDataForKey:userLoginInfo];
    if(objLogin != nil){
        NSString *param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@",((NSNumber*)objLogin.userId).integerValue,objLogin.sessionToken];
        [[SWWebManager sharedManager]bookingActivityPast:param success:^(NSArray<SWBookInfo *> *obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                pastContent = [NSArray arrayWithArray:obj];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [refreshControl endRefreshing];
                });
            });
        }];
    }
    
}

#pragma  mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return content.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"HistoryCell";
    
    SWHistoryCell* cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    cell.isMore = (BOOL)_segmaent.selectedSegmentIndex;
    cell.content = content[indexPath.row];
    cell.delegete = self;
    

    return cell;
}
#pragma  mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 204.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
 
    SWHistoryCell* cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    if([_delegete respondsToSelector:@selector(didSelectItem:withContent:)]){
        [_delegete didSelectItem:self withContent:cell.content];
    }
    
}
#pragma  mark - Action methods

-(IBAction)segmentValueChanged:(UISegmentedControl *)control{
    
    content = nil;
    [_tableView reloadData];
    [activeView setHidden:YES];
    
    if(control.selectedSegmentIndex == 0 || control.selectedSegmentIndex == 1){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(control.selectedSegmentIndex == 0){
                content = [NSArray arrayWithArray:futureContent];
            } else if(control.selectedSegmentIndex == 1){
                content = [NSArray arrayWithArray:pastContent];
            }
            [_tableView reloadData];
        });
    } else if(control.selectedSegmentIndex == 2){
        [activeView setHidden:NO];
    }
    
    
}
#pragma  mark - SWHistoryCell delegete methods
- (void)morePress:(SWHistoryCell*)obj{
    if([_delegete respondsToSelector:@selector(morePress:withContent:)]){
        [_delegete morePress:self withContent:obj.content];
    }
}
@end
