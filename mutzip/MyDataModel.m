//
//  MyDataModel.m
//  mutzip
//
//  Created by taeho.cho on 14. 8. 18..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "MyDataModel.h"

@implementation MyDataModel

+ (id)sharedManager {
    static MyDataModel *sharedMyManager = nil;
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

- (NSMutableSet *)getFavoriteShop {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteShop"]];
}

- (BOOL)setFavoriteShop:(NSString *)shopId {
    NSMutableSet *favoriteShop = [NSMutableSet setWithSet:[self getFavoriteShop]];
    
    if([self isFavoriteShop:shopId]) {
        [favoriteShop removeObject:shopId];
    }
    else {
        [favoriteShop addObject:shopId];
    }
    
    NSLog(@"%@",favoriteShop);
    [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject:favoriteShop] forKey:@"favoriteShop"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return [self isFavoriteShop:shopId];
}

- (BOOL)isFavoriteShop:(NSString *)shopId {
    NSMutableSet *favoriteShop = [self getFavoriteShop];
    return [favoriteShop containsObject:shopId];
}

- (NSMutableSet *)getImageLike {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageLike"]];
}

- (BOOL)setImageLike:(NSString *)imageId {
    NSMutableSet *imageLike = [NSMutableSet setWithSet:[self getImageLike]];
    
    if([self isImageLike:imageId]) {
        [imageLike removeObject:imageId];
    }
    else {
        [imageLike addObject:imageId];
    }
    
    NSLog(@"%@",imageLike );
    [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject:imageLike] forKey:@"imageLike"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return [self isImageLike:imageId];
}

- (BOOL)isImageLike:(NSString *)imageId {
    NSMutableSet *imageLike = [self getImageLike];
    return [imageLike containsObject:imageId];
}

@end
