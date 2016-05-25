//
//  InterstitialAdBanner.m
//  Splash Balls
//
//  Created by Maroun Abi Ramia on 1/23/16.
//  Copyright © 2016 Maroun Abi Ramia. All rights reserved.
//

#import "InterstitialAdBanner.h"

@implementation InterstitialAdBanner

+ (InterstitialAdBanner *)sharedInstance{
    static InterstitialAdBanner *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        self.adID = AD_BANNER_FULL;
        self.interstitial = [self createAndLoadInterstitialWithAdUnitID:self.adID];
    }
    return self;
}

- (GADInterstitial *)createAndLoadInterstitialWithAdUnitID:(NSString *)adID{
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:adID];
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID, MAROUN_TEST_DEVICE, SOPHIE_TEST_DEVICE, IPAD_TEST_DEVICE];
    interstitial.delegate = self;
    [interstitial loadRequest:request];
    return interstitial;
}

- (BOOL)isADReady{
    return [self.interstitial isReady];
}
#pragma mark GADInterstitial Delegate

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"Full add error :%@", error);
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    NSLog(@"Ad presented");
    
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {

    self.interstitial = [self createAndLoadInterstitialWithAdUnitID:self.adID];
}


- (void)displayADWithScene:(UIViewController * )view{
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:view];
    }
}

@end
