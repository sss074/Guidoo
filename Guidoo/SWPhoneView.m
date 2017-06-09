//
//  SWPhoneView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 28.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWPhoneView.h"
#import <Firebase/Firebase.h>
#import "SWPhoneController.h"
#import "TRCustomPickerView.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface SWPhoneView ()<UITextFieldDelegate,TRCustomPickerViewDelegate>{
    UITextField* activeTextField;
    NSString* phoneNumber;
    TRCustomPickerView* codePicker;
    NSArray* countries;
    NSNumber* curCode;
    NSNumber* maxLen;
}


@property (nonatomic, weak) IBOutlet UITextField* phoneField;
@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UIButton *sendButton;
@property (nonatomic,weak) IBOutlet UIButton *ruleButton;
@property (nonatomic,weak) IBOutlet UIButton *clearButton;
@property (nonatomic,weak) IBOutlet UIButton *codeButton;

@end

@implementation SWPhoneView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                 @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                 @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                 @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                 @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                 @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                 @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                 @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                 @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                 @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                 @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                 @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                 @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                 @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                 @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                 @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                 @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                 @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                 @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                 @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                 @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                 @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                 @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                 @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                 @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                 @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                 @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                 @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                 @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                 @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                 @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                 @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                 @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                 @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                 @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                 @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                 @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                 @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                 @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                 @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                 @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                 @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                 @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                 @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                 @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                 @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                 @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                 @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                 @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                 @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                 @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                 @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                 @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                 @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                 @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                 @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                 @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                 @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                 @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                 @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                 @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];

    
    NSMutableArray* temp = [NSMutableArray new];
    NSNumber* lenth = @(10);
    NSArray * sortedKeys = [[dictCodes allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    for(NSString* obj in sortedKeys){
        
        if([obj isEqualToString:@"UA"])
            lenth = @(9);
        if([obj isEqualToString:@"IL"])
            lenth = @(8);
        if([obj isEqualToString:@"US"])
            lenth = @(10);
        [temp addObject:@{@"locate":obj,
                          @"prefix":[NSString stringWithFormat:@"+%@",dictCodes[obj]],
                          @"lenth":lenth}];
    }
    
    countries =  [NSArray arrayWithArray:temp];
    /*countries = @[@{@"title":@"Ukraine",
                    @"locate":@"UA",
                    @"prefix":@"+380",
                    @"lenth":@(9)},
                  @{@"title":@"Israel",
                    @"locate":@"IL",
                    @"prefix":@"+972",
                    @"lenth":@(8)},
                  @{@"title":@"USA",
                    @"locate":@"US",
                    @"prefix":@"+1",
                    @"lenth":@(10)}
                  ];*/
 
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString* countryCode = [[currentLocale objectForKey:NSLocaleCountryCode]uppercaseString];
    NSLog(@"countryCode: %@", countryCode);
    [dictCodes objectForKey:countryCode];
    
    [temp removeAllObjects];
    for(int i = 0; i< countries.count; i++){
        NSDictionary* param = countries[i];
        [temp addObject:[NSString stringWithFormat:@"%@    %@",param[@"locate"],param[@"prefix"]]];
        if([countryCode isEqualToString:param[@"locate"]]){
            curCode = @(i);
            [_codeButton setTitle:param[@"prefix"] forState:UIControlStateNormal];
            [_codeButton setTitle:param[@"prefix"] forState:UIControlStateHighlighted];
            maxLen = param[@"lenth"];
        }
    }
   
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    numberToolbar.barTintColor = [UIColor colorWithRed:239.f/255.f green:243.f/255.f blue:245.f/255.f alpha:1.f];
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
    barItem.tintColor = [UIColor blackColor];
    numberToolbar.items = [NSArray arrayWithObjects:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           barItem,
                           nil];
    [numberToolbar sizeToFit];
    _phoneField.inputAccessoryView = numberToolbar;

    NSDictionary *attrDict = @{NSFontAttributeName : [UIFont
                                                      systemFontOfSize:14.0],NSForegroundColorAttributeName : [UIColor colorWithRed:0.f green:126.f / 255.f blue:255.f / 255.f alpha:1.f]};
    NSMutableAttributedString *title =[[NSMutableAttributedString alloc] initWithString:_ruleButton.titleLabel.text attributes: attrDict];
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange([title length] - 5,5)];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,[title length] - 5)];
    [_ruleButton setAttributedTitle:title forState:UIControlStateNormal];
    [_ruleButton setAttributedTitle:title forState:UIControlStateHighlighted];
    
    codePicker = [[TRCustomPickerView alloc]initWithFrame:CGRectMake(0, 50.f, CGRectGetWidth([[UIScreen mainScreen] bounds]), 200.f)];
    codePicker.appearancePlace = TRPickerAppearancePlace_Bottom;
    codePicker.customPickerViewDelegate = self;
    codePicker.content = @[[NSArray arrayWithArray:temp]];
   
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
    
    if(codePicker.isShow)
        [codePicker hide];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - Action methods

