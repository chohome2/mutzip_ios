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
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "ShopModel.h"
#import "MainImageModel.h"
#import "AFNetworking.h"
#import "SearchShopTableViewController.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import <FacebookSDK/FacebookSDK.h>


@interface DetailViewController () {
    NSArray *array;
    BOOL isAppend;
    UIActionSheet *contactActionSheet;
    UIActionSheet *shareActionSheet;
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
    
    //[self.navigationItem setRightBarButtonItems:@[searchButtonItem,homeButtonItem] animated:YES];
    [self.navigationItem setRightBarButtonItems:@[homeButtonItem] animated:YES];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ListLargeCell" bundle:nil] forCellWithReuseIdentifier:@"LARGECELL"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailImageCell" bundle:nil] forCellWithReuseIdentifier:@"DETAILIMAGECELL"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailMainInfoCell" bundle:nil] forCellWithReuseIdentifier:@"DETAILMAININFOCELL"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailExtraInfoCell" bundle:nil] forCellWithReuseIdentifier:@"DETAILEXTRAINFOCELL"];

    array = [[NSArray alloc] init];
    if([[[ShopModel sharedManager] getDetailImageList] count] > 0)
        array = [[ShopModel sharedManager] getDetailImageList][0][@"recommend_list"];
    self.navigationController.navigationBar.topItem.title = @"";
    
    isAppend = NO;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    //가로 플리킹시 collectionView reload
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(flickingStylecut:)
                                                 name:@"flickingStylecut"
                                               object:nil];
    
    //마이스타일 터치시, 컬렉션뷰 리로드
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadDetailViewByMyStyle:)
                                                 name:@"reloadDetailViewByMyStyle"
                                               object:nil];
    //전화버튼 터치시, 전화, 문자 선택용 액션시트 호출
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showActionSheetByContact:)
                                                 name:@"showActionSheetByContact"
                                               object:nil];
    
    //공유하기 터치시 공유용 액션시트 호출
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showActionSheetByShare:)
                                                 name:@"showActionSheetByShare"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self performSegueWithIdentifier:@"pushSearchViewFromDetailView" sender:nil];
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
            NSLog(@"cellForItemAtIndexPath : 0");
            DetailImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"DETAILIMAGECELL" forIndexPath:indexPath];
            
            [cell drawCell];
            return cell;
        }
        else if(indexPath.row == 1) {
            NSLog(@"cellForItemAtIndexPath : 1");
            DetailMainInfoCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"DETAILMAININFOCELL" forIndexPath:indexPath];
            [cell.appendButton addTarget:self action:@selector(appendExtraCell) forControlEvents:UIControlEventTouchUpInside];
            [cell.mapButton addTarget:self action:@selector(modalMapView) forControlEvents:UIControlEventTouchUpInside];
            [cell drawCell];
            return cell;
        }
        else if(indexPath.row == 2) {
            DetailExtraInfoCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"DETAILEXTRAINFOCELL" forIndexPath:indexPath];
            [cell drawCell];
            return cell;
        }
    }
    
    ListLargeCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"LARGECELL" forIndexPath:indexPath];
    NSDictionary *imageDict = [array objectAtIndex:indexPath.row];
    
    [cell drawCell:imageDict];
    return cell;
    
}

- (void)appendExtraCell {
    NSLog(@"press append button!!!");
    
    isAppend = isAppend?NO:YES;
    
    if(!isAppend && self.collectionView.contentOffset.y < 124) {
        [self.collectionView reloadData];
    }
    else {
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadData];
        } completion:^(BOOL finished) {
            if(self.collectionView.contentOffset.y < 81) {
                [self.collectionView setContentOffset:CGPointMake(0, 82) animated:YES];
            }
        }];
    }
    
    NSLog(@"%f",self.collectionView.contentOffset.y);
    //[self.collectionView reloadData];
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
    else if([[segue identifier] isEqualToString:@"pushSearchViewFromDetailView"])
    {
        SearchShopTableViewController *searchShopTableViewController = [segue destinationViewController];
        searchShopTableViewController.from = @"detail";
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
    if(indexPath.section == 1){
        [SVProgressHUD showWithStatus:@"Data Loading..." maskType:SVProgressHUDMaskTypeBlack];
        AFHTTPRequestOperationManager *dataManager = [AFHTTPRequestOperationManager manager];
        dataManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        [dataManager GET:BASE_REST_URL_SHOP(array[indexPath.row][@"shop_id"]) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"%@",responseObject);
            
            [[ShopModel sharedManager] setShop:responseObject];
            [[ShopModel sharedManager] setCurrentImageId:array[indexPath.row][@"image_id"]];
            [self showNavBarAnimated:NO];
            [SVProgressHUD popActivity];
            [self pushToDetailView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [SVProgressHUD popActivity];
            //데이터 수신 실패 시, 대응 필요
        }];
    }
        

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

