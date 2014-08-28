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
#import "DetailViewController.h"
#import "SearchShopTableViewController.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "MainImageModel.h"
#import "MapModel.h"
#import "ShopModel.h"
#import "MainImageModel.h"

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
    
    //릴리즈 전에 지울 것
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    
    
    isListView = YES;
    
    //네비게이션 바위에 올라가는 아이템들
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
  
    
    //collectionView에서 사용할 두개의 Cell 등록
    [self.collectionView registerNib:[UINib nibWithNibName:@"ListLargeCell" bundle:nil] forCellWithReuseIdentifier:@"LARGECELL"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ListSmallCell" bundle:nil] forCellWithReuseIdentifier:@"SMALLCELL"];
    
    
    //현재 본인 위치정보 얻어오기
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
    
    
    //네비게이션바 show/hide용 설정
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    [self followScrollView:self.collectionView];
    
    
    //backButton 타이틀 지움
    self.navigationController.navigationBar.topItem.title = @"";
    
    
    //지도뷰에서 디테이블뷰로 푸시용 notification 등록
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushToDetailViewFromMapView:)
                                                 name:@"pushToDetailViewFromMapView"
                                               object:nil];
    
    //like 터치시 컬렉션뷰 리로드
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadViewByMyStyle:)
                                                 name:@"reloadViewByMyStyle"
                                               object:nil];
    
    //최초 데이터 로딩, 메인페이지용 이미지목록과 지도데이터 수신
    [SVProgressHUD showWithStatus:@"Data Loading..." maskType:SVProgressHUDMaskTypeBlack];
    AFHTTPRequestOperationManager *dataManager = [AFHTTPRequestOperationManager manager];
    dataManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    NSLog(@"%@",BASE_REST_URL_MAIN);
    [dataManager GET:BASE_REST_URL_MAIN parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        //mainImageModel에 메인노출이미지목록 저장
        [[MainImageModel sharedManager] setMainImageList:responseObject[@"data"]];
        
        array = [[MainImageModel sharedManager] getMainImageList];
        [self.collectionView reloadData];
        [SVProgressHUD popActivity];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD popActivity];
        //데이터 수신 실패 시, 대응 필요
    }];
    
    //지도데이터용 api 호출
    [SVProgressHUD showWithStatus:@"Data Loading..." maskType:SVProgressHUDMaskTypeBlack];
    AFHTTPRequestOperationManager *mapManager = [AFHTTPRequestOperationManager manager];
    mapManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    [mapManager GET:BASE_REST_URL_MAP parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        [[MapModel sharedManager] setMapList:responseObject[@"data"]];
        
        [SVProgressHUD popActivity];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD popActivity];
        //데이터 수신 실패 시, 대응 필요
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setAlpha:1.0];
    [self showNavBarAnimated:NO];
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
        ListLargeCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"LARGECELL" forIndexPath:indexPath];
        
        NSLog(@"draw LARGECELL!!!!");
        //list view cell 그리기
        NSDictionary *imageDict = [array objectAtIndex:indexPath.row];
        
        [cell drawCell:imageDict];
        return cell;
    }
    else {
        ListSmallCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"SMALLCELL" forIndexPath:indexPath];
        
        //small cell 그리기 시작
        NSDictionary *imageDict = [array objectAtIndex:indexPath.row];
        cell.shopNameLabel.text = imageDict[@"name_main"];
        [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:imageDict[@"image_url"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.loadingIndicator.hidden = YES;
            cell.itemImageView.alpha = 0.0;
            [UIView animateWithDuration:0.4 animations:^{
                cell.itemImageView.alpha = 1.0;
            }];
        }];
        cell.itemImageView.layer.borderWidth = 0.5f;
        cell.itemImageView.layer.borderColor = RGB(172,172,172).CGColor;
        return cell;
    }
    
    return nil;
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
    [self getShopAndPushToDetailViewWithShopId:[[array objectAtIndex:indexPath.row] objectForKey:@"shop_id"] imageId:[[array objectAtIndex:indexPath.row] objectForKey:@"image_id"]];
}

- (void)getShopAndPushToDetailViewWithShopId:(NSString *)shopId imageId:(NSString *)imageId {
    [SVProgressHUD showWithStatus:@"Data Loading..." maskType:SVProgressHUDMaskTypeBlack];
    AFHTTPRequestOperationManager *dataManager = [AFHTTPRequestOperationManager manager];
    dataManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    [dataManager GET:BASE_REST_URL_SHOP(shopId) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        [[ShopModel sharedManager] setShop:responseObject];
        [[ShopModel sharedManager] setCurrentImageId:imageId];
        [self showNavBarAnimated:NO];
        [self performSegueWithIdentifier:@"pushDetailView" sender:responseObject];
        
        [SVProgressHUD popActivity];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD popActivity];
        //데이터 수신 실패 시, 대응 필요
    }];
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
    [self performSegueWithIdentifier:@"pushSearchViewFromMainView" sender:nil];
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
    else if([[segue identifier] isEqualToString:@"pushDetailView"])
    {
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.shopDict = sender;
    }
    else if([[segue identifier] isEqualToString:@"pushSearchViewFromMainView"])
    {
        SearchShopTableViewController *searchShopTableViewController = [segue destinationViewController];
        searchShopTableViewController.from = @"main";
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
    [self getShopAndPushToDetailViewWithShopId:notification.userInfo[@"shop"] imageId:@""];
}

- (void)reloadViewByMyStyle:(NSNotification *) notification {
    NSLog(@"reload!!");
    array = [[MainImageModel sharedManager] getMainImageList];
}


@end
