//
//  ListLargeCell.m
//  mutzip
//
//  Created by taeho.cho on 14. 6. 11..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "ListLargeCell.h"
#import "SVProgressHUD.h"

@implementation ListLargeCell

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
- (IBAction)touchMyStyle:(id)sender {
    NSLog(@"touch Mystyle");
}
- (IBAction)flipItemImageView:(id)sender {
    NSLog(@"flip image!!");
    
    if([self.isFront boolValue]) {
        self.isFront = [NSNumber numberWithBool:NO];
        [UIView transitionWithView:self.itemImageView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            self.itemImageView.image = [UIImage imageNamed:@"sample12.png"];
                        }
                        completion:NULL];
        [UIView transitionWithView:self.flipButton
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self.flipButton setBackgroundImage:[UIImage imageNamed:@"sample-circle2.png"] forState:UIControlStateNormal];
                        }
                        completion:NULL];
    }
    else {
        self.isFront = [NSNumber numberWithBool:YES];
        [UIView transitionWithView:self.itemImageView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            self.itemImageView.image = [UIImage imageNamed:self.imageName];

                        }
                        completion:NULL];
        [UIView transitionWithView:self.flipButton
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [self.flipButton setBackgroundImage:[UIImage imageNamed:@"sample-circle1.png"] forState:UIControlStateNormal];
                        }
                        completion:NULL];
    }
}
- (IBAction)toggleMyStyle:(id)sender {
    [SVProgressHUD showSuccessWithStatus:@"My Style에 추가되었습니다."];
    
}

@end
