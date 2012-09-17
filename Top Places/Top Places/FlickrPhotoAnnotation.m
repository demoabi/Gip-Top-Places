//
//  FlickrPhotoAnnotation.m
//  Top Places
//
//  Created by Gualberto Espechi Parada on 21/08/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "FlickrPhotoAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPhotoAnnotation

@synthesize photo = _photo;



+ (FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo //help method
{
    FlickrPhotoAnnotation *annotation = [[FlickrPhotoAnnotation alloc]init];
    annotation.photo = photo;
    return annotation;
}

- (NSString *)title
{
    return [self.photo objectForKey:FLICKR_PHOTO_TITLE];
}

- (NSString *)subtitle
{
    return [self.photo objectForKey:FLICKR_PHOTO_TITLE]; //[self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude= [[self.photo objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude= [[self.photo objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}

@end