- (void)doneWithNumberPad{
    [activeTextField resignFirstResponder];
}

- (IBAction)clicked:(id)sender{
    
    
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_sendButton]){
        
        if(_ruleButton.isSelected){

            if([_delegate respondsToSelector:@selector(alertMessage: withMessage:)]){
                [_delegate alertMessage:self withMessage:@"It is necessary to read the rules"];
            }
            return;
        }
        if(_phoneField.text.length < ((NSNumber*)maxLen).integerValue){
            if([_delegate respondsToSelector:@selector(alertMessage: withMessage:)]){
                [_delegate alertMessage:self withMessage:@"Invalid phone number format"];
            }
            return;
        }
    
        NSString* str = [NSString stringWithFormat:@"%@%@",_codeButton.titleLabel.text,_phoneField.text];
        phoneNumber = [self stringEncodeURIComponent:str];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        NSString* param = [NSString stringWithFormat:@"regId=%@",phoneNumber];
  
        [[SWWebManager sharedManager]registerPnone:param success:^(SWRegisterPhone *obj) {
            NSLog(@"%@",obj);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setObjectForKey:phoneNumber forKey:phoneNumberKey];
                if([_delegate respondsToSelector:@selector(backPress:)]){
                    [_delegate backPress:self];
                }
            });
        }];
    } else if([button isEqual:_ruleButton]){
        [_ruleButton setSelected:!_ruleButton.isSelected];
    } else if([button isEqual:_clearButton]){
        _phoneField.text = nil;
    } else if([button isEqual:_codeButton]){
        codePicker.params = @{key_pickerFontNameNSString : @"OpenSans-Light",
                                key_pickerFontSizeNSNumber : @(14.f),
                                key_pickerContentTextColorUIColor : [UIColor blackColor],
                                key_pickerComponentsRowsBackgroundColorUIColor : [UIColor whiteColor],
                                key_pickerBackgroundColorUIColor : [UIColor whiteColor],
                                key_pickerSelectionLinesColorUIColor : [UIColor lightGrayColor],
                                key_isToolBarExistNSNumber : @(YES),
                                key_doneBtnTitleNSString : @"Done",
                                key_cancelBtnTitleNSString : @"Cancel",
                                key_horizEdgeOffsetsCancelDoneBtns  : @(10.f),
                                key_toolBarTitleNSString : @"Select you country",
                                key_pickerSelectedRowsNSArray : @[curCode]};
        
        
        if(!codePicker.isShow){
            if(codePicker.isShow && codePicker.isCompleted){
                [codePicker hide];
            } else if(!codePicker.isShow && codePicker.isCompleted){
                [codePicker show];
            }
        }

    }
}

#pragma mark - Notification methods


- (void)keyboardWasShown:(NSNotification*)aNotification{
    NSDictionary* info          = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0,0, kbSize.height + 100, 0);
    _scrollView.contentInset          = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    [self scrollToActiveTextField:kbSize];
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    _scrollView.contentInset          = UIEdgeInsetsZero;
    _scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)scrollToActiveTextField:(CGSize)kbSize{
    
    if (activeTextField){
        CGRect aRect = self.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, activeTextField.frame.origin.y-kbSize.height);
            [_scrollView setContentOffset:scrollPoint animated:YES];
        }
    }
}
#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)__textField{
    
    activeTextField = __textField;
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    return  YES;
}
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
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    
    returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    return newLength <= ((NSNumber*)maxLen).integerValue || returnKey;
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)_textField{
    
    [_textField resignFirstResponder];
    activeTextField = nil;
    return  YES;
}
#pragma mark - TRCustomPickerViewDelegate delegate methods

-(void) cancelCustomPickerView:(TRCustomPickerView*)customPickerView{
    
}
-(void) inCustomPickerView:(TRCustomPickerView*) customPickerView didSelectRows:(NSArray*) rows {
    
    if([customPickerView isEqual:codePicker]){
        NSInteger curCountryRow = ((NSNumber*)rows[0]).integerValue;
        NSDictionary* param = countries[curCountryRow];
        curCode = @(curCountryRow);
        [_codeButton setTitle:param[@"prefix"] forState:UIControlStateNormal];
        [_codeButton setTitle:param[@"prefix"] forState:UIControlStateHighlighted];
        maxLen = param[@"lenth"];
        _phoneField.text = nil;
    }
    
    
}
@end
