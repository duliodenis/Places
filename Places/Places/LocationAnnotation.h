//
//  LocationAnnotation.h
//  Places
//
//  Created by Dulio Denis on 7/22/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface LocationAnnotation : MKAnnotationView <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithPlacemark:(MKPlacemark *)placemark;

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier
                           pinView:(UIView *)pinView
                       calloutView:(UIView *)calloutView;

- (instancetype)initAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
