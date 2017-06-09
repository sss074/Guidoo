//
//  SWInvitePopup.m
//  Guidoo
//
//  Created by Sergiy Bekker on 13.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWInvitePopup.h"

@interface SWInvitePopup()
@property (nonatomic, strong) IBOutlet UIImageView* imgView;
@property (nonatomic, strong) IBOutlet UILabel* duration;
@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UILabel* tour;
@property (nonatomic, strong) IBOutlet UILabel* deatil;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *stars;
@property (nonatomic, strong) IBOutlet UIButton* acceptBut;
@property (nonatomic, strong) IBOutlet UIButton* declineBut;
@end

@implementation SWInvitePopup

- (void)setContent:(SWBookInfo *)content{
    _content = content;
    
    if(_content != nil){
        if([self isParamValid:_content.guide.regId]){
            NSLog(@"%@",[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)_content.guide.regId).integerValue,kImageFBNextBaseApiUrl]);
            NSURL *thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)_content.guide.regId).integerValue,kImageFBNextBaseApiUrl]];
            [_imgView sd_setImageWithURL:thumbnailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image != nil){
                    [_imgView setImage:image];
                }
            }];
        }
        
        _name.text = [NSString stringWithFormat:@"%@ %@",_content.guide.firstName,_content.guide.lastName];
        NSInteger star = ((NSNumber*)_content.tour.rating).integerValue;
        for(UIImageView* obj in _stars){
            [obj setImage:[UIImage imageNamed:@"star_normal"]];
        }
        for(int i = 0; i < star; i++){
            UIImageView* obj = _stars[i];
            [obj setImage:[UIImage imageNamed:@"star_act"]];
        }
        _duration.text = [self isParamValid:_content.tour.durationHours] ? [NSString stringWithFormat:@"%.1f hour",((NSNumber*)_content.tour.durationHours).floatValue] : nil;
        _tour.text = ([_content.tour.name isEqualToString:@""] || _content.tour.name == nil)  ? @"Parameter is missing" : _content.tour.name;
        _deatil.text = ([_content.tour.descriptions isEqualToString:@""] || _content.tour.descriptions == nil)  ? @"Parameter is missing" : _content.tour.descriptions;
        
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_imgView setCornerRadius:CGRectGetHeight(_imgView.frame) / 2];
    [_imgView setClipsToBounds:YES];
}
#pragma  mark - Action methods

- (IBAction)clicked:(id)sender{

    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_acceptBut]){
        SWLogin *objLogin = [self objectDataForKey:userLoginInfo];
        if(objLogin != nil){
            NSString* param = [NSString stringWithFormat:@"tourId=%ld&userId=%ld&sessionToken=%@",((NSNumber*)_content.tour.tourId).integerValue,((NSNumber*)objLogin.userId).integerValue,objLogin.sessionToken];
            [[SWWebManager sharedManager]bookTour:param withTourID:_content.tour.tourId success:^{
                [self showAlertMessage:[NSString stringWithFormat:@"%@ successfully ordered",_content.tour.name]];
            }];
        }
    }
    [SWWebManager sharedManager].curPopup = nil;
    [self removeFromSuperview];
}
@end
