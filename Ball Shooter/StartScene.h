//
//  StartScene.h
//  Splash Balls
//
//  Created by Maroun Abi Ramia on 1/13/16.
//  Copyright © 2016 Maroun Abi Ramia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameCenterManager.h"
#import "GameHeaders.h"
#import "GameScene.h"
#import <Social/Social.h>
#import "InterstitialAdBanner.h"

@interface StartScene : SKScene
- (instancetype)initWithSize:(CGSize)size andScore:(int)score;
@property int score;
@end
