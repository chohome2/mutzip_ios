//
//  ShopModel.h
//  mutzip
//
//  Created by taeho.cho on 14. 8. 17..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject

- (void)setShop:(NSDictionary *)shop;
- (void)setCurrentImageId:(NSString *)imageId;
- (NSDictionary *)getShop;
- (NSString *)getCurrentImageId;
- (NSDictionary *)getImageWithId:(NSString *)imageId;
- (NSString *)getShopDetailInfo;
- (NSArray *)getFirstRecommendList;

- (NSArray *)getDetailImageList;

- (void)modifyLikeWithImageId:(NSString *)imageId amount:(NSInteger)amount;

+ (id)sharedManager;

@end
