//
//  NSObject+NSObject_CustomFont.m
//  SWGitHub
//
//  Created by Sergiy Bekker on 15.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "NSObject+NSObject_Custom.h"
#import <SDVersion/SDVersion.h>
#import "DGActivityIndicatorView.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <EventKit/EventKit.h>

static NSMapTable *requestClasses = nil;
static dispatch_once_t onceToken;
static DGActivityIndicatorView *viewButton;
static UIWindow *window;


@implementation NSObject (NSObject_Custom)

@dynamic font,fontSize,cornerRadius,borderColor;



- (NSString *)fontName
{
    return self.font.fontName;
}

- (void)setFontName:(NSString *)fontName
{
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}
- (void)setFontSize:(CGFloat)fontSize{
    CGFloat sizeFont = fontSize;
    DeviceSize size = [SDiOSVersion deviceSize];
    if(size == Screen4inch || size == Screen3Dot5inch)
        sizeFont -= 2.f;

    self.font = [UIFont fontWithName:self.font.fontName size:sizeFont];

    
}
- (void)setCornerRadius:(CGFloat)cornerRadius{
    
    CALayer* l = [(UIView*)self layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:cornerRadius];
}
- (void)setBorderColor:(UIColor *)borderColor{
    [[(UIView*)self layer]setBorderWidth:0.7];
    [(UIView*)self layer].borderColor = borderColor.CGColor;
}
-(UIFont*) fontFromScreen:(NSArray*)param withFontName:(NSString*)fontName{
    
    CGFloat pointSize = 18.f;
    
    if(param != nil){
        DeviceSize size = [SDiOSVersion deviceSize];
        if(param.count == 3){
            if(size == Screen5Dot5inch){
                pointSize = ((NSNumber*)param[0]).floatValue;
            } else if(size == Screen4Dot7inch){
                pointSize = ((NSNumber*)param[1]).floatValue;
            }else if(size == Screen4inch || size == Screen3Dot5inch){
                pointSize = ((NSNumber*)param[2]).floatValue;
            }
        }
    }
    
    return  [UIFont fontWithName:fontName size:pointSize];;
}

