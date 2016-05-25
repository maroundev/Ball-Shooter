//
//  GameViewController.h
//  Splash Balls
//

//  Copyright (c) 2016 Maroun Abi Ramia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "StartScene.h"
#import "GameHeaders.h"
#import "InterstitialAdBanner.h"

@import GoogleMobileAds;

@interface GameViewController : UIViewController <GADBannerViewDelegate>
@property (retain, nonatomic) IBOutlet GADBannerView  *bannerView;
@property InterstitialAdBanner *bannerFull;
@end
