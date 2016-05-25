//
//  InterstitialAdBanner.h
//  Splash Balls
//
//  Created by Maroun Abi Ramia on 1/23/16.
//  Copyright © 2016 Maroun Abi Ramia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameHeaders.h"

@import GoogleMobileAds;

@interface InterstitialAdBanner : NSObject <GADInterstitialDelegate>
+ (InterstitialAdBanner *)sharedInstance;
- (void)displayADWithScene:(UIViewController * )view;
- (BOOL)isADReady;

@property(nonatomic, strong) GADInterstitial *interstitial;
@property NSString *adID;
@end
