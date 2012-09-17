//
//  locationsPhotosList.m
//  Top Places
//
//  Created by Gualberto Espechi Parada on 29/07/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "locationsPhotosList.h"
#import "FlickrFetcher.h"
#import "viewPictureFromPlace.h"

@interface locationsPhotosList()
@property (nonatomic, strong) NSArray * photosInPlace;

@end

@implementation locationsPhotosList
@synthesize place = _place;
@synthesize photosInPlace = _photosInPlace;


- (viewPictureFromPlace *)splitViewViewPictureFromPlace
{
    id svpfp = [self.splitViewController.viewControllers lastObject];
    if (![svpfp isKindOfClass:[viewPictureFromPlace class]]) {
        svpfp = nil;
    }
    return svpfp;
}

-(void)setPhotosInPlace:(NSArray *)photosInPlace
{
    if (_photosInPlace != photosInPlace) {
        _photosInPlace = photosInPlace;
        if (self.tableView.window) [self.tableView reloadData];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"Show Picture"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [segue.destinationViewController setSelectedPicture:[self.photosInPlace objectAtIndex:indexPath.row]];
        [segue.destinationViewController setPhotoTitle:[self.tableView cellForRowAtIndexPath:indexPath].textLabel.text];
        //NSLog(@"normal Segue %@",[self.photosInPlace objectAtIndex:indexPath.row] );
        NSLog(@"indesxPath segue, %@", sender);

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
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr locations photos Downloader", NULL);
    dispatch_async(downloadQueue, ^{
        self.photosInPlace = [FlickrFetcher photosInPlace:self.place maxResults:10];
    });
    
    dispatch_release(downloadQueue);
    
    //NSLog(@"%@", self.place);
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photosInPlace count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"description of photos";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
       
    NSArray *photoDetails = [self.photosInPlace objectAtIndex:indexPath.row];
    
    cell.textLabel.text =[super getTitleFrom:photoDetails insideAnotherDictionary:NO withKey:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text= [super getTitleFrom:photoDetails insideAnotherDictionary:YES withKey:FLICKR_PHOTO_DESCRIPTION];
    if ([cell.textLabel.text isEqualToString:@"Unknown"] || [cell.textLabel.text isEqualToString:@""]) {
        cell.textLabel.text = cell.detailTextLabel.text;
        cell.detailTextLabel.text=@"";
    }
    
    //NSLog(@"%@", photoDetails);
    //NSLog(@"%@", photoDetails);
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSString * currentPhotoTitle = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;    
    
    if ([self splitViewViewPictureFromPlace]) {
        
            
            [self splitViewViewPictureFromPlace].selectedPicture = [self.photosInPlace objectAtIndex:indexPath.row];
            [self splitViewViewPictureFromPlace].photoTitle = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
     
        NSLog(@"normal Segue %@",[self.photosInPlace objectAtIndex:indexPath.row] );
        /*[segue.destinationViewController setSelectedPicture:[self.photosInPlace objectAtIndex:indexPath.row]];
        [segue.destinationViewController setPhotoTitle:[self.tableView cellForRowAtIndexPath:indexPath].textLabel.text];
        
        NSLog(@"indesxPath segue, %@", sender);
*/
    }
    
               
}

@end