- (void)clearPresentForClassDescriptor{
    [requestClasses removeAllObjects];
}
- (id)checkPresentForClassDescriptor:(NSString*)objID{
    
    if(objID == nil)
        return nil;

    dispatch_once(&onceToken, ^{
        requestClasses = [NSMapTable weakToStrongObjectsMapTable];
    });
    
    if ([requestClasses objectForKey:objID]) {
       return [requestClasses objectForKey:objID];
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id Obj = [storyboard instantiateViewControllerWithIdentifier:objID];
    [requestClasses setObject:Obj forKey:objID];
    
    return Obj;
}
- (CGSize)sizeWithText:(NSString*)text width:(CGFloat)wdt font:(UIFont*)font{
    CGSize maximumLabelSize = CGSizeMake(wdt, FLT_MAX);
    CGRect rectbut = [text boundingRectWithSize:maximumLabelSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName : font}
                                        context:nil];
    
    
    return rectbut.size;
}
- (BOOL) validateEmail:(NSString *) candidate {
  
    if([candidate isEqualToString:@""])
        return  NO;
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}
- (void)showAlertMessage:(NSString*)message{
    TheApp;
    
    UIAlertController* alert= [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionOK];
    [app.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
- (UIImage*)resizeImage:(UIImage*)image withContainer:(UIView*)view{
   
    CGFloat factor = image.size.width / image.size.height;
    return [image customResize:CGSizeMake(CGRectGetWidth(view.frame),CGRectGetHeight(view.frame)) inside:(factor < 1) ? NO : YES];
}
- (NSString*)stringEncodeURIComponent:(NSString *)string{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                     (__bridge CFStringRef)string,
                                                                     NULL,
                                                                     CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                     kCFStringEncodingUTF8));
    

    //return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
-(void)getAddressFromLocation:(CLLocation *)location {

    __block NSString *address;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark= [placemarks objectAtIndex:0];
             
             address = [NSString stringWithFormat:@"%@",[placemark locality]];
             
             NSLog(@"%@",[NSString stringWithFormat:@"%@, %@",address,placemark.country]);
             dispatch_async(dispatch_get_main_queue(), ^{
                 if([self isParamValid:placemark.locality] && ![self isParamValid:placemark.country]){
                     [self setObjectForKey:[NSString stringWithFormat:@"%@",placemark.locality] forKey:@"address"];
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"updatePlacesAfterLocation" object:nil];
                 } else if(![self isParamValid:placemark.locality] && [self isParamValid:placemark.country]){
                     [self setObjectForKey:[NSString stringWithFormat:@"%@",placemark.country] forKey:@"address"];
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"updatePlacesAfterLocation" object:nil];
                 } else if([self isParamValid:placemark.locality] && [self isParamValid:placemark.country]){
                     [self setObjectForKey:[NSString stringWithFormat:@"%@,%@",placemark.locality,placemark.country] forKey:@"address"];
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"updatePlacesAfterLocation" object:nil];
                 }
             });
         }
         
     }];

}
-(void)getGoogleAdrressFromLocation:(CLLocation *)location{
    
    CGFloat lat = location.coordinate.latitude;
    CGFloat lon = location.coordinate.longitude;
    
    [GMSServices provideAPIKey:@"AIzaSyBewraYizNMXlhkHYXW9UYRcwqbKznmzMw"];
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(lat, lon) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        NSLog(@"reverse geocoding results:");
        for(GMSAddress* addressObj in [response results])
        {
            if(addressObj != nil){
                NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
                NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
                NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
                NSLog(@"locality=%@", addressObj.locality);
                NSLog(@"subLocality=%@", addressObj.subLocality);
                NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
                NSLog(@"postalCode=%@", addressObj.postalCode);
                NSLog(@"country=%@", addressObj.country);
                NSLog(@"lines=%@", addressObj.lines);
                
                
                if([self isParamValid:addressObj.locality] && ![self isParamValid:addressObj.country]){
                    [self setObjectForKey:[NSString stringWithFormat:@"%@",addressObj.locality] forKey:@"address"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updatePlacesAfterLocation" object:nil];
                    break;
                } else if(![self isParamValid:addressObj.locality] && [self isParamValid:addressObj.country]){
                     [self setObjectForKey:[NSString stringWithFormat:@"%@",addressObj.country] forKey:@"address"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updatePlacesAfterLocation" object:nil];
                    break;
                } else if([self isParamValid:addressObj.locality] && [self isParamValid:addressObj.country]){
                     [self setObjectForKey:[NSString stringWithFormat:@"%@,%@",addressObj.locality,addressObj.country] forKey:@"address"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"updatePlacesAfterLocation" object:nil];
                    break;
                }
                
  
            }
        }
    }];

}
-(void)getLocationFromAddress:(NSString *)address success:(void (^)(CLLocation* obj))success{
    CLGeocoder* gc = [[CLGeocoder alloc] init];
    [gc geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error){
         dispatch_async(dispatch_get_main_queue(), ^{
             CLLocation* location = nil;
             if ([placemarks count] > 0){
                 CLPlacemark* mark = (CLPlacemark*)[placemarks objectAtIndex:0];
                 double lat = mark.location.coordinate.latitude;
                 double lng = mark.location.coordinate.longitude;
                 location = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
             }
             if(success)
                 success(location);
         });
    }];
}
- (NSDictionary*)replaceValueForKey:(NSDictionary*)dict withKey:(NSString*)key withValue:(id)value{
    NSMutableDictionary* newDict = [NSMutableDictionary new];
    [newDict addEntriesFromDictionary:dict];
    newDict[key] = value;
    
    return [NSDictionary dictionaryWithDictionary:newDict];
}

