//
//  MRKMovieDetailViewController.m
//  RottenTomatoesAPIExample
//
//  Created by Mark Norgren on 2/6/12.
//  Copyright (c) 2012 Marked Systems. All rights reserved.
//

#import "MRKMovieDetailViewController.h"
#import "MRKAppDelegate.h"
#import <Twitter/Twitter.h>

@implementation MRKMovieDetailViewController
@synthesize movieDetailScrollView;
@synthesize castLabel;
@synthesize moviePosterImageView;
@synthesize movieSynopsisLabel;
@synthesize currentMovie;

- (id)initWithNibNameAndMovie:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMovie:(Movie*)aMovie
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        DLog(@"Movie Title: %@",aMovie.title); 
        currentMovie = aMovie;
    }
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Tweet"                                            
                                   style:UIBarButtonItemStyleBordered 
                                   target:self 
                                   action:@selector(tweetAction)];
    self.navigationItem.rightBarButtonItem = tweetButton;
    
    UIBarButtonItem *fbShareButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Share"                                            
                                   style:UIBarButtonItemStyleBordered 
                                   target:self 
                                   action:@selector(fbShareAction)];
    NSArray *barButtonItems = [[NSArray alloc] initWithObjects:tweetButton, fbShareButton, nil];
    //self.navigationItem.rightBarButtonItem = fbShareButton;
    self.navigationItem.rightBarButtonItems = barButtonItems;
    DLog(@"movieSynopsisLabel BEFORE****: %f,%f,%f,%f", 
         moviePosterImageView.frame.origin.x, 
         moviePosterImageView.frame.origin.y,
         moviePosterImageView.frame.size.width,
         moviePosterImageView.frame.size.height);
    
    [ApplicationDelegate.networkEngine imageAtURL:currentMovie.moviePosterDetailedURL onCompletion:^(UIImage *fetchedImage, NSURL *fetchedURL, BOOL isInCache) {
        DLog(@"fetchedURL: %@", [fetchedURL absoluteString]);
        DLog(@"thisMoviePosterURL: %@", [currentMovie.moviePosterDetailedURL absoluteString]);
        if(currentMovie.moviePosterDetailedURL == fetchedURL)
            DLog(@"set imageView poster: %@", [currentMovie.moviePosterDetailedURL absoluteString]);
        //change width of frame
        CGRect frame = moviePosterImageView.frame;
        frame.size.width = 180;
        frame.size.height = 267;
        moviePosterImageView.frame = frame;
        moviePosterImageView.image = fetchedImage;
        
        DLog(@"movieSynopsisLabel: %f,%f,%f,%f", 
             moviePosterImageView.frame.origin.x, 
             moviePosterImageView.frame.origin.y,
             moviePosterImageView.frame.size.width,
             moviePosterImageView.frame.size.height);
    }];
    
    
    movieSynopsisLabel.text = currentMovie.synopsis;

    //Calculate the expected size based on the font and linebreak mode of your label
    CGSize maximumLabelSize = CGSizeMake(280,9999);
    CGSize expectedLabelSize = [movieSynopsisLabel.text sizeWithFont:movieSynopsisLabel.font 
                                      constrainedToSize:maximumLabelSize 
                                          lineBreakMode:movieSynopsisLabel.lineBreakMode]; 
    //adjust the label the the new height.
    CGRect newFrame = movieSynopsisLabel.frame;
    newFrame.size.height = expectedLabelSize.height;
    movieSynopsisLabel.frame = newFrame;
    CGRect castFrame = castLabel.frame;
    castFrame = CGRectMake(castFrame.origin.x, newFrame.origin.y + newFrame.size.height + 20, castFrame.size.width, castFrame.size.height);
    castLabel.frame = castFrame;
    //castLabel.frame = newFrame;
    DLog(@"movieSynopsisLabel: %f,%f,%f,%f", 
         movieSynopsisLabel.frame.origin.x, 
         movieSynopsisLabel.frame.origin.y,
         movieSynopsisLabel.frame.size.width,
         movieSynopsisLabel.frame.size.height);
    DLog(@"castLabel: %f,%f,%f,%f", 
         castLabel.frame.origin.x, 
         castLabel.frame.origin.y,
         castLabel.frame.size.width,
         castLabel.frame.size.height);

    NSMutableArray *textFields;
    textFields = [NSMutableArray array];
    
    const CGFloat width = 300;
    const CGFloat height = 31;
    const CGFloat margin = 0;
    CGFloat y = castLabel.frame.origin.y + castLabel.frame.size.height + 5;
    
    
    for(NSDictionary *castMember in currentMovie.cast) {
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y, width, height)];
        myLabel.text = [NSString stringWithFormat:@"%@ as %@", [castMember valueForKey:@"name"], [[castMember valueForKey:@"characters"] objectAtIndex:0]];
        
        [movieDetailScrollView addSubview:myLabel];
        
        [textFields addObject:myLabel];
        
        y += height + margin;
    }
    y = y + 10;
    
    UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(5, y, 310, 2)];
    separator.backgroundColor = [UIColor blackColor];//[UIColor colorWithWhite:0.7 alpha:1];
    [self.movieDetailScrollView addSubview:separator];
    
    y = y + 10;
    
    UILabel *anotherLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, width, height)];
    int movieMinutes = [currentMovie.runtime intValue];
    int movieHours = movieMinutes / 60;
    movieMinutes = movieMinutes % 60;
    anotherLabel.text = [NSString stringWithFormat:@"Rated %@ • Freshness: %@%% • Runtime: %dhr %02dmin", 
                         currentMovie.mpaa_rating,
                         currentMovie.critics_score,
                         movieHours,
                         movieMinutes
                         ];
    anotherLabel.numberOfLines = 1;
    anotherLabel.adjustsFontSizeToFitWidth = YES;
    anotherLabel.minimumFontSize = 8;
    [self.movieDetailScrollView addSubview:anotherLabel];
    
    
    movieDetailScrollView.contentInset = UIEdgeInsetsMake(5, 0, 50, 0);
    movieDetailScrollView.contentSize = CGSizeMake(width, y - margin);
    

    
}

