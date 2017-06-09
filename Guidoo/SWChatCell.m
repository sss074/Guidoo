//
//  SWChatCell.m
//  Guidoo
//
//  Created by Sergiy Bekker on 29.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWChatCell.h"

@interface SWChatCell ()
@property (nonatomic, strong) IBOutlet UIImageView* imgView;
@property (nonatomic, strong) IBOutlet UILabel* message;
@property (nonatomic, strong) IBOutlet UILabel* time;
@property (nonatomic, strong) IBOutlet UIView* contener;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* contenerH;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* contenerL;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* contenerT;
@end

@implementation SWChatCell

- (void)setContent:(SWChatMessage *)content{
    _content = content;
    
    if(_content != nil){
      
        _message.text = _content.message;
        _message.font = [UIFont fontWithName:@"OpenSans" size:16.f];
         CGSize size = [self sizeWithText:_message.text width:CGRectGetWidth([UIScreen mainScreen].bounds) - 90.f font:_message.font];
        _contenerH.constant = size.height + 35.f;
        
        NSTimeInterval seconds = [_content.sentTime longLongValue] / 1000;
        _time.text = [self formattedStringFromDuration:seconds];
        
        UIImage *streachedMaxImage = nil;
        if(((NSNumber*)_content.isIncome).boolValue){
            streachedMaxImage = [[UIImage imageNamed:@"mes_out"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.f, 15.f, 10.f, 15.f)];
            streachedMaxImage =[UIImage imageWithCGImage: streachedMaxImage.CGImage scale:1.0 orientation:(UIImageOrientationUpMirrored)];
            _imgView.tintColor = [UIColor whiteColor];
            _time.textAlignment = NSTextAlignmentLeft;
            _message.textAlignment = NSTextAlignmentLeft;
            _contenerT.constant = CGRectGetWidth([UIScreen mainScreen].bounds) - (size.width + 40.f);
            _contenerL.constant =  10.f;
        } else {
            streachedMaxImage = [[UIImage imageNamed:@"mess_in"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.f, 15.f, 10.f, 15.f)];
            _time.textAlignment = NSTextAlignmentRight;
            _message.textAlignment = NSTextAlignmentRight;
            _imgView.tintColor = [UIColor redColor];
            _contenerL.constant = CGRectGetWidth([UIScreen mainScreen].bounds) - (size.width + 40.f);
            _contenerT.constant =  10.f;

        }
        [_imgView setImage:streachedMaxImage];


    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
   [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}



@end
