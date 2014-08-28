//
//  DetailMainInfoCell.h
//  mutzip
//
//  Created by taeho.cho on 14. 6. 12..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailMainInfoCell : UICollectionViewCell <UIActionSheetDelegate> {
    CGFloat angle;
}

@property (strong, nonatomic) IBOutlet UIButton *appendButton;
@property (strong, nonatomic) IBOutlet UILabel *shopLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UIButton *mapButton;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;

- (void)drawCell;
@end
