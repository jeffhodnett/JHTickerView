//
//  JHTickerView.m
//  Ticker
//
//  Created by Jeff Hodnett on 03/05/2011.
//  Copyright 2011 Applausible. All rights reserved.
//

#import "JHTickerView.h"
#import <QuartzCore/QuartzCore.h>

// Defaults
static NSString *kDefaultTickerFontName = @"Marker Felt";
static const BOOL kDefaultTickerDoesLoop = YES;
static const JHTickerDirection kDefaultTickerDirection = JHTickerDirectionLTR;

@interface JHTickerView()
{
	// The current index for the string
	int _currentIndex;
	
	// The current state of the ticker
	BOOL _isRunning;
	
	// The ticker label
	UILabel *_tickerLabel;	
}

@property(nonatomic, strong) UIFont *font;
@property(nonatomic, strong) NSMutableArray *tickerStrings;

-(void)setupView;
-(void)animateCurrentTickerString;
-(void)pauseLayer:(CALayer *)layer;
-(void)resumeLayer:(CALayer *)layer;
@end

@implementation JHTickerView

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

-(void)setTickerSpeed:(CGFloat)tickerSpeed
{
    _tickerSpeed = tickerSpeed;
    
    // Disallow less than zero ticker speeds
    if(_tickerSpeed <= 0.0f) {
        _tickerSpeed = 0.1f;
    }
}

#if !__has_feature(objc_arc)
- (void)dealloc
{
	[_tickerLabel release];
    [_font release];
    [_tickerStrings release];
    
    [super dealloc];
}
#endif

-(void)setupView
{
	// Set background color to white
	[self setBackgroundColor:[UIColor whiteColor]];
	
	// Set a corner radius
	[self.layer setCornerRadius:5.0f];
	[self.layer setBorderWidth:2.0f];
	[self.layer setBorderColor:[UIColor blackColor].CGColor];
	[self setClipsToBounds:YES];
	
	// Set the font
    self.font = [UIFont fontWithName:kDefaultTickerFontName size:22.0];
    
	// Add the ticker label
    _tickerLabel = [[UILabel alloc] initWithFrame:self.bounds];
	[_tickerLabel setBackgroundColor:[UIColor clearColor]];
	[_tickerLabel setNumberOfLines:1];
    [_tickerLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_tickerLabel setFont:self.font];
    [_tickerLabel setAdjustsFontSizeToFitWidth:YES];
	[self addSubview:_tickerLabel];
	
	// Set that it loops by default
	self.loops = kDefaultTickerDoesLoop;
    
    // Set the default direction
    self.direction = kDefaultTickerDirection;
}

-(void)setTickerFont:(UIFont *)font
{
    self.font = font;
    [_tickerLabel setFont:self.font];
}

-(void)setTickerText:(NSArray *)text
{
    // Error check
    if (text == nil || [text count] == 0) {
        return;
    }
    
    self.tickerStrings = [NSMutableArray arrayWithArray:text];
}

-(void)addTickerText:(id)text
{
    [self.tickerStrings addObject:text];
}

-(void)removeAllTickerText
{
    [self.tickerStrings removeAllObjects];
}

-(void)animateCurrentTickerString
{
	id currentTickerString = [_tickerStrings objectAtIndex:_currentIndex];
	
	// Calculate the size of the text and update the frame size of the ticker label
    CGSize textSize = CGSizeZero;
    CGSize maxSize = CGSizeMake(MAXFLOAT, CGRectGetHeight(self.bounds));
    NSString *currentString = nil;
    if([currentTickerString isKindOfClass:[NSAttributedString class]]) {
        currentString = [currentTickerString string];
    }
    else {
        currentString = currentTickerString;
    }
    
    // Calculate size
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    NSDictionary *textAttributes = nil;
    if([currentTickerString isKindOfClass:[NSAttributedString class]]) {
        // Use the NSAttributedString attributes
        textAttributes = [currentTickerString attributesAtIndex:0 effectiveRange:NULL];
    }
    else {
        // Use this labels attributes
        textAttributes = @{
                           NSFontAttributeName: _tickerLabel.font
                           };
    }
    CGRect textRect = [currentString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttributes context:nil];
    textSize = textRect.size;
#else
    textSize = [currentString sizeWithFont:_tickerLabel.font constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
#endif

    // Setup some starting and end points
	CGFloat startingX = 0.0f;
    CGFloat endX = 0.0f;
    switch (self.direction) {
        case JHTickerDirectionRTL:
            startingX = -textSize.width;
            endX = self.frame.size.width;
            break;
        case JHTickerDirectionLTR:
        default:
            startingX = self.frame.size.width;
            endX = -textSize.width;
            break;
    }

	// Set starting position
	[_tickerLabel setFrame:CGRectMake(startingX, _tickerLabel.frame.origin.y, textSize.width, maxSize.height)];
	
	// Set the string
    if([currentTickerString isKindOfClass:[NSAttributedString class]]) {
        [_tickerLabel setAttributedText:currentTickerString];
    }
    else {
        [_tickerLabel setText:currentString];
    }
		
	// Calculate a uniform duration for the item
	float duration = (textSize.width + self.frame.size.width) / self.tickerSpeed;
	
	// Create animation
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        // Update end position
        CGRect tickerFrame = _tickerLabel.frame;
        tickerFrame.origin.x = endX;
        [_tickerLabel setFrame:tickerFrame];
    } completion:^(BOOL finished) {
        [self tickerAnimationCompleted];
    }];
}

//-(void)tickerMoveAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
-(void)tickerAnimationCompleted
{
	// Update the index
	_currentIndex++;
	
	// Check the index count
	if(_currentIndex >= [_tickerStrings count]) {
		_currentIndex = 0;

		// Check if we should loop
		if(!self.loops) {
			// Set not running
			_isRunning = NO;
		
			return;
		}
	}
	
	// Animate
	[self animateCurrentTickerString];
}

#pragma mark - Ticker Animation Handling
-(void)start
{
	// Set the index to 0 on starting
	_currentIndex = 0;
	
	// Set running
	_isRunning = YES;
	
	// Start the animation
	[self animateCurrentTickerString];
}

-(void)pause
{
	// Check if running
	if(_isRunning) {
		// Pause the layer
		[self pauseLayer:self.layer];
		
		_isRunning = NO;
	}
}

-(void)resume
{
	// Check not running
	if(!_isRunning) { 
		// Resume the layer
		[self resumeLayer:self.layer];
		
		_isRunning = YES;
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
