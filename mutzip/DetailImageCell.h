//
//  DetailImageCell.h
//  mutzip
//
//  Created by taeho.cho on 14. 6. 12..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailImageCell : UICollectionViewCell<UIScrollViewDelegate> {
    NSArray *array;
    int page;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *popupImageView;
@property (strong, nonatomic) IBOutlet UILabel *shopLabel;
@property (strong, nonatomic) IBOutlet UILabel *pageLabel;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UIButton *myStyleButton;

- (void)drawCell;
@end
