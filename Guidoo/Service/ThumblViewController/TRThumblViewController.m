//
//  TRThumblViewController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 28.03.17.
//  Copyright © 2016 Sergiy Bekker. All rights reserved.
//

#import "TRThumblViewController.h"
#import "TRThumblCell.h"

@interface TRThumblViewController () <TRGridControlDelegate,TRThumblCellDelegate,UIScrollViewDelegate> {
    TRGridControl* gridView;
    UIImageView *imageView;
    UIImageView *borderImageView;
    UIView *bottomView;
    UIImage *newImage;
    UIButton* cancelBut;
    UIButton* doneBut;
    UIView *separView1;
    UIView *separView2;
    UIView *separView3;
    UIView *separView4;
    float x;
    float y;
    int firstX;
    int firstY;
    NSMutableArray* editImages;
    NSMutableArray* thumblImages;
    NSMutableArray* orignImages;
    NSMutableArray* orignViews;
    NSInteger curIndex;

 
}
@property (retain, nonatomic) UIScrollView * moveView;
@end

@implementation TRThumblViewController

- (void)setContent:(NSDictionary *)content{
    _content = content;
    if([[TRManager sharedInstance]isParamValid:_content]){
        editImages = [[NSMutableArray alloc]initWithArray:_content[@"images"]];
        thumblImages = [[NSMutableArray alloc]initWithArray:_content[@"thumbl"]];
        orignImages = [[NSMutableArray alloc]initWithArray:_content[@"images"]];
        orignViews = [[NSMutableArray alloc]initWithCapacity:orignImages.count];
       
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    doneBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBut setTitleColor:[UIColor colorWithRed:3.f / 255.f green:87.f / 255.f blue:121.f / 255.f alpha:1.f] forState:UIControlStateNormal];
    [doneBut setTitle:[[TRSettings sharedInstance]languageSelectedStringForKey:@"az_58"] forState:UIControlStateNormal];
    [doneBut setTitle:[[TRSettings sharedInstance]languageSelectedStringForKey:@"az_58"] forState:UIControlStateHighlighted];
    [doneBut addTarget:self action:@selector(donePress) forControlEvents:UIControlEventTouchUpInside];
   
    doneBut.titleLabel.font = (IS_IPHONE_4 || IS_IPHONE_5) ? [UIFont fontWithName:OPENSANSTEXTREGULAR size:12.f] : [UIFont fontWithName:OPENSANSTEXTREGULAR size:15.f];
    
    CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
    CGRect rect = [doneBut.titleLabel.text boundingRectWithSize:maximumLabelSize
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName : doneBut.titleLabel.font}
                                                          context:nil];
    
    
    CGSize expectedLabelSize = rect.size;
    [doneBut setFrame:CGRectMake(0, 0, expectedLabelSize.width, CGRectGetHeight(self.navigationController.navigationBar.frame))];
    
    
    cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut setTitleColor:[UIColor colorWithRed:3.f / 255.f green:87.f / 255.f blue:121.f / 255.f alpha:1.f] forState:UIControlStateNormal];
    [cancelBut setTitle:[[TRSettings sharedInstance]languageSelectedStringForKey:@"title_cancel"] forState:UIControlStateNormal];
    [cancelBut setTitle:[[TRSettings sharedInstance]languageSelectedStringForKey:@"title_cancel"] forState:UIControlStateHighlighted];
    [cancelBut addTarget:self action:@selector(cancelPress) forControlEvents:UIControlEventTouchUpInside];
    cancelBut.titleLabel.font = (IS_IPHONE_4 || IS_IPHONE_5) ? [UIFont fontWithName:OPENSANSTEXTREGULAR size:12.f]: [UIFont fontWithName:OPENSANSTEXTREGULAR size:15.f];
 
    rect = [cancelBut.titleLabel.text boundingRectWithSize:maximumLabelSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName : doneBut.titleLabel.font}
                                                  context:nil];
    
    
    expectedLabelSize = rect.size;
    [cancelBut setFrame:CGRectMake(0, 0, expectedLabelSize.width, CGRectGetHeight(self.navigationController.navigationBar.frame))];
    
    
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc]initWithCustomView:doneBut];
    self.navigationItem.rightBarButtonItem = doneItem;
    UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBut];
    self.navigationItem.leftBarButtonItem = cancelItem;

}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [TRSettings sharedInstance].screendDate = [NSDate date];
    [[TRSettings sharedInstance] flurryTimeInterval:@"Время использования экрана \"Создать миниатюру\""];
    
    [self simpleTitle:[[TRSettings sharedInstance]languageSelectedStringForKey:@"title_thumbnail"]];
    self.titleLabel.font =  [UIFont fontWithName:OPENSANSREGULAR size:16.f];
    if(IS_IPHONE_5 || IS_IPHONE_4){
        self.titleLabel.font =  [UIFont fontWithName:OPENSANSREGULAR size:12.f];
    }
    
    

    gridView = [[TRGridControl alloc]initWithFrame:CGRectMake(2.f * [TRSettings sharedInstance].factor, CGRectGetWidth(self.view.frame),  CGRectGetWidth(self.view.frame) - 4.f * [TRSettings sharedInstance].factor,MAINHIGHT - CGRectGetWidth(self.view.frame)) withAtrributes:@{@"spaceLine":[NSNumber numberWithFloat:11.f  * [TRSettings sharedInstance].factor],
                                                                                                                                                                                                                @"spaceInteritem":[NSNumber numberWithFloat:0.f],
                                                                                                                                                                                                                @"widghtCell":[NSNumber numberWithFloat:87.f * [TRSettings sharedInstance].factor + 5.f  * [TRSettings sharedInstance].factor],
                                                                                                                                                                                                                @"hightCell":[NSNumber numberWithFloat:87.f * [TRSettings sharedInstance].factor + 6.f  * [TRSettings sharedInstance].factor],
                                                                                                                                                                                                                @"direction":[NSNumber numberWithInteger:UICollectionViewScrollDirectionVertical]
                                                                                                                                                                                                                }];
    gridView[@"kDelegateKey"] = self;
    gridView.mainDelegate = self;
    gridView[@"kRegisterClassKey"] = @"TRThumblCell";
    gridView[@"kRefreshEnabled"] = @(NO);
    gridView[@"kBouncesEnabled"] = @(NO);
    gridView[@"kHeaderKey"] = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  CGRectGetWidth(self.view.frame), 10)];
    gridView[@"kLongPressEnable"] = @(NO);
    [gridView setBackgroundColor:[UIColor blackColor]];
    gridView[@"kGridType"] = @(TRGridType_Base);
    [self.view addSubview:gridView];
    gridView[@"kContentKey"] = @[thumblImages];
    
    
    borderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.width)];
    borderImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    borderImageView.layer.borderWidth = 1.f;
    [self.view addSubview:borderImageView];
    
    separView1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(borderImageView.frame) / 3, 0.f, 1.f, CGRectGetHeight(borderImageView.frame))];
    [separView1 setBackgroundColor:WHITECOLOR];
    [self.view addSubview:separView1];
    [self.view bringSubviewToFront:separView1];
    
    separView2 = [[UIView alloc]initWithFrame:CGRectMake(2 * CGRectGetWidth(borderImageView.frame) / 3, 0.f, 1.f, CGRectGetHeight(borderImageView.frame))];
    [separView2 setBackgroundColor:WHITECOLOR];
    [self.view addSubview:separView2];
    [self.view bringSubviewToFront:separView2];
    
    separView3 = [[UIView alloc]initWithFrame:CGRectMake(0.f, CGRectGetHeight(borderImageView.frame) / 3, CGRectGetWidth(borderImageView.frame), 1.f)];
    [separView3 setBackgroundColor:WHITECOLOR];
    [self.view addSubview:separView3];
    [self.view bringSubviewToFront:separView3];
    
    separView4 = [[UIView alloc]initWithFrame:CGRectMake(0.f, 2 * CGRectGetHeight(borderImageView.frame) / 3, CGRectGetWidth(borderImageView.frame), 1.f)];
    [separView4 setBackgroundColor:WHITECOLOR];
    [self.view addSubview:separView4];
    [self.view bringSubviewToFront:separView4];
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetWidth(self.view.frame),  CGRectGetWidth(self.view.frame) ,MAINHIGHT - CGRectGetWidth(self.view.frame))];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:bottomView];
    
    
    [self.view bringSubviewToFront:gridView];
    
    for(int i = 0; i < orignImages.count; i++){

        UIImage* image = (UIImage*)orignImages[i];
        
        image = [self createImageForCurrentSize:image WithWidth:self.view.frame.size.width andHeight:self.view.frame.size.width];
        UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.width)];
        UIImageView *imgView =[[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, image.size.width, image.size.height))];
        image = (UIImage*)orignImages[i];
        [imgView setImage:image];
        imgView.tag = 100;
        [scrollView setContentSize:[imgView frame].size];
        [scrollView addSubview:imgView];
        [orignViews addObject:scrollView];
    }
    
    curIndex = 0;
    [self replaceImage:curIndex];
   
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[TRSettings sharedInstance] GATitle:@"Создать миниатюру"];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [[TRSettings sharedInstance] GATtimeInterval:@"Время использования экрана \"Создать миниатюру\"" withLastDate:[TRSettings sharedInstance].screendDate];
    
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    newImage = nil;
}
#pragma mark - TRThumblCell delegate methods
- (void)didRemoveCellItem:(TRThumblCell*)cell withIndex:(NSInteger)index{
    
    if(thumblImages.count == 1){
        [self cancelPress];
        return;
    }
  
    [thumblImages removeObjectAtIndex:index];
    [orignImages removeObjectAtIndex:index];
    [editImages removeObjectAtIndex:index];
    UIScrollView* scrollView = orignViews[index];
    UIImageView *imgView = [scrollView viewWithTag:100];
    [imgView removeFromSuperview];
    [scrollView removeFromSuperview];
    [orignViews removeObjectAtIndex:index];
    
    NSDictionary* dict = nil;
    for(int i = 0; i< thumblImages.count; i++){
        dict = (NSDictionary*)thumblImages[i];
        dict = [[TRManager sharedInstance]replaceValueForKey:dict withKey:@"isSelected" withValue:@(NO)];
        [thumblImages replaceObjectAtIndex:i withObject:dict];
    }
    dict = (NSDictionary*)thumblImages.firstObject;
    dict = [[TRManager sharedInstance]replaceValueForKey:dict withKey:@"isSelected" withValue:@(YES)];
    curIndex = 0;
    [thumblImages replaceObjectAtIndex:curIndex withObject:dict];
    [self replaceImage:curIndex];
    gridView[@"kContentKey"] = @[[NSNull null]];
    gridView[@"kContentKey"] = @[thumblImages];
    [gridView reloadItemsAtIndexPaths:[gridView indexPathsForVisibleItems]];
}
#pragma mark - TRGridControl delegate methods

