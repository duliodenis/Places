//
//  MyAnnotation.m
//  CustomMapAnnotations
//
//  Created by Dulio Denis on 7/29/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import "MyAnnotation.h"

@interface MyAnnotation()
@property(nonatomic, weak) AnnotationView *calloutView;
@end

@implementation MyAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
              andCallout:(AnnotationView *)callout {
    if ( self = [super init] ) {
        self.coordinate = coordinate;
//        self.title = @"GCD + callout";
        self.calloutView = callout;
        [self addSubview:self.calloutView];
        
        CGRect frame = self.calloutView.frame;
        frame.origin.y = 30;
        frame.origin.x = 30;
        self.calloutView.frame = frame;
    }
    return self;
}

// These methods are not being called

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil) {
        [self.superview bringSubviewToFront:self.calloutView];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL isPointInside = [super pointInside:point withEvent:event];
    return isPointInside;
}

- (void)hideCallout {
    self.calloutView.hidden = YES;
}

@end
