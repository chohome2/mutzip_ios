//
//  DetailExtraInfoCell.h
//  mutzip
//
//  Created by taeho.cho on 14. 6. 12..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailExtraInfoCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

- (void)drawCell;
@end
