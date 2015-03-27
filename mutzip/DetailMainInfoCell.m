//
//  DetailMainInfoCell.m
//  mutzip
//
//  Created by taeho.cho on 14. 6. 12..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "DetailMainInfoCell.h"
#import "SVProgressHUD.h"
#import "ShopModel.h"
#import "MyDataModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworking.h"

@implementation DetailMainInfoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawCell {
    NSDictionary *shop = [[ShopModel sharedManager] getShop];

    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:shop[@"image_logo"]]];
    self.shopLabel.text = shop[@"name_main"];
    
    if([[MyDataModel sharedManager] isFavoriteShop:shop[@"shop_id"]]) {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"detail_icon_favorite_focus.png"] forState:UIControlStateNormal];
    }
    else {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"detail_icon_favorite_nor.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)toggleFavorite:(id)sender {
    NSString *shopId = [[ShopModel sharedManager] getShop][@"shop_id"];
    
    [SVProgressHUD showWithStatus:@"Wait a moment..." maskType:SVProgressHUDMaskTypeBlack];
    AFHTTPRequestOperationManager *dataManager = [AFHTTPRequestOperationManager manager];
    dataManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    NSLog(@"%@",BASE_REST_URL_FAVORITE(shopId));
    NSString *url = BASE_REST_URL_FAVORITE(shopId);

    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    dataManager.requestSerializer = requestSerializer;
    
    if([[MyDataModel sharedManager] isFavoriteShop:shopId]) {
        url = [url stringByAppendingString:@"delete"];
    }
    else {
        url = [url stringByAppendingString:@"create"];
    }
    NSLog(@"%@",url);
    [dataManager POST:url parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"os",[[[UIDevice currentDevice] identifierForVendor] UUIDString],@"app_id", nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        if([[MyDataModel sharedManager] setFavoriteShop:shopId]) {
            [SVProgressHUD showSuccessWithStatus:@"지도상에 관심매장으로\n체크되었습니다."];
        }
        else {
            [SVProgressHUD showSuccessWithStatus:@"지도상에 관심매장에서\n해제되었습니다."];
        }
        [self drawCell];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
        //데이터 수신 실패 시, 대응 필요
    }];
    
    
    
}
- (IBAction)callToShop:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"showActionSheetByContact"
     object:self userInfo:nil];
}
- (IBAction)toggleAppendButton:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    angle = angle == 180?0:180;
    
    CGAffineTransform rotateTrans =
    CGAffineTransformMakeRotation(angle * M_PI/180);
    
    self.appendButton.transform = rotateTrans;
    
    [UIView commitAnimations];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
