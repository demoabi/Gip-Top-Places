//
//  viewPictureFromPlace.m
//  Top Places
//
//  Created by Gualberto Espechi Parada on 31/07/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "viewPictureFromPlace.h"
#import "FlickrFetcher.h"
@interface viewPictureFromPlace()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *viewPicture;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end


@implementation viewPictureFromPlace
@synthesize scrollView;
@synthesize viewPicture;
@synthesize loadingIndicator;
@synthesize selectedPicture = _selectedPicture;
@synthesize photoTitle = _photoTitle;

#define RECENTLY_VIEWED_KEY @"viewPictureFromPlace.recent"//good idea is to use the class name to avoid cpossble conflics


- (void)viewDidLoad 
{
    [super viewDidLoad];
   // viewPicture.image = nil;
}

-(void)loadImage
{
    NSLog(@"Selected Pic %@", self.selectedPicture);
    
    [loadingIndicator startAnimating];
    
    self.viewPicture.backgroundColor =[UIColor underPageBackgroundColor];
    
    NSString *currentPhotoId = [[self.selectedPicture objectForKey:FLICKR_PHOTO_ID] copy];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("Flickr photo download", NULL);
    dispatch_async(downloadQueue, ^{
        
        
        UIImage * photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:self.selectedPicture format:2]]];
        
        
        
        if ([currentPhotoId isEqualToString:[self.selectedPicture objectForKey:FLICKR_PHOTO_ID]]) 
        { 
            dispatch_async(dispatch_get_main_queue(), ^{
                
                viewPicture.image = photo;
                self.navigationItem.title = self.photoTitle;
                
                self.scrollView.zoomScale= 1;
                self.viewPicture.frame = CGRectMake(0, 0, viewPicture.image.size.width, viewPicture.image.size.height);
                self.scrollView.contentSize = self.viewPicture.image.size;
                self.scrollView.maximumZoomScale= 2;
                
                if (self.viewPicture.frame.size.width < self.viewPicture.frame.size.height) {
                    self.scrollView.minimumZoomScale= self.scrollView.frame.size.height / self.viewPicture.frame.size.height;
                    self.scrollView.zoomScale =self.scrollView.frame.size.width / self.viewPicture.frame.size.width;
                }else
                {
                    self.scrollView.minimumZoomScale= self.scrollView.frame.size.width / self.viewPicture.frame.size.width;
                    self.scrollView.zoomScale= self.scrollView.frame.size.height / self.viewPicture.frame.size.height;
                }
                
                NSLog(@"scroll view %g - viewpic %g", self.scrollView.frame.size.width, self.viewPicture.frame.size.width );
                [loadingIndicator stopAnimating];
                
            });
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];//create user default dic
            NSMutableArray *recentList = [[defaults objectForKey:RECENTLY_VIEWED_KEY] mutableCopy];//create an nsarray to store  favorites and get its value from the user defaults
            if (!recentList) recentList = [NSMutableArray  array];// if array is empty we fill it
            
            if (( [[recentList copy] containsObject:self.selectedPicture])) [recentList removeObject:self.selectedPicture];
            if ([recentList count]> 20) [recentList removeLastObject];
            [recentList insertObject:self.selectedPicture atIndex:0];// we add the new object to our nsarray
            [defaults setObject:recentList forKey:RECENTLY_VIEWED_KEY];// we save the nsarray to our favorites key
            [defaults synchronize];// save changes        
             
        }
      
    });

    dispatch_release(downloadQueue);
}


-(void) setSelectedPicture:(NSDictionary *)selectedPicture
{
    if (selectedPicture != _selectedPicture) {
        _selectedPicture = selectedPicture;
        [self.viewPicture setNeedsDisplay];
        if (self.scrollView.window)[self loadImage];
        
        NSLog(@"Picture Changed");
    }
}


- (void) viewWillAppear:(BOOL)animated
{       
    [super viewWillAppear:animated];
    self.scrollView.delegate = self;
        if (self.selectedPicture) {    
            [self loadImage];
        } else {
            self.viewPicture.backgroundColor =[UIColor underPageBackgroundColor];
            [loadingIndicator stopAnimating];
        }
  }


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];    
}


- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.viewPicture;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;

}   
   
- (void)viewDidUnload {
    [self setViewPicture:nil];
    [self setScrollView:nil];
    [self setLoadingIndicator:nil];
    [super viewDidUnload];
}
@end
