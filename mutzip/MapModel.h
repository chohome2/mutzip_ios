//
//  MapModel.h
//  mutzip
//
//  Created by taeho.cho on 14. 8. 14..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapModel : NSObject

- (void)setMapList:(NSArray *)mapList;
- (NSDictionary *)getMapList;
+ (id)sharedManager;

@end
