//
//  AboutViewController.m
//  RottenTomatoesAPIExample
//
//  Created by Mark Norgren on 2/10/12.
//  Copyright (c) 2012 Marked Systems. All rights reserved.
//

#import "MRKAboutViewController.h"

@implementation MRKAboutViewController

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)marknorgrenURLButtonAction:(id)sender {
    NSString* launchUrl = @"http://www.marknorgren.com/";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}

- (IBAction)markedsystemsURLButtonAction:(id)sender {
    NSString* launchUrl = @"http://www.markedsystems.com/";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
    
}

- (IBAction)mkNetworkKitURLButtonAction:(id)sender {
    NSString* launchUrl = @"https://github.com/MugunthKumar/MKNetworkKit";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}

- (IBAction)glyphishURLButtonAction:(id)sender {
    NSString* launchUrl = @"http://glyphish.com";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}
@end
