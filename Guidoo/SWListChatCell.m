//
//  SWMessageCell.m
//  Guidoo
//
//  Created by Sergiy Bekker on 27.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWListChatCell.h"
#import "CustomBadge.h"

@interface SWListChatCell (){
     CustomBadge* badgeMessage;
}
@property (nonatomic, strong) IBOutlet UIImageView* imgView;
@property (nonatomic, strong) IBOutlet UIImageView* stateView;
@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UILabel* message;
@property (nonatomic, strong) IBOutlet UILabel* time;
@end

@implementation SWListChatCell

- (void)setContent:(SWChatMessage *)content{
    _content = content;
    
    if(_content != nil){
        if(_content.regId != nil){
            NSLog(@"%@",[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)_content.regId).integerValue,kImageFBNextBaseApiUrl]);
            NSURL *thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld%@",kImageFBPrevBaseApiUrl,((NSNumber*)_content.regId).integerValue,kImageFBNextBaseApiUrl]];
            [_imgView sd_setImageWithURL:thumbnailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(image != nil){
                    [_imgView setImage:image];
                }
            }];
        }
        _name.text = [NSString stringWithFormat:@"%@ %@",_content.firstName,_content.lastName];
        _message.text = _content.message;
        
        [_stateView setImage:_content.isIncome ?  [UIImage imageNamed:@"arrowLeft"] : [UIImage imageNamed:@"arrowRight"]];
        
        [badgeMessage removeFromSuperview];
        badgeMessage = nil;
        [_time setHidden:NO];
        if(((NSNumber*)_content.badgeCout).integerValue > 0){
            [_time setHidden:YES];
            BadgeStyle* style = [BadgeStyle new];
            style.badgeTextColor = [UIColor whiteColor];
            style.badgeInsetColor = [UIColor colorWithRed:251.f / 255.f green:129.f / 255.f blue:129.f / 255.f alpha:1.f];
            style.badgeFrameColor = [UIColor clearColor];
            style.badgeFrame = YES;
            style.badgeShining = NO;
            style.badgeFontType =  BadgeStyleFontTypeHelveticaNeueLight;
            badgeMessage = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%ld",((NSNumber*)_content.badgeCout).integerValue] withStyle:style];
            [badgeMessage setFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 15.f - badgeMessage.frame.size.width, CGRectGetHeight(self.contentView.frame) / 2 - badgeMessage.frame.size.height / 2, badgeMessage.frame.size.width, badgeMessage.frame.size.height)];
            [self.contentView addSubview:badgeMessage];
            [self.contentView bringSubviewToFront:badgeMessage];
        } else {
             NSTimeInterval seconds = [_content.sentTime longLongValue] / 1000;
            _time.text = [self formattedStringFromDuration:seconds];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [_imgView setCornerRadius:CGRectGetHeight(_imgView.frame) / 2];
    [_imgView setClipsToBounds:YES];
}



@end
