//
//  MRKViewController.h
//  RottenTomatoesAPIExample
//
//  Created by Mark Norgren on 2/2/12.
//  Copyright (c) 2012 Marked Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRKViewController : UIViewController
{
    NSArray *movieObjectsArray;
}

@property (nonatomic, retain) NSArray *movieObjectsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
