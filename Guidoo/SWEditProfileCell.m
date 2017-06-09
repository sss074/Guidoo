//
//  SWEditProfileCell.m
//  Guidoo
//
//  Created by Sergiy Bekker on 11.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWEditProfileCell.h"

@interface SWEditProfileCell ()

@property (nonatomic, strong) IBOutlet NSLayoutConstraint* imgW;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* imgH;

@end


@implementation SWEditProfileCell

- (void)setContent:(NSDictionary *)content{
    
    _content = content;
    
    if(_content != nil){
        UIImage* image = [UIImage imageNamed:_content[@"image"]];
        _imgW.constant = image.size.width;
        _imgH.constant = image.size.height;
        [_imgView setImage:image];
        _title.text = _content[@"title"];
        [_imgView updateConstraints];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];

    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}



@end
