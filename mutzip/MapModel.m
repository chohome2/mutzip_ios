//
//  MapModel.m
//  mutzip
//
//  Created by taeho.cho on 14. 8. 14..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "MapModel.h"

@implementation MapModel

+ (id)sharedManager {
    static MapModel *sharedMyManager = nil;
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

- (void)setMapList:(NSArray *)mapList {
    NSMutableDictionary *mapDict = [[NSMutableDictionary alloc] init];
    for(NSDictionary *map in mapList) {
        [mapDict setObject:map forKey:map[@"shop_id"]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject:mapDict] forKey:@"mapList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)getMapList {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"mapList"]];
}

@end
