//
//  MainImageModel.m
//  mutzip
//
//  Created by taeho.cho on 14. 8. 14..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "MainImageModel.h"

@implementation MainImageModel

+ (id)sharedManager {
    static MainImageModel *sharedMyManager = nil;
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

- (void)setMainImageList:(NSArray *)mainImageList {
    [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject:mainImageList] forKey:@"mainImageList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)getMainImageList {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"mainImageList"]];
}

- (void)modifyLikeWithImageId:(NSString *)imageId amount:(NSInteger)amount {
    NSMutableArray *imageList = [NSMutableArray arrayWithArray:[self getMainImageList]];
    
    for(int i = 0 ; i < [imageList count] ; i++) {
        NSMutableDictionary *imageDict = [NSMutableDictionary dictionaryWithDictionary:imageList[i]];
        if([imageDict[@"image_id"] isEqualToString:imageId]) {
            imageDict[@"likes"] = [NSNumber numberWithInteger: [imageDict[@"likes"] integerValue] + amount];
            imageList[i] = imageDict;
            break;
        }
    }
    [self setMainImageList:imageList];
}
@end
