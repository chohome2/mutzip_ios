//
//  DetailImageCell.m
//  mutzip
//
//  Created by taeho.cho on 14. 6. 12..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "DetailImageCell.h"
#import "SVProgressHUD.h"

@implementation DetailImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    NSArray *array = @[@"sample01.png",@"sample02.png",@"sample03.png",@"sample04.png",@"sample05.png",@"sample06.png",@"sample07.png",@"sample08.png",@"sample09.png",@"sample10.png"];

    for(int i = 0;  i < 10; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[array objectAtIndex:i]]];
        imageView.frame = CGRectMake(320 * i,0, 320, 427);
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(320*10, 427);
    
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

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = ceil((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageLabel.text = [NSString stringWithFormat:@"%d/10",page];
}

//dragging ends, please switch off paging to listen for this event
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *) targetContentOffset
NS_AVAILABLE_IOS(5_0){
    
    //find the page number you are on
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = ceil((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"Dragging - You are now on page %i",page);
    self.pageLabel.text = [NSString stringWithFormat:@"%d/10",page];
}

- (IBAction)toggleMyStyle:(id)sender {
    [SVProgressHUD showSuccessWithStatus:@"My Style에 추가되었습니다."];
}
- (IBAction)shareSNS:(id)sender {
}
@end
