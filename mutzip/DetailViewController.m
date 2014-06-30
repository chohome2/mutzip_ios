//
//  DetailViewController.m
//  mutzip
//
//  Created by taeho.cho on 14. 5. 13..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "DetailViewController.h"
#import "UIViewController+ScrollingNavbar.h"
#import <SVProgressHUD.h>
#import "ListLargeCell.h"
#import "DetailImageCell.h"
#import "DetailMainInfoCell.h"
#import "DetailExtraInfoCell.h"
#import "MapViewController.h"

@interface DetailViewController () {
    NSArray *array;
    BOOL isAppend;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"detail_actionbar_bg.png"] forBarMetrics:UIBarMetricsDefault];
    
	// Do any additional setup after loading the view.
    
    UIButton *homeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [homeButton setBackgroundImage:[UIImage imageNamed:@"detail_actionbar_icon_home.png"] forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(popToHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"detail_actionbar_icon_search.png"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(modalSearchView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    [self.navigationItem setRightBarButtonItems:@[searchButtonItem,homeButtonItem] animated:YES];
    //[self followScrollView:self.detailTableView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ListLargeCell" bundle:nil] forCellWithReuseIdentifier:@"LARGECELL"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailImageCell" bundle:nil] forCellWithReuseIdentifier:@"DETAILIMAGECELL"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailMainInfoCell" bundle:nil] forCellWithReuseIdentifier:@"DETAILMAININFOCELL"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailExtraInfoCell" bundle:nil] forCellWithReuseIdentifier:@"DETAILEXTRAINFOCELL"];
    
    array = @[@"sample01.png",@"sample02.png",@"sample03.png",@"sample04.png",@"sample05.png",@"sample06.png",@"sample07.png",@"sample08.png",@"sample09.png",@"sample10.png"];
    self.navigationController.navigationBar.topItem.title = @"";
    //[self.collectionView setContentOffset:CGPointMake(0, 44) animated:NO];
    isAppend = NO;
    

    
}

- (void)viewDidAppear:(BOOL)animated {
    /*
     [self.navigationController.navigationBar setTranslucent:YES];
    [UIView animateWithDuration:0.3f animations:^{
        [self.navigationController.navigationBar setAlpha:0.5];}];
     */
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
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
- (void)pushToDetailView {
    //[SVProgressHUD show];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *vc = (DetailViewController *)[sb instantiateViewControllerWithIdentifier:@"DETAILVIEW"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)popToHome {
    [SVProgressHUD dismiss];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)modalSearchView {
    [SVProgressHUD showSuccessWithStatus:@"검색화면으로 이동"];
}

#pragma mark - CollectionView Delegate
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == 0) return 3;
    return [array count];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            DetailImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DETAILIMAGECELL" forIndexPath:indexPath];
            [cell drawCell];
            return cell;
        }
        else if(indexPath.row == 1) {
            DetailMainInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DETAILMAININFOCELL" forIndexPath:indexPath];
            [cell.appendButton addTarget:self action:@selector(appendExtraCell) forControlEvents:UIControlEventTouchUpInside];
            [cell.mapButton addTarget:self action:@selector(modalMapView) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        else if(indexPath.row == 2) {
            DetailExtraInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DETAILEXTRAINFOCELL" forIndexPath:indexPath];
            return cell;
        }
    }
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

- (void)appendExtraCell {
    isAppend = isAppend?NO:YES;
    [self.collectionView reloadData];
}

- (void)modalMapView {
    [self performSegueWithIdentifier:@"modalMapViewFromDetailView" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"modalMapViewFromDetailView"])
    {
        MapViewController *mapViewController = [segue destinationViewController];
        mapViewController.mode = @"shop";
    }
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if(indexPath.row == 0) return CGSizeMake(320, 427);
        if(indexPath.row == 1) return CGSizeMake(320, 84);
        if(indexPath.row == 2)
            if(isAppend) return CGSizeMake(320, 76);
            return CGSizeMake(320, 0);
    }
    return CGSizeMake(320, 423);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(section == 0) return UIEdgeInsetsZero;
    return UIEdgeInsetsMake(4, 0, 4, 0);
}


- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1)
        [self pushToDetailView];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader) {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HEADERCELL" forIndexPath:indexPath];
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section == 0) return CGSizeZero;
    return CGSizeMake(320,35);
}

@end
