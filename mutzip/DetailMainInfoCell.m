//
//  DetailMainInfoCell.m
//  mutzip
//
//  Created by taeho.cho on 14. 6. 12..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "DetailMainInfoCell.h"
#import "SVProgressHUD.h"

@implementation DetailMainInfoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)toggleFavorite:(id)sender {
    [SVProgressHUD showSuccessWithStatus:@"지도상에 관심매장으로 체크되었습니다."];
}
- (IBAction)callToShop:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://01011112222"]];
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
