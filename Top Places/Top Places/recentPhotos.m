//
//  recentPhotos.m
//  Top Places
//
//  Created by Gualberto Espechi Parada on 01/08/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "recentPhotos.h"
#import "viewPictureFromPlace.h"

@interface recentPhotos ()


@property (nonatomic, weak) NSArray *recentPhotosList;
@property (nonatomic, copy) NSIndexPath *path;
@end

@implementation recentPhotos

@synthesize recentPhotosList = _recentPhotosList;
@synthesize tableView =_tableView;
@synthesize path = _path;

#define RECENTLY_VIEWED_KEY @"viewPictureFromPlace.recent"//good idea is to use the class name to avoid cpossble conflics

- (viewPictureFromPlace *)splitViewViewPictureFromPlace
{
    id svpfp = [self.splitViewController.viewControllers lastObject];
    if (![svpfp isKindOfClass:[viewPictureFromPlace class]]) {
        svpfp = nil;
    }
    return svpfp;
}


- (void)setRecentPhotosList:(NSArray *)recentPhotosList
{
    if (_recentPhotosList != recentPhotosList) {
        _recentPhotosList = recentPhotosList;
        // Model changed, so update our View (the table)if (self.tableView.window)
         if (self.tableView.window)[self.tableView reloadData];
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
    if ([segue.identifier isEqualToString: @"Show Recent Picture"]) {
       // NSIndexPath *indexPath = self.path;
        [segue.destinationViewController setSelectedPicture:[self.recentPhotosList objectAtIndex:self.path.row]];
        NSLog(@"indesxPath segue, %@", self.path);

        //NSLog(@"recent Segue %@",[self.recentPhotosList objectAtIndex:indexPath.row] );
    }
}




- (void) viewDidLoad
{
    [super viewDidLoad];
    //NSUserDefaults *defaults = [NSUserDefaultsstandardUserDefaults];
    dispatch_queue_t donwloadQueue  = dispatch_queue_create("flickr recent photos donwload", NULL);
    dispatch_async(donwloadQueue, ^{
        self.recentPhotosList = [[NSUserDefaults standardUserDefaults] objectForKey:RECENTLY_VIEWED_KEY];
    });
    dispatch_release(donwloadQueue);
    // NSLog(@"recentPhotolist  %@", self.recentPhotosList);
       // [self.tableView reloadData] ;

}

- (void)viewWillAppear:(BOOL)animated
{    
    [self.tableView reloadData] ;
    [super viewWillAppear:animated];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recentPhotosList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recent Photo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    NSArray *photoDetails = [self.recentPhotosList objectAtIndex:indexPath.row];
    
    cell.textLabel.text =[super getTitleFrom:photoDetails insideAnotherDictionary:NO withKey:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text= [super getTitleFrom:photoDetails insideAnotherDictionary:YES withKey:FLICKR_PHOTO_DESCRIPTION];
    if ([cell.textLabel.text isEqualToString:@"Unknown"] || [cell.textLabel.text isEqualToString:@""]) {
        cell.textLabel.text = cell.detailTextLabel.text;
        cell.detailTextLabel.text=@"";
    }
    
    //NSLog(@"photo details %@", photoDetails);
    //NSLog(@"%@", photoDetails);
    
    return cell;
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
/*
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    return indexPath;
    NSLog(@"indesxPath void, %@", indexPath);
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.path = indexPath;
    if ([self splitViewViewPictureFromPlace]) {
        [self splitViewViewPictureFromPlace].selectedPicture = [self.recentPhotosList objectAtIndex:indexPath.row];
        [self splitViewViewPictureFromPlace].photoTitle = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    }
    [self.tableView reloadData];
}

@end
