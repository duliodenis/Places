//
//  LocationAnnotationView.m
//  Places
//
//  Created by Dulio Denis on 7/27/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import "LocationAnnotationView.h"

@implementation LocationAnnotationView

- (void)setupAnnotationView:(NSString *)title subtitle:(NSString *)subtitle {
    _title.text = title;
    _subtitle.text = subtitle;
}

@end
