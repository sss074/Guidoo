//
//  TRMapView.m
//  DatingApp
//
//  Created by Sergiy Bekker on 14.05.15.
//  Copyright (c) 2015 Sergiy Bekker. All rights reserved.
//

#import "SWMapView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SWPreferences.h"

static NSString *reuseIdentifier = @"ADClusterableAnnotation";
#define MERCATOR_RADIUS 85445659.44705395
#define MAX_GOOGLE_LEVELS 20

@interface SWMapView() <MKMapViewDelegate>{
    CLLocation* initialLocation;
    CLLocationManager *locationManager;
    BOOL location;
}

@end

@implementation SWMapView

@synthesize isLocation = _isLocation;

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    location = YES;
    if ( [self respondsToSelector:@selector(isLocation)]){
        _isLocation = [self valueForKey:@"isLocation"];
        location = _isLocation.integerValue > 0 ? YES : NO;
    }
    
    //if(location){
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        locationManager.activityType = CLActivityTypeOther;
        locationManager.distanceFilter = 10.f;
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        };
        self.showsUserLocation = location;
        [self setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2f * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            [locationManager startUpdatingLocation];
        });
    //}
    self.delegate = self;

    //UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc]
                           //           initWithTarget:self action:@selector(didTapMap:)];
    //[self addGestureRecognizer:tapRec];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMapAnnotation:) name:@"updateMapAnnotation" object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateMapAnnotation" object:nil];
}
#pragma mark -  NSNotification

- (void)updateMapAnnotation:(NSNotification*)notify{
    self.anotations = notify.object;
    [self updateMap];
}

- (void)didTapMap:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;

}
-(void)releaseMap{
    [locationManager stopUpdatingLocation];
    locationManager = nil;
}

#pragma mark - Public methods
-(void)updateMap{
    
    if(location){
        [self removeAnnotations:self.annotations];
       
        
        NSMutableArray* temp = [NSMutableArray new];
        for (int i = 0; i < self.anotations.count; i++){
            MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
            NSDictionary* obj = self.anotations[i];
             CLLocationCoordinate2D latLng = CLLocationCoordinate2DMake(((NSNumber*)obj[@"latitude"]).floatValue,((NSNumber*)obj[@"longitude"]).floatValue);
            mapPin.coordinate = latLng;
            mapPin.title = obj[@"title"];
            mapPin.subtitle = @"";
            [temp addObject:mapPin];
        }
        
        [self addAnnotations:[NSArray arrayWithArray:temp]];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
            CLLocationCoordinate2D latLng = CLLocationCoordinate2DMake(self.coord.latitude, self.coord.longitude);
            
            mapPin.coordinate = latLng;
            mapPin.title = @"";
            mapPin.subtitle = @"";

            [self addAnnotation:mapPin];
            
            MKCoordinateRegion region;
            CLLocationCoordinate2D point;
            region.center = self.coord;
            point.latitude = self.coord.latitude;
            point.longitude = self.coord.longitude;
            region.center = point;
            region.span = MKCoordinateSpanMake(DISTANCE, DISTANCE);
            region = [self regionThatFits:region];
            [self setRegion:region animated:YES];
        
            [self setCenterCoordinate:self.coord animated:YES];
        });
    }
    
 
    
}


#pragma mark - MapViewDelegate
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
    double curLevel = [self getZoomLevel];
    if(curLevel > 15){
        [self setMapType:MKMapTypeHybrid];
    } else if(curLevel <= 15){
        [self setMapType:MKMapTypeStandard];
    }

}


- (void)mapView:(MKMapView *)_mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if (!initialLocation && location){
        initialLocation = userLocation.location;
            
        MKCoordinateRegion region;
        CLLocationCoordinate2D point;
        
        region.center = initialLocation.coordinate;
        point.latitude = initialLocation.coordinate.latitude;
        point.longitude = initialLocation.coordinate.longitude;
        region.center = point;
        //region.span = MKCoordinateSpanMake(5 * DISTANCE, 5 * DISTANCE);
        region = [self regionThatFits:region];
        [_mapView setRegion:region animated:YES];
        self.pitchEnabled = YES;
        self.showsBuildings = YES;
        self.showsPointsOfInterest = YES;
        self.zoomEnabled = YES;
        
        
        
    }
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if([_mapDelegate respondsToSelector:@selector(showInfo:withCoord:)]){
        [_mapDelegate showInfo:self withCoord:view.annotation.coordinate];
    }
}
- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if([annotation class] == MKUserLocation.class)
        return nil;
    
    MKAnnotationView * _pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    _pinView.canShowCallout = YES;
    _pinView.image = [UIImage imageNamed:@"pin_map"];
    return _pinView;
}
#pragma mark - Service methods
- (double)getZoomLevel
{
    CLLocationDegrees longitudeDelta = self.region.span.longitudeDelta;
    CGFloat mapWidthInPixels = self.bounds.size.width;
    double zoomScale = longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * mapWidthInPixels);
    double zoomer = MAX_GOOGLE_LEVELS - log2( zoomScale );
    if ( zoomer < 0 ) zoomer = 0;
    return zoomer;
}

@end
