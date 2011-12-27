//
//  TickerViewController.m
//  Ticker
//
//  Created by Jeff Hodnett on 03/05/2011.
//  Copyright 2011 Applausible. All rights reserved.
//

#import "TickerViewController.h"

@implementation TickerViewController

- (void)dealloc
{
	[ticker release];
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
//	NSArray *tickerStrings = [NSArray arrayWithObjects:@"Some really long text in here to test.....whats next......Some really long text in here to test.....whats next......", @"I like cats......", @"I also like blue........", nil];
	
	
	NSArray *tickerStrings = [NSArray arrayWithObjects:@"JHTickerView - A custom ticker view by Jeff Hodnett", @"We're no strangers to love, You know the rules and so do I, A full commitment's what I'm thinking of, You wouldn't get this from any other guy.....", @"I just wanna tell you how I'm feeling, Gotta make you understand.....", @"Never gonna give you up, Never gonna let you down, Never gonna run around and desert you.....", @"Never gonna make you cry, Never gonna say goodbye, Never gonna tell a lie and hurt you.....", nil];
	
	ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(10, 100, 300, 50)];
    [ticker setDirection:JHTickerDirectionLTR];
	[ticker setTickerStrings:tickerStrings];
	[ticker setTickerSpeed:60.0f];
	[ticker start];
	
	[self.view addSubview:ticker];
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

-(IBAction)pauseButtonSelected:(id)sender {
	
	[ticker pause];
}

-(IBAction)resumeButtonSelected:(id)sender {

	[ticker resume];
}

@end
