//
//  SWInboxView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 27.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWInboxView.h"
#import "SWListChatCell.h"
#import "UIRefreshControl+UITableView.h"

@interface SWInboxView (){
    NSArray* messageContent;
    NSArray * content;
    UIRefreshControl *refreshControl;
}

@property (nonatomic,strong)IBOutlet UISegmentedControl* segmaent;
@property (nonatomic,strong)IBOutlet UITableView* tableView;

@end

@implementation SWInboxView

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
    [_tableView setTableFooterView:[UIView new]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSession:) name:@"updateSession" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateListChat:) name:@"updateListChat" object:nil];
    
    [self showIndecator:YES];
    [self listChat];
}
- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateSession" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateListChat" object:nil];
}
#pragma mark -  NSNotification
- (void)updateSession:(NSNotification*)notify{
    [refreshControl beginRefreshing];
    [self refreshContent];
}
- (void)updateListChat:(NSNotification*)notify{
    [self listChat];
}
#pragma  mark - Service methods
- (void)refreshContent{
    if(_segmaent.selectedSegmentIndex == 0){
        [self listChat];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [refreshControl endRefreshing];
        });
    }
}
- (void)listChat{
    
    SWLogin *objLogin = [self objectDataForKey:userLoginInfo];
    if(objLogin != nil){
        NSString *param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@",((NSNumber*)objLogin.userId).integerValue,objLogin.sessionToken];
        [[SWWebManager sharedManager]getUnreadMessages:param success:^(NSArray<SWBookInfo *> *obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                messageContent = [NSArray arrayWithArray:obj];
                NSMutableArray* temp = [[NSMutableArray alloc]initWithCapacity:messageContent.count];
                for(int i = 0; i < messageContent.count; i++){
                    SWChatMessage* item = messageContent[i];
                    item.isNew = @(YES);
                    item.isIncome = @(YES);
                    [[SWDataManager sharedManager]updateChatItem:item];
                }
                [[SWDataManager sharedManager]updateBage:NO];
                NSArray* chatItems = [[SWDataManager sharedManager] chatItems];
                for(int i = 0; i < chatItems.count; i++){
                    SWChatMessage* item = chatItems[i];
                    [temp addObject:item];
                }
                NSSet *uniqueStates = [NSSet setWithArray:[temp valueForKey:@"senderUserId"]];
                NSArray *array = [uniqueStates allObjects];
                [temp removeAllObjects];
                for(int i = 0; i < array.count; i++){
                    NSNumber* item = array[i];
                    [temp addObject:[[SWDataManager sharedManager] listChatItem:item]];
                }
                messageContent = [NSArray arrayWithArray:temp];
                content = [NSArray arrayWithArray:messageContent];
                [_tableView reloadData];
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
    static NSString *simpleTableIdentifier = @"ListChatCell";
    
    SWListChatCell* cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell.content = content[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma  mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if([_delegete respondsToSelector:@selector(didSelectItem:withContent:)]){
        [_delegete didSelectItem:self withContent:content[indexPath.row]];
    }
    
}
#pragma  mark - Action methods

-(IBAction)segmentValueChanged:(UISegmentedControl *)control{
    
    content = nil;
    [_tableView reloadData];
  
    if(control.selectedSegmentIndex == 0){
        content = [NSArray arrayWithArray:messageContent];
        [_tableView reloadData];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    } else {
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
}


@end
