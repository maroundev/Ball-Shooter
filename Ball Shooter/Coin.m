//
//  Coin.m
//  Splash Balls
//
//  Created by Maroun Abi Ramia on 1/18/16.
//  Copyright © 2016 Maroun Abi Ramia. All rights reserved.
//

#import "Coin.h"

@implementation Coin

- (instancetype)initWithPosition:(CGPoint)po{
    if (self = [super initWithImageNamed:@"coin.png"]){
        self.position = po;
        [self set_up_coin_properties];
        [self setScale:0.5];
    }
    return self;
}

- (void)set_up_coin_properties{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    self.physicsBody.categoryBitMask = BSPhysicsCategoryCoin;
    self.physicsBody.collisionBitMask = BSPhysicsCategoryPlayer;
    self.physicsBody.contactTestBitMask = BSPhysicsCategoryPlayer;
    self.physicsBody.usesPreciseCollisionDetection = YES;
}


- (void)coin_remove{
    NSString *burstPath =
    [[NSBundle mainBundle]
     pathForResource:@"Explosion" ofType:@"sks"];
    SKEmitterNode *explode = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    explode.position = CGPointMake(0, 0);
    [self addChild:explode];
    
    SKAction *fadeIn = [SKAction fadeOutWithDuration:0.5];
    SKAction *scaleIn = [SKAction scaleTo:0 duration:0.6];
    SKAction *sequence  = [SKAction sequence:@[scaleIn, fadeIn]];
    [self runAction:sequence completion:^{
        [self removeFromParent];
    }];
}

@end
