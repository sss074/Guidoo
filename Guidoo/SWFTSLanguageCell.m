//
//  SWFTSLanguageCell.m
//  Guidoo
//
//  Created by Sergiy Bekker on 03.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWFTSLanguageCell.h"

@interface SWFTSLanguageCell ()


@property (nonatomic,strong)IBOutlet UILabel* label;


@end


@implementation SWFTSLanguageCell

- (void)setContent:(SWLanguage*) content{
    _content = content;
    
    if(_content != nil){
        [_swith setSelected:YES];
        _label.text = _content.name;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

#pragma  mark - Action methods
- (IBAction)clicked:(id)sender{
    
    UIButton* button = (UIButton*)sender;
    [button setSelected:!button.isSelected];
}

@end
