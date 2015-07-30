//
//  MyAnnotation.h
//  CustomMapAnnotations
//
//  Created by Dulio Denis on 7/29/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;
@import UIKit;

@interface MyAnnotation : MKAnnotationView <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
              andCallout:(UIView *)callout;
@end
