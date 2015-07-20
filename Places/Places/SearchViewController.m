//
//  SearchViewController.m
//  Places
//
//  Created by Dulio Denis on 7/20/15.
//  Copyright (c) 2015 Dulio Denis. All rights reserved.
//

#import "SearchViewController.h"
#import "LocationData.h"
#import <MapKit/MapKit.h>


@interface SearchViewController() <UISearchResultsUpdating, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) LocationData *locationData;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
   
    // allocate the locationData search result object
    self.locationData = [[LocationData alloc] init];
}


#pragma mark - UITableView Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    MKMapItem *mapItem = self.locationData.searchResults[indexPath.row];
    cell.textLabel.text = mapItem.name;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationData.searchResults.count;
}

#pragma mark - UISearchResultsUpdating Delegate Method

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
  //  [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    [self.tableView reloadData];
}


#pragma mark - UISearchBar Delegate Method

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchController resignFirstResponder];
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchBar.text;
    request.region = self.locationData.region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.locationData.searchResults = (NSMutableArray *)response.mapItems;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

@end
