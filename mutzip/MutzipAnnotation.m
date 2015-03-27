//
//  MutzipAnnotation.m
//  mutzip
//
//  Created by taeho.cho on 14. 6. 10..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "MutzipAnnotation.h"

@implementation MutzipAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title grade:(NSString *)grade{
    if ((self = [super init])) {
        self.coordinate =coordinate;
        self.title = title;
        self.subtitle = title;
        self.grade = grade;
    }
    return self;
}

@end
