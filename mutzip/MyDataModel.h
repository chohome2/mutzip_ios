//
//  MyDataModel.h
//  mutzip
//
//  Created by taeho.cho on 14. 8. 18..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDataModel : NSObject

+ (id)sharedManager;

- (BOOL)setFavoriteShop:(NSString *)shopId;
- (BOOL)setImageLike:(NSString *)imageId;

- (BOOL)isFavoriteShop:(NSString *)shopId;
- (BOOL)isImageLike:(NSString *)imageId;
@end
