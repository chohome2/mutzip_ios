//
//  ShopModel.m
//  mutzip
//
//  Created by taeho.cho on 14. 8. 17..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel

+ (id)sharedManager {
    static ShopModel *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    self = [super init];
    return self;
}

- (void)setShop:(NSDictionary *)shop {
    [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject:shop] forKey:@"shopData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for(NSDictionary *image in shop[@"image_list"]) {
        [dict setObject:image forKey:image[@"image_id"]];
    }
    [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject:dict] forKey:@"shopImageList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setCurrentImageId:(NSString *)imageId {
    [[NSUserDefaults standardUserDefaults] setObject: imageId forKey:@"currentImageId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)getShop {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"shopData"]];
}

- (NSDictionary *)getShopImageList {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"shopImageList"]];
}


- (NSString *)getCurrentImageId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"currentImageId"];
}

- (NSDictionary *)getImageWithId:(NSString *)imageId {
    NSDictionary *imageList = [self getShopImageList];
    return [imageList objectForKey:imageId];
}

- (NSArray *)getDetailImageList {
    NSDictionary *shop = [self getShop];
    NSMutableArray *imageList = [[NSMutableArray alloc] init];
    NSDictionary *currentImage = [self getImageWithId:[self getCurrentImageId]];
    if(currentImage != nil) {
        [imageList addObject:currentImage];
    }
    
    for(NSDictionary *image in shop[@"image_list"]) {
        if(![image[@"image_id"] isEqualToString:[self getCurrentImageId]]) {
            [imageList addObject:image];
        }
    }
    return imageList;
}

- (NSString *)getShopDetailInfo {
    NSString *info = @"";
    NSDictionary *shop = [self getShop];
    if(shop[@"work_time"]) {
        info = [info stringByAppendingFormat:@"%@\n",shop[@"work_time"]];
    }
    if(shop[@"address"]) {
        info = [info stringByAppendingFormat:@"%@\n",shop[@"address"]];
    }

    if(shop[@"phone_repr"]) {
        info = [info stringByAppendingFormat:@"%@\n",shop[@"phone_repr"]];
    }
    if(shop[@"phone_etc"]) {
        for(NSString *phone in shop[@"phone_etc"]) {
            info = [info stringByAppendingFormat:@"%@\n",phone];
        }
    }
    
    return info;
}

- (NSArray *)getFirstRecommendList {
   //NSDictionary *imageList = [self getShopImageList];
    return nil;
}

- (void)modifyLikeWithImageId:(NSString *)imageId amount:(NSInteger)amount {
    NSMutableDictionary *shop = [NSMutableDictionary dictionaryWithDictionary:[self getShop]];
    NSMutableArray *imageList = [NSMutableArray arrayWithArray:shop[@"image_list"]];
    
    for(int i = 0 ; i < [imageList count] ; i++) {
        NSMutableDictionary *imageDict = [NSMutableDictionary dictionaryWithDictionary:imageList[i]];
        if([imageDict[@"image_id"] isEqualToString:imageId]) {
            imageDict[@"likes"] = [NSNumber numberWithInteger: [imageDict[@"likes"] integerValue] + amount];
            imageList[i] = imageDict;
            break;
        }
    }
    shop[@"image_list"] = imageList;
    [self setShop:shop];
}

@end
