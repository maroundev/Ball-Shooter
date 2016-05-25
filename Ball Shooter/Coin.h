//
//  Coin.h
//  Splash Balls
//
//  Created by Maroun Abi Ramia on 1/18/16.
//  Copyright © 2016 Maroun Abi Ramia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameHeaders.h"

@interface Coin : SKSpriteNode
- (instancetype)initWithPosition:(CGPoint)po;
- (void)coin_remove;
@end
