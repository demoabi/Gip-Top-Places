//
//  topPlacesLocationsTableViewController.h
//  Top Places
//
//  Created by Gualberto Espechi Parada on 27/07/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrFetcher.h"

@interface topPlacesLocationsTableViewController : UITableViewController

- (NSString *)getTitleFrom:(NSArray *) dictionary insideAnotherDictionary: (BOOL)inSubDic withKey:(NSString *)key;
- (NSString *)getSubTitleFrom:(NSArray *) dictionary  withKey:(NSString *)key;

@end
