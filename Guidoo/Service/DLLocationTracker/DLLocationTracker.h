//
//  KWLocationTracker.h
//  Prototype
//
//  Created by Sergiy Bekker on 27.03.15.
//  Copyright (c) 2015 Sergiy Bekker. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface DLLocationTracker : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTask;
@property (nonatomic,assign) BOOL afterResume;



+ (DLLocationTracker *)sharedInstance;

- (void)endBackgroundTask;
- (void)startMonitoringLocation;
- (void)restartMonitoringLocation;
- (void)releaseMonitoringLocation;

@end
