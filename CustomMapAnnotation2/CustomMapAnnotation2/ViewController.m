//
//  ViewController.m
//  CustomMapAnnotation2
//
//  Created by Dulio Denis on 8/1/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

@import MapKit;
#import "ViewController.h"
#import "CustomPin.h"

@interface ViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Grand Central
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 40.7528;
    coordinate.longitude = -73.9765;
    self.mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000);
    self.mapView.delegate = self;

    
    CustomPin *pin = [[CustomPin alloc] init];
    pin.coordinate = coordinate;
    pin.title = @"GCD";
    
    [self.mapView addAnnotation:pin];
}

@end
