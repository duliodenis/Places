//
//  LocationData.h
//  Places
//
//  Created by Dulio Denis on 7/20/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

// Model Object to store locations as a result of a search

@interface LocationData : NSObject
@property (nonatomic) NSMutableArray *searchResults;
@property (nonatomic) MKCoordinateRegion region;
@end
