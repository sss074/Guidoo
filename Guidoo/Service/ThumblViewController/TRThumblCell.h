//
//  TRThumblCell.h
//  DatingApp
//
//  Created by Sergiy Bekker on 20.07.16.
//  Copyright © 2016 Sergiy Bekker. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TRThumblCell;

@protocol TRThumblCellDelegate <NSObject>

@optional
- (void)didRemoveCellItem:(TRThumblCell*)cell withIndex:(NSInteger)index;

@end

@interface TRThumblCell : UICollectionViewCell

@property(nonatomic,strong) NSDictionary* content;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,weak) id<TRThumblCellDelegate> cellDelegate;

@end
