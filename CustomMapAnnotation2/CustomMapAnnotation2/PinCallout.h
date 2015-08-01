//
//  PinCallout.h
//  CustomMapAnnotation2
//
//  Created by Dulio Denis on 8/1/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

@import Foundation;
@import MapKit;

@interface PinCallout : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

- (instancetype)initForAnnotation:(id<MKAnnotation>)annotation;

@end
