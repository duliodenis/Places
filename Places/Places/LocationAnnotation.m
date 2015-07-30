//
//  LocationAnnotation.m
//  Places
//
//  Created by Dulio Denis on 7/22/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import "LocationAnnotation.h"


@interface LocationAnnotation()

@property(nonatomic, strong) UIView *pinView;
@property(nonatomic, strong) UIView *calloutView;
@property(assign) BOOL hasCalloutView;

@end


@implementation LocationAnnotation

+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coord {
    return [[[self class] alloc] initWithCoordinate:coord];
}


- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if ( self = [super init] ) {
        self.coordinate = coordinate;
    }
    return self;
}


- (id)initWithPlacemark:(MKPlacemark *)placemark {
    if ( self = [super init] ) {
        self.coordinate = placemark.coordinate;;
        self.title = placemark.name;
        self.subtitle = placemark.title;
    }
    return self;
}


- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier
                           pinView:(UIView *)pinView
                       calloutView:(UIView *)calloutView {
    
    self = [super initWithAnnotation:annotation
                     reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.clipsToBounds = NO;
        self.hasCalloutView = (calloutView) ? YES : NO;
        self.canShowCallout = YES;
        
        self.pinView = pinView;
        self.pinView.userInteractionEnabled = YES;
        self.calloutView = calloutView;
        self.calloutView.hidden = NO;
        
        [self addSubview:self.pinView];
        [self addSubview:self.calloutView];
        self.frame = [self calculateFrame];
        if (self.hasCalloutView) {
                [self addCalloutBorder];
        }
        [self positionSubviews];
    }
    return self;
}


- (void)addCalloutBorder {
    self.calloutView.layer.borderWidth = 2.0;
    self.calloutView.layer.borderColor = (__bridge CGColorRef)([UIColor colorWithRed:0.329 green:0.565 blue:0.616 alpha:1.000]);
}


- (CGRect)calculateFrame {
    return self.pinView.bounds;
}


- (void)positionSubviews {
    self.pinView.center = self.center;
    if (self.hasCalloutView) {
        CGRect frame = self.calloutView.frame;
        frame.origin.y = frame.size.height - 10.0f;
        frame.origin.x = -(self.frame.size.width - frame.size.width) / 2.0;
        self.calloutView.frame = frame;
    }
}


- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self.calloutView];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}

-(void)dismiss {
    [self setHidden:YES];
}

@end
