//
//  Places.h
//  Places
//
//  Created by Dulio Denis on 7/23/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Places : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSNumber * lattitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
