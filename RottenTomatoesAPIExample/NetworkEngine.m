//
//  NetworkEngine.m
//  RottenTomatoesAPIExample
//
//  Created by Mark Norgren on 1/1/12.
//  Copyright (c) 2012 MarkedSystems All rights reserved.
//

#import "NetworkEngine.h"
#import "MRKAppDelegate.h"
#import "Movie.h"

@implementation NetworkEngine

//translate string to JSON with ios4 support
-(NSDictionary *) getResponseDictionary:(NSData *)response{
    //Check for ios5 or later...
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        
        NSError *error;
        return [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error]; 
    }
    else{
        DLog(@"iOS < 5.0 not supported");
        return nil;
    }
}

-(MKNetworkOperation*) getBoxOfficeMovieList:(BoxOfficeMoivesResponseBlock)completionBlock onError:(MKNKErrorBlock)errorBlock
{
    MKNetworkOperation *op = [self operationWithPath:kListMoviesBoxOffice
                                              params:nil
                                          httpMethod:@"GET"];
    [op onCompletion:^(MKNetworkOperation *completedOperation)
     {
         if([completedOperation isCachedResponse]) {
             //DLog(@"Data from cache %@", [completedOperation responseString]);
         }
         else {
             //DLog(@"Data from server %@", [completedOperation responseString]);
         }
         /* process reponse here */
         NSDictionary *responseDict = [self getResponseDictionary:[completedOperation responseData]];
         //DLog(@"responseDict: %@", responseDict);
         NSArray *movies = responseDict[@"movies"];
         NSMutableArray *movieModelObjects = [[NSMutableArray alloc] init ];
         //DLog(@"movies: %@", movies);
         for (id movie in movies) {
             //DLog(@"movie: %@", movie);
             Movie *thisMovie = [[Movie alloc] initWithDictionary:movie];
             DLog(@"thisMovie.title: %@", thisMovie.title);
             DLog(@"thisMovie.moviePosterURL: %@", [thisMovie.moviePosterURL absoluteString]);
             [movieModelObjects addObject:thisMovie];
            
         }
         NSArray *array = [NSArray arrayWithArray:movieModelObjects];
         completionBlock(array);
     }onError:^(NSError* error) {
         errorBlock(error);
     }];
    [self enqueueOperation:op];
    return op;
}

-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"BoxOfficeMoviePosters"];
    return cacheDirectoryName;
}

@end
