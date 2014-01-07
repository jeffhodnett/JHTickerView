//
//  JHViewController.m
//  TickerDemo
//
//  Created by Jeff Hodnett on 1/5/14.
//  Copyright (c) 2014 Jeff Hodnett. All rights reserved.
//

#import "JHViewController.h"
#import "JHTickerView.h"

@interface JHViewController ()
{
    JHTickerView *_tickerNormal;
    JHTickerView *_tickerAttributed;
}

@end

@implementation JHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat runningY = 100.0f;
    CGRect tickerFrame = CGRectMake(10.0f, runningY, 300.0f, 50.0f);
    CGFloat tickerSpeed = 100.0f;
    
    // Add a normal string based ticker
	_tickerNormal = [[JHTickerView alloc] initWithFrame:tickerFrame];
    [_tickerNormal setDirection:JHTickerDirectionLTR];
    [_tickerNormal setTickerText:@[@"JHTickerView - A custom ticker view for iOS!"]];
    [_tickerNormal setTickerFont:[UIFont fontWithName:@"Arial" size:21.0f]];
	[_tickerNormal setTickerSpeed:tickerSpeed];
	[_tickerNormal start];
	[self.view addSubview:_tickerNormal];

    tickerFrame.origin.y += tickerFrame.size.height + 20.0f;
    
    NSArray *tickerStrings = @[
                               @"We're no strangers to love, You know the rules and so do I,",
                               @"A full commitment's what I'm thinking of, You wouldn't get this from any other guy.....",
                               @"I just wanna tell you how I'm feeling, Gotta make you understand.....",
                               @"Never gonna give you up, Never gonna let you down, Never gonna run around and desert you.....",
                               @"Never gonna make you cry, Never gonna say goodbye, Never gonna tell a lie and hurt you....."];

    // Add attributed text
    NSMutableArray *attributedText = [NSMutableArray array];
    NSInteger attributedIndex = 0;
    for (NSString *str in tickerStrings) {
        // Create some attributed strings
        NSAttributedString *text = [self createRandomAttributedStringWithText:str];
        [attributedText addObject:text];
        attributedIndex++;
    }

	_tickerAttributed = [[JHTickerView alloc] initWithFrame:tickerFrame];
    [_tickerAttributed setDirection:JHTickerDirectionLTR];
    [_tickerAttributed setTickerText:attributedText];
	[_tickerAttributed setTickerSpeed:tickerSpeed];
	[_tickerAttributed start];
	[self.view addSubview:_tickerAttributed];
}

-(NSAttributedString *)createRandomAttributedStringWithText:(NSString *)text
{
    // Generate some random attributes
    NSArray *familyNames = [UIFont familyNames];
    NSString *randomFontName = [familyNames objectAtIndex:[self randomFrom:0 to:[familyNames count]]];
    NSInteger randomFontPointSize = [self randomFrom:12.0f to:32.0f];
    UIFont *randomFont = [UIFont fontWithName:randomFontName size:randomFontPointSize];
    
    UIColor *randomForegroundColor = [UIColor blackColor];
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                               attributes:@{
                                                                            NSFontAttributeName: randomFont,
                                                                            NSForegroundColorAttributeName: randomForegroundColor,
                                                                            }];
    return attributedText;
}

-(NSInteger)randomFrom:(NSInteger)fromNumber to:(NSInteger)toNumber
{
    return (arc4random()%(toNumber-fromNumber))+fromNumber;
}

-(IBAction)addTickerText:(id)sender
{
    static int index = 0;
    [_tickerNormal addTickerText:[NSString stringWithFormat:@"Hello Ticker World %d!!", ++index]];
}

@end
