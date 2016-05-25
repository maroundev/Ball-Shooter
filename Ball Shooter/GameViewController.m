//
//  GameViewController.m
//  Ball Shooter
//
//  Created by Maroun Abi Ramia on 1/13/16.
//  Copyright (c) 2016 Maroun Abi Ramia. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKView * skView = (SKView *)self.view;
    skView.ignoresSiblingOrder = YES;
    
    SKScene * scene = [StartScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
    
    _bannerFull = [[InterstitialAdBanner alloc] init];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFullAd:) name:@"fullad" object:nil];

    [self make_and_display_banner];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)make_and_display_banner{
    _bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 50)];
    [self.view addSubview:_bannerView];

    _bannerView.delegate = self;
    _bannerView.adUnitID = AD_BANNER_SMALL;
    _bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID, MAROUN_TEST_DEVICE, SOPHIE_TEST_DEVICE, CLAIRE_TEST_DEVICE, IPAD_TEST_DEVICE ];
    //[_bannerView loadRequest:request];

}

#pragma mark - GADBannerView Delegates

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    [UIView animateWithDuration:1.0 animations:^{
        _bannerView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.view.frame), 50);
    }];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    [_bannerView removeFromSuperview];
    NSLog(@"%@", error);
}

- (void)showFullAd:(NSNotification *)notif{
    [_bannerFull displayADWithScene:self];
}

@end
