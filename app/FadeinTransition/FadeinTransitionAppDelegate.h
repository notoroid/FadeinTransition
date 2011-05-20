//
//  FadeinTransitionAppDelegate.h
//  FadeinTransition
//
//  Created by Kaname Noto on 11/05/20.
//  Copyright 2011 Irimasu Densan Planning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FadeinTransitionViewController;

@interface FadeinTransitionAppDelegate : NSObject <UIApplicationDelegate> {
    CALayer* layerFade_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UIViewController *setupViewController;

@end
