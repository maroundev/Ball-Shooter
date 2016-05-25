//
//  Wall.m
//  Ball Shooter
//
//  Created by Maroun Abi Ramia on 1/15/16.
//  Copyright © 2016 Maroun Abi Ramia. All rights reserved.
//

#import "Wall.h"

@implementation Wall
- (instancetype)initWithImageNamed:(NSString *)name andPosition:(CGPoint)position{
    if (self = [super initWithImageNamed:name]) {
        self.position = position;
        [self set_up_wall];

    }
    return self;
}

- (void)set_up_wall{
    
    self.color = [SKColor redColor];    
    self.colorBlendFactor = 1;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height)];
    self.physicsBody.mass = 30;
    self.physicsBody.categoryBitMask = BSPhysicsCategoryWall;
    self.physicsBody.collisionBitMask = BSPhysicsCategoryPlayer | BSPhysicsCategoryNextPlayer;
    self.physicsBody.contactTestBitMask = BSPhysicsCategoryPlayer | BSPhysicsCategoryNextPlayer;
    self.physicsBody.usesPreciseCollisionDetection = YES;
}

- (void)move_wallsToTheLeft:(BOOL)leftDirection atSpeed:(float)speedDuration{
    int x = - self.size.width/1.1;
    if (leftDirection) {
        x = self.size.width/1.1;
    }
    
    float speed = speedDuration;
    SKAction *move = [SKAction moveBy:CGVectorMake(x, 0) duration:speed];
    SKAction *move2 = [SKAction moveBy:CGVectorMake(-x, 0) duration:speed];
    SKAction *sequence  = [SKAction sequence:@[move2, move, move, move2]];
    SKAction *repeatSequence = [SKAction repeatActionForever:sequence];
    [self runAction:repeatSequence];
}

- (void)remove_wall{
    [self removeFromParent];
}
@end
