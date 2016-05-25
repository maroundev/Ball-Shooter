//
//  GameScene.m
//  Ball Shooter
//
//  Created by Maroun Abi Ramia on 1/14/16.
//  Copyright © 2016 Maroun Abi Ramia. All rights reserved.
//

#import "GameScene.h"
#import "Walls.h"

@implementation GameScene{
    SKLabelNode *scoreLabel;
    SKSpriteNode *boostBtn;
    SKLabelNode *boostLabel;
    SKSpriteNode *coinLabel;
    SKLabelNode *coinLabelCount;
    
    Walls *walls;
    int wallCount;
    BOOL gameInProgress;
    long cointCount;
    int score;
    float ballSpeed;

}

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self set_up_environment];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if ([boostBtn containsPoint:location] && !gameInProgress && cointCount >= 5) {
            [self do_player_boost];
        }else if (!gameInProgress){
            [self do_player_action];
        }
    }
}

- (void)update:(NSTimeInterval)currentTime{
    if (cointCount >= 5) {
     [self boost_create];   
    }
}

- (void)set_up_environment{
    [self background_make];
    [self load_coin_count];
    
    gameInProgress = false;
    wallCount = 1;
    ballSpeed = 1400;
    if (IS_IPAD) ballSpeed = 2400;
    
    [self physics_world_init];
    [self make_game_objects];
    [_player show_player_tutorial];
    [_nextPlayer show_hit_target_tut];
 }

- (void)make_game_objects{
    [self player_create];
    [self next_player_create];
    [self wall_create];
    [self scoreLabel_make];
    [self boost_create];
}

- (void)background_make{
    float r = arc4random_uniform(248.0) + 200.0;
    // 238.0
    self.backgroundColor = [UIColor colorWithRed:126.0/255 green:192.0/255 blue:r/255 alpha:1];
}

- (void)load_coin_count{
    cointCount = [[NSUserDefaults standardUserDefaults] integerForKey:COIN_KEY];
    [self coin_label_make];
}

- (void)coin_create{
    _coin = [[Coin alloc]initWithPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + CGRectGetHeight(self.frame)/4)];
    [self addChild:_coin];
}

- (void)coin_label_make{
    coinLabel = [SKSpriteNode spriteNodeWithImageNamed:@"coin.png"];
    coinLabel.position = CGPointMake(20, CGRectGetHeight(self.frame) - coinLabel.size.height/2);
    [coinLabel setScale:0.5];
    [self addChild:coinLabel];
    
    coinLabelCount = [SKLabelNode labelNodeWithFontNamed:FONT_TYPE];
    coinLabelCount.position = CGPointMake(coinLabel.frame.origin.x + 50, CGRectGetHeight(self.frame) - 40);
    coinLabelCount.text = [NSString stringWithFormat:@"%ld", (long)cointCount];
    coinLabelCount.fontColor = [SKColor brownColor];
    coinLabelCount.fontSize = 16;
    coinLabelCount.zPosition = 1;
    [self addChild:coinLabelCount];
}

- (void)player_create{
    CGPoint po = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - CGRectGetMaxY(self.frame)/5);
    _player = [[Player alloc] initWithPosition:po imageName:PLAYER_IMG andSize:1.2];
    _player.color = [SKColor whiteColor];
    [self addChild:_player];
}

- (void)do_player_action{
    [self runAction:[SKAction playSoundFileNamed:@"whoosh.mp3" waitForCompletion:NO]];
    gameInProgress = true;
    
    [_player showPlayerTrail];
    
    _player.physicsBody.velocity = CGVectorMake(0, ballSpeed);
    [_player remove_player_tutorial];
    [_nextPlayer remove_hit_target_tut];
}

- (void)do_player_boost{
    gameInProgress = true;
    [_player showPlayerTrail];
    _player.physicsBody.velocity = CGVectorMake(0, ballSpeed * 2);
    [_player remove_player_tutorial];
    [self removeCoins:5];
    if (cointCount < 5) {
        [boostBtn removeFromParent];
        [boostLabel removeFromParent];
    }
    [coinLabel removeFromParent];
    [coinLabelCount removeFromParent];
    [self coin_label_make];

}

- (void)boost_create{
    if (boostBtn == nil && cointCount >= 5 && score > 1){
        boostBtn = [SKSpriteNode spriteNodeWithImageNamed:@"boost@2x.png"];
        boostBtn.position = CGPointMake(10 + boostBtn.size.width/2, CGRectGetHeight(self.frame)/4);
        [self addChild:boostBtn];
    
        boostLabel = [SKLabelNode labelNodeWithFontNamed:FONT_TYPE];
        boostLabel.position = CGPointMake(10 + boostBtn.size.width/2, CGRectGetHeight(self.frame)/4 - boostBtn.size.height/2 - 14);
        boostLabel.text = @"BOOST";
        boostLabel.fontColor = [SKColor whiteColor];
        boostLabel.fontSize = 14;
        [self addChild:boostLabel];
    }
}

