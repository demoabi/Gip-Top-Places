//
//  topPlacesLocationsTableViewController.m
//  Top Places
//
//  Created by Gualberto Espechi Parada on 27/07/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "topPlacesLocationsTableViewController.h"
#import "locationsPhotosList.h"
#import "FlickrPhotoAnnotation.h"
#import "MapViewController.h"

@interface topPlacesLocationsTableViewController()

@property (nonatomic, strong) NSArray * topPlaces;

@end

@implementation topPlacesLocationsTableViewController
@synthesize topPlaces = _topPlaces;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setTopPlaces:(NSArray *)topPlaces
{
    if (_topPlaces !=topPlaces) {
        _topPlaces=topPlaces;
        if(self.tableView.window )[self.tableView reloadData];
    }

}

- (NSArray*)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.topPlaces count]];
    for (NSDictionary *photo in self.topPlaces) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"Show Photos of Place"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [segue.destinationViewController setPlace:[self.topPlaces objectAtIndex:indexPath.row]];
        //NSLog(@"%@", [self.topPlaces objectAtIndex:indexPath.row]);
    }
    
    /*
    if ([segue.identifierisEqualToString:@"MapSegue"]) {
        NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.recentPhotos count]];
        for (NSDictionary *photo inself.recentPhotos) {
            [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
        }
        [segue.destinationViewController setAnnotations:annotations];
    }
    */
    
    if ([segue.identifier isEqualToString: @"Show Map"]) {
        
       // NSLog(@"%@", [self mapAnnotations]);
        
        NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.topPlaces count]];
        for (NSDictionary *photo in self.topPlaces) {
            [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
        }
        
        [segue.destinationViewController setAnnotation:annotations];
      
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr top places downlader", NULL);
    dispatch_async(downloadQueue, ^{
        
      NSArray *topPlaces = [FlickrFetcher topPlaces];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.topPlaces = topPlaces ;
        });
    });
    dispatch_release(downloadQueue);
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.topPlaces count];
}


- (NSString *)getTitleFrom:(NSArray *) dictionary insideAnotherDictionary: (BOOL)inSubDic withKey:(NSString *)key
{
    NSString *title = @"Unknown";
    NSArray *PlaceUrl = [[dictionary valueForKey:key] componentsSeparatedByString:@"/"];
    
    if (inSubDic){
        if (![[dictionary valueForKeyPath:key] isEqualToString:@""]) {
            title = [dictionary valueForKeyPath:key] ;
        }
    } else{ 
    if ([PlaceUrl count]> 0)
        {   int i = 0;
            while (i<[PlaceUrl count]) {
                title = [[PlaceUrl objectAtIndex:i]stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                i++;
            }
        } 
    }
    return title;
}


- (NSString *)getSubTitleFrom:(NSArray *) dictionary withKey:(NSString *)key 
{
    NSString *subTitle = @"Unknown";
    NSArray *PlaceUrl = [[dictionary valueForKey:key] componentsSeparatedByString:@"/"];
    if ([PlaceUrl count]> 0)
    { 
        int i = [PlaceUrl count]-1;
        while (i>0) {            
            subTitle = [[PlaceUrl objectAtIndex:i]stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            i--;
        }
    }
    return subTitle;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Place Description";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   //valueForKeyPath:@"description._content"

    NSArray *TopPlace = [self.topPlaces objectAtIndex:indexPath.row];
    cell.textLabel.text = [self getTitleFrom:TopPlace insideAnotherDictionary:NO withKey:FLICKR_PLACE_NAME];
    cell.detailTextLabel.text = [self getSubTitleFrom:TopPlace withKey:FLICKR_PLACE_NAME];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // self.place = [self.topPlaces objectAtIndex:indexPath.row];
}

@end
