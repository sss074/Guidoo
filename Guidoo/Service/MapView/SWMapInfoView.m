//
//  SWMapInfoView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 02.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWMapInfoView.h"

@interface SWMapInfoView ()

@property (nonatomic, strong) IBOutlet UIImageView* imgView;
@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UILabel* resume;
@property (nonatomic, strong) IBOutlet UILabel* distance;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *stars;
@property (nonatomic, strong) IBOutlet UIButton* infoBut;
@end

@implementation SWMapInfoView

- (void)setContent:(SWGuide *)content{
    _content = content;
    
    if(_content != nil){
        _name.text = [NSString stringWithFormat:@"%@ %@",_content.firstName,_content.lastName];
        NSInteger star = ((NSNumber*)_content.rating).integerValue;
        for(UIImageView* obj in _stars){
            [obj setImage:[UIImage imageNamed:@"star_normal"]];
        }
        for(int i = 0; i < star; i++){
            UIImageView* obj = _stars[i];
            [obj setImage:[UIImage imageNamed:@"star_act"]];
        }
        _resume.text = ([_content.resume isEqualToString:@""] || _content.resume == nil)  ? @"Parameter is missing" : _content.resume;
        
        NSNumber* distanceMeters = _content.distanceMeters;
        if(distanceMeters.integerValue < 1000){
            _distance.text = [NSString stringWithFormat:@"%ld m",distanceMeters.integerValue];
        } else {
            _distance.text = [NSString stringWithFormat:@"%ld km",distanceMeters.integerValue / 1000];
        }
        if(_content.regId != nil){
            NSLog(@"%@",[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)_content.regId).integerValue,kImageFBNextBaseApiUrl]);
            NSURL *thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)_content.regId).integerValue,kImageFBNextBaseApiUrl]];
            [_imgView sd_setImageWithURL:thumbnailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image != nil){
                    [_imgView setImage:image];
                }
            }];
        }

    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_imgView setCornerRadius:CGRectGetHeight(_imgView.frame) / 2];
    [_imgView setClipsToBounds:YES];
}

- (IBAction)clicked:(id)sender{
    
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_infoBut]){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showInfoGuid" object:_content];
    }
    
}

@end
