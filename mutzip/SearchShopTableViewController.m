//
//  SearchShopTableViewController.m
//  mutzip
//
//  Created by taeho.cho on 14. 8. 14..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "SearchShopTableViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface SearchShopTableViewController ()


@end

@implementation SearchShopTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
/*
-(void)viewDidLayoutSubviews{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.searchDisplayController.searchBar becomeFirstResponder];
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SEARCHCELL"];
    
    UILabel *mainLabel = (UILabel *)[cell viewWithTag:1];
    mainLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"name_main"];
    
    UILabel *subLabel = (UILabel *)[cell viewWithTag:2];
    subLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"name_sub"];
    
    UILabel *poiLabel = (UILabel *)[cell viewWithTag:3];
    poiLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"poi"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.from isEqualToString:@"main"]) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"pushToDetailViewFromMapView"
         object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:array[indexPath.row][@"shop_id"],@"shop", nil]];
    }
    else {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"pushToDetailViewFromMapView"
         object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:array[indexPath.row][@"shop_id"],@"shop", nil]];
        
    }
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - UISearchDisplayDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    NSLog(@"search!! : %@", [searchBar text]);
    
    [SVProgressHUD showWithStatus:@"Now Searching..." maskType:SVProgressHUDMaskTypeBlack];
    AFHTTPRequestOperationManager *dataManager = [AFHTTPRequestOperationManager manager];
    dataManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    //NSLog(@"%@",BASE_REST_URL_SEARCH([searchBar text]));
    [dataManager GET:BASE_REST_URL_SEARCH parameters:[NSDictionary dictionaryWithObjectsAndKeys:[searchBar text],@"query", nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        array = responseObject[@"data"];
        [self.searchDisplayController.searchResultsTableView reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        //데이터 수신 실패 시, 대응 필요
    }];
    
}


#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return YES;
}



#pragma mark - State restoration

// Note:
// UITableView itself supports current scroll position and selected row if its data source
// supports UIDataSourceModeAssociation protocol.
//
// To make things simpler here, we choose to manually preserve/restore the table view selection
// and not support scroll position.

static NSString *SearchDisplayControllerIsActiveKey = @"SearchDisplayControllerIsActiveKey";
static NSString *SearchBarScopeIndexKey = @"SearchBarScopeIndexKey";
static NSString *SearchBarTextKey = @"SearchBarTextKey";
static NSString *SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

static NSString *SearchDisplayControllerSelectedRowKey = @"SearchDisplayControllerSelectedRowKey";
static NSString *TableViewSelectedRowKey = @"TableViewSelectedRowKey";


- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    UISearchDisplayController *searchDisplayController = self.searchDisplayController;
    
    BOOL searchDisplayControllerIsActive = [searchDisplayController isActive];
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchDisplayControllerIsActiveKey];
    
    if (searchDisplayControllerIsActive)
    {
        [coder encodeObject:[searchDisplayController.searchBar text] forKey:SearchBarTextKey];
        [coder encodeInteger:[searchDisplayController.searchBar selectedScopeButtonIndex] forKey:SearchBarScopeIndexKey];
        
        NSIndexPath *selectedIndexPath = [searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        if (selectedIndexPath != nil)
        {
            [coder encodeObject:selectedIndexPath forKey:SearchDisplayControllerSelectedRowKey];
        }
        
        BOOL searchFieldIsFirstResponder = [searchDisplayController.searchBar isFirstResponder];
        [coder encodeBool:searchFieldIsFirstResponder forKey:SearchBarIsFirstResponderKey];
    }
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath != nil)
    {
        [coder encodeObject:selectedIndexPath forKey:TableViewSelectedRowKey];
    }
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    
    BOOL searchDisplayControllerIsActive = [coder decodeBoolForKey:SearchDisplayControllerIsActiveKey];
    
    if (searchDisplayControllerIsActive)
    {
        [self.searchDisplayController setActive:YES];
        
        // order is important here. Setting the search bar text causes
        // searchDisplayController:shouldReloadTableForSearchString: to be invoked.
        //
        NSInteger searchBarScopeIndex = [coder decodeIntegerForKey:SearchBarScopeIndexKey];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:searchBarScopeIndex];
        
        NSString *searchBarText = [coder decodeObjectForKey:SearchBarTextKey];
        if (searchBarText != nil)
        {
            [self.searchDisplayController.searchBar setText:searchBarText];
        }
        
        NSIndexPath *selectedIndexPath = [coder decodeObjectForKey:SearchDisplayControllerSelectedRowKey];
        if (selectedIndexPath != nil)
        {
            [self.searchDisplayController.searchResultsTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
        
        BOOL searchFieldIsFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
        if (searchFieldIsFirstResponder)
        {
            [self.searchDisplayController.searchBar becomeFirstResponder];
        }
    }
    
    NSIndexPath *selectedIndexPath = [coder decodeObjectForKey:TableViewSelectedRowKey];
    if (selectedIndexPath != nil)
    {
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
}

@end
