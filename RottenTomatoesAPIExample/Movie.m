//
//  Movie.m
//  RottenTomatoesAPIExample
//
//  Created by Mark Norgren on 2/3/12.
//  Copyright (c) 2012 Marked Systems. All rights reserved.
//

#import "Movie.h"



@implementation Movie{
    
}

@synthesize title, synopsis;
@synthesize moviePosterURL;
@synthesize moviePoster, moviePosterDetailedURL, moviePosterOriginalURL, fullMoviePageURL;
@synthesize cast;
@synthesize critics_rating;
@synthesize critics_score;
@synthesize runtime;
@synthesize mpaa_rating;

- (id)initWithDictionary:(NSDictionary *)aDictionary {
	if ([self init]) {
		self.title = [aDictionary valueForKey:@"title"];
        self.synopsis = [aDictionary valueForKey:@"synopsis"];
		self.moviePosterURL = [NSURL URLWithString:[[aDictionary valueForKey:@"posters"] valueForKey:@"thumbnail"]];
        self.moviePosterDetailedURL = [NSURL URLWithString:[[aDictionary valueForKey:@"posters"] valueForKey:@"detailed"]];
        self.moviePosterOriginalURL = [NSURL URLWithString:[[aDictionary valueForKey:@"posters"] valueForKey:@"original"]];
        self.fullMoviePageURL = [NSURL URLWithString:[[aDictionary valueForKey:@"links"] valueForKey:@"alternate"]];
        // TODO - start asynchronous download of moviePoster
		self.cast = [aDictionary valueForKey:@"abridged_cast"];
		self.critics_score = [[aDictionary valueForKey:@"ratings"] valueForKey:@"critics_score"];
		self.critics_rating = [[aDictionary valueForKey:@"ratings"] valueForKey:@"critics_rating"];
		self.runtime = [aDictionary valueForKey:@"runtime"];
        self.mpaa_rating = [aDictionary valueForKey:@"mpaa_rating"];
        
	}
	return self;
}

- (void)dealloc {
	title = nil;
	moviePoster = nil;
	cast = nil;
	critics_rating = nil;
	critics_score = nil;
	runtime = nil;
    mpaa_rating = nil;
}

@end
