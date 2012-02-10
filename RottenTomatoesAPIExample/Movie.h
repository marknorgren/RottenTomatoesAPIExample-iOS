//
//  Movie.h
//  RottenTomatoesAPIExample
//
//  Created by Mark Norgren on 2/3/12.
//  Copyright (c) 2012 Marked Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject {
    
    NSString *title;
    NSString *synopsis;
    NSURL *moviePosterURL;
    NSURL *moviePosterDetailedURL;
    NSURL *moviePosterOriginalURL;
    NSURL *fullMoviePageURL;
    UIImage *moviePoster;
    NSArray *cast;
    NSString *critics_rating;
    NSString *critics_score;
    NSNumber *runtime;
    NSString *mpaa_rating;
    
}

- (id)initWithDictionary:(NSDictionary *)aDictionary;


@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *synopsis;

@property (nonatomic,retain) NSURL *moviePosterURL;
@property (nonatomic,retain) NSURL *moviePosterDetailedURL;
@property (nonatomic,retain) NSURL *moviePosterOriginalURL;
@property (nonatomic,retain) NSURL *fullMoviePageURL;
@property (nonatomic,retain) UIImage *moviePoster;
@property (nonatomic,retain) NSArray *cast;
@property (nonatomic,retain) NSString *critics_rating;
@property (nonatomic,retain) NSString *critics_score;
@property (nonatomic,retain) NSNumber *runtime;
@property (nonatomic,retain) NSString *mpaa_rating;


@end
