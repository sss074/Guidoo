//
//  SWChoseView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 12.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWChoseView.h"

@interface SWChoseView (){
    NSMutableArray* indexes;
}

@property (nonatomic,strong)IBOutlet UITableView* tableView;

@end

@implementation SWChoseView

- (void)setContent:(NSArray *)content{
    _content = content;
    
    if(_content != nil){
        
        indexes = [[NSMutableArray alloc]initWithCapacity:_content.count];
        for(int i = 0; i< _content.count; i++){
            NSDictionary* param = _content[i];
            [indexes addObject:((NSNumber*)param[@"isCheck"]).boolValue ? _content[i] : [NSNull null]];
        }
    }
}
- (void)awakeFromNib{
    [super awakeFromNib];
    
    [_tableView setTableFooterView:[UIView new]];
    _tableView.allowsMultipleSelection = YES;
    _result = nil;
    
}

#pragma  mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _content.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ChoseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSDictionary* param = _content[indexPath.row];
    cell.textLabel.text = param[@"title"];
    cell.textLabel.font = [UIFont fontWithName:@"OpenSans" size:17.f];
    cell.accessoryType = [indexes[indexPath.row] isEqual:[NSNull null]] ? UITableViewCellAccessoryNone  : UITableViewCellAccessoryCheckmark;

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
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [indexes replaceObjectAtIndex:indexPath.row withObject:_content[indexPath.row]];
    _result = [NSArray arrayWithArray:indexes];
    NSLog(@"%@",_result);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    [indexes replaceObjectAtIndex:indexPath.row withObject:[NSNull null]];
    _result = [NSArray arrayWithArray:indexes];
    NSLog(@"%@",_result);

}
/*-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *oldIndex = [self.tableView indexPathForSelectedRow];
    [self.tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}*/

@end
