//
//  NSObject+NSObject_CustomFont.h
//  SWGitHub
//
//  Created by Sergiy Bekker on 15.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SWHistory.h"


@interface NSObject (NSObject_Custom)

@property (strong, nonatomic) NSString *fontName;
@property (strong, nonatomic) UIFont *font;
@property (assign, nonatomic) CGFloat fontSize;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) UIColor* borderColor;


- (UIFont*) fontFromScreen:(NSArray*)param withFontName:(NSString*)fontName;
- (id)checkPresentForClassDescriptor:(NSString*)objID;
- (BOOL)validateEmail:(NSString *) obj;
- (CGSize)sizeWithText:(NSString*)text width:(CGFloat)wdt font:(UIFont*)font;
- (void)clearPresentForClassDescriptor;
- (void)showIndecator:(BOOL)state;
- (void)showAlertMessage:(NSString*)message;
- (UIImage*)resizeImage:(UIImage*)image withContainer:(UIView*)view;
- (NSString*)stringEncodeURIComponent:(NSString *)string;
- (UIViewController*)currentController;
- (NSDictionary*)replaceValueForKey:(NSDictionary*)dict withKey:(NSString*)key withValue:(id)value;
- (void)getAddressFromLocation:(CLLocation *)location;
- (void)getGoogleAdrressFromLocation:(CLLocation *)location;
- (void)getLocationFromAddress:(NSString *)location success:(void (^)(CLLocation* obj))success;
- (id)objectForKey:(NSString*)key;
- (id)objectDataForKey:(NSString*)key;
- (void)setObjectForKey:(id)obj forKey:(NSString*)key;
- (void)setObjectDataForKey:(id)obj forKey:(NSString*)key;
- (void)removeObjectForKey:(NSString*)key;
- (void)logOut;
- (BOOL)isParamValid:(id)obj;
- (NSString *)documentsPathForFileName:(NSString *)name;
- (void)setImageForKey:(UIImage*)image forKey:(NSString*)key;
- (UIImage*)imageForKey:(NSString*)key;
- (NSString*)groupFromID:(NSNumber*)ID;
- (NSString*)languageFromID:(NSNumber*)ID;
- (void)cancelReminder:(SWHistory*)content;
- (BOOL)checkGuid:(NSNumber*)obj;
- (BOOL)checkTour:(NSNumber*)obj;
- (NSString*)formattedStringFromDuration:(NSTimeInterval)incomeStampinterval;
@end
