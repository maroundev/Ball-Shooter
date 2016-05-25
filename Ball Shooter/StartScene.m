//
//  StartScene.m
//  Ball Shooter
//
//  Created by Maroun Abi Ramia on 1/13/16.
//  Copyright © 2016 Maroun Abi Ramia. All rights reserved.
//

#import "StartScene.h"

@implementation StartScene{
    SKSpriteNode *play_btn;
    SKSpriteNode *stats_btn;
    SKSpriteNode *rate_btn;
    SKSpriteNode *twitter_btn;
    SKSpriteNode *reward_btn;
    SKLabelNode *highLabel;
    
    UIColor *_gameColor;
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [self set_up_environment];
        [self scoreboard_createWithCurrentScore:NO];
    }
    return self;
}

- (instancetype)initWithSize:(CGSize)size andScore:(int)score{
    if ([self initWithSize:size]) {
        _score = score;
        [self scoreboard_createWithCurrentScore:YES];
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if ([play_btn containsPoint:location]) {
            [self presentGameScene];
        }else if ([stats_btn containsPoint:location]){
            [self showGameCenterLeaderboards];
        }else if ([rate_btn containsPoint:location]){
            [self rate_game];
        }else if ([twitter_btn containsPoint:location]) {
            [self twitter_share];
        }else if ([reward_btn containsPoint:location]){
            [self reward_screen];
        }
    }
}

- (void)set_up_environment{
    [self check_game_center_acheivements];
    [self title_create];
    [self play_btn_create];
    [self etc_btn_create];
    [self background_make];
    [self coin_label_make];
}

- (void)coin_label_make{
    SKSpriteNode *coinLabel = [SKSpriteNode spriteNodeWithImageNamed:@"coin.png"];
    coinLabel.position = CGPointMake(20, CGRectGetHeight(self.frame) - coinLabel.size.height/2);
    [coinLabel setScale:0.5];
    [self addChild:coinLabel];
    
    SKLabelNode *la = [SKLabelNode labelNodeWithFontNamed:FONT_TYPE];
    la.position = CGPointMake(coinLabel.frame.origin.x + 50, CGRectGetHeight(self.frame) - 40);
    la.text = [NSString stringWithFormat:@" %ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:COIN_KEY]];
    la.fontColor = [SKColor brownColor];
    la.fontSize = 16;
    la.zPosition = 1;
    [self addChild:la];
}

- (void)background_make{
        float r = arc4random_uniform(248.0) + 200.0;
    self.backgroundColor = [UIColor colorWithRed:126.0/255 green:192.0/255 blue:r/255 alpha:1];
    SKSpriteNode *clouds = [SKSpriteNode spriteNodeWithImageNamed:@"cloud.png"];
    clouds.position = CGPointMake(clouds.size.width/2 + 50, CGRectGetHeight(self.frame) - clouds.size.height/2);
    //[self addChild:clouds];
    SKSpriteNode *sun = [SKSpriteNode spriteNodeWithImageNamed:@"sun.png"];
    sun.position = CGPointMake(CGRectGetWidth(self.frame) - sun.size.width/2 - 50, CGRectGetHeight(self.frame) - sun.size.height/2);
    //[self addChild:sun];
    _gameColor = [UIColor colorWithRed:227.0/255.0 green:75.0/255.0 blue:80.0/255.0 alpha:1.0];

    SKSpriteNode *mountains = [SKSpriteNode spriteNodeWithImageNamed:@"mountain.png"];
    mountains.position = CGPointMake(CGRectGetWidth(self.frame)/2, 70);
    mountains.zPosition = -1;
    [self addChild:mountains];
}

- (void)title_create{
    SKLabelNode *title_label = [SKLabelNode labelNodeWithFontNamed:FONT_TYPE];
    title_label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + CGRectGetMidY(self.frame)/2);
    title_label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    title_label.fontColor = [SKColor whiteColor];
    title_label.colorBlendFactor = 0;
    title_label.fontSize = 42;
    title_label.text = @"Ball Shooter";
    title_label.name = @"title label";
    [self addChild:title_label];
}

