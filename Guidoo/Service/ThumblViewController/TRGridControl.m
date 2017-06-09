//
//  TRSubsectionControl.m
//  DatingApp
//
//  Created by Sergiy Bekker on 28.09.15.
//  Copyright © 2015 Sergiy Bekker. All rights reserved.
//

#import "TRGridControl.h"
#import "TRStartScreenCell.h"
#import "TRUserPlaceCell.h"
#import "TRPhotoGridCell.h"
#import "TRPhotoStackCell.h"
#import "TRThumblCell.h"

NSString *const CellIdentifier = @"gridCell";
NSString *const headerViewIdentifier = @"HeaderView";
NSString *const footerViewIdentifier = @"FooterView";
NSString *const kRegisterClassKey = @"kRegisterClassKey";
NSString *const kContentKey = @"kContentKey";
NSString *const kHeaderKey = @"kHeaderKey";
NSString *const kFooterKey = @"kFooterKey";
NSString *const kRefreshEnabled = @"kRefreshEnabled";
NSString *const kRefreshTextEnabled = @"kRefreshTextEnabled";
NSString *const kBouncesEnabled = @"kBouncesEnabled";
NSString *const kGridType = @"kGridType";
NSString *const kLongPressEnable = @"kLongPressEnable";
NSString *const kDelegateKey = @"kDelegateKey";
NSString *const kSettingsCell = @"kSettingsCell";

@interface TRGridControl() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    CGSize sizeItem;
    UIRefreshControl *refreshControl;
    NSArray* content;
    UIView* headerView;
    UIView* footerView;
    BOOL isRefreshEnabled;
    BOOL isRefreshTextEnabled;
    BOOL isBouncesEnabled;
    BOOL isLongPressEnable;
    TRGridType gridType;
    NSIndexPath* curindexPath;
    id cellDelegate;
    NSDictionary* settingsCell;
    NSInteger factor;
    CGFloat lastContentOffset;
    
}

@end

@implementation TRGridControl


