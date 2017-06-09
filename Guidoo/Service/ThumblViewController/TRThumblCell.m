//
//  TRThumblCell.m
//  DatingApp
//
//  Created by Sergiy Bekker on 20.07.16.
//  Copyright © 2016 Sergiy Bekker. All rights reserved.
//

#import "TRThumblCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface TRThumblCell (){
    UIImageView* imageView;
    UIButton* chekBut;
    UIButton* undoBut;
}

@end

@implementation TRThumblCell

- (void)setContent:(NSDictionary *)content{
    
    _content = content;
    if([[TRManager sharedInstance]isParamValid:_content]){
        [imageView setImage:(UIImage*)_content[@"thumbl"]];
  
        imageView.layer.borderColor = [UIColor clearColor].CGColor;
        imageView.layer.borderWidth = 0.f;
        if(((NSNumber*)_content[@"isSelected"]).boolValue){
            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            imageView.layer.borderWidth = 3.f;
        }
        [self.contentView bringSubviewToFront:undoBut];
        [self setNeedsLayout];
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:imageView];
        
        UIImage* image = [UIImage sizedImageWithName:@"ic-cross-photo-delele"];
        chekBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [chekBut setImage:image forState:UIControlStateNormal];
        [chekBut setImage:image forState:UIControlStateHighlighted];
        [chekBut setBackgroundColor:[UIColor colorWithRed:255.f / 255.f green:60.f / 255.f blue:34.f / 255.f alpha:1.f]];
        CALayer*l = [chekBut layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:9.f];
        [self.contentView addSubview:chekBut];
        
        undoBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [undoBut addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
        [undoBut setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:undoBut];
        
    }
    
    return self;
    
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [imageView setFrame:self.contentView.bounds];
    [chekBut setFrame:CGRectMake(CGRectGetWidth(imageView.frame) - 15.5f, CGRectGetMinY(imageView.frame) - 4.f, 18.f, 18.f)];
    [undoBut setFrame:CGRectMake(CGRectGetWidth(imageView.frame) - CGRectGetWidth(imageView.frame) / 3 - 5.f, CGRectGetMinY(imageView.frame)- 4.f, CGRectGetWidth(imageView.frame) / 3 + 5.f , CGRectGetWidth(imageView.frame) / 3 + 5.f)];
    
}
- (void)clicked{
    if([_cellDelegate respondsToSelector:@selector(didRemoveCellItem:withIndex:)]){
        [_cellDelegate didRemoveCellItem:self withIndex:_index];
    }
}
@end
