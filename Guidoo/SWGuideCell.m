//
//  SWGuideCell.m
//  Guidoo
//
//  Created by Sergiy Bekker on 06.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWGuideCell.h"

@interface SWGuideCell ()

@property (nonatomic, strong) IBOutlet UIImageView* bgView;
@property (nonatomic, strong) IBOutlet UIImageView* imgView;
@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UILabel* professional;
@property (nonatomic, strong) IBOutlet UILabel* deatil;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *stars;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* proffHight;
@property (nonatomic, strong) IBOutlet UIImageView* accesView;
@end


@implementation SWGuideCell

- (void)setIsMore:(BOOL)isMore{
    _isMore = isMore;
    
    [_bgView setHidden:_isMore];
    [_accesView setHidden:_isMore];
    [self.contentView setBackgroundColor:_isMore ? [UIColor whiteColor] : [UIColor clearColor]];
    
}
- (void)setContent:(SWGuide*) content{
    _content = content;
    
    if(_content != nil){
        [_professional setHidden:YES];
        _proffHight.constant = 0;
        
        _name.text = [NSString stringWithFormat:@"%@ %@",_content.firstName,_content.lastName];
        NSInteger star = ((NSNumber*)_content.rating).integerValue;
        for(UIImageView* obj in _stars){
            [obj setImage:[UIImage imageNamed:@"star_normal"]];
        }
        for(int i = 0; i < star; i++){
            UIImageView* obj = _stars[i];
             [obj setImage:[UIImage imageNamed:@"star_act"]];
        }
        _deatil.text = ([_content.resume isEqualToString:@""] || _content.resume == nil)  ? @"Parameter is missing" : _content.resume;
       
        
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
    UIImage *streachedImage = [[UIImage imageNamed:@"guids_cell"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 15)];
    [_bgView setImage:streachedImage];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}



@end
