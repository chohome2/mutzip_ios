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
    /*
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 4;
    self.infoTextView.attributedText = [[NSAttributedString alloc]
                                        initWithString:[[ShopModel sharedManager] getShopDetailInfo]
                                        attributes:@{NSParagraphStyleAttributeName : style}];
     */
    self.infoTextView.text = [[ShopModel sharedManager] getShopDetailInfo];
}
@end