- (UIViewController*)currentController{
    TheApp;
    if([app.window.rootViewController isKindOfClass:[UIViewController class]]){
        return app.window.rootViewController;
    } else {
        UINavigationController* nav = (UINavigationController*)app.window.rootViewController;
        return [nav.viewControllers firstObject];
    }
    return  nil;
}
- (void)showIndecator:(BOOL)state{

    viewButton = nil;
    [viewButton stopAnimating];
    [viewButton removeFromSuperview];
    window.hidden = YES;
    window = nil;
    viewButton = nil;
    
    if(state){

        window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
        window.windowLevel = UIWindowLevelAlert + 1.0;
        window.backgroundColor = [UIColor clearColor];
        [window makeKeyAndVisible];
        
        
        CGRect frame= [[UIScreen mainScreen]bounds];
        
        viewButton =  [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader tintColor:[UIColor colorWithRed:11.f/255.f green:13.f/255.f blue:13.f/255.f alpha:1.f] size:50.0f];
        
        viewButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
                                       UIViewAutoresizingFlexibleBottomMargin |
                                       UIViewAutoresizingFlexibleLeftMargin |
                                       UIViewAutoresizingFlexibleRightMargin);
        viewButton.frame = CGRectMake(frame.size.width / 2 - 25.f, frame.size.height / 2 - 110.f, 50.0f, 50.0f);
        viewButton.tag = 23456;
        [window addSubview:viewButton];
        [window bringSubviewToFront:viewButton];
        [viewButton startAnimating];
    }
    
}
- (void)setObjectDataForKey:(id)obj forKey:(NSString*)key{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (void)setObjectForKey:(id)obj forKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (id)objectDataForKey:(NSString*)key{
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if(encodedObject != nil){
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    return nil;
}
- (id)objectForKey:(NSString*)key{
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}
- (void)removeObjectForKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (void)logOut{
    dispatch_async(dispatch_get_main_queue(), ^{
   
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:userLoginInfo];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:userPreferences];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:locationInfo];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:FacebookProfile];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:address];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:profileInfo];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:avatar];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:currentLoginKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        
        requestClasses = nil;
        onceToken = 0;
        TheApp;
        app.window.rootViewController = [self checkPresentForClassDescriptor:@"StartLoaderController"];
        [self showIndecator:NO];
    });
}
- (BOOL)isParamValid:(id)obj{
    if(obj == nil)
        return NO;
    if([obj isEqual:[NSNull null]])
        return NO;
    
    return YES;
}
- (NSString*)groupFromID:(NSNumber*)ID{
    
    NSArray* groups = [self objectDataForKey:@"tourGroupSizes"];
    NSString* result = nil;
    NSInteger IDs = ID.integerValue;
    
    for(int i = 0; i < groups.count; i++){
        SWTourGroupSizes* obj = groups[i];
        if(IDs == obj.ID.integerValue){
            result = obj.value;
        }
    }

    return result;
}
- (NSString*)languageFromID:(NSNumber*)ID{
    NSString* result = @"English";
    NSInteger IDs = ID.integerValue;
    
    if(IDs == 2)
        result = @"Franch";
    else if(IDs == 2)
        result = @"Ispan";
    
    return result;
}
- (void)setImageForKey:(UIImage*)image forKey:(NSString*)key{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);

    NSString *imagePath = [self documentsPathForFileName:[NSString stringWithFormat:@"image_avatar.jpg"]];
    [imageData writeToFile:imagePath atomically:YES];
    [[NSUserDefaults standardUserDefaults] setObject:imagePath forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (UIImage*)imageForKey:(NSString*)key{
    NSString *imagePath = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (imagePath) {
        return [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
    }
    
    return nil;
}
- (NSString *)documentsPathForFileName:(NSString *)name {
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSString *documentsPath = [[paths lastObject]absoluteString];
    
    return [documentsPath stringByAppendingPathComponent:name];

}
- (void)cancelReminder:(SWHistory*)content{

    UILocalNotification *notificationToCancel=nil;
    
    for(UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSNumber* cutID = (NSNumber*)aNotif.userInfo[@"id"];
        NSNumber* ID = (NSNumber*)content.bookingId;
        if(cutID.integerValue ==  ID.integerValue) {
            notificationToCancel=aNotif;
            break;
        }
    }
    if(notificationToCancel)
        [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
    
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        NSTimeInterval seconds = [content.startTime longLongValue] / 1000;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
        NSDate *startDate = date;
        NSDate *endDate = [date dateByAddingTimeInterval:3600];
        
            
        NSPredicate *predicate = [store predicateForEventsWithStartDate:startDate
                                                                endDate:endDate
                                                              calendars:nil];
        
        NSArray *events = [store eventsMatchingPredicate:predicate];
        NSError *err = nil;
        for (int i = 0; i < events.count; i++) {
            EKEvent *event = events[i];
            [store removeEvent:event span:EKSpanFutureEvents error:&err];
        }
            
        
        
    }];
}
- (BOOL)checkGuid:(NSNumber*)obj{
    NSArray* guids = [SWWebManager sharedManager].bookmarkGuids;

    for(int i = 0; i < guids.count; i++){
        SWGuide* guid = guids[i];
        NSNumber* ID = guid.guideId;
        if(ID.integerValue == obj.integerValue)
            return YES;
    }
    return NO;
}
- (BOOL)checkTour:(NSNumber*)obj{
    NSArray* tours = [SWWebManager sharedManager].bookmarkTours;

    for(int i = 0; i < tours.count; i++){
        SWTour* tour = tours[i];
        NSNumber* ID = tour.tourId;
        if(ID.integerValue == obj.integerValue)
            return YES;
    }
    return NO;
}
- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Universal"];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}
- (NSString*)formattedStringFromDuration:(NSTimeInterval)incomeStampinterval{
    
    NSString* time = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Universal"]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];

    NSDate *curDate = [self dateAtBeginningOfDayForDate:[NSDate date]];
    
    int curStampinterval = (int)[curDate timeIntervalSince1970];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:incomeStampinterval];
    
    if(incomeStampinterval >= curStampinterval){
        [formatter setDateFormat:@"HH:mm"];
        time = [formatter stringFromDate:date];
    } else if(incomeStampinterval < curStampinterval && incomeStampinterval >= (curStampinterval - nightTime)){
        time = @"yesterday";
    } else if(incomeStampinterval < (curStampinterval - nightTime) && incomeStampinterval >= (curStampinterval - 6 * nightTime)){
        [formatter setDateFormat:@"EEEE,LLLL dd, yyyy"];
        time = [formatter stringFromDate:date];
        NSArray* components = [time componentsSeparatedByString:@","];
        if(components != nil && components.count > 2){
            time = components[0];
        }
    } else {
        [formatter setDateFormat:@"dd.MM.yy"];
        time = [formatter stringFromDate:date];
    }
    
    
    return time;
}
@end
