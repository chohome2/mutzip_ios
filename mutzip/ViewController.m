//
//  ViewController.m
//  mutzip
//
//  Created by taeho.cho on 14. 5. 13..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+ScrollingNavbar.h"
#import "ListLargeCell.h"
#import "ListSmallCell.h"
#import "SVProgressHUD.h"
#import "MapViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *flipButton;
@end

@implementation ViewController {
    NSArray *array;
    CLLocationManager *manager;
    BOOL isListView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isListView = YES;
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 61, 22)];
    titleImageView.image = [UIImage imageNamed:@"main_actionbar_title.png"];
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleImageView];
    [self.navigationItem setLeftBarButtonItem:titleItem animated:NO];
    
    self.flipButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.flipButton setBackgroundImage:[UIImage imageNamed:@"main_actionbar_icon_card2grid.png"] forState:UIControlStateNormal];
    [self.flipButton addTarget:self action:@selector(flipView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *flipButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.flipButton];
    
    UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [mapButton setBackgroundImage:[UIImage imageNamed:@"main_actionbar_icon_map.png"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(modalMapView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mapButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mapButton];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"main_actionbar_icon_search.png"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(modalSearchView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    [self.navigationItem setRightBarButtonItems:@[searchButtonItem,mapButtonItem,flipButtonItem] animated:YES];
  
    array = @[@"sample01.png",@"sample02.png",@"sample03.png",@"sample04.png",@"sample05.png",@"sample06.png",@"sample07.png",@"sample08.png",@"sample09.png",@"sample10.png",@"sample01.png",@"sample02.png",@"sample03.png",@"sample04.png",@"sample05.png",@"sample06.png",@"sample07.png",@"sample08.png",@"sample09.png",@"sample10.png",@"sample01.png",@"sample02.png",@"sample03.png",@"sample04.png",@"sample05.png",@"sample06.png",@"sample07.png",@"sample08.png",@"sample09.png",@"sample10.png"];
    
    for(int i = 3; i<=10; i++ ) {
        //NSLog(@"%@",[NSString stringWithFormat:@"sample%2d.png",i]);
        UIImageView *cacheImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"sample%02d.png",i]]];
        cacheImageView.frame = CGRectMake(0, 0, 0, 0);
        [self.view addSubview:cacheImageView];
    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ListLargeCell" bundle:nil] forCellWithReuseIdentifier:@"LARGECELL"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ListSmallCell" bundle:nil] forCellWithReuseIdentifier:@"SMALLCELL"];
    
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    [self followScrollView:self.collectionView];
    
    /*self.navigationController.navigationBar.backIndicatorImage = [[UIImage imageNamed:@"detail_actionbar_icon_back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [[UIImage imageNamed:@"detail_actionbar_icon_back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
*/
    self.navigationController.navigationBar.topItem.title = @"";
    //[[UINavigationBar appearance] setBarTintColor:RGB(55, 55, 255)];
    //[self.navigationController.navigationBar setBarTintColor:RGB(0, 0, 255)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushToDetailViewFromMapView:)
                                                 name:@"pushToDetailViewFromMapView"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setAlpha:1.0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self showNavBarAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView Delegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [array count];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(isListView) {
        ListLargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LARGECELL" forIndexPath:indexPath];
        
        cell.isFront = [NSNumber numberWithBool:YES];
        cell.imageName = [array objectAtIndex:indexPath.row];
        cell.itemImageView.image = [UIImage imageNamed:[array objectAtIndex:indexPath.row]];
        cell.itemImageView.layer.borderWidth = 0.5f;
        cell.itemImageView.layer.borderColor = RGB(172,172,172).CGColor;
        
        cell.flipButton.layer.borderWidth = 2.0f;
        cell.flipButton.layer.borderColor = RGB(255, 255, 255).CGColor;
        cell.flipButton.layer.cornerRadius = cell.flipButton.bounds.size.width / 2.0;
        [cell.flipButton setBackgroundImage:[UIImage imageNamed:@"sample-circle1.png"] forState:UIControlStateNormal];
        
        return cell;
    }
    else {
        ListSmallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SMALLCELL" forIndexPath:indexPath];
        cell.itemImageView.image = [UIImage imageNamed:[array objectAtIndex:indexPath.row]];
        cell.itemImageView.layer.borderWidth = 0.5f;
        cell.itemImageView.layer.borderColor = RGB(172,172,172).CGColor;
        return cell;
    }
    
    return nil;
    /*
    UICollectionViewCell *cell = nil;
    if(isListView) {
        cell = [self getLargeCellWithCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    else {
        cell = [self getSmallCellWithCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    return cell;*/
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(isListView) return CGSizeMake(320, 423);
    return CGSizeMake(155, 210);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(isListView) return UIEdgeInsetsMake(9, 0, 0, 0);
    return UIEdgeInsetsMake(6, 7, 0, 3);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self showNavBarAnimated:NO];
    NSLog(@"select!! : %ld",(long)indexPath.row);
    [self performSegueWithIdentifier:@"pushDetailView" sender:self];
}


#pragma mark - LocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@",error.debugDescription);
}

- (void)locationManager:(CLLocationManager *)managers didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSLog(@"%.8f",location.coordinate.latitude);
    NSLog(@"%.8f",location.coordinate.longitude);
    [managers stopUpdatingLocation];
}

-(void)modalMapView
{
    [self performSegueWithIdentifier:@"modalMapViewFromMainView" sender:nil];
}

-(void)modalSearchView
{
    [SVProgressHUD showSuccessWithStatus:@"검색화면으로 이동"];
}

-(void)flipView
{
    if(isListView) {
        [self.flipButton setBackgroundImage:[UIImage imageNamed:@"main_actionbar_icon_grid2card.png"] forState:UIControlStateNormal];
        isListView = NO;
    }
    else {
        [self.flipButton setBackgroundImage:[UIImage imageNamed:@"main_actionbar_icon_card2grid.png"] forState:UIControlStateNormal];
        isListView = YES;
    }
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"modalMapViewFromMainView"])
    {
        MapViewController *mapViewController = [segue destinationViewController];
        mapViewController.mode = @"all";
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	// This enables the user to scroll down the navbar by tapping the status bar.
	[self showNavbar];
	
	return YES;
}


#pragma mark - push notification

- (void)pushToDetailViewFromMapView:(NSNotification *) notification {
    [self performSegueWithIdentifier:@"pushDetailView" sender:self];
}
@end
