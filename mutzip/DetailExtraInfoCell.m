//
//  DetailExtraInfoCell.m
//  mutzip
//
//  Created by taeho.cho on 14. 6. 12..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "DetailExtraInfoCell.h"
#import "ShopModel.h"

@implementation DetailExtraInfoCell

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
#define FONT_SIZE 12
    
    NSString*myNSString = [[ShopModel sharedManager] getShopDetailInfo];
    UIFont * labelFont = [UIFont systemFontOfSize:FONT_SIZE];
    UIColor * labelColor = [UIColor colorWithWhite:1 alpha:1];
    
    NSAttributedString *labelText = [[NSAttributedString alloc] initWithString : myNSString
                                                                    attributes : @{
                                                                                   NSFontAttributeName : labelFont,
                                                                                   NSForegroundColorAttributeName : labelColor }];

    
    self.infoTextView.attributedText = labelText;
    //self.infoTextView.text = [[ShopModel sharedManager] getShopDetailInfo];
    
    NSLog(@"info text : %@",self.infoTextView.text);
    NSLog(@"info text height : %f", self.infoTextView.contentSize.height);
    CGRect frame = self.infoTextView.frame;
    frame.size.height = self.infoTextView.contentSize.height;
    self.infoTextView.frame = frame;
    
    frame = self.backgroundImage.frame;
    frame.size.height = self.infoTextView.contentSize.height;
    self.backgroundImage.frame = frame;
}
@end
