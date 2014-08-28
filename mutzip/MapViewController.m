//
//  MapViewController.m
//  mutzip
//
//  Created by taeho.cho on 14. 5. 13..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "DefaultAnnotation.h"
#import "MutzipAnnotation.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "MapModel.h"
#import "ShopModel.h"
#import "MyDataModel.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController {
    NSDictionary *mapDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    mapDict = [[MapModel sharedManager] getMapList];
    
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(37.5225221, 127.0227997);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 1000, 1000)];
    
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    if([self.mode isEqualToString:@"all"]) {
        for(NSString *shopId in mapDict) {
            NSDictionary *map = mapDict[shopId];
            if(([map[@"grade"] isEqualToString:@"WAIT"] || [map[@"grade"] isEqualToString:@"FREE"]) && ![[MyDataModel sharedManager] isFavoriteShop:shopId]) {
                continue;
            }
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [[[map objectForKey:@"location"] objectForKey:@"latitude"] doubleValue];
            coordinate.longitude = [[[map objectForKey:@"location"] objectForKey:@"longitude"] doubleValue];
            DefaultAnnotation *annotation = [[DefaultAnnotation alloc] initWithCoordinate:coordinate title:map[@"shop_id"] grade:map[@"grade"]];
            [self.mapView addAnnotation:annotation];
        }
    }
    else {
        NSDictionary *shop = [[ShopModel sharedManager] getShop];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [shop[@"location"][@"latitude"] floatValue];
        coordinate.longitude = [shop[@"location"][@"longitude"] floatValue];
        DefaultAnnotation *annotation = [[DefaultAnnotation alloc] initWithCoordinate:coordinate title:shop[@"shop_id"] grade:shop[@"grade"]];
        [self.mapView addAnnotation:annotation];
        
        MutzipAnnotation *mutzipAnnotation =
        [[MutzipAnnotation alloc] initWithCoordinate:coordinate title:shop[@"shop_id"] grade:shop[@"grade"]];
        [self.mapView addAnnotation:mutzipAnnotation];
        [self gotoLocationWidthCoordination:coordinate];
    }
    NSLog(@"%@",self.mode);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)gotoLocationWidthCoordination:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion newRegion = self.mapView.region;
    newRegion.center.latitude = coordinate.latitude;
    newRegion.center.longitude = coordinate.longitude;

    [self.mapView setRegion:newRegion animated:YES];
}

- (void)gotoLocationWidthCoordinations:(CLLocationCoordinate2D)coordinate{
    //ignore "Annotation", this is just my own custom MKAnnotation subclass
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    CGPoint fakecenter = CGPointMake(160,200);
    CLLocationCoordinate2D moveCoordinate = [self.mapView convertPoint:fakecenter toCoordinateFromView:self.mapView];


    MKCoordinateRegion newRegion = self.mapView.region;
    newRegion.center.latitude = moveCoordinate.latitude;
    newRegion.center.longitude = moveCoordinate.longitude;
    
    //[self.mapView setRegion:newRegion animated:YES];

//    [self.mapView setCenterCoordinate:moveCoordinate animated:YES];
}

#pragma mark -MapView Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *customIdentifier  = @"CustomAnnotation";
    static NSString *calloutIdentifier = @"CalloutAnnotation";
    
    if ([annotation isKindOfClass:[DefaultAnnotation class]]) {
        
        MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customIdentifier];
        
        if([[MyDataModel sharedManager] isFavoriteShop:[annotation title]]) {
            view.image = [UIImage imageNamed:@"map_pin_red.png"];
        }
        else {
            view.image = [UIImage imageNamed:@"map_pin_white.png"];
        }
        if([self.mode isEqualToString:@"all"]) {
            [view setHidden:YES];
        }
        view.canShowCallout       = NO;  // make sure to turn off standard callout
        return view;
    } else if ([annotation isKindOfClass:[MutzipAnnotation class]]) {
        NSLog(@"%@",[annotation title]);
        MutzipAnnotation *annotations = (MutzipAnnotation *)annotation;
        NSDictionary *map = mapDict[[annotations title]];
        
        CGSize            size = CGSizeMake(118, 185);
        MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:calloutIdentifier];
        view.frame             = CGRectMake(0.0, 0.0, size.width, size.height);
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_bubble"]];
        
        UIButton *button       = [UIButton buttonWithType:UIButtonTypeCustom];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:map[@"image_map"]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            button.alpha = 0.0;
            [UIView animateWithDuration:0.4 animations:^{
                button.alpha = 1.0;
            }];
        }];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:map[@"image_map"]] forState:UIControlStateHighlighted];
        button.frame           = CGRectMake(8,7,102,136);
        button.layer.borderColor = RGB(172, 172, 172).CGColor;
        button.layer.borderWidth = 0.5f;
        button.titleLabel.text = [annotations title];
        [button addTarget:self action:@selector(pushToDetailView:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *addButton       = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [addButton setBackgroundImage:[UIImage imageNamed:@"map_icon_favorite.png"] forState:UIControlStateNormal];
        
        addButton.frame           = CGRectMake(91,148,20,20);
        
        UILabel *koreanTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 148, 80, 10)];
        koreanTitle.text = map[@"name_main"];
        koreanTitle.font = [UIFont systemFontOfSize:9];
        
        UILabel *englishTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 159, 80, 10)];
        englishTitle.text = map[@"name_sub"];
        englishTitle.font = [UIFont systemFontOfSize:9];
        [view addSubview:backgroundImageView];
        [view addSubview:button];
        if([[MyDataModel sharedManager] isFavoriteShop:[annotation title]]) {
            [view addSubview:addButton];
        }
        [view addSubview:koreanTitle];
        [view addSubview:englishTitle];
        
        view.canShowCallout    = NO;
        view.centerOffset      = CGPointMake(7, -125);
        return view;
    }
    
    return nil;
}

