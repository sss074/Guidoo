//
//  SWPhoneProfileView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 12.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWPhoneProfileView.h"
#import "JJMaterialTextField.h"

@interface SWPhoneProfileView ()<UITextFieldDelegate>

@property (nonatomic,strong)IBOutlet JJMaterialTextfield* firstField;
@property (nonatomic,strong)IBOutlet JJMaterialTextfield* lastField;
@property (nonatomic,strong)IBOutlet UIButton* doneBut;

@end

@implementation SWPhoneProfileView


- (void)awakeFromNib{
    [super awakeFromNib];
    
    _firstField.enableMaterialPlaceHolder = YES;
    _firstField.errorColor = [UIColor redColor];
    _firstField.lineColor= [UIColor blackColor];
    _firstField.tintColor=[UIColor blackColor];
    _firstField.placeholderAttributes = @{NSFontAttributeName : [UIFont fontWithName:OPENSANS size:16.f],
                                         NSForegroundColorAttributeName : [UIColor colorWithRed:142.f / 255.f green:142.f / 255.f blue:147.f / 255.f alpha:1.f]};
    
    _lastField.enableMaterialPlaceHolder = YES;
    _lastField.errorColor = [UIColor redColor];
    _lastField.lineColor= [UIColor blackColor];
    _lastField.tintColor=[UIColor blackColor];
    _lastField.placeholderAttributes = @{NSFontAttributeName : [UIFont fontWithName:OPENSANS size:16.f],
                                          NSForegroundColorAttributeName : [UIColor colorWithRed:142.f / 255.f green:142.f / 255.f blue:147.f / 255.f alpha:1.f]};
}

#pragma  mark - Action methods

- (IBAction)clicked:(id)sender{

    UIButton* button = (UIButton*)sender;
    
    [_firstField resignFirstResponder];
    [_lastField resignFirstResponder];
    
    if([_firstField.text isEqualToString:@""] || [_lastField.text isEqualToString:@""]){
        if([_delegate respondsToSelector:@selector(alertMessage: withMessage:)]){
            [_delegate alertMessage:self withMessage:@"All fields must be filled in"];
        }
        return;
    }
    if([button isEqual:_doneBut]){
        SWLogin *object = [self objectDataForKey:currentLoginKey];
        if(object != nil){
            object.firstName = _firstField.text;
            object.lastName = _lastField.text;
            [self setObjectDataForKey:object forKey:currentLoginKey];
        }
        
        if([_delegate respondsToSelector:@selector(backPress:)]){
            [_delegate backPress:self];
        }

    }
}
#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)_textField{
    
    [_textField resignFirstResponder];

    return  YES;
}

@end
