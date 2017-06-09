//
//  SWRateView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 24.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWRatePopup.h"

@interface SWRatePopup (){
    NSInteger rating;
}

@property (nonatomic, strong) IBOutlet UIImageView* imgView;
@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UILabel* tour;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *stars;
@property (nonatomic, strong) IBOutlet UIButton* doneBut;
@property (nonatomic, strong) IBOutlet UIButton* skipBut;
@end

@implementation SWRatePopup

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
        _tour.text = ([_content.tour.name isEqualToString:@""] || _content.tour.name == nil)  ? @"Parameter is missing" : _content.tour.name;
        
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    rating = 0;
    [_imgView setCornerRadius:CGRectGetHeight(_imgView.frame) / 2];
    [_imgView setClipsToBounds:YES];
}
#pragma  mark - Action methods

- (IBAction)clicked:(id)sender{
    
    UIButton* button = (UIButton*)sender;

    if([button isEqual:_doneBut]){
        if(rating == 0){
            TheApp;
            [app.window sendSubviewToBack:self];
      
            UIAlertController* alert= [UIAlertController alertControllerWithTitle:nil message:@"It is necessary to put a rating. Select the number of stars." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [app.window bringSubviewToFront:self];
            }];
            [alert addAction:actionOK];
            [app.window.rootViewController presentViewController:alert animated:YES completion:nil];
            return;
        }
        SWLogin *objLogin = [self objectDataForKey:userLoginInfo];
        if(objLogin != nil){
            NSString* param = [NSString stringWithFormat:@"bookingId=%ld&userId=%ld&sessionToken=%@&rate=%ld",((NSNumber*)_content.bookingId).integerValue,((NSNumber*)objLogin.userId).integerValue,objLogin.sessionToken,rating];
            [[SWWebManager sharedManager]rateTour:param success:nil];
            [SWWebManager sharedManager].curPopup = nil;
            [self removeFromSuperview];
        }
    } else if ([button isEqual:_skipBut]){
        [SWWebManager sharedManager].curPopup = nil;
        [self removeFromSuperview];
    } else if ([button isEqual:_stars[0]]){
        [_stars[0] setSelected:NO];
        [_stars[1] setSelected:NO];
        [_stars[2] setSelected:NO];
        [_stars[3] setSelected:NO];
        [_stars[4] setSelected:NO];
        [_stars[0] setSelected:YES];
        rating = 1;
    } else if ([button isEqual:_stars[1]]){
        [_stars[0] setSelected:NO];
        [_stars[1] setSelected:NO];
        [_stars[2] setSelected:NO];
        [_stars[3] setSelected:NO];
        [_stars[4] setSelected:NO];
        [_stars[0] setSelected:YES];
        [_stars[1] setSelected:YES];
        rating = 2;
    } else if ([button isEqual:_stars[2]]){
        [_stars[0] setSelected:NO];
        [_stars[1] setSelected:NO];
        [_stars[2] setSelected:NO];
        [_stars[3] setSelected:NO];
        [_stars[4] setSelected:NO];
        [_stars[0] setSelected:YES];
        [_stars[1] setSelected:YES];
        [_stars[2] setSelected:YES];
        rating = 3;
    } else if ([button isEqual:_stars[3]]){
        [_stars[0] setSelected:NO];
        [_stars[1] setSelected:NO];
        [_stars[2] setSelected:NO];
        [_stars[3] setSelected:NO];
        [_stars[4] setSelected:NO];
        [_stars[0] setSelected:YES];
        [_stars[1] setSelected:YES];
        [_stars[2] setSelected:YES];
        [_stars[3] setSelected:YES];
        rating = 4;
    } else if ([button isEqual:_stars[4]]){
        [_stars[0] setSelected:NO];
        [_stars[1] setSelected:NO];
        [_stars[2] setSelected:NO];
        [_stars[3] setSelected:NO];
        [_stars[4] setSelected:NO];
        [_stars[0] setSelected:YES];
        [_stars[1] setSelected:YES];
        [_stars[2] setSelected:YES];
        [_stars[3] setSelected:YES];
        [_stars[4] setSelected:YES];
        rating = 5;
    }
    
}

@end
