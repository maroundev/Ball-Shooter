//
//  Walls.m
//  Splash Balls
//
//  Created by Maroun Abi Ramia on 1/18/16.
//  Copyright © 2016 Maroun Abi Ramia. All rights reserved.
//

#import "Walls.h"
#import "GameScene.h"

@implementation Walls{
    SKScene *myScene;
    NSMutableArray *walls;
    int numberOfWalls;
}

- (instancetype)initWithScene:(SKScene *)scene atCount:(int)count{
    if (self = [super init]) {
        myScene = (GameScene *)scene;
        walls = [NSMutableArray array];
        numberOfWalls = count;
        [self make_walls];
    }
    return self;
}

- (void)make_walls{
  
    Wall *wl;
    Wall *wr;
    
    NSString *wall_img_url = @"wall.png";
    if (IS_IPAD)
        wall_img_url = @"wallbig.png";
    
    int point = 0;
    int offest = [self determineOffset];
    int speedOffset = 1.7;
    int wallSpeed = arc4random_uniform(speedOffset) + 1.0;
    BOOL leftDirection = [self direction_one];
    
    for (int count = 0; count < numberOfWalls; count++) {
        
        point = [self getWallYCoordinateAtCount:count];
        
//        if (numberOfWalls == 2 && count == 1) offest++;
//        if (numberOfWalls == (3 | 4) && count == (0 | 1)) offest++;
//        if (numberOfWalls == 3 && count == 2) offest += 2;
//        if (numberOfWalls == 4 && count != 3) offest++;
//        if (numberOfWalls > 4 && count > 1) offest += 2;
        
        wl = [[Wall alloc] initWithImageNamed:wall_img_url andPosition:CGPointMake(CGRectGetWidth(myScene.frame)/offest, point)];
        [myScene addChild:wl];
        
        wr = [[Wall alloc] initWithImageNamed:wall_img_url andPosition:CGPointMake(CGRectGetWidth(myScene.frame) - CGRectGetWidth(myScene.frame)/offest, point)];
        [myScene addChild:wr];
        
        [wl move_wallsToTheLeft:leftDirection atSpeed:wallSpeed];
        [wr move_wallsToTheLeft:leftDirection atSpeed:wallSpeed];
        
        if (leftDirection){
            leftDirection = false;
        }else{
            leftDirection = true;
        }
        
        if(numberOfWalls != 1)
        wallSpeed = arc4random_uniform(2.2) + 1.0;
        
        [walls addObject:wr];
        [walls addObject:wl];
    }
    offest = 5;
}

- (float)getWallYCoordinateAtCount:(int)count{
    float yCord = 0.0;
    int offset = 13;
    int added = 40;
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
        added = 30;
    }
    
    if (numberOfWalls <= 2){
        if (count == 0) {
            yCord = [self randYWithWallCount:count];
        }else if (count == 1){
            Wall *tmpWall = walls.firstObject;
            yCord = [self randYWithWallCount:count];

            float difference = tmpWall.frame.origin.y - yCord;
            if (difference >= added){
                [self getWallYCoordinateAtCount:count]; // Recursive
            }
        }
    }
    
    if (numberOfWalls > 2) {
        
        if (count == 0) {
            
            yCord = CGRectGetMidY(myScene.frame) - CGRectGetMaxY(myScene.frame)/offset;
        
        }else if (count == 1){
            
            yCord = CGRectGetMidY(myScene.frame) - (CGRectGetMaxY(myScene.frame)/offset) + (added * count);

        }else if (count == 2){
            
            yCord = CGRectGetMidY(myScene.frame) -  (CGRectGetMaxY(myScene.frame)/offset) + (added * count);

        }else if (count == 3){
        
            yCord = CGRectGetMidY(myScene.frame) -  (CGRectGetMaxY(myScene.frame)/offset) + (added * count);
        
        }else if (count == 4){
        
            yCord = CGRectGetMidY(myScene.frame) -  (CGRectGetMaxY(myScene.frame)/offset) + (added * count);
        
        }else if (count == 5 && !IS_IPHONE_4_OR_LESS){
        
            yCord = CGRectGetMidY(myScene.frame) -  (CGRectGetMaxY(myScene.frame)/offset) + (added * count);
        
        }
        
    }
    
    return yCord;
}

- (void)remove_walls{
    for (int index = 0;  index < [walls count]; index++) {
        [walls[index] remove_wall];
    }
    walls = [NSMutableArray array];
}

- (int)randYWithWallCount:(int)wallCount{
    int yInterval = 0;
    
    if (wallCount == (1)) {
        yInterval = 4;
    }else if (wallCount == 2){
        yInterval = 8;
    }else if (wallCount == 3){
        yInterval = 12;
    }
    
    int lowerBound = (CGRectGetMidY(myScene.frame) - CGRectGetMaxY(myScene.frame)/8);
    lowerBound += 20 + yInterval;
    
    int upperBound = CGRectGetMidY(myScene.frame) + CGRectGetHeight(myScene.frame)/4;
    upperBound -= 40 - yInterval;
    
    int n = upperBound - lowerBound + 1;
    int n1 = arc4random_uniform(n);
    
    return n1 + lowerBound;
}

- (BOOL)direction_one{
    return ((double)arc4random() / ARC4RANDOM_MAX) > 0.5;
}

- (int)determineOffset{
    // 5 6 10 13 29
    int offset = 6;
    
    if (IS_IPHONE_6P) {
        offset = 10;
    }else if (IS_IPHONE_6){
        offset = 11;
    }else if (IS_IPHONE_5){
        offset = 15;
    }else if (IS_IPHONE_4_OR_LESS){
        offset = 18;
    }else if (IS_IPAD){
        offset = 55;
    }
    
    return offset;
}

@end
