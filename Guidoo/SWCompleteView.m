//
//  SWCompleteView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 19.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWCompleteView.h"

@interface SWCompleteView ()
@property (nonatomic,weak) IBOutlet UIButton *doneButton;
@end


@implementation SWCompleteView

- (void)awakeFromNib{
    [super awakeFromNib];

}

#pragma mark - Action methods



- (IBAction)clicked:(id)sender{
    
    
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_doneButton]){
        if([_delegate respondsToSelector:@selector(backPress:)]){
            [_delegate backPress:self];
        }
    }
}
@end
