//
//  CoreDataStack.h
//  Places
//
//  Created by Dulio Denis on 7/24/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Places.h"

@interface CoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)defaultStack;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
