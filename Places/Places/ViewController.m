//
//  ViewController.m
//  Places
//
//  Created by Dulio Denis on 7/17/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import "ViewController.h"
#import "LocationController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <LocationControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // the Location Controller Singleton
    [[LocationController sharedInstance] addLocationCoordinatorDelegate:self];
    self.mapView.showsUserLocation = YES;
}

- (IBAction)currentLocation:(id)sender {
    
}

#pragma mark - Location Controller Delegate Method

- (void)locationDidUpdateLocation:(CLLocation *)location {
    [self updateLocation:location];
}


- (void)updateLocation:(CLLocation *)location {
    CLLocationCoordinate2D myLocation;
    myLocation.latitude = location.coordinate.latitude;
    myLocation.longitude = location.coordinate.longitude;
    
    MKCoordinateRegion region;
    region.span = MKCoordinateSpanMake(0.01, 0.01);
    region.center = myLocation;
    [self.mapView setRegion:region animated:YES];
}

@end
