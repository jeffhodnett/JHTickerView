//
//  JHTickerView.h
//  Ticker
//
//  Created by Jeff Hodnett on 03/05/2011.
//  Copyright 2011 Applausible. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    JHTickerDirectionLTR,
    JHTickerDirectionRTL,
} JHTickerDirection;

@interface JHTickerView : UIView

// The ticker speed
@property(nonatomic) CGFloat tickerSpeed;

// Should the ticker loop
@property(nonatomic) BOOL loops;

// The ticker animation direction
@property(nonatomic) JHTickerDirection direction;

// The ticker font
-(void)setTickerFont:(UIFont *)font;

// Set text either normal NSString or NSAttributedString
-(void)setTickerText:(NSArray *)text;
-(void)addTickerText:(id)text;
-(void)removeAllTickerText;

// Start the ticker
-(void)start;

// Pause the ticker
-(void)pause;

// Resume the ticker
-(void)resume;

@end