#pragma mark - push notification

- (void)flickingStylecut:(NSNotification *) notification {
    //NSLog(@"%@",notification.userInfo[@"image"]);
    NSLog(@"flickingStyleCut : detailView :  %@", notification.userInfo[@"image"][@"image_id"]);
    array = notification.userInfo[@"image"][@"recommend_list"];
    //[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    [self.collectionView reloadData];
}

- (void)reloadDetailViewByMyStyle:(NSNotification *) notification {
    NSLog(@"reload!!");
    array = [[MainImageModel sharedManager] getMainImageList];
    [self.collectionView reloadData];
}

- (void)showActionSheetByContact:(NSNotification *) notification {
    NSLog(@"contact!!");
    contactActionSheet = [[UIActionSheet alloc]
                           initWithTitle: @"연락수단을 선택하세요"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"전화걸기", @"문자보내기", nil];
    [contactActionSheet showInView:self.view];
}

- (void)showActionSheetByShare:(NSNotification *) notification {
    NSLog(@"share!!");
    NSLog(@"%@",notification.userInfo);
    self.nowImageDict = notification.userInfo;
    shareActionSheet = [[UIActionSheet alloc]
                           initWithTitle: @"공유수단을 선택하세요"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"카카오톡", @"페이스북", nil];
    [shareActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet == contactActionSheet) {
        if(buttonIndex == 0) {
            NSLog(@"%@",[[[ShopModel sharedManager] getShop] objectForKey:@"phone_repr"]);
            NSString *telString = [NSString stringWithFormat:@"telprompt://%@",[[[ShopModel sharedManager] getShop] objectForKey:@"phone_repr"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
        }
        else if(buttonIndex == 1) {
            if ([MFMessageComposeViewController canSendText]) {
                MFMessageComposeViewController *view = [[MFMessageComposeViewController alloc] init];
                view.body = @"";
                view.recipients = [NSArray arrayWithObject:[[[ShopModel sharedManager] getShop] objectForKey:@"phone_repr"]];
                view.messageComposeDelegate = self;
                
                [self presentViewController:view animated:YES completion:nil];
            }
        }
    }
    
    else if(actionSheet == shareActionSheet) {
        NSString *imageUrl = self.nowImageDict[@"image"][@"image_url"];
        if(buttonIndex == 0) {
            KakaoTalkLinkAction *androidAppAction
            = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformAndroid
                                        devicetype:KakaoTalkLinkActionDeviceTypePhone
                                         execparam:nil];
            
            KakaoTalkLinkAction *iphoneAppAction
            = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformIOS
                                        devicetype:KakaoTalkLinkActionDeviceTypePhone
                                         execparam:nil];
            
            KakaoTalkLinkObject *button
            = [KakaoTalkLinkObject createAppButton:@"Mutzip"
                                           actions:@[androidAppAction, iphoneAppAction]];
            
            NSLog(@"image url : %@",imageUrl);
            KakaoTalkLinkObject *image
            = [KakaoTalkLinkObject createImage:imageUrl
                                         width:150
                                        height:200];
            
            [KOAppCall openKakaoTalkAppLink:@[image,button]];
        }
        else if(buttonIndex == 1) {
            FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
            params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
            //params.picture = [NSURL URLWithString:@"http://1.234.20.163:8080/static/image/sample6.jpg"];
            
            // If the Facebook app is installed and we can present the share dialog
            if ([FBDialogs canPresentShareDialogWithParams:params]) {
                NSLog(@"facebook!!!");
                /*
                [FBDialogs presentShareDialogWithParams:params clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                    if(error) {
                        // An error occurred, we need to handle the error
                        // See: https://developers.facebook.com/docs/ios/errors
                        NSLog(@"Error publishing story: %@", error.description);
                    } else {
                        // Success
                        NSLog(@"result %@", results);
                    }
                }];
                */
                 [FBDialogs presentShareDialogWithLink:[NSURL URLWithString:@"http://www.facebook.com"] name:@"title" caption:@"subtitle" description:@"내가 멋집이다" picture:[NSURL URLWithString:imageUrl] clientState:nil
                                              handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                  if(error) {
                                                      // An error occurred, we need to handle the error
                                                      // See: https://developers.facebook.com/docs/ios/errors
                                                      NSLog(@"Error publishing story: %@", error.description);
                                                  } else {
                                                      // Success
                                                      NSLog(@"result %@", results);
                                                  }
                                              }];

            } else {
                // Present the feed dialog
                NSLog(@"can not!!");
            }
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                  didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if(result == MessageComposeResultSent) {
        [SVProgressHUD showSuccessWithStatus:@"문자전송이 완료되었습니다."];
    }
}

@end
