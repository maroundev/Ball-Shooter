//
//  Player.h
//  Splash Balls
//
//  Created by Maroun Abi Ramia on 1/15/16.
//  Copyright © 2016 Maroun Abi Ramia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameHeaders.h"

@interface Player : SKSpriteNode

- (instancetype)initWithPosition:(CGPoint)position imageName:(NSString *)image andSize:(float)sizePassed;
- (void)update:(NSTimeInterval)currentTime;
- (void)removePlayerWithAnimation:(BOOL)animate;

- (void)showPlayerTrail;
- (void)removeTrail;

- (void)remove_player_tutorial;
- (void)show_player_tutorial;

- (void)show_hit_target_tut;
- (void)remove_hit_target_tut;

@end
