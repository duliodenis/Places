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
    
    CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
    annotation.coordinate = self.mapView.centerCoordinate;
    annotation.title = [[NSDate date] description];
    
    [self.mapView addAnnotation:annotation];


    // this is an MKPinAnnotation Method
    // annotation.animatesDrop = YES;
  
    [self.mapView addAnnotation:annotation];
}

/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *customIdentifier  = @"MyAnnotation";
    static NSString *calloutIdentifier = @"AnnotationView";
    
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customIdentifier];
        view.canShowCallout       = NO;  // make sure to turn off standard callout
        return view;
    } else if ([annotation isKindOfClass:[AnnotationView class]]) {
        CGSize            size = CGSizeMake(100.0, 80.0);
        MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:calloutIdentifier];
        view.frame             = CGRectMake(0.0, 0.0, size.width, size.height);
        view.backgroundColor   = [UIColor whiteColor];
        UIButton *button       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame           = CGRectMake(5.0, 5.0, size.width - 10.0, size.height - 10.0);
        [button setTitle:@"OK" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didTouchUpInsideCalloutButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        view.canShowCallout    = NO;
        view.centerOffset      = CGPointMake(0.0, -5);
        return view;
    }
    
    return nil;
}
*/

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if(![view.annotation isKindOfClass:[AnnotationView class]]) {
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


- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if([view.annotation isKindOfClass:[MyAnnotation class]]) {
        [self.mapView ]

        
    } else {
//        [mapView removeAnnotation:view.annotation];
    }
}


- (void)didTouchUpInsideCalloutButton:(id)sender {
    NSLog(@"Touched callout button");
}

@end
