//
//  TickerAppDelegate.h
//  Ticker
//
//  Created by Jeff Hodnett on 03/05/2011.
//  Copyright 2011 Applausible. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TickerViewController;

@interface TickerAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TickerViewController *viewController;

@end
