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
    
    AnnotationView *calloutView = [[[NSBundle mainBundle] loadNibNamed:@"AnnotationView" owner:self options:nil] firstObject];
    
    [self.mapView addSubview:calloutView];
    
    MyAnnotation *annotation = [[MyAnnotation alloc] initWithCoordinate:coordinate andCallout:calloutView];
    
    // this is an MKPinAnnotation Method
    // annotation.animatesDrop = YES;
    
    [self.mapView addAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if(![view.annotation isKindOfClass:[MKUserLocation class]]) {
        AnnotationView *calloutView = (AnnotationView *)[[[NSBundle mainBundle] loadNibNamed:@"AnnotationView" owner:self options:nil] firstObject];
        CGRect calloutViewFrame = calloutView.frame;
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
        calloutView.frame = calloutViewFrame;
        [calloutView.title setText:@"GCD from code"];
        
        calloutView.userInteractionEnabled = YES;
        view.userInteractionEnabled = YES;
        [view addSubview:calloutView];
    }
    
}

@end