- (void)presentGameScene{
    [self runAction:[SKAction playSoundFileNamed:@"blop.mp3" waitForCompletion:NO]];
    GameScene *scene = [[GameScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:scene transition:transition];

}

- (void)showGameCenterLeaderboards{
    [self pressedButtonSound];

    if ([[GameCenterManager sharedManager] isGameCenterAvailable]) {
        [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self.view.window.rootViewController];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game Center" message:@"Game center not logged in." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionOk];
        [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)twitter_share{
    [self pressedButtonSound];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *msg = [NSString stringWithFormat:@"Download Ball Shooter - boost! My best score is %ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:SCORE_KEY]];
        [tweetSheet setInitialText:msg];
        [self.view.window.rootViewController presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (void)reward_screen{
    [self pressedButtonSound];
    [[GameCenterManager sharedManager] presentAchievementsOnViewController:self.view.window.rootViewController];
}

- (void)rate_game{
    [self pressedButtonSound];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_URL_PATH]];
}

- (void)pressedButtonSound{
    [self runAction:[SKAction playSoundFileNamed:@"blop.mp3" waitForCompletion:NO]];
}

- (void)scoreboard_createWithCurrentScore:(BOOL)showScore{
    if (highLabel != nil) [highLabel removeFromParent];
    [self scoreboard_make];

    if (showScore){
        [self show_current_score];
        [self show_game_over];
    }
    highLabel = [SKLabelNode labelNodeWithFontNamed:FONT_TYPE];
    highLabel.fontSize = 28;

    if ([[NSUserDefaults standardUserDefaults] integerForKey:SCORE_KEY] < _score) {
        [highLabel removeFromParent];
        highLabel.position = CGPointMake(0, CGRectGetMidY(self.frame) + 40);
        
        [[NSUserDefaults standardUserDefaults] setInteger:_score forKey:SCORE_KEY];
        SKAction *fadeIn = [SKAction fadeOutWithDuration:0.3];
        SKAction *fadeOut = [SKAction fadeInWithDuration:0.3];
        SKAction *sqnce = [SKAction sequence:@[fadeIn, fadeOut]];
        SKAction *rept = [SKAction repeatActionForever:sqnce];
        [highLabel runAction:rept];
        highLabel.text = [NSString stringWithFormat:@"New Best Score: %d", _score];
        highLabel.fontColor = _gameColor;
        highLabel.text = @"New Best Score: 103";

        [[GameCenterManager sharedManager] saveAndReportScore:_score leaderboard:@"SB" sortOrder:GameCenterSortOrderHighToLow];
        [self check_game_center_acheivements];
        [self addChild:highLabel];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fullad" object:nil];

    }else{
        highLabel.position = CGPointMake(0, CGRectGetMidY(self.frame) + 40);
        highLabel.text = [NSString stringWithFormat:@"Best Score: %ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:SCORE_KEY]];
        highLabel.fontColor = [SKColor whiteColor];
        [self addChild:highLabel];
    }
    [self animateSprite:nil spriteLabel:highLabel speed:0.4];
}

- (void)scoreboard_make{
    SKShapeNode *square = [SKShapeNode shapeNodeWithRect:CGRectMake(-self.size.width, CGRectGetMidY(self.frame) - 30, self.size.width - 20, 160) cornerRadius:0];
    square.alpha = 0.6;
    square.fillColor = [SKColor blackColor];
    square.strokeColor = [SKColor clearColor];
    square.lineWidth = 0;
    [self addChild:square];
    [self animateSprite:square spriteLabel:nil speed:0.2];
    
}

- (void)show_current_score{
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:FONT_TYPE];
    scoreLabel.position = CGPointMake(0, CGRectGetMidY(self.frame));
    scoreLabel.text = [NSString stringWithFormat:@"Score: %d", _score];
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.fontSize = 28;
    [self addChild:scoreLabel];
    
    [self animateSprite:nil spriteLabel:scoreLabel speed:0.5];

}

- (void)show_game_over{
    SKLabelNode *go = [SKLabelNode labelNodeWithFontNamed:FONT_TYPE];
    go.position = CGPointMake(0, CGRectGetMidY(self.frame) + 90);
    go.text = @"Game Over";
    go.fontColor = [SKColor redColor];
    [self addChild:go];
    
    [self animateSprite:nil spriteLabel:go speed:0.3];
}

-(void)animateSprite:(SKNode *)sprite spriteLabel:(SKLabelNode *)label speed:(CGFloat)speed{
    if (label) {
        SKAction *action = [SKAction moveByX:CGRectGetMidX(self.frame) y:0.0 duration:speed];
        [label runAction:action];
    }else{
        SKAction *action = [SKAction moveByX:CGRectGetMaxX(self.frame) + 10.0 y:0.0 duration:speed];
        [sprite runAction:action];
    }
}
#pragma mark Action Button Implementation

- (void)play_btn_create{
    play_btn = [SKSpriteNode spriteNodeWithImageNamed:@"play_btn.png"];
    [play_btn setScale:0.2];
    play_btn.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetMidY(self.frame)) - play_btn.frame.size.height + 20);
    [self addChild:play_btn];
}

- (void)etc_btn_create{
    float offset = 2.0;
    if (IS_IPAD) offset = 1.3;
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) offset = 2.5;
    
    stats_btn = [SKSpriteNode spriteNodeWithImageNamed:@"stats_btn.png"];
    stats_btn.position = CGPointMake((CGRectGetMidX(self.frame)/offset), (CGRectGetMidY(self.frame)/2) - stats_btn.frame.size.height/16);
    [stats_btn setScale:0.5];
    [self addChild:stats_btn];
    
    rate_btn = [SKSpriteNode spriteNodeWithImageNamed:@"rate_btn.png"];
    rate_btn.position = CGPointMake((CGRectGetMidX(self.frame)/offset) + rate_btn.frame.size.width/2, (CGRectGetMidY(self.frame)/2) - rate_btn.frame.size.height/16);
    [rate_btn setScale:0.5];
    [self addChild:rate_btn];
    
    twitter_btn = [SKSpriteNode spriteNodeWithImageNamed:@"twitter_btn.png"];
    twitter_btn.position = CGPointMake((CGRectGetMidX(self.frame)/offset) + twitter_btn.frame.size.width, (CGRectGetMidY(self.frame)/2) - twitter_btn.frame.size.height/16);
    [twitter_btn setScale:0.5];
    [self addChild:twitter_btn];
    
    reward_btn = [SKSpriteNode spriteNodeWithImageNamed:@"reward_btn.png"];
    float muteOffSet =  (reward_btn.frame.size.width) + ( reward_btn.frame.size.width/1.4);
    reward_btn.position = CGPointMake((CGRectGetMidX(self.frame)/offset) + muteOffSet, - 2 + (self.size.height/4) - reward_btn.frame.size.height/16);
    [reward_btn setScale:0.5];
    [self addChild:reward_btn];
}

- (void)check_game_center_acheivements{
    float percentComplete = 100.0;
    [[GameCenterManager sharedManager] saveAndReportAchievement:@"SB.1" percentComplete:percentComplete shouldDisplayNotification:YES];
    
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:SCORE_KEY]) {
        case 10:
            percentComplete = 10;
            [[GameCenterManager sharedManager] saveAndReportAchievement:@"SB.2" percentComplete:percentComplete+90 shouldDisplayNotification:YES];

            break;
        case 20:
            percentComplete = 20;
            [[GameCenterManager sharedManager] saveAndReportAchievement:@"SB.3" percentComplete:percentComplete+80 shouldDisplayNotification:YES];

            break;
        case 30:
            percentComplete = 30;
            [[GameCenterManager sharedManager] saveAndReportAchievement:@"SB.4" percentComplete:percentComplete+70 shouldDisplayNotification:YES];

            break;
        default:
            break;
    }
    
}

@end
