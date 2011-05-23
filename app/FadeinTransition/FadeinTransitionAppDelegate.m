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

// 独自のキーと値
#define kSetupViewAnimationType @"setupViewAnimationType"
#define kSetupViewAnimationTypeFadeIn @"setupViewAnimationTypeFadeIn"

- (void) firedStart:(id)sender 
{
    NSAutoreleasePool* autoreleasePool = [[NSAutoreleasePool alloc] init];
    {
        CGFloat scale = [[UIScreen mainScreen] respondsToSelector:NSSelectorFromString(@"scale")] ? [UIScreen mainScreen].scale : 1.0f;
            // スケールを判別
        CGRect bounds = [UIScreen mainScreen].bounds;
        
        CGRect rectDrawArea = bounds;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(rectDrawArea.size.width,rectDrawArea.size.height) , NO , scale );
            // 画面サイズの描画領域を確保する
        
        [self.setupViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
           // 描画領域に対してsetupViewController のlayer の内容を描画する
        
        UIImage* screenImage = UIGraphicsGetImageFromCurrentImageContext();
            // 作画した結果をUIImage として取得する
            
        UIGraphicsEndImageContext(); // 確保した領域を解放する
        self.setupViewController = nil;
            // setupViewController はこのさき必要ないので解放する
        
        // セットアップ中viewControllerをメインビューを置き換え
        self.window.rootViewController = self.navigationController;

        // アニメーションを開始
        // 開始画面からメイン画面へフェードインしながら切り替わるアニメーションを実現する
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        
        layerFade_ = [[CALayer alloc] init];
        layerFade_.contents = (id)[screenImage CGImage];
        
        layerFade_.position = CGPointMake(bounds.size.width * .5f ,bounds.size.height * .5f + 20.0f);
        layerFade_.bounds = CGRectMake(0.0f, 0.0f, rectDrawArea.size.width , rectDrawArea.size.height );
        layerFade_.opacity = 0.0f;
        [self.window.layer addSublayer:layerFade_];
        
        CABasicAnimation* theAnimation = [[CABasicAnimation alloc] init]; // アニメーションのインスタンスを確保
        
        theAnimation.duration = 1.0f; // アニメーションの秒数を指定 [秒].[ミリ秒]
        theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]; // アニメーションタイミングを登録
        theAnimation.keyPath = @"opacity"; // 不透過度
        theAnimation.fromValue = [NSNumber numberWithFloat:1.0f]; // 開始1.0
        theAnimation.toValue = [NSNumber numberWithFloat:0.0f]; // 終了0.0
        [theAnimation setValue:kSetupViewAnimationTypeFadeIn forKey:kSetupViewAnimationType]; // 独自のプロパティkSetupViewAnimationType に値kSetupViewAnimationTypeFadeIn を格納
        theAnimation.delegate = self; // アニメーション終了後のdelegate を登録
        [layerFade_ addAnimation:theAnimation forKey:@"fadeinAnimation"]; // キー名fadeinAnimation としてアニメーションを追加
        
        [theAnimation release]; // 追加が終わったアニメーションを削除
        
        [CATransaction commit ]; // CATransaction begin から始まったアニメーションをcommit する
    }
    [autoreleasePool release];
}

// CAAnimation のdelegate メソッド
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString* setupViewAnimationType = [anim valueForKey:kSetupViewAnimationType];
    
	if( setupViewAnimationType != nil && [setupViewAnimationType compare:kSetupViewAnimationTypeFadeIn] == NSOrderedSame ){
        [layerFade_ removeFromSuperlayer]; // CALayer を親layer から削除
        [layerFade_ release]; // CALalayer から削除
        layerFade_ = nil;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    self.window.rootViewController = self.setupViewController; // セットアップ中に用意するviewController を用意する
    [self.window makeKeyAndVisible];
    
    [self performSelector:@selector(firedStart:) withObject:nil afterDelay:3.0f];
        // 3秒待ち受ける、実際にはNSURLConnection などネットワークへのリクエストを行う
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

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