- (void)next_player_create{
    CGPoint po = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + CGRectGetMidY(self.frame)/1.5 );
    
    _nextPlayer = [[Player alloc] initWithPosition:po imageName:PLAYER_IMG andSize:1.4];
    _nextPlayer.physicsBody.categoryBitMask = BSPhysicsCategoryNextPlayer;
    _nextPlayer.physicsBody.contactTestBitMask  = (BSPhysicsCategoryPlayer | BSPhysicsCategoryWall);
    _nextPlayer.physicsBody.collisionBitMask  = (BSPhysicsCategoryPlayer | BSPhysicsCategoryWall);
    [_nextPlayer removeTrail];
    
    [self addChild:_nextPlayer];
}

- (void)wall_create{
    wallCount = 1;
    
    if ((((double)arc4random() / ARC4RANDOM_MAX) > 0.6) && score > 1){
        [self coin_create];
        
        if (_nextPlayer != nil) {
            [_nextPlayer removeFromParent];
        }
    }
    
    if (score >= 5) wallCount = 2;
    if (score >= 10) wallCount = 3;
    if (score >= 15) wallCount = 4;
    if (score >= 20) wallCount = 5;
    if (score >= 25) wallCount = 6;
    
    if ((score >= 30) && ((double)arc4random() / ARC4RANDOM_MAX) > 0.5) {
        wallCount = arc4random_uniform(6) + 3;
    }

    walls = [[Walls alloc] initWithScene:self atCount:wallCount];
}

- (void)physics_world_init{
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
}

- (void)scoreLabel_make{
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:FONT_TYPE];
    score = 0;
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + CGRectGetMidY(self.frame)/1.2);
    scoreLabel.fontColor = [SKColor whiteColor];
    [self addChild:scoreLabel];
}

#pragma mark - Physics Delegate Methods

- (void)didBeginContact:(SKPhysicsContact *)contact{
    uint32_t collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask);
    if (collision == (BSPhysicsCategoryWall | BSPhysicsCategoryPlayer) ){
        // Game Over
        _player.physicsBody.velocity = CGVectorMake(0, 0);
        [self present_game_over_scene];
        
    }else if (collision == (BSPhysicsCategoryPlayer | BSPhysicsCategoryNextPlayer) && (collision != BSPhysicsCategoryCoin)){
        // Next round
        [self runAction:[SKAction playSoundFileNamed:@"levelup.wav" waitForCompletion:NO]];
        [_player.physicsBody setVelocity:CGVectorMake(0, 0)];
        [_nextPlayer.physicsBody setVelocity:CGVectorMake(0, 0)];
        [self set_next_round];
        
    }else if (collision == (BSPhysicsCategoryCoin | BSPhysicsCategoryPlayer)){
        
        [self runAction:[SKAction playSoundFileNamed:@"coincollect.wav" waitForCompletion:NO]];

        [_coin coin_remove];
        [coinLabel removeFromParent];
        [coinLabelCount removeFromParent];
        [[NSUserDefaults standardUserDefaults] setInteger:++cointCount forKey:COIN_KEY];
        [self coin_label_make];
        [self set_next_round];

    }
    [_player removeTrail];
}

- (void)show_point_gained{
        SKLabelNode *point = [SKLabelNode labelNodeWithFontNamed:FONT_TYPE];
        point.position = CGPointMake(CGRectGetMidX(self.frame) + 35, CGRectGetMidY(self.frame) + CGRectGetHeight(self.frame)/4);
        point.text = @"+1";
        point.fontColor = [SKColor whiteColor];
        point.fontSize = 12;
        [self addChild:point];
        
        SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:0.8];
        SKAction *moveOut = [SKAction moveByX:5 y:5 duration:0.8];
        SKAction *sequence = [SKAction sequence:@[fadeOut, moveOut]];
        [point runAction:sequence completion:^{
            [point removeFromParent];
        }];
}

- (void)present_game_over_scene{
    [self runAction:[SKAction playSoundFileNamed:@"hitwall.mp3" waitForCompletion:NO]];
        [_player removePlayerWithAnimation:YES];
        
    [self runAction:[SKAction waitForDuration:1.0] completion:^{
            StartScene *scene = [[StartScene alloc] initWithSize:self.size andScore:score];
            SKTransition *transition = [SKTransition fadeWithDuration:0.2];
            [self.view presentScene:scene transition:transition];
        }];
    
}

- (void)set_next_round{
    
    scoreLabel.text = [NSString stringWithFormat:@"%d",++score];
    [self show_point_gained];
    
    [_player removePlayerWithAnimation:NO];
    [_nextPlayer removePlayerWithAnimation:YES];
    [walls remove_walls];

    
    [self player_create];
    [self next_player_create];
    [self wall_create];
    
    gameInProgress = false;
}


- (void)removeCoins:(int)number{
    SKLabelNode *point = [SKLabelNode labelNodeWithFontNamed:FONT_TYPE];
    point.position = CGPointMake(20, CGRectGetHeight(self.frame) - coinLabel.size.height * 2);
    point.text = [NSString stringWithFormat:@"-%d", number];
    point.fontColor = [SKColor redColor];
    point.fontSize = 12;
    [self addChild:point];
    
    cointCount -= number;
    [[NSUserDefaults standardUserDefaults] setInteger:cointCount forKey:COIN_KEY];

    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:0.8];
    SKAction *moveOut = [SKAction moveByX:5 y:5 duration:0.8];
    SKAction *sequence = [SKAction sequence:@[fadeOut, moveOut]];
    [point runAction:sequence completion:^{
        [point removeFromParent];
    }];
}

@end
