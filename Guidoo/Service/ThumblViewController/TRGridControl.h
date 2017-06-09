//
//  TRSubsectionControl.h
//  DatingApp
//
//  Created by Sergiy Bekker on 28.09.15.
//  Copyright © 2015 Sergiy Bekker. All rights reserved.
//

@class TRGridControl;

@protocol TRGridControlDelegate <NSObject>

@optional
- (void)scrollGridViewDidScroll:(UIScrollView*)scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)_scrollView willDecelerate:(BOOL)decelerate;
- (void)reloadDataSource:(TRGridControl*)obj;
- (void)didLongSelectItem:(TRGridControl*)obj withTaggetCell:(id)cell withIndex:(NSInteger)index;
- (void)didSelectItem:(TRGridControl*)obj withTaggetCell:(id)cell withIndex:(NSInteger)index;
- (void)isShowSearch:(TRGridControl*)obj withState:(BOOL)state;
@end


@interface TRGridControl : UICollectionView

@property(nonatomic, weak) id<TRGridControlDelegate> mainDelegate;
@property (nonatomic, copy) NSString *kRegisterClassKey;
@property (nonatomic, copy) NSString *kContentKey;
@property (nonatomic, copy) NSString *kDelegateKey;
@property (nonatomic, copy) NSString *kHeaderKey;
@property (nonatomic, copy) NSString *kFooterKey;
@property (nonatomic, copy) NSString *kRefreshEnabled;
@property (nonatomic, copy) NSString *kRefreshTextEnabled;
@property (nonatomic, copy) NSString *kBouncesEnabled;
@property (nonatomic, copy) NSString *kGridType;
@property (nonatomic, copy) NSString *kLongPressEnable;
@property (nonatomic, copy) NSString *kSettingsCell;
@property (nonatomic, assign) BOOL isAnime;
@property (nonatomic, assign) BOOL isSearchAnime;

- (instancetype)initWithFrame:(CGRect)frame withAtrributes:(NSDictionary*)param;
- (void)refreshContent;
- (void)doneRefresh;
- (id) objectForKeyedSubscript:(id<NSCopying>)paramKey;
- (void) setObject:(id)paramObject forKeyedSubscript:(id<NSCopying>)paramKey;

@end


