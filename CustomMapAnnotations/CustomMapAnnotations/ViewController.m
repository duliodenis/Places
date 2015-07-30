//
//  ViewController.m
//  CustomMapAnnotations
//
//  Created by Dulio Denis on 7/29/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

@import MapKit;
#import "ViewController.h"
#import "MyAnnotation.h"
#import "AnnotationView.h"

@interface ViewController () 
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
    
    AnnotationView *calloutView = [[[NSBundle mainBundle] loadNibNamed:@"AnnotationView" owner:self options:nil] firstObject];
    
    MyAnnotation *annotation = [[MyAnnotation alloc] initWithCoordinate:coordinate andCallout:calloutView];
    
    // this is an MKPinAnnotation Method
    // annotation.animatesDrop = YES;
    
    [self.mapView addAnnotation:annotation];
}

@end
