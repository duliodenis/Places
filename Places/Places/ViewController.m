//
//  ViewController.m
//  Places
//
//  Created by Dulio Denis on 7/17/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import "ViewController.h"
#import "LocationController.h"
#import "LocationData.h"
#import <MapKit/MapKit.h>


@interface ViewController () <LocationControllerDelegate, MKMapViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) UISearchController *searchController;
@property (nonatomic) LocationData *locationData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Keep the subviews inside the top and bottom layout guides
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;
    
    // setup the Location Controller Singleton
    [[LocationController sharedInstance] addLocationCoordinatorDelegate:self];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
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
    NSString *searchString = searchController.searchBar.text;
    [self searchText:searchString];
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
    request.region = self.locationData.region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.locationData.searchResults = (NSMutableArray *)response.mapItems;
        dispatch_async(dispatch_get_main_queue(), ^{
            // drop pins into map
        });
    }];
}

@end
