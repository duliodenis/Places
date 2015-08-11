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

- (instancetype)initAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate
                                       title:(NSString *)title
                                    subtitle:(NSString *)subtitle;

@end
