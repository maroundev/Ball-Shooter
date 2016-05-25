//
//  Player.m
//  Ball Shooter
//
//  Created by Maroun Abi Ramia on 1/15/16.
//  Copyright © 2016 Maroun Abi Ramia. All rights reserved.
//

#import "Player.h"

@implementation Player{
    SKEmitterNode *trail;
    
    // Player Tutorial Var
    SKSpriteNode *left;
    SKSpriteNode *right;
    SKSpriteNode *arrow;
    SKLabelNode *targetText;
    SKLabelNode *tut;
}

- (instancetype)initWithPosition:(CGPoint)position imageName:(NSString *)image andSize:(float)sizePassed{
    if (self = [super initWithImageNamed:image]){
        self.position = position;
        [self setScale:sizePassed];
        [self set_up_player];
    }
    return self;
}

- (void)set_up_player{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    self.color = color;

    self.colorBlendFactor = 1;
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
    self.physicsBody.categoryBitMask = BSPhysicsCategoryPlayer;
    self.physicsBody.collisionBitMask  = (BSPhysicsCategoryWall | BSPhysicsCategoryNextPlayer | BSPhysicsCategoryCoin);
    self.physicsBody.contactTestBitMask  = (BSPhysicsCategoryWall | BSPhysicsCategoryNextPlayer | BSPhysicsCategoryCoin);
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsBody.restitution = 0;
    
}

- (void)showPlayerTrail{
    NSString *burstPath =
    [[NSBundle mainBundle]
     pathForResource:@"Trail" ofType:@"sks"];
    trail = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    trail.position = CGPointMake(0, 0);
    [self addChild:trail];
}

- (void)removeTrail{
    [trail removeFromParent];
}

- (void)removePlayerWithAnimation:(BOOL)animate{
    if (animate) {
    NSString *burstPath =
    [[NSBundle mainBundle]
     pathForResource:@"Explosion" ofType:@"sks"];
    SKEmitterNode *explode = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
    explode.position = CGPointMake(0, 0);
    [self addChild:explode];

    SKAction *fadeIn = [SKAction fadeOutWithDuration:0.2];
    SKAction *scaleIn = [SKAction scaleTo:0 duration:0.3];
    SKAction *sequence  = [SKAction sequence:@[scaleIn, fadeIn]];
    [self runAction:sequence completion:^{
        [self removeFromParent];
    }];
    }else{
        [self removeFromParent];
    }
}

- (void)show_player_tutorial{
    left = [SKSpriteNode spriteNodeWithImageNamed:@"right.png"];
    left.position = CGPointMake(-left.size.width *2, 0);
    left.color = [UIColor colorWithRed:227.0/255.0 green:75.0/255.0 blue:80.0/255.0 alpha:1.0];
    left.colorBlendFactor = 1;
    [self addChild:left];
    
    right = [SKSpriteNode spriteNodeWithImageNamed:@"left.png"];
    right.position = CGPointMake(right.size.width*2, 0);
    right.color = [UIColor colorWithRed:227.0/255.0 green:75.0/255.0 blue:80.0/255.0 alpha:1.0];
    right.colorBlendFactor = 1;
    [self addChild:right];
 
    tut = [SKLabelNode labelNodeWithFontNamed:FONT_TYPE];
    tut.text = @"Tap to shoot";
    tut.position = CGPointMake(0, - tut.frame.size.height*2);
    [self addChild:tut];
    
    SKAction *fadeIn = [SKAction fadeOutWithDuration:0.4];
    SKAction *fadeOut = [SKAction fadeInWithDuration:0.4];
    SKAction *sequence  = [SKAction sequence:@[fadeIn, fadeOut]];
    [tut runAction:[SKAction repeatActionForever:sequence]];
    [left runAction:[SKAction repeatActionForever:sequence]];
    [right runAction:[SKAction repeatActionForever:sequence]];

}

- (void)show_hit_target_tut{
   
    arrow = [ SKSpriteNode spriteNodeWithImageNamed:@"left.png"];
    arrow.position = CGPointMake(arrow.size.width, 0);
    arrow.color = [UIColor colorWithRed:227.0/255.0 green:75.0/255.0 blue:80.0/255.0 alpha:1.0];
    arrow.colorBlendFactor = 1;
    [self addChild:arrow];
    
    targetText = [SKLabelNode labelNodeWithFontNamed:FONT_TYPE];
    targetText.fontColor = [SKColor whiteColor];
    targetText.fontSize = 16;
    targetText.text = @"HIT TARGET";
    targetText.position = CGPointMake(targetText.frame.size.width - arrow.size.width/2, -8);
    [self addChild:targetText];
    
    SKAction *fadeIn = [SKAction fadeOutWithDuration:0.4];
    SKAction *fadeOut = [SKAction fadeInWithDuration:0.4];
    SKAction *sequence  = [SKAction sequence:@[fadeIn, fadeOut]];
    [arrow runAction:[SKAction repeatActionForever:sequence]];
    [targetText runAction:[SKAction repeatActionForever:sequence]];
}

- (void)remove_hit_target_tut{
    [arrow removeFromParent];
    [targetText removeFromParent];
}

- (void)remove_player_tutorial{
    if (tut != nil){
        [left removeFromParent];
        [left removeAllActions];
        [right removeFromParent];
        [right removeAllActions];
        [tut removeFromParent];
        [tut removeAllActions];
    }
}

- (void)update:(NSTimeInterval)currentTime{

}

@end
