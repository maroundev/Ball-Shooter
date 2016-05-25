//
//  Wall.h
//  Splash Balls
//
//  Created by Maroun Abi Ramia on 1/15/16.
//  Copyright © 2016 Maroun Abi Ramia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameHeaders.h"

@interface Wall : SKSpriteNode
- (instancetype)initWithImageNamed:(NSString *)name andPosition:(CGPoint)position;
- (void)move_wallsToTheLeft:(BOOL)leftDirection atSpeed:(float)speedDuration;
- (void)remove_wall;
@end
