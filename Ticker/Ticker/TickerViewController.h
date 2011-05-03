//
//  TickerViewController.h
//  Ticker
//
//  Created by Jeff Hodnett on 03/05/2011.
//  Copyright 2011 Applausible. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTickerView.h"

@interface TickerViewController : UIViewController {
    
	// The ticker
	JHTickerView *ticker;
}

-(IBAction)pauseButtonSelected:(id)sender;
-(IBAction)resumeButtonSelected:(id)sender;

@end
