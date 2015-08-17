//
//  MapViewController.m
//  Places
//
//  Created by Dulio Denis on 7/17/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import "MapViewController.h"
#import "LocationController.h"
#import "LocationData.h"
#import "LocationAnnotation.h"
#import "LocationAnnotationView.h"
#import <MapKit/MapKit.h>
#import "CoreDataStack.h"


@interface MapViewController () <LocationControllerDelegate, MKMapViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) UISearchController *searchController;
@property (nonatomic) LocationData *locationData;
@property (nonatomic) LocationAnnotation *currentAnnotation;
@end


@implementation MapViewController

#pragma mark - Constants
NSInteger const kFavoritePlace = 0;

#pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Keep the subviews inside the top and bottom layout guides
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;
    
    [self setupLocationController];
    [self setupSearchBar];
    [self loadFavorites];
}


#pragma mark - Setup Helper Methods

- (void)setupSearchBar {
    // Add a search controller to the top of the map
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.automaticallyAdjustsScrollViewInsets = YES;
    self.searchController.searchBar.delegate = self;
    
    // Set search bar dimension and position
    CGRect searchBarFrame = self.searchController.searchBar.frame;
    CGRect viewFrame = self.view.frame;
    self.searchController.searchBar.frame = CGRectMake(searchBarFrame.origin.x,
                                                       searchBarFrame.origin.y,
                                                       viewFrame.size.width,
                                                       44.0);
    
    // Add SearchController's search bar to our view and bring it to front
    [self.view addSubview:self.searchController.searchBar];
    [self.view bringSubviewToFront:self.searchController.searchBar];
}


- (void)setupLocationController {
    // setup the Location Controller Singleton
    [[LocationController sharedInstance] addLocationCoordinatorDelegate:self];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    // allocate the locationData search result object
    self.locationData = [[LocationData alloc] init];
}


- (IBAction)currentLocation:(id)sender {
    NSLog(@"my current location");
}


#pragma mark - Location Controller Delegate Method

- (void)locationDidUpdateLocation:(CLLocation *)location {
    [self updateLocation:location];
}


- (void)updateLocation:(CLLocation *)location {
    CLLocationCoordinate2D myLocation;
    myLocation.latitude = location.coordinate.latitude;
    myLocation.longitude = location.coordinate.longitude;
    
    MKCoordinateRegion region;
    region.span = MKCoordinateSpanMake(0.01, 0.01);
    region.center = myLocation;
    [self.mapView setRegion:region animated:YES];
}


#pragma mark - UISearchResultsUpdating Delegate Method

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
// Do nothing - crashes without this method
//    NSString *searchString = searchController.searchBar.text;
//    [self searchText:searchString];
}


#pragma mark - UISearchBar Delegate Method

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchController resignFirstResponder];
    [self searchText:searchBar.text];
    self.searchController.active = false;
}


- (void)searchText:(NSString *)text {
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = text;
    request.region = self.mapView.region; // use the current mapView region instead of
                                          // request.region = self.locationData.region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.locationData.searchResults = (NSMutableArray *)response.mapItems;
        dispatch_async(dispatch_get_main_queue(), ^{
            // drop pins into map
            for (MKMapItem *mapItem in self.locationData.searchResults) {
                MKPlacemark *placemark = mapItem.placemark;
                
                LocationAnnotation *annotation = [[LocationAnnotation alloc] initAnnotationWithCoordinate:placemark.coordinate title:placemark.name subtitle:placemark.title];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView addAnnotation:annotation];
                });
            }
        });
    }];
}


#pragma mark - Shake Motion Detection Method
// Remove all search pins from map when user shakes device

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        id userLocation = [self.mapView userLocation];
        NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
        if ( userLocation != nil ) {
            [pins removeObject:userLocation]; // avoid removing user location off the map
        }
        
        [self.mapView removeAnnotations:pins];
    }
    [self loadFavorites];
}


#pragma mark - Annotation Delegate Methods

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView: %@", view);
    if ([view isKindOfClass:[LocationAnnotation class]]) {
        LocationAnnotation *ann = (LocationAnnotation*)view;
        NSLog(@"ann: %@", ann);
        ann.calloutView.hidden = !ann.calloutView.hidden;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    //first make sure the annotation is our custom class...
    if ([view.annotation isKindOfClass:[LocationAnnotation class]]) {
        //cast the object to our custom class...
        LocationAnnotation *annotation = (LocationAnnotation *)view.annotation;
        self.currentAnnotation = annotation;
        
        if (control.tag == kFavoritePlace) {
            [self favoritesActionSheetForPlace:annotation.title];
        }
    }
}


// show an action sheet with title set to annotation's title
// to confirm saving
- (void)favoritesActionSheetForPlace:(NSString *)place {
    UIAlertController *favoriteActionSheet = [UIAlertController alertControllerWithTitle:@"Favorite Location"
                                                                                 message:[NSString stringWithFormat:@"You can save %@ as a favorite place.", place]
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Yes, save this as a favorite"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [self saveFavorite];
                                                       }];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"No, not right now"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              // Canceled the Parse Save Operation
                                                              self.currentAnnotation = nil;
                                                          }];
    
    [favoriteActionSheet addAction:saveAction];
    [favoriteActionSheet addAction:defaultAction];
    [self presentViewController:favoriteActionSheet animated:YES completion:nil];
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    LocationAnnotation *annotationView = [[LocationAnnotation alloc] initAnnotationWithCoordinate:annotation.coordinate
                                                                                            title:annotation.title
                                                                                         subtitle:annotation.subtitle];
    return annotationView;
}


- (void)makePinInMap:(NSArray*)pins {
    for (Places *pin in pins) {
        CLLocationDegrees latitude = [pin.latitude doubleValue];
        CLLocationDegrees longitude = [pin.longitude doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        LocationAnnotation *myPin = (LocationAnnotation *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([LocationAnnotation class])];
        if (!myPin) {
            myPin = [[LocationAnnotation alloc] initAnnotationWithCoordinate:coordinate
                                                                       title:pin.title
                                                                    subtitle:pin.subtitle];
        }
        
        [self.mapView addAnnotation:myPin];
    }
}


#pragma mark - Model Helper Methods

- (void)loadFavorites {
    NSManagedObjectContext *context = [[CoreDataStack defaultStack] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Places" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [self makePinInMap:fetchedObjects];
}


- (void)saveFavorite {
    NSManagedObjectContext *context = [[CoreDataStack defaultStack] managedObjectContext];
    
    Places *favorite = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Places"
                                       inManagedObjectContext:context];
    
    favorite.title = self.currentAnnotation.title;
    favorite.subtitle = self.currentAnnotation.subtitle;
    favorite.latitude = [NSNumber numberWithDouble:self.currentAnnotation.coordinate.latitude];
    favorite.longitude = [NSNumber numberWithDouble:self.currentAnnotation.coordinate.longitude];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
}

@end
