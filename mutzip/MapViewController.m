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

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

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
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(37.5225221, 127.0227997);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 1000, 1000)];
    
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    if([self.mode isEqualToString:@"all"]) {
        CLLocationCoordinate2D coordinate1;
        coordinate1.latitude = 37.5214071;
        coordinate1.longitude = 127.0226713;
        DefaultAnnotation *annotation = [[DefaultAnnotation alloc] initWithCoordinate:coordinate1 title:@"Starbucks NY" isFavorite:[NSNumber numberWithBool:YES]];
        [self.mapView addAnnotation:annotation];
        
        CLLocationCoordinate2D coordinate2;
        coordinate2.latitude = 37.5184215;
        coordinate2.longitude = 127.0230428;
        DefaultAnnotation *annotation2 = [[DefaultAnnotation alloc] initWithCoordinate:coordinate2 title:@"Pascal Boyer Gallery" isFavorite:[NSNumber numberWithBool:YES]];
        [self.mapView addAnnotation:annotation2];
        
        CLLocationCoordinate2D coordinate3;
        coordinate3.latitude = 37.5247657;
        coordinate3.longitude = 127.0242654;
        DefaultAnnotation *annotation3 = [[DefaultAnnotation alloc] initWithCoordinate:coordinate3 title:@"Virgin Records" isFavorite:[NSNumber numberWithBool:NO]];
        [self.mapView addAnnotation:annotation3];
        
        CLLocationCoordinate2D coordinate4;
        coordinate4.latitude = 37.5227657;
        coordinate4.longitude = 127.0232654;
        DefaultAnnotation *annotation4 = [[DefaultAnnotation alloc] initWithCoordinate:coordinate4 title:@"Virgin Records" isFavorite:[NSNumber numberWithBool:NO]];
        [self.mapView addAnnotation:annotation4];
        
        CLLocationCoordinate2D coordinate5;
        coordinate5.latitude = 37.5220657;
        coordinate5.longitude = 127.0217654;
        DefaultAnnotation *annotation5 = [[DefaultAnnotation alloc] initWithCoordinate:coordinate5 title:@"Virgin Records" isFavorite:[NSNumber numberWithBool:NO]];
        [self.mapView addAnnotation:annotation5];
        
        CLLocationCoordinate2D coordinate6;
        coordinate6.latitude = 37.5230657;
        coordinate6.longitude = 127.0207654;
        DefaultAnnotation *annotation6 = [[DefaultAnnotation alloc] initWithCoordinate:coordinate6 title:@"Virgin Records" isFavorite:[NSNumber numberWithBool:NO]];
        [self.mapView addAnnotation:annotation6];
    }
    else {
        CLLocationCoordinate2D coordinate1;
        coordinate1.latitude = 37.5225221;
        coordinate1.longitude = 127.0227997;
        DefaultAnnotation *annotation = [[DefaultAnnotation alloc] initWithCoordinate:coordinate1 title:@"Starbucks NY" isFavorite:[NSNumber numberWithBool:YES]];
        [self.mapView addAnnotation:annotation];
        
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
        
        DefaultAnnotation *annotations = (DefaultAnnotation *)annotation;
        if([annotations.isFavorite boolValue])
            view.image = [UIImage imageNamed:@"map_pin_red.png"];
        else
            view.image = [UIImage imageNamed:@"map_pin_white.png"];
        view.canShowCallout       = NO;  // make sure to turn off standard callout
        return view;
    } else if ([annotation isKindOfClass:[MutzipAnnotation class]]) {
        CGSize            size = CGSizeMake(118, 185);
        MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:calloutIdentifier];
        view.frame             = CGRectMake(0.0, 0.0, size.width, size.height);
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_bubble"]];
        
        UIButton *button       = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"sample03.png"] forState:UIControlStateNormal];
        button.frame           = CGRectMake(8,7,102,136);
        button.layer.borderColor = RGB(172, 172, 172).CGColor;
        button.layer.borderWidth = 0.5f;
        [button addTarget:self action:@selector(pushToDetailView) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *addButton       = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setBackgroundImage:[UIImage imageNamed:@"map_icon_favorite.png"] forState:UIControlStateNormal];
        addButton.frame           = CGRectMake(91,148,20,20);
        
        UILabel *koreanTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 148, 80, 10)];
        koreanTitle.text = @"마켓리버티";
        koreanTitle.font = [UIFont systemFontOfSize:9];
        
        UILabel *englishTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 159, 80, 10)];
        englishTitle.text = @"market Liberty";
        englishTitle.font = [UIFont systemFontOfSize:9];
        [view addSubview:backgroundImageView];
        [view addSubview:button];
        [view addSubview:addButton];
        [view addSubview:koreanTitle];
        [view addSubview:englishTitle];
        
        view.canShowCallout    = NO;
        view.centerOffset      = CGPointMake(7, -125);
        return view;
    }
    
    return nil;
}

- (void)pushToDetailView {
    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"pushToDetailViewFromMapView"
         object:self userInfo:nil];

    }];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if([view.annotation isKindOfClass:[DefaultAnnotation class]]) {
        MutzipAnnotation *mutzipAnnotation =
        [[MutzipAnnotation alloc] initWithCoordinate:[view.annotation coordinate]
                                                title:[view.annotation title]];
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
    if([view.annotation isKindOfClass:[MutzipAnnotation class]]) {
        [mapView removeAnnotation:view.annotation];
    }
}


@end
