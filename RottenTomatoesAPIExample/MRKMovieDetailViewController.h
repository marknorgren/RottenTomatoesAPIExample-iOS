//
//  MRKMovieDetailViewController.h
//  RottenTomatoesAPIExample
//
//  Created by Mark Norgren on 2/6/12.
//  Copyright (c) 2012 Marked Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "Facebook.h"

@interface MRKMovieDetailViewController : UIViewController <UIScrollViewDelegate, FBDialogDelegate, FBRequestDelegate,FBSessionDelegate>

@property (nonatomic, retain) Movie *currentMovie;
@property (weak, nonatomic) IBOutlet UIScrollView *movieDetailScrollView;
@property (weak, nonatomic) IBOutlet UILabel *castLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsisLabel;

- (id)initWithNibNameAndMovie:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMovie:(Movie*)aMovie;
-(void) tweetAction;
-(void) fbShareAction;

@end


