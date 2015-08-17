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
@property(assign) BOOL hasCalloutView;
@property (nonatomic, retain) MKAnnotationView *parentAnnotationView;

@end


@implementation LocationAnnotation


- (void)setUpAnnotation:(UIView *)pinView andCalloutView:(LocationAnnotationView *)calloutView {
    self.clipsToBounds = NO;
    self.hasCalloutView = (calloutView) ? YES : NO;
    self.canShowCallout = NO;
    
    self.pinView = pinView;
    self.pinView.userInteractionEnabled = YES;
    self.calloutView = calloutView;
    self.calloutView.hidden = YES;
    
    [self addSubview:self.pinView];
    [self addSubview:self.calloutView];
    self.frame = [self calculateFrame];
    if (self.hasCalloutView) {
        [self addCalloutBorder];
    }
    [self positionSubviews];
}

- (instancetype)initAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate
                                       title:(NSString *)title
                                    subtitle:(NSString *)subtitle {
    UIView *pinView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin-blue"]];
    
    LocationAnnotationView *calloutView = [[[NSBundle mainBundle] loadNibNamed:@"LocationAnnotationView" owner:self options:nil] firstObject];
    
    [calloutView setupAnnotationView:title subtitle:subtitle];
    
    if (self = [super init] ) {
        self.coordinate = coordinate;
        [self setUpAnnotation:pinView andCalloutView:calloutView];
        self.title = title;
        self.subtitle = subtitle;
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
        CGRect rect = CGRectMake(0, 0, 300, 100);
        
        CGRect frame = self.calloutView.frame;
        rect.origin = CGPointMake(-frame.size.width/2 + 65, -frame.size.height + 50);
        frame.origin = CGPointMake(-frame.size.width/2 + 65, -frame.size.height + 50);
        self.calloutView.frame = rect;
    }
}


- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    
    // If the accessory is hit, the map view may want to select an annotation sitting below it
    // so we must disable the other annotations
    // But not the parent because that will screw up the selection
    if (hitView != nil) {
        for (UIView *sibling in self.superview.subviews) {
            if ([sibling isKindOfClass:[MKAnnotationView class]] && sibling != self.parentAnnotationView) {
                ((MKAnnotationView *)sibling).enabled = NO;
            }
        }
        self.selected = YES;
    } else {
        self.selected = NO;
    }
    return hitView;
}


- (void) enableSibling:(UIView *)sibling {
    ((MKAnnotationView *)sibling).enabled = YES;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside) {
        for (UIView *view in self.subviews) {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Get the custom callout view.
    UIView *calloutView = self.calloutView;
    if (selected) {
        [self addSubview:calloutView];
        calloutView.hidden = NO;
    } else {
        calloutView.hidden = YES;
        [calloutView removeFromSuperview];
    }
}

-(void)dismiss {
    [self.calloutView setHidden:YES];
}

@end