- (void)viewDidUnload
{
    [self setMovieDetailScrollView:nil];
    [self setCastLabel:nil];
    [self setMoviePosterImageView:nil];
    [self setMovieSynopsisLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark TwitterMethods

-(void) tweetAction
{
    DLog(@"Tweet tweet");
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        if ([TWTweetComposeViewController canSendTweet])
        {
            NSString *stringToTweet=[NSString stringWithFormat:@"Check out this movie! %@", currentMovie.fullMoviePageURL];
            TWTweetComposeViewController *tweetSheet = 
            [[TWTweetComposeViewController alloc] init];
            [tweetSheet setInitialText:stringToTweet];
            [self presentModalViewController:tweetSheet animated:YES];
            
        }
        //else open a window to take user to settings
        else{
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Twitter Not Configured" message:@"There are no Twitter accounts configured. You can add or create a Twitter account in Settings." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];   
            [alert show];
        }
    }
}

#pragma mark - Facebook
- (void)showLoggedIn {
    DLog(@"showLoggedIn");
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   kFacebookAppID, @"app_id",
                                   [currentMovie.fullMoviePageURL absoluteString], @"link",
                                   [currentMovie.moviePosterURL absoluteString], @"picture",
                                   @"mkrdSystems", @"name",
                                   currentMovie.title, @"caption",
                                   currentMovie.synopsis, @"description",
                                   @"*Ignored by Facebook*",  @"message",
                                   nil];
    [ApplicationDelegate.facebook dialog:@"feed" andParams:params andDelegate:self];
}

/**
 * Show the authorization dialog.
 */
- (void)login {
    if (![ApplicationDelegate.facebook isSessionValid]) {
        [ApplicationDelegate.facebook authorize:ApplicationDelegate.permissions];
    } else {
        [self showLoggedIn];
    }
}

-(void) fbShareAction
{
    DLog(@"shareOnFacebook");
    if(!ApplicationDelegate.facebook){
        DLog(@"!_facebook");            
            
        ApplicationDelegate.facebook = [[Facebook alloc] initWithAppId:kFacebookAppID andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] 
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
            ApplicationDelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            ApplicationDelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
        ApplicationDelegate.permissions =  [NSArray arrayWithObjects:@"publish_stream", @"offline_access", nil];
        if (![ApplicationDelegate.facebook isSessionValid])
        {
            [ApplicationDelegate.facebook authorize:ApplicationDelegate.permissions];
        }
        
    }
    else{
        DLog(@"facebook");
        /* get this from current article */
        [self login];
        
        
    }
    /* 
     @"message" is now ignored by a dialog feed post - 
     reference: 
     http://stackoverflow.com/questions/7195917/fill-in-message-box-on-facebook-mobile-app
     https://developers.facebook.com/blog/post/510/
     */
     
}

