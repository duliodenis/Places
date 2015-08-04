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
#import "PinCallout.h"

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


#pragma mark - MKMapViewDelegate Methods

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[CustomPin class]]) {
        PinCallout *calloutAnnotation = [[PinCallout alloc] initForAnnotation:view.annotation];
        [mapView addAnnotation:calloutAnnotation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [mapView selectAnnotation:calloutAnnotation animated:YES];
        });
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[PinCallout class]]) {
        CustomPin *pin = [[CustomPin alloc] init];
        pin.coordinate = view.annotation.coordinate;
        [mapView addAnnotation:pin];
        [mapView removeAnnotation:view.annotation];
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *customIdentifier  = @"Callout";
    static NSString *calloutIdentifier = @"PinCallout";
    
    if ([annotation isKindOfClass:[CustomPin class]]) {
        MKPinAnnotationView *view = (id)[mapView dequeueReusableAnnotationViewWithIdentifier:customIdentifier];
        if (!view) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customIdentifier];
            view.canShowCallout       = NO;
            view.animatesDrop         = YES;
        } else {
            view.annotation = annotation;
        }
        return view;
    } else if ([annotation isKindOfClass:[PinCallout class]]) {
        MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:calloutIdentifier];
        if (!view) {
            // Use XIB
            //view.label.text = @"Hello";
            // view = [[[NSBundle mainBundle] loadNibNamed:@"Callout" owner:self options:nil] firstObject];
            
        } else {
            view.annotation = annotation;
        }
        return view;
    }
    
    return nil;
}

@end
