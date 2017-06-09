//
//  SWGuideCell.m
//  Guidoo
//
//  Created by Sergiy Bekker on 05.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWTourCell.h"
#import <QuartzCore/QuartzCore.h>

@interface SWTourCell ()

@property (nonatomic, strong) IBOutlet UIImageView* imgView;
@property (nonatomic, strong) IBOutlet UIImageView* logoView;
@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UILabel* guid;
@property (nonatomic, strong) IBOutlet UILabel* price;
@property (nonatomic, strong) IBOutlet UILabel* guidinfo;
@property (nonatomic, strong) IBOutlet UILabel* photos;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *stars;


@end

@implementation SWTourCell

- (void)setGuidInfo:(SWGuide*) guidInfo{
    _guidInfo = guidInfo;
    
    if(_guidInfo != nil){

        _guid.text = [NSString stringWithFormat:@"%@ %@",_guidInfo.firstName,_guidInfo.lastName];
        NSInteger star = ((NSNumber*)_guidInfo.rating).integerValue;
        for(UIImageView* obj in _stars){
            [obj setImage:[UIImage imageNamed:@"star_normal"]];
        }
        for(int i = 0; i < star; i++){
            UIImageView* obj = _stars[i];
            [obj setImage:[UIImage imageNamed:@"star_act"]];
        }
        _guidinfo.text = ([_guidInfo.resume isEqualToString:@""] || _guidInfo.resume == nil)  ? @"Parameter is missing" : _guidInfo.resume;
        
        
        if(_guidInfo.regId != nil){
            NSLog(@"%@",[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)_guidInfo.regId).integerValue,kImageFBNextBaseApiUrl]);
            NSURL *thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)_guidInfo.regId).integerValue,kImageFBNextBaseApiUrl]];
            [_logoView sd_setImageWithURL:thumbnailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image != nil){
                    [_logoView setImage:image];
                }
            }];
        }
    }
}

- (void)setContent:(SWTour*) content{
    _content = content;
    
    if(_content != nil){
        _name.text = [self isParamValid:_content.name] ? _content.name : nil;
        _price.text = [NSString stringWithFormat:@"$ %ld",(NSInteger)(((NSNumber*)_content.pricePerHour).integerValue * ((NSNumber*)_content.durationHours).floatValue)];
        _photos.text = [NSString stringWithFormat:@"%ld",_content.imageIds.count];
        
        UIImage* image = [UIImage imageNamed:@"tour_bg"];
        [_imgView setImage:image];
        if(_content.imageIds.count > 0){
            NSLog(@"%@",[NSString stringWithFormat:@"%@%ld/tour/%ld/image/%ld",kImageBaseApiUrl,((NSNumber*)_content.guideId).integerValue,((NSNumber*)_content.tourId).integerValue,((NSNumber*)_content.imageIds[0]).integerValue]);
            NSURL *thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld/tour/%ld/image/%ld",kImageBaseApiUrl,((NSNumber*)_content.guideId).integerValue,((NSNumber*)_content.tourId).integerValue,((NSNumber*)_content.imageIds[0]).integerValue]];
            [_imgView sd_setImageWithURL:thumbnailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image != nil){
                    [_imgView setImage:image];
                }
            }];
        } else if([self isParamValid:_content.imageId]){
            NSLog(@"%@",[NSString stringWithFormat:@"%@%ld/tour/%ld/image/%ld",kImageBaseApiUrl,((NSNumber*)_content.guideId).integerValue,((NSNumber*)_content.tourId).integerValue,((NSNumber*)_content.imageId).integerValue]);
            NSURL *thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld/tour/%ld/image/%ld",kImageBaseApiUrl,((NSNumber*)_content.guideId).integerValue,((NSNumber*)_content.tourId).integerValue,((NSNumber*)_content.imageId).integerValue]];
            [_imgView sd_setImageWithURL:thumbnailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image != nil){
                    [_imgView setImage:image];
                }
            }];
            _photos.text = @"1";
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_logoView setCornerRadius:CGRectGetHeight(_logoView.frame) / 2];
    [_logoView setClipsToBounds:YES];
    UIImage* image = [UIImage imageNamed:@"tour_bg"];
    [self resizeImage:image withContainer:_imgView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_imgView.bounds byRoundingCorners:(UIRectCornerTopLeft) cornerRadii:CGSizeMake(5.0, 5.0)];
    maskPath.lineCapStyle = kCGLineCapRound;
    
    CAShapeLayer *maskLayer =  [CAShapeLayer layer];
    //maskLayer.frame = _imgView.bounds;
    maskLayer.path  = maskPath.CGPath;
    _imgView.layer.mask = maskLayer;
    [_imgView setNeedsDisplay];
     [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}

@end
