//
//  FlickrPhotoAnnotation.h
//  Top Places
//
//  Created by Gualberto Espechi Parada on 21/08/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrPhotoAnnotation : NSObject <MKAnnotation>

+ (FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo ; //Flicr photo dictionary

@property (nonatomic, strong) NSDictionary *photo;
@end
