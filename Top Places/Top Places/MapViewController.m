//
//  MapViewController.m
//  Top Places
//
//  Created by Gualberto Espechi Parada on 21/08/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>


@interface MapViewController()
@property (weak, nonatomic) IBOutlet MKMapView *placesMapView;

@end

@implementation MapViewController
@synthesize placesMapView= _placesMapView;
@synthesize annotations= _annotations;


- (void) updateMapView
{
    if (self.placesMapView.annotations) [self.placesMapView removeAnnotations:self.placesMapView.annotations];
    if (self.annotations) [self.placesMapView addAnnotations:self.annotations];
}


- (void)setPlacesMapView:(MKMapView *)placesMapView
{
    _placesMapView = placesMapView;
    [self updateMapView];
}

- (void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

- (void)viewDidUnload {
    [self setPlacesMapView:nil];
    [super viewDidUnload];
}
@end
