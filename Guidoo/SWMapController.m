//
//  SWMapController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 03.04.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWMapController.h"
#import "SWNeaMeMapView.h"
#import "SWGuidDetailController.h"


@interface SWMapController () 

@property (nonatomic, weak) IBOutlet SWNeaMeMapView* nmMapView;

@end

@implementation SWMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInfoGuid:) name:@"showInfoGuid" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlacesAfterLocation:) name:@"updatePlacesAfterLocation" object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupNavBtn:BASETYPE];
    [self simpleTitle:[self objectForKey:address]];
    [_nmMapView getGuids];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showInfoGuid" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updatePlacesAfterLocation" object:nil];
}
#pragma mark -  NSNotification
- (void)showInfoGuid:(NSNotification*)notify{
    
    SWGuide* obj = notify.object;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWGuidDetailController* controller = [storyboard instantiateViewControllerWithIdentifier:@"GuidDetailController"];
    NSMutableArray* results = [[NSMutableArray alloc]init];
    [results addObject:obj];
    [results addObjectsFromArray:obj.tours];
    controller.content = [NSArray arrayWithArray:results];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)updatePlacesAfterLocation:(NSNotification*)notify{
    //[self simpleTitle:[self objectForKey:address]];
}

#pragma mark -  Action methods
- (void)btnMapPressed{
   [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)btnFilterPressed{
    [_nmMapView showFilter];
}


@end