#pragma mark -
#pragma mark FBDialogDelegate

/*
 * Called when the dialog succeeds and is about to be dismissed.
 */
- (void)dialogDidComplete:(FBDialog *)dialog{
    DLog(@"FB dialog did complete");
}

/**
 * Called when the dialog succeeds with a returning url.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url{
    DLog(@"FB dialog did complete with URL %@", url);
    
    NSRange textRange;
    textRange =[[NSString stringWithFormat:@"%@",url] rangeOfString:@"post_id"];
    
    if(textRange.location != NSNotFound)
    {  
        //[delegate facebookPublishedFeed:username];
        
    }
    
}

/**
 * Called when the dialog get canceled by the user.
 */
- (void)dialogDidNotCompleteWithUrl:(NSURL *)url{
    DLog(@"dialogDidNotCompleteWithURL: %@", [url absoluteString]);
}

/**
 * Called when the dialog is cancelled and is about to be dismissed.
 */
- (void)dialogDidNotComplete:(FBDialog *)dialog{
    DLog(@"dialogDidNotComplete");
    
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError*)error {
	DLog(@"%@",[NSString stringWithFormat:@"Facebook Dialog Error(%d): %@", error.code,
                error.localizedDescription]);
}

#pragma mark -
#pragma mark FBRequestDelegate
/**
 * Show the logged in menu
 */



/**
 * Show the logged in menu
 */

- (void)showLoggedOut {
    DLog(@"showLoggedOut");
}



/**
 * Invalidate the access token and clear the cookie.
 */
- (void)logout {
    [ApplicationDelegate.facebook logout];
}


- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
	DLog(@"Error - Facebook Request [%@] failed with code [%d]: %@", request, error.code, error.localizedDescription);
}



#pragma mark - FBSessionDelegate Methods
/**
 * Called when the user has logged in successfully.
 */
- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    DLog(@"storeAuthData: %@, expiresAt: %@", accessToken, dateString);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbDidLogin {
    DLog(@"fbDidLogin");
    DLog(@"fb did login");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[ApplicationDelegate.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[ApplicationDelegate.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self showLoggedIn];
    
    //HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self storeAuthData:ApplicationDelegate.facebook.accessToken expiresAt:ApplicationDelegate.facebook.expirationDate];
    
    //[self publishFeed:kFbPrompt name:kFbName link:kFbLink caption:kFbCaption description:kFbDescription imageURL:kFbImageURL imageLink:kFbImageLink];
}




-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
    DLog(@"fbDidNotLogin");
    //[pendingApiCallsController userDidNotGrantPermission];
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    //pendingApiCallsController = nil;
    
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self showLoggedOut];
}

/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [self fbDidLogout];
}



#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    DLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    DLog(@"request didLoad");
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    // This callback can be a result of getting the user's basic
    // information or getting the user's permissions.
    if ([result objectForKey:@"name"]) {
        // If basic information callback, set the UI objects to
        // display this.
        //nameLabel.text = [result objectForKey:@"name"];
        // Get the profile image
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[result objectForKey:@"pic"]]]];
        
        // Resize, crop the image to make sure it is square and renders
        // well on Retina display
        float ratio;
        float delta;
        float px = 100; // Double the pixels of the UIImageView (to render on Retina)
        CGPoint offset;
        CGSize size = image.size;
        if (size.width > size.height) {
            ratio = px / size.width;
            delta = (ratio*size.width - ratio*size.height);
            offset = CGPointMake(delta/2, 0);
        } else {
            ratio = px / size.height;
            delta = (ratio*size.height - ratio*size.width);
            offset = CGPointMake(0, delta/2);
        }
        CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                     (ratio * size.width) + delta,
                                     (ratio * size.height) + delta);
        UIGraphicsBeginImageContext(CGSizeMake(px, px));
        UIRectClip(clipRect);
        [image drawInRect:clipRect];
        
        //[profilePhotoImageView setImage:imgThumb];
        //[self apiGraphUserPermissions];
    } else {
        // Processing permissions information
        //HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
        //[delegate setUserPermissions:[[result objectForKey:@"data"] objectAtIndex:0]];
    }
}

@end
