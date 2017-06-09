//
//  SWCreateProfileView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 28.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWCreateProfileView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Firebase/Firebase.h>

@interface SWCreateProfileView () <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
     UITextField* activeTextField;
     UIImagePickerController * picker;
}

@property (nonatomic, weak) IBOutlet UITextField* emailField;
@property (nonatomic, weak) IBOutlet UITextField* nameField;
@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UIButton *editButton;
@property (nonatomic,weak) IBOutlet UIButton *doneButton;
@property (nonatomic,weak) IBOutlet UIImageView *logoView;

@end


@implementation SWCreateProfileView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
    NSDictionary* currentFacebookProfile = [self objectForKey:FacebookProfile];
    
    NSLog(@"Current Profile %@", currentFacebookProfile);
    NSString* urlStr = currentFacebookProfile[@"profilePhotoURL"];
    //NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:urlStr]];
   // UIImage *cashImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
   // if(cashImage == nil){
        [_logoView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image != nil){
                 [_logoView setImage:[self resizeImage:image withContainer:_logoView]];
            }
        }];
   // } else {
   //     [self resizeImage:cashImage withContainer:_logoView];
   // }
    
    _nameField.text = currentFacebookProfile[@"name"];
    _emailField.text = currentFacebookProfile[@"email"];
    
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
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

#pragma mark - Action methods


- (IBAction)clicked:(id)sender{
    
    
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_doneButton]){
        NSDictionary* currentFacebookProfile =[self objectForKey:FacebookProfile];
        NSLog(@"Current Profile %@", currentFacebookProfile);
        __block NSString* param = [NSString stringWithFormat:@"regId=%@&userType=REGULAR&credentialType=FACEBOOK&credential=%@",currentFacebookProfile[@"id"],currentFacebookProfile[@"fbtoken"]];
        [[SWWebManager sharedManager]registerUser:param success:^(SWLogin *obj)  {
            NSLog(@"%@",obj);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setObjectDataForKey:obj forKey:userLoginInfo];
                if ([[FIRInstanceID instanceID] token]) {
                    NSLog(@"[FIRInstanceID: %@",[[FIRInstanceID instanceID] token]);
                    SWLogin *object = [self objectDataForKey:userLoginInfo];
                    if(object != nil){
                        NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&notificationToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken,[[FIRInstanceID instanceID] token]];
                        [[SWWebManager sharedManager]sendNotificationToken:param  success:nil];
                    }
                }
                TheApp;
                app.window.rootViewController =  [self checkPresentForClassDescriptor:@"FTSNavController"];
            });
        } failure:^(NSInteger statusCode) {
            if(statusCode == ISPRESENT){
                dispatch_async(dispatch_get_main_queue(), ^{
                    param = [NSString stringWithFormat:@"regId=%@&credential=%@",currentFacebookProfile[@"id"],currentFacebookProfile[@"fbtoken"]];
                    [[SWWebManager sharedManager]login:param success:^(SWLogin *obj) {
                        NSLog(@"%@",obj);
                        dispatch_async(dispatch_get_main_queue(), ^{
                           [self setObjectDataForKey:obj forKey:userLoginInfo];
                            if ([[FIRInstanceID instanceID] token]) {
                                NSLog(@"[FIRInstanceID: %@",[[FIRInstanceID instanceID] token]);
                                SWLogin *object = [self objectDataForKey:userLoginInfo];
                                if(object != nil){
                                    NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&notificationToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken,[[FIRInstanceID instanceID] token]];
                                    [[SWWebManager sharedManager]sendNotificationToken:param  success:nil];
                                }
                            }
                            [[SWWebManager sharedManager] setProfileUser:param success:^{
                                
                            }];
                            TheApp;
                            app.window.rootViewController =  [self checkPresentForClassDescriptor:@"FTSNavController"];
                        });
                    }];
                });
            }
        }];
        
    } else if([button isEqual:_editButton]){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:
                                    nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* actionCreate = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 [self photoPressed:UIImagePickerControllerSourceTypeCamera];
                                                             }];
        UIAlertAction* actionAdd = [UIAlertAction actionWithTitle:@"Photo Gallery" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [self photoPressed:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                                                          }];
        
        UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCreate];
        [alert addAction:actionAdd];
        [alert addAction:actionCancel];
        [[self currentController] presentViewController:alert animated:YES completion:nil];

    }
    
}

#pragma mark - Notification methods


- (void)keyboardWasShown:(NSNotification*)aNotification{
    NSDictionary* info          = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0,0, kbSize.height + 140, 0);
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

#pragma mark - Sewrvice methods

- (void)photoPressed:(UIImagePickerControllerSourceType)_typePicker {
    
    picker.delegate = self;
    picker.sourceType = _typePicker;
    picker.mediaTypes = @[@"public.image"];
    
    [[self currentController] presentViewController:picker animated:YES completion:nil];


}

#pragma mark - UIImagePickerController Delegate methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)_picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)_picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if (![type isEqualToString:(NSString *)kUTTypeVideo] && ![type isEqualToString:(NSString *)kUTTypeMovie]){
        
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.7 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [_logoView setImage:[self resizeImage:image withContainer:_logoView]];
        });
        
    }
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
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
    NSCharacterSet *nameCharSet = [NSCharacterSet characterSetWithCharactersInString:charSet];
    
    if([__textField isEqual:_nameField]){
        nameCharSet = [NSCharacterSet characterSetWithCharactersInString:passCharTemplate];
    }  else if([__textField isEqual:_emailField]){
        nameCharSet = [NSCharacterSet characterSetWithCharactersInString:emailCharTemplate];
    }
    
    
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
    return newLength <= 30 || returnKey;
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)_textField{
    
    [_textField resignFirstResponder];
    activeTextField = nil;
    return  YES;
}

@end
