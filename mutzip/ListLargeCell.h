//
//  ListLargeCell.h
//  mutzip
//
//  Created by taeho.cho on 14. 6. 11..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListLargeCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *itemImageView;
@property (strong, nonatomic) IBOutlet UIButton *flipButton;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSNumber *isFront;

@end
