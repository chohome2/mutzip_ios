//
//  ListLargeself.m
//  mutzip
//
//  Created by taeho.cho on 14. 6. 11..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "ListLargeCell.h"
#import "SVProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "AFNetworking.h"
#import "MyDataModel.h"
#import "MainImageModel.h"

@implementation ListLargeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawCell:(NSDictionary *)imageDict {
    myImage = [NSMutableDictionary dictionaryWithDictionary:imageDict];
    self.isFront = [NSNumber numberWithBool:YES];
    self.imageName = imageDict[@"image_url"];
    self.entireName = imageDict[@"image_entire"];
    self.buttonName = imageDict[@"image_repr"];
    self.shopNameLabel.text = imageDict[@"name_main"];
    self.likeLabel.text = [NSString stringWithFormat:@"%@",imageDict[@"likes"]];
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:imageDict[@"image_url"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.loadingIndicator.hidden = YES;
        self.itemImageView.alpha = 0.0;
        [UIView animateWithDuration:0.4 animations:^{
            self.itemImageView.alpha = 1.0;
        }];
    }];
    self.itemImageView.layer.borderWidth = 0.5f;
    self.itemImageView.layer.borderColor = RGB(172,172,172).CGColor;
    
    self.flipButton.layer.borderWidth = 2.0f;
    self.flipButton.layer.borderColor = RGB(255, 255, 255).CGColor;
    self.flipButton.layer.cornerRadius = self.flipButton.bounds.size.width / 2.0;
    [self.flipButton.layer setMasksToBounds:YES];
    [self.flipButton sd_setBackgroundImageWithURL:[NSURL URLWithString:imageDict[@"image_repr"]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    if([[MyDataModel sharedManager] isImageLike:imageDict[@"image_id"]]) {
        [self.myStyleButton setBackgroundImage:[UIImage imageNamed:@"main_list_detail_check_on.png"] forState:UIControlStateNormal];
        NSLog(@"draw check on!!");
    }
    else {
        [self.myStyleButton setBackgroundImage:[UIImage imageNamed:@"main_list_detail_check_off.png"] forState:UIControlStateNormal];
        NSLog(@"draw check off!!");
    }
}

- (IBAction)flipItemImageView:(id)sender {
    NSLog(@"flip image!!");
    
    if([self.isFront boolValue]) {
        self.isFront = [NSNumber numberWithBool:NO];
        [UIView transitionWithView:self.itemImageView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:self.entireName]];
                        }
                        completion:NULL];
        [UIView transitionWithView:self.flipButton
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.flipButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.imageName] forState:UIControlStateNormal];
                        }
                        completion:NULL];
    }
    else {
        self.isFront = [NSNumber numberWithBool:YES];
        [UIView transitionWithView:self.itemImageView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:self.imageName]];
                        }
                        completion:NULL];
        [UIView transitionWithView:self.flipButton
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.flipButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.buttonName] forState:UIControlStateNormal];
                        }
                        completion:NULL];
    }
}
- (IBAction)toggleMyStyle:(id)sender {
    
    NSString *imageId = myImage[@"image_id"];
    
    [SVProgressHUD showWithStatus:@"Wait a moment..." maskType:SVProgressHUDMaskTypeBlack];
    AFHTTPRequestOperationManager *dataManager = [AFHTTPRequestOperationManager manager];
    dataManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;

    NSString *url = BASE_REST_URL_LIKE(imageId);
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    dataManager.requestSerializer = requestSerializer;
    
    if([[MyDataModel sharedManager] isImageLike:imageId]) {
        url = [url stringByAppendingString:@"delete"];
    }
    else {
        url = [url stringByAppendingString:@"create"];
    }
    NSLog(@"%@",url);
    [dataManager POST:url parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"ios",@"os",[[[UIDevice currentDevice] identifierForVendor] UUIDString],@"app_id", nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        if([[MyDataModel sharedManager] setImageLike:imageId]) {
            [SVProgressHUD showSuccessWithStatus:@"My Style에 추가되었습니다."];
            myImage[@"likes"] = [NSNumber numberWithInteger:[myImage[@"likes"] integerValue] + 1];
            [[MainImageModel sharedManager] modifyLikeWithImageId:imageId amount:1];
        }
        else {
            [SVProgressHUD showSuccessWithStatus:@"My Style에서 삭제되었습니다."];
            myImage[@"likes"] = [NSNumber numberWithInteger:[myImage[@"likes"] integerValue] - 1];
            [[MainImageModel sharedManager] modifyLikeWithImageId:imageId amount:-1];
        }
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"reloadViewByMyStyle"
         object:self userInfo:nil];
        
        [self drawCell:myImage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD popActivity];
        //데이터 수신 실패 시, 대응 필요
    }];
}

@end
