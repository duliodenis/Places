//
//  PinCallout.m
//  CustomMapAnnotation2
//
//  Created by Dulio Denis on 8/1/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import "PinCallout.h"
//#import "CustomPin.h"

@interface PinCallout()
@property(nonatomic, weak) id<MKAnnotation> annotation;
@end

@implementation PinCallout

- (instancetype)initForAnnotation:(id<MKAnnotation>)annotation {
    self = [super init];
    if (self) {
        self.annotation = annotation;
    }
    return self;
}

- (NSString *)title {
    return _annotation.title;
}

- (NSString *)subtitle {
    return _annotation.title;
}

- (CLLocationCoordinate2D)coordinate {
    return _annotation.coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    [_annotation setCoordinate:newCoordinate];
}

@end
