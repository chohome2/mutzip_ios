//
//  MutzipAnnotation.h
//  mutzip
//
//  Created by taeho.cho on 14. 6. 10..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MutzipAnnotation : NSObject <MKAnnotation>
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title;

@end
