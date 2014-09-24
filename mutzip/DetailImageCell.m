//
//  DetailImageCell.m
//  mutzip
//
//  Created by taeho.cho on 14. 6. 12..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "DetailImageCell.h"
#import "SVProgressHUD.h"
#import "ShopModel.h"
#import "MyDataModel.h"
#import "MainImageModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworking.h"

@implementation DetailImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"init cell");
        page = 0;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawCell {
    NSLog(@"drawCell : %d", page);
    array = [[ShopModel sharedManager] getDetailImageList];
    
    ////추후 필드 변경 필수!!!//
    self.shopLabel.text = [[ShopModel sharedManager] getShop][@"name_main"];
    
    ///////////////////////////
    self.likeLabel.text = [NSString stringWithFormat:@"%@", array[page][@"likes"]];
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%d",page + 1,[array count]];
    for(int i = 0;  i < [array count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 * i,0, 320, 427)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[[array objectAtIndex:i] objectForKey:@"image_url"]]];
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(320*[array count], 427);
    
    [UIView animateWithDuration:2
                     animations:^{
                         self.popupImageView.alpha = 0.999;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              self.popupImageView.alpha = 0;
                                              self.shopLabel.alpha = 0;
                                          }
                                          completion:^(BOOL finished) {
                                              self.popupImageView.hidden = YES;
                                              self.shopLabel.hidden = YES;
                                          }];
                     }
     ];
    
    if([[MyDataModel sharedManager] isImageLike:array[page][@"image_id"]]) {
        [self.myStyleButton setBackgroundImage:[UIImage imageNamed:@"detail_check_on.png"] forState:UIControlStateNormal];
    }
    else {
        [self.myStyleButton setBackgroundImage:[UIImage imageNamed:@"detail_check_off.png"] forState:UIControlStateNormal];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scroll Did end!!");
    CGFloat pageWidth = scrollView.frame.size.width;
    page = ceil((scrollView.contentOffset.x - pageWidth / 2) / pageWidth);
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%d",page + 1,[array count]];
    
    self.likeLabel.text = [NSString stringWithFormat:@"%@", array[page][@"likes"]];
    
    if([[MyDataModel sharedManager] isImageLike:array[page][@"image_id"]]) {
        [self.myStyleButton setBackgroundImage:[UIImage imageNamed:@"detail_check_on.png"] forState:UIControlStateNormal];
    }
    else {
        [self.myStyleButton setBackgroundImage:[UIImage imageNamed:@"detail_check_off.png"] forState:UIControlStateNormal];
    }

    NSLog(@"flickingStyleCut : scroll did end : %d", page);
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"flickingStylecut"
     object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:array[page],@"image", nil]];
}

//dragging ends, please switch off paging to listen for this event
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *) targetContentOffset
NS_AVAILABLE_IOS(5_0){
        NSLog(@"scroll Will end!!");
    //find the page number you are on
    CGFloat pageWidth = scrollView.frame.size.width;
    page = ceil((scrollView.contentOffset.x - pageWidth / 2) / pageWidth);
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%d",page + 1,[array count]];
    self.likeLabel.text = [NSString stringWithFormat:@"%@", array[page][@"likes"]];

    if([[MyDataModel sharedManager] isImageLike:array[page][@"image_id"]]) {
        [self.myStyleButton setBackgroundImage:[UIImage imageNamed:@"detail_check_on.png"] forState:UIControlStateNormal];
    }
    else {
        [self.myStyleButton setBackgroundImage:[UIImage imageNamed:@"detail_check_off.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)toggleMyStyle:(id)sender {
    NSString *imageId = array[page][@"image_id"];
    
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
            //myImage[@"likes"] = [NSNumber numberWithInteger:[myImage[@"likes"] integerValue] + 1];
            [[ShopModel sharedManager] modifyLikeWithImageId:imageId amount:1];
        }
        else {
            [SVProgressHUD showSuccessWithStatus:@"My Style에서 삭제되었습니다."];
            //myImage[@"likes"] = [NSNumber numberWithInteger:[myImage[@"likes"] integerValue] - 1];
            [[ShopModel sharedManager] modifyLikeWithImageId:imageId amount:-1];
        }
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"reloadDetailViewByMyStyle"
         object:self userInfo:nil];
        
        //[self drawCell:myImage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD popActivity];
        //데이터 수신 실패 시, 대응 필요
    }];
    
    [SVProgressHUD showSuccessWithStatus:@"My Style에 추가되었습니다."];
}
- (IBAction)shareSNS:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"showActionSheetByShare"
     object:self userInfo:nil];
}
@end