- (instancetype)initWithFrame:(CGRect)frame withAtrributes:(NSDictionary*)param{
    
    isLongPressEnable = NO;
    
    cellDelegate = nil;
    
    factor = 1;
    self.isAnime = YES;
    self.isSearchAnime = YES;
    
    isBouncesEnabled = isRefreshTextEnabled = isRefreshEnabled = NO;
    
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerViewIdentifier];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = ((NSNumber*)param[@"spaceLine"]).floatValue;
    flowLayout.minimumInteritemSpacing = ((NSNumber*)param[@"spaceInteritem"]).floatValue;
    [flowLayout setItemSize: CGSizeMake(((NSNumber*)param[@"widghtCell"]).floatValue, ((NSNumber*)param[@"hightCell"]).floatValue)];
    [flowLayout setScrollDirection:(UICollectionViewScrollDirection)((NSNumber*)param[@"direction"]).integerValue];
    flowLayout.sectionInset = UIEdgeInsetsMake(5.0f, 5.0f, 10.0f, 5.0f);
    
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        
        
        sizeItem = CGSizeMake(((NSNumber*)param[@"widghtCell"]).floatValue, ((NSNumber*)param[@"hightCell"]).floatValue);
        
        if((UICollectionViewScrollDirection)((NSNumber*)param[@"direction"]).integerValue == UICollectionViewScrollDirectionVertical){
            refreshControl = [[UIRefreshControl alloc] init];
            refreshControl.tintColor = [UIColor grayColor];
            [refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
            
        }
        
        [self setBackgroundColor:[UIColor whiteColor]];
        self.dataSource = self;
        self.delegate = self;
        
        [self setCollectionViewLayout:flowLayout];
        
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}
- (void)dealloc{
    [self removeObserver:self forKeyPath:@"contentSize" context:NULL];
}
#pragma mark - Public methods
- (void)refreshContent{
    [self setUserInteractionEnabled:NO];
    [refreshControl beginRefreshing];
    [self setContentOffset:CGPointMake(0, -refreshControl.frame.size.height) animated:YES];
}
- (void)doneRefresh{
    [self setUserInteractionEnabled:YES];
    if(isRefreshTextEnabled)
        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Данные обнавлены"];
    [refreshControl endRefreshing];
    
}
#pragma mark - UICollectionView layout delegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = nil;
    UICollectionReusableView *supplementaryView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        identifier = headerViewIdentifier;
        supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
        
        [supplementaryView addSubview:headerView];
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        identifier = footerViewIdentifier;
        supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
        [supplementaryView addSubview:footerView];
    }
    
    
    return supplementaryView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return headerView.bounds.size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return footerView.bounds.size;
}
#pragma mark - UICollectionView datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if([[TRManager sharedInstance]isParamValid:content]){
        return content.count;
    }
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if([[TRManager sharedInstance]isParamValid:content[section]]){
        return ((NSArray*)content[section]).count;
    }
    return 0;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
  
    if([[TRManager sharedInstance]isParamValid:content[indexPath.section]]){
    NSArray *data = (NSArray*)content[indexPath.section];
        if([[TRManager sharedInstance]isParamValid:data] && data.count > 0){
            if([cell isMemberOfClass:[TRPhotoStackCell class]]){
                ((TRPhotoStackCell*)cell).asset = (NSDictionary*)data[indexPath.row];
            } else if([cell isMemberOfClass:[TRThumblCell class]]){
                ((TRThumblCell*)cell).content = (NSDictionary*)data[indexPath.row];
                ((TRThumblCell*)cell).cellDelegate = cellDelegate;
                ((TRThumblCell*)cell).index = indexPath.row;
            } else if([cell isMemberOfClass:[TRGridCell class]]){
                ((TRGridCell*)cell).content = (NSDictionary*)data[indexPath.row];
                ((TRGridCell*)cell).type = gridType;
                ((TRGridCell*)cell).index = indexPath.row;
            } else if([cell isMemberOfClass:[TRUserPlaceCell class]]){
                ((TRUserPlaceCell*)cell).content = (NSDictionary*)data[indexPath.row];
                ((TRUserPlaceCell*)cell).index = indexPath.row;
            } else if([cell isMemberOfClass:[TRPhotoGridCell class]]){
                ((TRPhotoGridCell*)cell).index = indexPath.row;
                ((TRPhotoGridCell*)cell).content = (NSDictionary*)data[indexPath.row];
                ((TRPhotoGridCell*)cell).mainDelegate = (id<TRPhotoGridCellDelegate>)_mainDelegate;
            } else if([cell isMemberOfClass:[TRStartScreenCell class]]){
                ((TRStartScreenCell*)cell).content = (NSDictionary*)data[indexPath.row];
                ((TRStartScreenCell*)cell).index = indexPath.row;
                ((TRStartScreenCell*)cell).mainDelegate = cellDelegate;
            }
        }

        return cell;
    }
    
    return  nil;
    

    
}
-(void)collectionView:(UICollectionView *)collectionView
      willDisplayCell:(UICollectionViewCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //CGRect frame = [[UIScreen mainScreen]bounds];
    //CGFloat posY =  (-1) * factor * CGRectGetHeight(frame) / 2;
    

    
    if([cell isMemberOfClass:[TRGridCell class]] && _isAnime && _isSearchAnime){

        CGFloat posY  =  factor * cell.frame.size.height;
        cell.transform = CGAffineTransformMakeScale(0.7, 0.7);
        cell.transform = CGAffineTransformMakeTranslation(-cell.frame.size.width, posY);
        if(indexPath.row % 3 == 0 || indexPath.row == 0)
            cell.transform = CGAffineTransformMakeTranslation(-cell.frame.size.width, posY);
        else if(indexPath.row % 3 == 1)
            cell.transform = CGAffineTransformMakeTranslation(cell.frame.size.width, posY);
        else
            cell.transform = CGAffineTransformMakeTranslation(- 2 * cell.frame.size.width / 3, posY);
        cell.alpha = 0.0;
        
       
        [UIView animateKeyframesWithDuration:0.3 delay:0.01*indexPath.row options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            cell.transform = CGAffineTransformIdentity;
            
            cell.alpha = 1;
            
        } completion:^(BOOL finished) {
        }];
            
        
        
        
       /* posY =  (-1 ) * factor * cell.frame.size.height;
        cell.alpha = 0.5;
        
        [UIView animateKeyframesWithDuration:0.3 delay:0.1 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
           
            cell.transform = CGAffineTransformMakeScale(0.7, 0.7);
            cell.transform = CGAffineTransformMakeTranslation(-cell.frame.size.width, posY);
            if(indexPath.row % 3 == 0 || indexPath.row == 0)
                cell.transform = CGAffineTransformMakeTranslation(-cell.frame.size.width, posY);
            else if(indexPath.row % 3 == 1)
                cell.transform = CGAffineTransformMakeTranslation(cell.frame.size.width, posY);
            else
                cell.transform = CGAffineTransformMakeTranslation(- 2 * cell.frame.size.width / 3, posY);
            
            cell.alpha = 0.5;
            [UIView animateKeyframesWithDuration:0.3 delay:0.1 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                
                cell.transform = CGAffineTransformIdentity;
                
                cell.alpha = 1;
                
            } completion:^(BOOL finished) {
            }];
            
        } completion:^(BOOL finished) {
        }];*/
        
        
    }
}


