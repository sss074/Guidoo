////
//  KWLocationTracker.m
//  Prototype
//
//  Created by Sergiy Bekker on 27.03.15.
//  Copyright (c) 2015 Sergiy Bekker. All rights reserved.
//

#import "DLLocationTracker.h"
#import <CoreLocation/CoreLocation.h>
#import "SWLogin.h"

//static NSTimeInterval const kMinUpdateTime = 180.f;
static NSTimeInterval const kMinLocationTime = 20.f;
//static NSInteger const kMinLocationRadius = 50;
static NSString* regionIdent = @"currentLocation";
static dispatch_once_t once;
static dispatch_once_t oncetoken;
static DLLocationTracker *sharedInstance;


@interface DLLocationTracker () {
    CLLocation* oldBgLocation;
    NSTimer* timer;
    NSTimer * delayUpdateTimeSeconds;
    NSMutableArray* myLocationArray;
}
@end

@implementation DLLocationTracker

#pragma mark - NSObject

+ (DLLocationTracker *)sharedInstance {
    
    dispatch_once(&once, ^{
        sharedInstance = [DLLocationTracker new];
    });

    return sharedInstance;
}


#pragma mark - Public methods

- (void)startMonitoringLocation {
    
    if (_locationManager){
        [myLocationArray removeAllObjects];
        myLocationArray = nil;
        [_locationManager stopMonitoringSignificantLocationChanges];
        [_locationManager stopUpdatingLocation];
        _locationManager = nil;
    }
    
    [self clearTiming];
    
    myLocationArray = [[NSMutableArray alloc]init];
    
    self.locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.activityType = CLActivityTypeOther;

    if([_locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
        _locationManager.allowsBackgroundLocationUpdates = YES;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];

}
- (void)restartMonitoringLocation {

    [self clearTiming];
    
    [_locationManager stopMonitoringSignificantLocationChanges];
    [_locationManager stopUpdatingLocation];
    if([_locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
        _locationManager.allowsBackgroundLocationUpdates = YES;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
}

- (void)releaseMonitoringLocation{

    [self clearTiming];

    [_locationManager stopMonitoringSignificantLocationChanges];
    [_locationManager stopUpdatingLocation];
    
}

#pragma mark - Service methods
- (void)clearTiming{
    if([timer isValid]){
        [timer invalidate];
        timer = nil;
    }
    if([delayUpdateTimeSeconds isValid]){
        [delayUpdateTimeSeconds invalidate];
        delayUpdateTimeSeconds = nil;
    }
    oncetoken = 0;
}
- (void)endBackgroundTask {
    if (self.bgTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }
}
-(void)restartLocationUpdates{
    if([timer isValid]){
        [timer invalidate];
        timer = nil;
    }
    if([delayUpdateTimeSeconds isValid]){
        [delayUpdateTimeSeconds invalidate];
        delayUpdateTimeSeconds = nil;
    }
    [_locationManager requestWhenInUseAuthorization];
    if([_locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
        _locationManager.allowsBackgroundLocationUpdates = YES;
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
}

-(void)stopLocationDelayByUpdateTimeSeconds{
    if([delayUpdateTimeSeconds isValid]){
        [delayUpdateTimeSeconds invalidate];
        delayUpdateTimeSeconds = nil;
    }
    if(myLocationArray.count > 0){
        NSDictionary* param = (NSDictionary*)[myLocationArray lastObject];
        
        NSDictionary* locInfo = [self objectForKey:locationInfo];
        locInfo = [self replaceValueForKey:locInfo withKey:@"latitude" withValue:param[@"latitude"]];
        locInfo = [self replaceValueForKey:locInfo withKey:@"longitude" withValue:param[@"longitude"]];
        [self setObjectForKey:locInfo forKey:locationInfo];

        
        SWLogin *object = [self objectDataForKey:userLoginInfo];
        if(object != nil){
            NSString* param = [NSString stringWithFormat:@"userId=%ld&latitude=%f&longitude=%f&sessionToken=%@",((NSNumber*)object.userId).integerValue,((NSNumber*)locInfo[@"latitude"]).floatValue,((NSNumber*)locInfo[@"longitude"]).floatValue,object.sessionToken];
            [[SWWebManager sharedManager]location:param success:nil];
        }
        [myLocationArray removeAllObjects];
        CLLocation* location = [[CLLocation alloc]initWithLatitude:((NSNumber*)locInfo[@"latitude"]).floatValue longitude:((NSNumber*)locInfo[@"longitude"]).floatValue];
        if([self objectForKey:address] == nil){
            [self getAddressFromLocation:location];
            [self getGoogleAdrressFromLocation:location];
        }
    }
    [_locationManager stopMonitoringSignificantLocationChanges];
    [_locationManager stopUpdatingLocation];
}


#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
 
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"locationStatusUpdateNotification" object:manager];
 
    } else  if (status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusDenied){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"locationStatusUpdateNotification" object:manager];
 
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    for(int i=0;i<locations.count;i++){
        CLLocation * newLocation = [locations objectAtIndex:i];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
        
        if (locationAge > 30.0){
            continue;
        }

        if(newLocation!= nil && theAccuracy > 0 && theAccuracy < 2000 && (!(theLocation.latitude == 0.0 && theLocation.longitude == 0.0))){
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[NSNumber numberWithFloat:theLocation.latitude] forKey:@"latitude"];
            [dict setObject:[NSNumber numberWithFloat:theLocation.longitude] forKey:@"longitude"];
            [dict setObject:[NSNumber numberWithFloat:theAccuracy] forKey:@"theAccuracy"];
            [myLocationArray addObject:dict];
            
            dispatch_once(&oncetoken, ^{
                NSDictionary* locInfo = [self objectForKey:locationInfo];
                locInfo = [self replaceValueForKey:locInfo withKey:@"latitude" withValue:[NSNumber numberWithFloat:manager.location.coordinate.latitude]];
                locInfo = [self replaceValueForKey:locInfo withKey:@"longitude" withValue:[NSNumber numberWithFloat:manager.location.coordinate.longitude]];
                [self setObjectForKey:locInfo forKey:locationInfo];

                SWLogin *object = [self objectDataForKey:userLoginInfo];
                if(object != nil){
                    NSString* param = [NSString stringWithFormat:@"userId=%ld&latitude=%f&longitude=%f&sessionToken=%@",((NSNumber*)object.userId).integerValue,manager.location.coordinate.latitude,manager.location.coordinate.longitude,object.sessionToken];
                    [[SWWebManager sharedManager]location:param success:nil];
                }

            });

           
        }
    }

    
    
    [self endBackgroundTask];
    self.bgTask = [[UIApplication sharedApplication]
                   beginBackgroundTaskWithExpirationHandler:
                   ^{
                       [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
                   }];
    
   
    
    if ([timer isValid]) {
        return;
    }
   
    timer = [NSTimer scheduledTimerWithTimeInterval:180.f target:self
                                           selector:@selector(restartLocationUpdates)
                                           userInfo:nil
                                            repeats:NO];
    
    
    delayUpdateTimeSeconds = [NSTimer scheduledTimerWithTimeInterval:kMinLocationTime target:self
                                                    selector:@selector(stopLocationDelayByUpdateTimeSeconds)
                                                    userInfo:nil
                                                     repeats:NO];
    
 
  
}





@end
