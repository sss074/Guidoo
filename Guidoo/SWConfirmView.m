//
//  SWConfirmView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 18.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWConfirmView.h"
#import <Firebase/Firebase.h>

@interface SWConfirmView()<UITextFieldDelegate>{
    UITextField* activeTextField;
    NSString* phoneNumber;
    UITextField* codeField;
}
@property (nonatomic,strong) IBOutlet UIButton *doneButton;
@property (nonatomic,strong) IBOutlet UIButton *codeButton;
@property (nonatomic,strong) IBOutlet UIButton *resendButton;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *filds;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *thumbls;

@end

@implementation SWConfirmView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
    codeField = [[UITextField alloc] init];
    codeField.borderStyle = UITextBorderStyleNone;
    [codeField setBackgroundColor:[UIColor clearColor]];
    codeField.keyboardType = UIKeyboardTypeNumberPad;
    codeField.returnKeyType = UIReturnKeyDone;
    codeField.clearButtonMode = UITextFieldViewModeNever;
    codeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    codeField.delegate = self;
    [self addSubview:codeField];
    [codeField setHidden:YES];
    
    phoneNumber = [self objectForKey:phoneNumberKey];
   
    NSDictionary *attrDict = @{NSFontAttributeName : [UIFont
                                                      systemFontOfSize:14.0],NSForegroundColorAttributeName : [UIColor colorWithRed:0.f green:126.f / 255.f blue:255.f / 255.f alpha:1.f]};
    NSMutableAttributedString *title =[[NSMutableAttributedString alloc] initWithString:_resendButton.titleLabel.text attributes: attrDict];
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange([title length] - 10,10)];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,[title length] - 10)];
    [_resendButton setAttributedTitle:title forState:UIControlStateNormal];
    [_resendButton setAttributedTitle:title forState:UIControlStateHighlighted];
    
    [codeField becomeFirstResponder];
}

- (void)dealloc{
    
}
#pragma mark - Action methods

- (void)doneWithNumberPad{
    [activeTextField resignFirstResponder];
}

- (IBAction)clicked:(id)sender{
    
    
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_resendButton]){

        [_resendButton setUserInteractionEnabled:NO];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString* param = [NSString stringWithFormat:@"regId=%@",phoneNumber];
        [[SWWebManager sharedManager]registerPnone:param success:^(SWRegisterPhone *obj) {
            NSLog(@"%@",obj);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_resendButton setUserInteractionEnabled:YES];
            });
        }];
        
        
    } else if([button isEqual:_codeButton]){
        [_codeButton setHidden:YES];
        [codeField becomeFirstResponder];
    } else if([button isEqual:_doneButton]){

        if(codeField.text.length < 4){
            if([_delegate respondsToSelector:@selector(alertMessage: withMessage:)]){
                [_delegate alertMessage:self withMessage:@"Invalid confirmation code"];
            }
            return;
        }
     
        __block NSString* param = [NSString stringWithFormat:@"regId=%@&confirmationCode=%@",phoneNumber,codeField.text];
        [[SWWebManager sharedManager]confirmPnone:param success:^(SWConfirmPhone *obj) {
            NSLog(@"%@",obj);
            dispatch_async(dispatch_get_main_queue(), ^{
                obj.phoneNumber = phoneNumber;
                
                [self setObjectDataForKey:obj forKey:userInfo];
                
                param = [NSString stringWithFormat:@"regId=%@&userType=REGULAR&credentialType=PHONE&credential=%@",phoneNumber,obj.token];
                
                [[SWWebManager sharedManager]registerUser:param success:^(SWLogin *obj) {
                    NSLog(@"%@",obj);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setObjectDataForKey:obj forKey:currentLoginKey];
                        if ([[FIRInstanceID instanceID] token]) {
                            NSLog(@"[FIRInstanceID: %@",[[FIRInstanceID instanceID] token]);
                            SWLogin *object = [self objectDataForKey:currentLoginKey];
                            if(object != nil){
                                NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&notificationToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken,[[FIRInstanceID instanceID] token]];
                                [[SWWebManager sharedManager]sendNotificationToken:param  success:nil];
                            }
                        }
                        if([_delegate respondsToSelector:@selector(backPress:)]){
                            [_delegate backPress:self];
                        }
                    });
                } failure:^(NSInteger statusCode) {
                    if(statusCode == ISPRESENT){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            param = [NSString stringWithFormat:@"regId=%@&credential=%@",phoneNumber,obj.token];
                            [[SWWebManager sharedManager]login:param success:^(SWLogin *obj) {
                                NSLog(@"%@",obj);
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self setObjectDataForKey:obj forKey:currentLoginKey];
                                    if ([[FIRInstanceID instanceID] token]) {
                                        NSLog(@"[FIRInstanceID: %@",[[FIRInstanceID instanceID] token]);
                                        SWLogin *object = [self objectDataForKey:currentLoginKey];
                                        if(object != nil){
                                            NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&notificationToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken,[[FIRInstanceID instanceID] token]];
                                            [[SWWebManager sharedManager]sendNotificationToken:param  success:nil];
                                           
                                            [self setObjectDataForKey:object forKey:userLoginInfo];
                                            
                                            param = [NSString stringWithFormat:@"tourist_id=%ld&sessionToken=%@&notificationToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken,[[FIRInstanceID instanceID] token]];
                                            [[SWWebManager sharedManager]getTouristPreferences:param success:^(SWPreferences *obj) {
                                                [self setObjectDataForKey:obj forKey:userPreferences];
                                                TheApp;
                                                app.window.rootViewController =  [self checkPresentForClassDescriptor:@"TabbarController"];
                                            }];
                                           
                                        }
                                    }
                                   
                                });
                            }];
                        });
                    }
                }];
                
            });
        }];
    }
    
}

#pragma mark - UITextField Delegate methods

- (BOOL)textField:(UITextField *) __textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
    NSArray *currents = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currents firstObject];
    if ([[current primaryLanguage] isEqualToString:@"emoji"] ) {
        return NO;
    }
    
    BOOL returnKey = YES;
    NSCharacterSet *nameCharSet = [NSCharacterSet characterSetWithCharactersInString:phonecharSet];
    
    
    for (int i = 0; i < [string length]; i++){
        unichar c = [string characterAtIndex:i];
        if ([nameCharSet characterIsMember:c]){
            return NO;
        }
    }
    
    NSUInteger oldLength = [__textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(![string isEqualToString:@""]){
            if(__textField.text.length == 4){
                ((UITextField*)_filds[__textField.text.length - 1]).text = string;
                [((UIView*)_thumbls[__textField.text.length - 1]) setHidden:YES];
                [_codeButton setHidden:NO];
                [codeField resignFirstResponder];
            } else {
                if(__textField.text.length <_filds.count ){
                    ((UILabel*)_filds[__textField.text.length - 1]).text = string;
                    [((UIView*)_thumbls[__textField.text.length - 1]) setHidden:YES];
                }
            }
        } else {
            if(__textField.text.length == 0){
                [_codeButton setHidden:NO];
                [codeField resignFirstResponder];
                ((UITextField*)_filds[0]).text = string;
                [((UIView*)_thumbls[0]) setHidden:NO];
            } else {
                if(__textField.text.length < _filds.count){
                    ((UILabel*)_filds[__textField.text.length]).text = string;
                    [((UIView*)_thumbls[__textField.text.length]) setHidden:NO];
                }
            }
        }
    });
    
    returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    return newLength <= 4 || returnKey;
    
    
}


@end
