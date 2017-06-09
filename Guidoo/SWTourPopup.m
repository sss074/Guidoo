//
//  SWTourPopup.m
//  Guidoo
//
//  Created by Sergiy Bekker on 04.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWTourPopup.h"
#import "SWPaymentController.h"

@interface SWTourPopup()

@property (nonatomic, strong) IBOutlet UIImageView* imgView;
@property (nonatomic, strong) IBOutlet UILabel* state;
@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UILabel* tour;
@property (nonatomic, strong) IBOutlet UILabel* deatil;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *stars;
@property (nonatomic, strong) IBOutlet UIButton* doneBut;
@end

@implementation SWTourPopup

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
        _state.text = [_content.bookingState uppercaseString];
        if([_content.bookingState isEqualToString:@"DECLINED"]){
            _state.textColor = [UIColor redColor];
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
    
    if([button isEqual:_doneBut]){
        if([_content.bookingState isEqualToString:@"ACCEPTED"]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController* controller = [storyboard instantiateViewControllerWithIdentifier:@"PaymentNavController"];
            SWTabbarController* tabBarController =(SWTabbarController*)self.window.rootViewController;
            UINavigationController* nav = (UINavigationController*)[tabBarController selectedViewController];
            nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [nav presentViewController: controller animated: YES completion:nil];
        }
        [SWWebManager sharedManager].curPopup = nil;
        [self removeFromSuperview];
    }
}
@end
