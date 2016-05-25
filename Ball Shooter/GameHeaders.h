//
//  GameHeaders.h
//  Splash Balls
//
//  Created by Maroun Abi Ramia on 1/15/16.
//  Copyright © 2016 Maroun Abi Ramia. All rights reserved.
//

#ifndef GameHeaders_h
#define GameHeaders_h

typedef NS_OPTIONS(uint32_t, BSPhysicsCategory) {
    BSPhysicsCategoryWall = 0x1 << 0, // 0001
    BSPhysicsCategoryPlayer = 0x1 << 1, // 0010
    BSPhysicsCategoryNextPlayer = 0x1 << 2, // 0100
    BSPhysicsCategoryCoin = 0x1 << 3,
};
#define ARC4RANDOM_MAX      0x100000000

#define SCORE_KEY @"ScoreKey1"
#define COIN_KEY @"CoinKey"
#define FONT_TYPE @"GROBOLD"

#define PLAYER_IMG @"ball.png"
#define APPSTORE_URL_PATH @"itms://itunes.apple.com/us/app/splash-balls/id1076092655?ls=1&mt=8"

#define AD_BANNER_SMALL @"ca-app-pub-5238743433535049/7673130418"
#define AD_BANNER_FULL @"ca-app-pub-5238743433535049/9149863618"
#define AD_BANNER_VIDEO @"ca-app-pub-5238743433535049/2184353218"
#define MAROUN_TEST_DEVICE @"59dcd80c9d900715a3d16d28ca3ce197"
#define SOPHIE_TEST_DEVICE @"e4b25a5f39bcef2a610504a92ed903ec"
#define CLAIRE_TEST_DEVICE @"8e2e3dcd4c9663eeba0ffb7f442066b6"
#define IPAD_TEST_DEVICE @"c9016d1b407621a1a8b6c83fe93d303d"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//Game Color : [UIColor colorWithRed:227.0/255.0 green:75.0/255.0 blue:80.0/255.0 alpha:1.0];
#endif /* GameHeaders_h */
