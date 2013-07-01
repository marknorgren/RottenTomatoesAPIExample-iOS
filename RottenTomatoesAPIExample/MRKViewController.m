//
//  MRKViewController.m
//  RottenTomatoesAPIExample
//
//  Created by Mark Norgren on 2/2/12.
//  Copyright (c) 2012 Marked Systems. All rights reserved.
//

#import "MRKViewController.h"
#import "MRKAppDelegate.h"
#import "MovieCustomTableViewCell.h"
#import "MRKMovieDetailViewController.h"
#import "Movie.h"

@implementation MRKViewController

@synthesize movieObjectsArray;
@synthesize tableView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [ApplicationDelegate.networkEngine getBoxOfficeMovieList:^(NSArray *responseArray) {
        DLog(@"response: %@", responseArray);
        movieObjectsArray = responseArray;
        [tableView reloadData];
        
    }
                                                     onError:^(NSError* error) {
                                                         DLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason], 
                                                              [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                                                     }];
    
}

- (void)viewDidUnload
{
    tableView = nil;
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [super viewWillAppear:animated];
}


- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [movieObjectsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MovieCustomTableViewCell" owner:self options:nil];
        for (id cellPossible in topLevelObjects)
            if ([cellPossible isKindOfClass:[UITableViewCell class]])
                cell = (UITableViewCell *) cellPossible;
    }
    
    
    // Configure the cell...
    Movie *thisMovie;
    thisMovie = (Movie*)movieObjectsArray[indexPath.row];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1001];
    UIImageView *arrowImageView = (UIImageView *)[cell viewWithTag:1005];
    UILabel *labelView = (UILabel *)[cell viewWithTag:1002];
    UIImageView *ratingImage = (UIImageView *)[cell viewWithTag:1003];
    UIProgressView *movieRating = (UIProgressView *)[cell viewWithTag:1004];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
#define kCellBackgroundGrey [UIColor colorWithRed:100.0/242 green:100.0/242 blue:100.0/242 alpha:1.]
    if (indexPath.row % 2) 
    {
        cell.contentView.backgroundColor = kCellBackgroundGrey;
        arrowImageView.image = [UIImage imageNamed:@"arrowWhite"]; 
    }
    else
    {
        arrowImageView.image = [UIImage imageNamed:@"arrow"]; 
    }
    
    CGSize maximumLabelSize = CGSizeMake(151,40);
    labelView.text = thisMovie.title;
    CGSize expectedLabelSize = [labelView.text sizeWithFont:labelView.font 
                                                   constrainedToSize:maximumLabelSize 
                                                       lineBreakMode:labelView.lineBreakMode];
    CGRect newFrame = labelView.frame;
    labelView.frame = CGRectMake(newFrame.origin.x, newFrame.origin.y, expectedLabelSize.width, expectedLabelSize.height);
    
    DLog(@"labelView.frame: %f,%f,%f,%f", labelView.frame.origin.x,labelView.frame.origin.y,labelView.frame.size.width,labelView.frame.size.height);
    NSURL *thisMoviePosterURL = thisMovie.moviePosterURL;
    DLog(@"thisMoviePosterURL: %@", [thisMoviePosterURL absoluteString]);
    [ApplicationDelegate.networkEngine imageAtURL:thisMoviePosterURL onCompletion:^(UIImage *fetchedImage, NSURL *fetchedURL, BOOL isInCache) {
        DLog(@"fetchedURL: %@", [fetchedURL absoluteString]);
        DLog(@"thisMoviePosterURL: %@", [thisMoviePosterURL absoluteString]);
        if(thisMoviePosterURL == fetchedURL)
        {
            DLog(@"set imageView poster: %@", [thisMoviePosterURL absoluteString]);
            imageView.image = fetchedImage;
        }
        
    }];
    movieRating.progress = (float)[thisMovie.critics_score intValue]/100.0;
    
    float ratingImageOriginX = labelView.frame.origin.x + labelView.frame.size.width + 5;

    if (thisMovie.mpaa_rating) {
        ratingImage.image = [UIImage imageNamed:[thisMovie.mpaa_rating lowercaseString]];
        ratingImage.frame = CGRectMake(ratingImageOriginX, ratingImage.frame.origin.y-5, ratingImage.frame.size.width, ratingImage.frame.size.height);

    }
    
    //labelView.frame = CGRectMake(20,18,238,27);    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Movie *thisMovie;
    thisMovie = (Movie*)movieObjectsArray[indexPath.row];
    
    MRKMovieDetailViewController *movieDetailVC = [[MRKMovieDetailViewController alloc] initWithNibNameAndMovie:@"MRKMovieDetailViewController" bundle:nil withMovie:thisMovie];
    
    
    DLog(@"mdvc: %@", movieDetailVC.description);
    DLog(@"navController: %@", self.navigationController.description);
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:movieDetailVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO - calculate this from customTableViewCell XIB
    return 104;
}

@end