- (void)pushToDetailView:(id)sender {
    if([self.mode isEqualToString:@"shop"]) return;
    UIButton *button = (UIButton *)sender;
    NSLog(@"!!%@",button.titleLabel.text);
    
    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"pushToDetailViewFromMapView"
         object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:button.titleLabel.text,@"shop", nil]];
    }];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if([view.annotation isKindOfClass:[DefaultAnnotation class]] && view.hidden == NO && [self.mode isEqualToString:@"all"]) {
        DefaultAnnotation *defaultAnnotation = (DefaultAnnotation *)view.annotation;
        MutzipAnnotation *mutzipAnnotation =
        [[MutzipAnnotation alloc] initWithCoordinate:[defaultAnnotation coordinate]
                                                title:[defaultAnnotation title] grade:[defaultAnnotation grade]];
        [self.mapView addAnnotation:mutzipAnnotation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [mapView selectAnnotation:mutzipAnnotation animated:YES];
            [self gotoLocationWidthCoordination:[view.annotation coordinate]];
        });
    }
}

// when user deselects callout annotation view (i.e. taps anywhere other than the callout annotation), remove the callout annotation

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if([view.annotation isKindOfClass:[MutzipAnnotation class]] && [self.mode isEqualToString:@"all"]) {
        [mapView removeAnnotation:view.annotation];
    }
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    [self redrawAnnotations];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self redrawAnnotations];
}
- (void)redrawAnnotations {
    if([self.mode isEqualToString:@"shop"]) return;
    for(id annotation in self.mapView.annotations) {
        if([annotation isKindOfClass:[DefaultAnnotation class]])
            NSLog(@"%@",[annotation grade]);
    }
    
    //0.008 , 0.020
    if(self.mapView.region.span.latitudeDelta >= 0.020) {
        for(id annotation in self.mapView.annotations) {
            if([annotation isKindOfClass:[DefaultAnnotation class]]) {
                if([[annotation grade] isEqualToString:@"PREMIUM"] || [[annotation grade] isEqualToString:@"BASIC"]) {
                    [[self.mapView viewForAnnotation:annotation] setHidden:YES];
                }
            }
            else if([annotation isKindOfClass:[MutzipAnnotation class]]) {
                if([[annotation grade] isEqualToString:@"PREMIUM"] || [[annotation grade] isEqualToString:@"BASIC"]) {
                    [[self.mapView viewForAnnotation:annotation] setHidden:YES];
                }
            }
        }
    }
    else if(self.mapView.region.span.latitudeDelta < 0.020 && self.mapView.region.span.latitudeDelta > 0.008) {
        for(id annotation in self.mapView.annotations) {
            if([annotation isKindOfClass:[DefaultAnnotation class]]) {
                if([[annotation grade] isEqualToString:@"BASIC"]) {
                    [[self.mapView viewForAnnotation:annotation] setHidden:YES];
                }
                else {
                    [[self.mapView viewForAnnotation:annotation] setHidden:NO];
                }
            }
            else if([annotation isKindOfClass:[MutzipAnnotation class]]) {
                if([[annotation grade] isEqualToString:@"BASIC"]) {
                    [[self.mapView viewForAnnotation:annotation] setHidden:YES];
                }
            }
        }
    }
    else if(self.mapView.region.span.latitudeDelta <= 0.008) {
        for(id annotation in self.mapView.annotations) {
            if([annotation isKindOfClass:[DefaultAnnotation class]]) {
                [[self.mapView viewForAnnotation:annotation] setHidden:NO];
            }
        }
    }
    
    for(id annotation in self.mapView.annotations) {
        if([[MyDataModel sharedManager] isFavoriteShop:[annotation title]]) {
            [[self.mapView viewForAnnotation:annotation] setHidden:NO];
        }
    }
}
@end
