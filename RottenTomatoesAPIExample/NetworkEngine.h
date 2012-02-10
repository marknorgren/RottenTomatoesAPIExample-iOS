//
//  NetworkEngine.h
//  RottenTomatoesAPIExample
//
//  Created by Mark Norgren on 1/1/12.
//  Copyright (c) 2012 MarkedSystems All rights reserved.
//

#import "MKNetworkEngine.h"

@interface NetworkEngine : MKNetworkEngine

typedef void (^CurrencyResponseBlock)(double rate);
typedef void (^RegisterResponseBlock)(NSDictionary *responseDict);
typedef void (^BoxOfficeMoivesResponseBlock)(NSArray *movieModelsArray);

-(MKNetworkOperation*) getBoxOfficeMovieList:(BoxOfficeMoivesResponseBlock) completionBlock onError:(MKNKErrorBlock) errorBlock;

@end