#pragma mark - UICollectionView delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return sizeItem;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    curindexPath = indexPath;
    if(!isLongPressEnable){
        if([_mainDelegate respondsToSelector:@selector(didSelectItem:withTaggetCell:withIndex:)]){
            [_mainDelegate didSelectItem:self withTaggetCell:[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath]  withIndex:indexPath.row];
        }
    }
}
- (void)refershControlAction{
   
    [self setUserInteractionEnabled:NO];
    
    if(isRefreshTextEnabled)
        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Загрузка..."];
    
    if([_mainDelegate respondsToSelector:@selector(reloadDataSource:)]){
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
        [_mainDelegate reloadDataSource:self];
    }
}
#pragma mark - UIScrollView delegate methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    
    if(translation.y > 0){
        factor = 1;
    } else {
        factor = -1;
    }
    if([_mainDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]){
        [_mainDelegate scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if([_mainDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]){
        [_mainDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
-(void)scrollViewDidScroll: (UIScrollView*)scrollView{
    
    if([_mainDelegate respondsToSelector:@selector(scrollGridViewDidScroll:)]){
        [_mainDelegate scrollGridViewDidScroll:scrollView];
    }
    if (lastContentOffset > scrollView.contentOffset.y)
        _isAnime = NO;
    else if (lastContentOffset < scrollView.contentOffset.y)
        _isAnime = YES;
    
    lastContentOffset = scrollView.contentOffset.y;
}
#pragma mark - UIPinchGestureRecognizer methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
   
    return YES;
}
- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture{
 
    if (gesture.state == UIGestureRecognizerStateBegan){
        CGPoint p = [gesture locationInView:self];
        NSIndexPath *indexPath = [self indexPathForItemAtPoint:p];

        if([_mainDelegate respondsToSelector:@selector(didLongSelectItem:withTaggetCell:withIndex:)]){
            [_mainDelegate didLongSelectItem:self withTaggetCell:[self dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath]  withIndex:indexPath.row];
        }
    }
    
    

}

- (void)handleSingleTap:(UITapGestureRecognizer *)gesture{
 
    if (gesture.state == UIGestureRecognizerStateEnded){
        CGPoint p = [gesture locationInView:self];
        NSIndexPath *indexPath = [self indexPathForItemAtPoint:p];
        
        if([_mainDelegate respondsToSelector:@selector(didSelectItem:withTaggetCell:withIndex:)] && indexPath){
            [_mainDelegate didSelectItem:self withTaggetCell:[self dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath]  withIndex:indexPath.row];
        }
    }
}
#pragma mark - Service methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary  *)change context:(void *)context{
    
}
- (id) objectForKeyedSubscript:(id<NSCopying>)paramKey{
    NSObject<NSCopying> *keyAsObject = (NSObject<NSCopying> *)paramKey;
    if ([keyAsObject isKindOfClass:[NSString class]]){
        NSString *keyAsString = (NSString *)keyAsObject;
        if ([keyAsString isEqualToString:kRegisterClassKey] || [keyAsString isEqualToString:kContentKey]  || [keyAsString isEqualToString:kHeaderKey] || [keyAsString isEqualToString:kFooterKey] || [keyAsString isEqualToString:kRefreshEnabled] || [keyAsString isEqualToString:kRefreshTextEnabled] || [keyAsString isEqualToString:kBouncesEnabled]  || [keyAsString isEqualToString:kGridType] || [keyAsString isEqualToString:kLongPressEnable] || [keyAsString isEqualToString:kDelegateKey]  || [keyAsString isEqualToString:kSettingsCell]){
            return [self valueForKey:keyAsString];
        }
    }
    return nil;
}
- (void) setObject:(id)paramObject forKeyedSubscript:(id<NSCopying>)paramKey{
    NSObject<NSCopying> *keyAsObject = (NSObject<NSCopying> *)paramKey;
    if ([keyAsObject isKindOfClass:[NSString class]]){
        NSString *keyAsString = (NSString *)keyAsObject;
        if ([keyAsString isEqualToString:kRegisterClassKey] || [keyAsString isEqualToString:kContentKey] || [keyAsString isEqualToString:kHeaderKey] || [keyAsString isEqualToString:kFooterKey] || [keyAsString isEqualToString:kRefreshEnabled] || [keyAsString isEqualToString:kRefreshTextEnabled] || [keyAsString isEqualToString:kBouncesEnabled] || [keyAsString isEqualToString:kGridType] || [keyAsString isEqualToString:kLongPressEnable] || [keyAsString isEqualToString:kDelegateKey]  || [keyAsString isEqualToString:kSettingsCell]){
            [self setValue:paramObject forKey:keyAsString];
        }
    }
}
- (id)valueForKey:(NSString *)key{
    if([key isEqualToString:kContentKey]){
        return  content;
    } else if([key isEqualToString:kHeaderKey]){
        return  headerView;
    } else if([key isEqualToString:kFooterKey]){
        return  footerView;
    }
    return  nil;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    
    if([key isEqualToString:kRegisterClassKey]){
        _kRegisterClassKey = key;
        [self registerClass:NSClassFromString(value) forCellWithReuseIdentifier:CellIdentifier];
        [self reloadData];
    } else if([key isEqualToString:kContentKey]){
        _kContentKey = key;
        content = (NSArray*)value;
        [self reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([_mainDelegate respondsToSelector:@selector(isShowSearch:withState:)]){
         
                if([[TRManager sharedInstance]isParamValid:content]){
                    if([[TRManager sharedInstance]isParamValid:content[0]]){
                        NSArray *paths = (NSArray*)content[0];
                        if(paths.count > 0){
                            CGFloat posY = (paths.count / (CGRectGetWidth(self.frame) / sizeItem.width)) * sizeItem.height;
                            [_mainDelegate isShowSearch:self withState:posY > self.frame.size.height  ? NO : YES];
                        }
                    }
                }
            }
        });
        
    } else if([key isEqualToString:kHeaderKey]){
        _kHeaderKey = key;
        headerView = (UIView*)value;
        [self reloadData];
    } else if([key isEqualToString:kFooterKey]){
        _kFooterKey = key;
        footerView = (UIView*)value;
        [self reloadData];
    } else if([key isEqualToString:kRefreshEnabled]){
        _kRefreshEnabled = key;
        isRefreshEnabled = ((NSNumber*)value).boolValue;
        if(isRefreshEnabled)
            [self addSubview:refreshControl];
    } else if([key isEqualToString:kRefreshTextEnabled]){
        _kRefreshTextEnabled = key;
        isRefreshTextEnabled = ((NSNumber*)value).boolValue;
        if(isRefreshTextEnabled){
            refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Потяните для обновления..."];
        }
    } else if([key isEqualToString:kBouncesEnabled]){
        _kBouncesEnabled = key;
        isBouncesEnabled = ((NSNumber*)value).boolValue;
        self.alwaysBounceVertical = isBouncesEnabled;
    } else if([key isEqualToString:kGridType]){
        _kGridType = key;
        gridType = ((NSNumber*)value).integerValue;
    } else if([key isEqualToString:kDelegateKey]){
        _kDelegateKey = key;
        cellDelegate = value;
    } else if([key isEqualToString:kSettingsCell]){
        _kSettingsCell = key;
        settingsCell = (NSDictionary*)value;
        [self reloadData];
    } else if([key isEqualToString:kLongPressEnable]){
        _kLongPressEnable = key;
        isLongPressEnable = ((NSNumber*)value).boolValue;
        if(isLongPressEnable){
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
            longPress.minimumPressDuration = 0.3;
            longPress.numberOfTouchesRequired = 1;
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            singleTap.numberOfTouchesRequired = 1;
            singleTap.numberOfTapsRequired = 1;
            [singleTap requireGestureRecognizerToFail:longPress];
            
            [self addGestureRecognizer:longPress];
            [self addGestureRecognizer:singleTap];
        }

    }
}

@end
