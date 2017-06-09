//
//  TRMapView.h
//  DatingApp
//
//  Created by Sergiy Bekker on 14.05.15.
//  Copyright (c) 2015 Sergiy Bekker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class SWMapView;

@protocol SWMapViewDelegate <NSObject>

- (void)showInfo:(SWMapView*)obj withCoord:(CLLocationCoordinate2D) coord;

@end


@interface SWMapView : MKMapView <CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic,assign) CLLocationCoordinate2D coord;
@property (nonatomic,weak) id<SWMapViewDelegate> mapDelegate;
@property (nonatomic, strong) NSArray* anotations;
@property (nonatomic, assign) NSNumber* isLocation;

-(void)updateMap;
-(void)releaseMap;

@end
