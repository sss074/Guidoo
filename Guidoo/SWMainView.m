//
//  SWMainView.m
//  Guidoo
//
//  Created by Sergiy Bekker on 28.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWMainView.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SWPhoneController.h"
#import "SWMainController.h"
#import "AppConstants.h"
#import <Firebase/Firebase.h>
#import "SWAgreementController.h"

@interface SWMainView () <FBSDKLoginButtonDelegate,UITextFieldDelegate>{
    FBSDKLoginButton *fbloginButton;
    NSArray* languages;
}

@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UIButton *agreButton;
@property (nonatomic,weak) IBOutlet UIButton *policyButton;
@property (nonatomic,weak) IBOutlet UIButton *fbButton;
@property (nonatomic,weak) IBOutlet UIButton *phoneButton;

@end


@implementation SWMainView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [[SWWebManager sharedManager]dictionaries:^(NSArray<SWLanguage *> *obj) {
        NSLog(@"%@",obj);
        dispatch_async(dispatch_get_main_queue(), ^{
            languages = [NSArray arrayWithArray:obj];
        });
    }];
    
    fbloginButton = [[FBSDKLoginButton alloc]initWithFrame:CGRectMake(10, 10, 10, 10)];
    fbloginButton.readPermissions = @[@"public_profile",@"email",@"user_about_me",@"user_birthday",@"user_hometown",@"user_location",@"user_status"];
    fbloginButton.delegate = self;
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [self addSubview:fbloginButton];
    [self sendSubviewToBack:fbloginButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginStatusChanged) name:FBSDKProfileDidChangeNotification object:nil];

    NSDictionary *attrDict = @{NSFontAttributeName : _agreButton.titleLabel.font,NSForegroundColorAttributeName : [UIColor colorWithRed:0.f green:126.f / 255.f blue:255.f / 255.f alpha:1.f]};
    NSMutableAttributedString *title =[[NSMutableAttributedString alloc] initWithString:_agreButton.titleLabel.text attributes: attrDict];
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0,[title length])];
    [_agreButton setAttributedTitle:title forState:UIControlStateNormal];
    [_agreButton setAttributedTitle:title forState:UIControlStateHighlighted];
    
    
    title =[[NSMutableAttributedString alloc] initWithString:_policyButton.titleLabel.text attributes: attrDict];
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0,[title length])];
    [_policyButton setAttributedTitle:title forState:UIControlStateNormal];
    [_policyButton setAttributedTitle:title forState:UIControlStateHighlighted];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSDKProfileDidChangeNotification object:nil];

}
#pragma mark - Notification methods

-(void)userLoginStatusChanged{
   
    
    [self showIndecator:YES];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"first_name, last_name, picture.width(540).height(540),                                                                           email, name, id, gender, birthday"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                  id result, NSError *error) {
         if (error) {
             NSLog(@"Login error: %@", [error localizedDescription]);
             return;
         }
         NSString* name =  (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                 (CFStringRef)result[@"name"],
                                                                                                 NULL,
                                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                                 CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
         [self setObjectForKey:@{@"id":result[@"id"],
                           @"fbtoken":[FBSDKAccessToken currentAccessToken].tokenString,
                           @"profilePhotoURL":result[@"picture"][@"data"][@"url"],
                           @"email":result[@"email"],
                           @"gender":result[@"gender"],
                           @"name":name
                           }
                  forKey:FacebookProfile];

         NSLog(@"Gathered the following info from your logged in user: %@ email: %@ birthday: %@, profilePhotoURL: %@", result, result[@"email"], result[@"birthday"],
               result[@"picture"][@"data"][@"url"]);
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [self showIndecator:NO];
             
             NSDictionary* currentFacebookProfile =[self objectForKey:FacebookProfile];
             NSLog(@"Current Profile %@", currentFacebookProfile);
             __block NSString* param = [NSString stringWithFormat:@"regId=%@&userType=REGULAR&credentialType=FACEBOOK&credential=%@",currentFacebookProfile[@"id"],currentFacebookProfile[@"fbtoken"]];
             [[SWWebManager sharedManager]registerUser:param success:^(SWLogin *obj)  {
                 NSLog(@"%@",obj);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self setObjectDataForKey:obj forKey:currentLoginKey];
                     if ([[FIRInstanceID instanceID] token]) {
                         NSLog(@"[FIRInstanceID: %@",[[FIRInstanceID instanceID] token]);
                         SWLogin *object = [self objectDataForKey:currentLoginKey];
                         if(object != nil){
                             NSString* param = [NSString stringWithFormat:@"userId=%ld&sessionToken=%@&notificationToken=%@",((NSNumber*)object.userId).integerValue,object.sessionToken,[[FIRInstanceID instanceID] token]];
                             [[SWWebManager sharedManager]sendNotificationToken:param  success:nil];
                             TheApp;
                             app.window.rootViewController =  [self checkPresentForClassDescriptor:@"FTSNavController"];
                            
                         }
                         
                     }
                     
                                         });
             } failure:^(NSInteger statusCode) {
                 if(statusCode == ISPRESENT){
                     dispatch_async(dispatch_get_main_queue(), ^{
                         param = [NSString stringWithFormat:@"regId=%@&credential=%@",currentFacebookProfile[@"id"],currentFacebookProfile[@"fbtoken"]];
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
                                         
                                         
                                     } else {
                                         TheApp;
                                         app.window.rootViewController =  [self checkPresentForClassDescriptor:@"MainNavController"];
                                     }
                                 } else {
                                     TheApp;
                                     app.window.rootViewController =  [self checkPresentForClassDescriptor:@"MainNavController"];
                                 }
                                 
                             });
                         }];
                     });
                 }
             }];
         });
         
     }];
   
}



#pragma mark - Action methods


- (IBAction)clicked:(id)sender{
    
    
    UIButton* button = (UIButton*)sender;
    
    if([button isEqual:_fbButton]){
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
        fbloginButton.loginBehavior = FBSDKLoginBehaviorNative;
        [fbloginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        
    } else if([button isEqual:_phoneButton]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SWPhoneController* controller = [storyboard instantiateViewControllerWithIdentifier:@"PhoneController"];
        TheApp;
        UINavigationController* rootController = (UINavigationController*)app.window.rootViewController;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [rootController presentViewController:controller animated:YES completion:nil];
    } else if([button isEqual:_agreButton] || [button isEqual:_policyButton]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SWAgreementController* controller = [storyboard instantiateViewControllerWithIdentifier:@"AgreementController"];
        TheApp;
        UINavigationController* rootController = (UINavigationController*)app.window.rootViewController;
        [rootController pushViewController:controller animated:YES];
    }
    
}

#pragma mark - FBSDKLoginButton delegate methods

- (void)  loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{

}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}


- (BOOL)loginButtonWillLogin:(FBSDKLoginButton *)loginButton{
    return YES;
}



@end
