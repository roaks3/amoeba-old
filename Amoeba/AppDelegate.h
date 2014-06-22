//
//  AppDelegate.h
//  Amoeba
//
//  Created by Ryan Oaks on 6/17/11.
//  Copyright Gov 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
