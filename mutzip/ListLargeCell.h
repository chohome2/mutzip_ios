//
//  ListLargeCell.h
//  mutzip
//
//  Created by taeho.cho on 14. 6. 11..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListLargeCell : UICollectionViewCell {
    NSMutableDictionary *myImage;
}

@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;
@property (strong, nonatomic) IBOutlet UIButton *flipButton;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *entireName;
@property (strong, nonatomic) NSString *buttonName;
@property (strong, nonatomic) NSNumber *isFront;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *likeLabel;
@property (strong, nonatomic) IBOutlet UIButton *myStyleButton;

- (void)drawCell:(NSDictionary *)imageDict;
@end
