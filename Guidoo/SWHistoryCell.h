//
//  SWHistoryCell.h
//  Guidoo
//
//  Created by Sergiy Bekker on 17.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWHistoryCell;

@protocol SWHistoryCellDelegate <NSObject>

- (void)morePress:(SWHistoryCell*)obj;


@end

@interface SWHistoryCell : UITableViewCell

@property (nonatomic,strong) SWHistory* content;
@property (nonatomic,weak) id<SWHistoryCellDelegate> delegete;
@property (nonatomic,assign) BOOL isMore;
@property (nonatomic,assign) BOOL isRecent;
@end
