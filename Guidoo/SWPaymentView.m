//
//  SWPaymentView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 04.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWPaymentView.h"
#import <Stripe/Stripe.h>

@interface SWPaymentView (){
    UITextField* activeTextField;
}

@property (nonatomic,strong)IBOutlet UIScrollView* scrollView;
@property (nonatomic,strong)IBOutlet UIView* cardContener;
@property (nonatomic,strong)IBOutlet UISegmentedControl* segmaent;
@property (nonatomic,strong)IBOutlet UIView* creditView;
@property (nonatomic,strong)IBOutlet UIView* paypalView;
@property (nonatomic,strong)IBOutlet UITextField* numberField;
@property (nonatomic,strong)IBOutlet UITextField* expField;
@property (nonatomic,strong)IBOutlet UITextField* cvcField;
@property (nonatomic,strong)IBOutlet UITextField* nameField;
@property (nonatomic,strong)IBOutlet UIButton* numberBut;
@property (nonatomic,strong)IBOutlet UIButton* expBut;
@property (nonatomic,strong)IBOutlet UIButton* cvcBut;
@property (nonatomic,strong)IBOutlet UIButton* nameBut;
@property (nonatomic,strong)IBOutlet UIButton* saveBut;
@property (nonatomic,strong)IBOutlet UIButton* payBut;

@end

