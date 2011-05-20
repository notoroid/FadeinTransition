//
//  FadeinTransitionAppDelegate.m
//  FadeinTransition
//
//  Created by Kaname Noto on 11/05/20.
//  Copyright 2011 Irimasu Densan Planning. All rights reserved.
//

#import "FadeinTransitionAppDelegate.h"
#import "FadeinTransitionViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation FadeinTransitionAppDelegate


@synthesize window=_window;
@synthesize navigationController=_navigationController;
@synthesize setupViewController=_setupViewController;

#define kSetupViewAnimationType @"setupViewAnimationType"
#define kSetupViewAnimationTypeFadeIn @"setupViewAnimationTypeFadeIn"

- (void) firedStart:(id)sender 
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    
    CGRect rectDrawArea = bounds;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rectDrawArea.size.width,rectDrawArea.size.height) , NO , scale );
    
    [self.setupViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.setupViewController = nil;
    
    // 現在のビューを置き換え
    self.window.rootViewController = self.navigationController;
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    layerFade_ = [[CALayer alloc] init];
    layerFade_.contents = (id)[screenImage CGImage];
    
    layerFade_.position = CGPointMake(bounds.size.width * .5f ,bounds.size.height * .5f + 20.0f);
    layerFade_.bounds = CGRectMake(0.0f, 0.0f, rectDrawArea.size.width , rectDrawArea.size.height );
    layerFade_.opacity = 0.0f;
    [self.window.layer addSublayer:layerFade_];
    
    CABasicAnimation* theAnimation = [[CABasicAnimation alloc] init];
    
    theAnimation.duration = 1.0f;
    theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    theAnimation.keyPath = @"opacity";
    theAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    theAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    [theAnimation setValue:kSetupViewAnimationTypeFadeIn forKey:kSetupViewAnimationType];
    theAnimation.delegate = self;
    [layerFade_ addAnimation:theAnimation forKey:@"fadeinAnimation"];
    
    [theAnimation release];
    
    [CATransaction commit ];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString* setupViewAnimationType = [anim valueForKey:kSetupViewAnimationType];
    
	if( [setupViewAnimationType compare:kSetupViewAnimationTypeFadeIn] == NSOrderedSame ){
        [layerFade_ removeFromSuperlayer];
        [layerFade_ release];
        layerFade_ = nil;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    self.window.rootViewController = self.setupViewController;
    [self.window makeKeyAndVisible];
    
    [self performSelector:@selector(firedStart:) withObject:nil afterDelay:3.0f];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [layerFade_ release];
    [_window release];
    [_setupViewController release];
    [_navigationController release];
    [super dealloc];
}

@end
