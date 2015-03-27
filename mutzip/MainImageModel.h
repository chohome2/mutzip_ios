//
//  MainImageModel.h
//  mutzip
//
//  Created by taeho.cho on 14. 8. 14..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainImageModel : NSObject

- (void)setMainImageList:(NSArray *)mainImageList;
- (NSArray *)getMainImageList;
- (void)modifyLikeWithImageId:(NSString *)imageId amount:(NSInteger)amount;
+ (id)sharedManager;

@end