@implementation SWPaymentView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
    DeviceSize size = [SDiOSVersion deviceSize];
    [_scrollView setScrollEnabled:(size == Screen4inch || size == Screen3Dot5inch)];
        
 
    [_segmaent setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                        NSFontAttributeName:[UIFont fontWithName:OPENSANSSEMIBOLD size:15.f]} forState:UIControlStateNormal];
    [_segmaent setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                        NSFontAttributeName:[UIFont fontWithName:OPENSANSSEMIBOLD size:15.f]} forState:UIControlStateSelected];
    [_segmaent setTintColor:[UIColor colorWithRed:56.f/255.f green:150.f/255.f blue:44.f/255.f alpha:1.f]];
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    numberToolbar.barTintColor = [UIColor colorWithRed:56.f/255.f green:150.f/255.f blue:44.f/255.f alpha:1.f];
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
    barItem.tintColor = [UIColor blackColor];
    numberToolbar.items = [NSArray arrayWithObjects:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           barItem,
                           nil];
    [numberToolbar sizeToFit];
    _numberField.inputAccessoryView = numberToolbar;
    
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    numberToolbar.barTintColor = [UIColor colorWithRed:56.f/255.f green:150.f/255.f blue:44.f/255.f alpha:1.f];
    barItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
    barItem.tintColor = [UIColor blackColor];
    numberToolbar.items = [NSArray arrayWithObjects:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           barItem,
                           nil];
    [numberToolbar sizeToFit];
    _expField.inputAccessoryView = numberToolbar;
    
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    numberToolbar.barTintColor = [UIColor colorWithRed:56.f/255.f green:150.f/255.f blue:44.f/255.f alpha:1.f];
    barItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
    barItem.tintColor = [UIColor blackColor];
    numberToolbar.items = [NSArray arrayWithObjects:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           barItem,
                           nil];
    [numberToolbar sizeToFit];
    _cvcField.inputAccessoryView = numberToolbar;
    
    NSDictionary* cardParam = [self objectForKey:@"cardParam"];
    if(cardParam != nil){
        NSString* number = cardParam[@"number"];
        _numberField.text = [NSString stringWithFormat:@"%@ %@ %@ %@",[number substringToIndex:4],[number substringWithRange:NSMakeRange(4, 4)],[number substringWithRange:NSMakeRange(8, 4)],[number substringWithRange:NSMakeRange(12, 4)] ];
        NSString * exp = cardParam[@"exp"];
        _expField.text = [NSString stringWithFormat:@"%@ / %@",[exp substringToIndex:2],[exp substringFromIndex:2]];
        _nameField.text = cardParam[@"name"];
        [_numberBut setHidden:YES];
        [_expBut setHidden:YES];
        [_saveBut setSelected:YES];
        [_nameBut setHidden:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}
- (void)dealloc{
 
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - UITextField Delegate methods

- (BOOL)textField:(UITextField *) __textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSArray *currents = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currents firstObject];
    if ([[current primaryLanguage] isEqualToString:@"emoji"] ) {
        return NO;
    }
    
    
    
    BOOL returnKey = YES;
    NSCharacterSet *nameCharSet = [NSCharacterSet characterSetWithCharactersInString:charSet];
    
    
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
    
    NSLog(@"%ld",newLength);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([__textField isEqual:_numberField]){
            if(__textField.text.length == 16){
                [self doneWithNumberPad];
                [self clicked:_expBut];
            }
        } else if([__textField isEqual:_expField]){
            if(__textField.text.length == 4){
                [self doneWithNumberPad];
                [self clicked:_cvcBut];
            }
        } else if([__textField isEqual:_cvcField]){
            if(__textField.text.length == 3){
                [self doneWithNumberPad];
                [self clicked:_nameBut];
            }
        }
    });
    
    returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    if([__textField isEqual:_numberField]){
       return newLength <= 16 || returnKey;
    } else if([__textField isEqual:_expField]){
       return newLength <= 4 || returnKey;
    } else if([__textField isEqual:_cvcField]){
       return newLength <= 3 || returnKey;
    }
    
    
    return newLength <= 50 || returnKey;
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)__textField{
    
    activeTextField = __textField;
    
    [_numberField setUserInteractionEnabled:NO];
    [_expField setUserInteractionEnabled:NO];
    [_cvcField setUserInteractionEnabled:NO];
    [_nameField setUserInteractionEnabled:NO];
    [_numberBut setUserInteractionEnabled:NO];
    [_expBut setUserInteractionEnabled:NO];
    [_cvcBut setUserInteractionEnabled:NO];
    [_nameBut setUserInteractionEnabled:NO];
    
    [activeTextField setUserInteractionEnabled:YES];
    
    if([activeTextField isEqual:_numberField]){
        _numberField.text = [_numberField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    } else if([activeTextField isEqual:_expField]){
        _expField.text = [_expField.text stringByReplacingOccurrencesOfString:@"/" withString:@""];
        _expField.text = [_expField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)_textField{
    
    [_textField resignFirstResponder];
    
    if([_textField isEqual:_nameField]){
        [_nameBut setHidden:![_nameField.text isEqualToString:@""]];
        if(![_nameField.text isEqualToString:@""]){
            
        }
    }
    [_numberField setUserInteractionEnabled:YES];
    [_expField setUserInteractionEnabled:YES];
    [_cvcField setUserInteractionEnabled:YES];
    [_nameField setUserInteractionEnabled:YES];
    [_numberBut setUserInteractionEnabled:YES];
    [_expBut setUserInteractionEnabled:YES];
    [_cvcBut setUserInteractionEnabled:YES];
    [_nameBut setUserInteractionEnabled:YES];
    return  YES;
}
#pragma  mark - Service methods
- (BOOL)validateContent{
    
    BOOL key = YES;
    
    if(_numberField.text.length < 16){
        key = NO;
        [self showAlertMessage:@"Card number incorrect"];
    }
    if(_cvcField.text.length < 3){
        key = NO;
        [self showAlertMessage:@"CVC code incorrect"];
    }
    if(_expField.text.length < 4){
        key = NO;
        [self showAlertMessage:@"Expiration date incorrect"];
    }
    
    return  key;
}

#pragma  mark - Action methods
- (void)doneWithNumberPad{

    NSString* title = nil;
    if([activeTextField isEqual:_numberField]){
        if(_numberField.text.length > 0 && _numberField.text.length < 16)
            return;
        if(![_numberField.text isEqualToString:@""]){
            title = [NSString stringWithFormat:@"%@ %@ %@ %@",[_numberField.text substringToIndex:4],[_numberField.text substringWithRange:NSMakeRange(4, 4)],[_numberField.text substringWithRange:NSMakeRange(8, 4)],[_numberField.text substringWithRange:NSMakeRange(12, 4)] ];
            _numberField.text = title;
        }
    } else if([activeTextField isEqual:_expField]){
        if(_expField.text.length > 0 && _expField.text.length < 4)
            return;
        if(![_expField.text isEqualToString:@""]){
            title = [NSString stringWithFormat:@"%@ / %@",[_expField.text substringToIndex:2],[_expField.text substringFromIndex:2]];
            _expField.text = title;
        }
    } else if([activeTextField isEqual:_cvcField]){
        if(_cvcField.text.length > 0 && _cvcField.text.length < 3)
            return;
    }
    [_numberBut setHidden:![_numberField.text isEqualToString:@""]];
    [_expBut setHidden:![_expField.text isEqualToString:@""]];
    [_cvcBut setHidden:![_cvcField.text isEqualToString:@""]];
    [_numberField setUserInteractionEnabled:YES];
    [_expField setUserInteractionEnabled:YES];
    [_cvcField setUserInteractionEnabled:YES];
    [_nameField setUserInteractionEnabled:YES];
    [_numberBut setUserInteractionEnabled:YES];
    [_expBut setUserInteractionEnabled:YES];
    [_cvcBut setUserInteractionEnabled:YES];
    [_nameBut setUserInteractionEnabled:YES];
    
    [activeTextField resignFirstResponder];
    

}
-(IBAction)segmentValueChanged:(UISegmentedControl *)control{
    
    [_creditView setHidden:control.selectedSegmentIndex];
    [_paypalView setHidden:!control.selectedSegmentIndex];
    if(control.selectedSegmentIndex == 0){
       
    } else {
       
    }
    
   
}
- (IBAction)clicked:(id)sender{
    
    
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_numberBut]){
        [_numberBut setHidden:YES];
        [_numberField becomeFirstResponder];
    } else if([button isEqual:_expBut]){
        [_expBut setHidden:YES];
        [_expField becomeFirstResponder];
    } else if([button isEqual:_cvcBut]){
        [_cvcBut setHidden:YES];
        [_cvcField becomeFirstResponder];
    } else if([button isEqual:_nameBut]){
        [_nameBut setHidden:YES];
        [_nameField becomeFirstResponder];
    } else if([button isEqual:_saveBut]){
        [_saveBut setSelected:!_saveBut.isSelected];
        if(_saveBut.isSelected){
            NSString* exp = _expField.text;
            exp = [exp stringByReplacingOccurrencesOfString:@"/" withString:@""];
            exp = [exp stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSDictionary* cardParam = @{@"number":[_numberField.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                                        @"exp":exp,
                                        @"name":_nameField.text
                                        };
            [self setObjectForKey:cardParam forKey:@"cardParam"];
        } else {
            [self removeObjectForKey:@"cardParam"];
        }
    } else if([button isEqual:_payBut]){
       
        if([self validateContent]){
            if (![Stripe defaultPublishableKey]) {
                return;
            }
            
            STPCardParams* param = [STPCardParams new];
            param.number = [_numberField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            param.cvc = _cvcField.text;
            NSString* exp = _expField.text;
            exp = [exp stringByReplacingOccurrencesOfString:@"/" withString:@""];
            exp = [exp stringByReplacingOccurrencesOfString:@" " withString:@""];
            param.expMonth = [[exp substringToIndex:2]integerValue];
            param.expYear = [[exp substringFromIndex:2]integerValue];
            
            
            [self showIndecator:YES];
            [[STPAPIClient sharedClient] createTokenWithCard:param
                                                  completion:^(STPToken *token, NSError *error) {
                                                      if (!error) {
                                                          SWLogin *object = [self objectDataForKey:userLoginInfo];
                                                          if(object != nil){
                                                              
                                                              __block NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&paymentToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken,token.tokenId];
                                                              //NSDictionary* payInfo = [self objectForKey:@"payInfo"];
                                                              //if(payInfo == nil){
                                                                  [[SWWebManager sharedManager]registerPaymentMethod:param success:^{
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          NSDictionary* payInfo = [self objectForKey:@"payInfo"];
                                                                          if(payInfo != nil){
                                                                              NSDictionary* paymentMethod = payInfo[@"paymentMethod"];
                                                                              param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&paymentMethodToken=%@&bookingId=%ld",((NSNumber*)object.userId).integerValue,object.sessionToken,paymentMethod[@"token"],[SWWebManager sharedManager].curBookInfo.bookingId.integerValue];
                                                                              [[SWWebManager sharedManager]payTour:param success:^{
                                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                                      if([_delegate respondsToSelector:@selector(backPress:)]){
                                                                                          [_delegate backPress:self];
                                                                                      }
                                                                                  });
                                                                              }];
                                                                          }
                                                                      });
                                                                  }];
                                                             /* } else {
                                                                  NSDictionary* paymentMethod = payInfo[@"paymentMethod"];
                                                                  
                                                                  param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&paymentMethodToken=%@&bookingId=%ld",((NSNumber*)object.userId).integerValue,object.sessionToken,paymentMethod[@"token"],[SWWebManager sharedManager].curBookInfo.bookingId.integerValue];
                                                                  [[SWWebManager sharedManager]payTour:param success:^{
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                                          if([_delegate respondsToSelector:@selector(backPress:)]){
                                                                              [_delegate backPress:self];
                                                                          }
                                                                      });
                                                                  }];
                                                              }*/
                                                     
                                                          }
                                                      } else {
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [self showIndecator:NO];
                                                              [self showAlertMessage:@"Your card's expiration year is invalid"];
                                                          });
                                                      }
                                                  }];
        }
    }
}
#pragma mark - Notification methods


- (void)keyboardWasShown:(NSNotification*)aNotification{
    NSDictionary* info          = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0,0, kbSize.height + 100.f, 0);
    _scrollView.contentInset          = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    [self scrollToActiveTextField:kbSize];
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    _scrollView.contentInset          = UIEdgeInsetsZero;
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    CGPoint scrollPoint = CGPointMake(0.0,0.0);
    [_scrollView setContentOffset:scrollPoint animated:YES];
}

- (void)scrollToActiveTextField:(CGSize)kbSize{
    
    if (activeTextField){
        CGRect aRect = self.frame;
        aRect.size.height -= (kbSize.height + _cardContener.frame.origin.y);
        CGPoint point = CGPointMake(activeTextField.frame.origin.x + _cardContener.frame.origin.x, activeTextField.frame.origin.y + _cardContener.frame.origin.y + self.frame.origin.y);
        if (!CGRectContainsPoint(aRect, point) ) {
            CGPoint scrollPoint = CGPointMake(0.0,_cardContener.frame.origin.y + activeTextField.frame.origin.y -kbSize.height + 50.f);
            [_scrollView setContentOffset:scrollPoint animated:YES];
        }
    }
}

@end
