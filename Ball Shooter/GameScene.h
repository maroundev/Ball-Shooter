//
//  GameScene.h
//  Splash Balls
//
//  Created by Maroun Abi Ramia on 1/14/16.
//  Copyright © 2016 Maroun Abi Ramia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameHeaders.h"
#import "StartScene.h"
#import "Player.h"
#import "Coin.h"
#import "Walls.h"

@interface GameScene : SKScene <SKPhysicsContactDelegate>
@property Player *player;
@property Player *nextPlayer;
@property Coin *coin;

@end