- (void)didSelectItem:(TRGridControl*)obj withTaggetCell:(id)cell withIndex:(NSInteger)index{
    
    curIndex = index;

    NSDictionary* dict = nil;
    
    for(int i = 0; i< thumblImages.count; i++){
        dict = (NSDictionary*)thumblImages[i];
        dict = [[TRManager sharedInstance]replaceValueForKey:dict withKey:@"isSelected" withValue:@(NO)];
        [thumblImages replaceObjectAtIndex:i withObject:dict];
    }
    dict = (NSDictionary*)gridView[@"kContentKey"][0][index];
    dict = [[TRManager sharedInstance]replaceValueForKey:dict withKey:@"isSelected" withValue:@(YES)];
    [thumblImages replaceObjectAtIndex:index withObject:dict];
    

    [self replaceImage:curIndex];
    [gridView reloadItemsAtIndexPaths:[gridView indexPathsForVisibleItems]];
    
}

#pragma mark - Action methods
- (void)donePress{
    NSMutableArray* temp = [[NSMutableArray alloc]initWithCapacity:orignImages.count];
    for(int i = 0; i< thumblImages.count; i++){
        [orignImages replaceObjectAtIndex:i withObject:[((UIImage*)orignImages[i])normalizedImage]];
        [editImages replaceObjectAtIndex:i withObject:[((UIImage*)editImages[i])normalizedImage]];
        [temp addObject:@[orignImages[i],editImages[i]]];
    }
    if([_delegate respondsToSelector:@selector(thumblViewController:didFinishCroppingImage:)]){
        [_delegate thumblViewController:self didFinishCroppingImage:[NSArray arrayWithArray:temp]];
    }
    [self cancelPress];
}
- (void)cancelPress{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIScrollView delegate methods

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if(![scrollView isEqual:gridView]){
        UIImageView *imgView = [scrollView viewWithTag:100];
        return  imgView;
    }
    return  nil;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if(![scrollView isEqual:gridView]){
        UIImageView *imgView = [scrollView viewWithTag:100];
        imgView.frame = [self centeredFrameForScrollView:scrollView andUIView:imgView];
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{

    if(![scrollView isEqual:gridView]){
        CGPoint offset = scrollView.contentOffset;
        CGRect cropRect = CGRectOffset(borderImageView.frame, offset.x, offset.y);
        
        UIImage *currentImage = [self croppedImageOfView:scrollView withFrame:cropRect];
        if([[TRManager sharedInstance]isParamValid:currentImage]){
            [editImages replaceObjectAtIndex:curIndex withObject:currentImage];
            NSDictionary* thumbl = (NSDictionary*)thumblImages[curIndex];
            thumbl = [[TRManager sharedInstance]replaceValueForKey:thumbl withKey:@"thumbl" withValue:currentImage];
            [thumblImages replaceObjectAtIndex:curIndex withObject:thumbl];
            [gridView reloadItemsAtIndexPaths:[gridView indexPathsForVisibleItems]];
        }
        [orignViews replaceObjectAtIndex:curIndex withObject:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if(![scrollView isEqual:gridView]){
        CGPoint offset = scrollView.contentOffset;
        CGRect cropRect = CGRectOffset(borderImageView.frame, offset.x, offset.y);
        
        UIImage *currentImage = [self croppedImageOfView:scrollView withFrame:cropRect];
        if([[TRManager sharedInstance]isParamValid:currentImage]){
            [editImages replaceObjectAtIndex:curIndex withObject:currentImage];
            NSDictionary* thumbl = (NSDictionary*)thumblImages[curIndex];
            thumbl = [[TRManager sharedInstance]replaceValueForKey:thumbl withKey:@"thumbl" withValue:currentImage];
            [thumblImages replaceObjectAtIndex:curIndex withObject:thumbl];
            [gridView reloadItemsAtIndexPaths:[gridView indexPathsForVisibleItems]];
        }
        [orignViews replaceObjectAtIndex:curIndex withObject:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(![scrollView isEqual:gridView]){
        CGPoint offset = scrollView.contentOffset;
        CGRect cropRect = CGRectOffset(borderImageView.frame, offset.x, offset.y);
        
        UIImage *currentImage = [self croppedImageOfView:scrollView withFrame:cropRect];
        if([[TRManager sharedInstance]isParamValid:currentImage]){
            [editImages replaceObjectAtIndex:curIndex withObject:currentImage];
            NSDictionary* thumbl = (NSDictionary*)thumblImages[curIndex];
            thumbl = [[TRManager sharedInstance]replaceValueForKey:thumbl withKey:@"thumbl" withValue:currentImage];
            [thumblImages replaceObjectAtIndex:curIndex withObject:thumbl];
            [gridView reloadItemsAtIndexPaths:[gridView indexPathsForVisibleItems]];
        }
        [orignViews replaceObjectAtIndex:curIndex withObject:scrollView];
    }
}
#pragma mark - Service methods
- (void)replaceImage:(NSInteger)index{
    
    for(int i = 0; i < orignViews.count; i++){
        UIScrollView* scrollView = orignViews[i];
        [scrollView removeFromSuperview];
    }
    UIScrollView* scrollView = orignViews[index];
    scrollView.delegate = self;
    [scrollView setMinimumZoomScale:1];
    [scrollView setMaximumZoomScale:10];
    [scrollView setBouncesZoom:YES];
    [scrollView setBounces:NO];
    [self.view addSubview:scrollView];
    [self.view sendSubviewToBack:scrollView];
    
    [self.view bringSubviewToFront:borderImageView];
    [self.view bringSubviewToFront:bottomView];
    [self.view bringSubviewToFront:gridView];
   
}
- (UIImage*) croppedImageOfView:(UIView*) view withFrame:(CGRect) rect
{
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,0.0);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -rect.origin.x, -rect.origin.y);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *visibleScrollViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return visibleScrollViewImage;
}

-(UIImage*) createImageForCurrentSize:(UIImage*)image WithWidth:(float)needWidth andHeight:(float)needHeight{
    float width = image.size.width;
    float height = image.size.height;
    if (width != 0 && height != 0) {
        if (width >= needWidth && height >= needHeight) {
            if (width == needWidth && height == needHeight) {
                width = needWidth;
                height = needHeight;
            }else{
                if (needHeight/height > needWidth/width) {
                    width = needHeight*width/height;
                    height = needHeight;
                }else{
                    height = height* needWidth/width;
                    width = needWidth;
                }
            }
        }else if (width < needWidth && height >= needHeight){
            width = needWidth;
            height = height*needWidth/width;
        }else if (height < needHeight && width >= needWidth){
            width = needHeight*width/height;
            height = needHeight;
        }else if (width < needWidth && height < needHeight){
            width = needWidth;
            height = needHeight;

            /*if (needHeight/height < needWidth/width) {
                width = needHeight*width/height;
                height = needHeight;
            }else{
                width = needWidth;
                height = height* needWidth/width;
            }
            if (width < needWidth && height >= needHeight){
                width = needWidth;
                height = height*needWidth/width;
            }else if (height < needHeight && width >= needWidth){
                width = needHeight*width/height;
                height = needHeight;
            }*/
        }
    }else{
        width = 0;
        height = 0;
    }
    
    return [self image:image scaledToSize:CGSizeMake(width, height)];
}

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    UIGraphicsBeginImageContext(size);
   // CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}


- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView{
    CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}
@end
