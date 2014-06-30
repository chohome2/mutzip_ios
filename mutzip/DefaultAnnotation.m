//
//  DefaultAnnotation.m
//  mutzip
//
//  Created by taeho.cho on 14. 6. 10..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "DefaultAnnotation.h"

@implementation DefaultAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title isFavorite:(NSNumber *)isFavorite{
    if ((self = [super init])) {
        self.coordinate =coordinate;
        self.title = title;
        self.subtitle = title;
        self.isFavorite = isFavorite;
    }
    return self;
}

@end
