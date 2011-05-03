//
//  JHTickerView.m
//  Ticker
//
//  Created by Jeff Hodnett on 03/05/2011.
//  Copyright 2011 Applausible. All rights reserved.
//

#import "JHTickerView.h"
#import <QuartzCore/QuartzCore.h>

@interface JHTickerView(Private)
-(void)setupView;
-(void)animateCurrentTickerString;
-(void)pauseLayer:(CALayer *)layer;
-(void)resumeLayer:(CALayer *)layer;
@end

@implementation JHTickerView

@synthesize tickerStrings;
@synthesize tickerSpeed;
@synthesize loops;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setupView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	if( (self = [super initWithCoder:aDecoder]) ) {
		// Initialization code
		[self setupView];
	}
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
	[tickerLabel release];
	[tickerStrings release];
	
    [super dealloc];
}

-(void)setupView {
	// Set background color to white
	[self setBackgroundColor:[UIColor whiteColor]];
	
	// Set a corner radius
	[self.layer setCornerRadius:5.0f];
	[self.layer setBorderWidth:2.0f];
	[self.layer setBorderColor:[UIColor blackColor].CGColor];
	[self setClipsToBounds:YES];
	
	// Set the font
	tickerFont = [UIFont fontWithName:@"Marker Felt" size:22.0];
	
	// Add the label (i'm gonna center it on the view - please feel free to do your own thing)
	tickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 4, self.frame.size.width, self.frame.size.height)];
	[tickerLabel setBackgroundColor:[UIColor clearColor]];
	[tickerLabel setNumberOfLines:1];
	[tickerLabel setFont:tickerFont];
	[self addSubview:tickerLabel];
	
	// Set that it loops by default
	loops = YES;
}

-(void)animateCurrentTickerString
{
	NSString *currentString = [tickerStrings objectAtIndex:currentIndex];
	
	// Calculate the size of the text and update the frame size of the ticker label
	CGSize textSize = [currentString sizeWithFont:tickerFont constrainedToSize:CGSizeMake(9999, self.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
	
	// Move off screen
	[tickerLabel setFrame:CGRectMake(self.frame.size.width, tickerLabel.frame.origin.y, textSize.width, textSize.height)];
	
	// Set the string
	[tickerLabel setText:currentString];
		
	// Calculate a uniform duration for the item	
	float duration = (textSize.width + self.frame.size.width) / tickerSpeed;
	
	// Create a UIView animation
	[UIView beginAnimations:@"" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(tickerMoveAnimationDidStop:finished:context:)];
	
	[tickerLabel setFrame:CGRectMake(-textSize.width, tickerLabel.frame.origin.y, textSize.width, textSize.height)];
	
	[UIView commitAnimations];
}

-(void)tickerMoveAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	// Update the index
	currentIndex++;
	
	// Check the index count
	if(currentIndex >= [tickerStrings count]) {
		currentIndex = 0;

		// Check if we should loop
		if(!loops) {
			// Set not running
			running = NO;
		
			return;
		}
	}
	
	// Animate
	[self animateCurrentTickerString];
}

#pragma mark - Ticker Animation Handling
-(void)start {
	
	// Set the index to 0 on starting
	currentIndex = 0;
	
	// Set running
	running = YES;
	
	// Start the animation
	[self animateCurrentTickerString];
}

-(void)pause {
	
	// Check if running
	if(running) {
		// Pause the layer
		[self pauseLayer:self.layer];
		
		running = NO;
	}
}

-(void)resume {

	// Check not running
	if(!running) { 
		// Resume the layer
		[self resumeLayer:self.layer];
		
		running = YES;
	}
}

#pragma mark - UIView layer animations utilities
-(void)pauseLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

@end
