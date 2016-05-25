//
//  Walls.h
//  Splash Balls
//
//  Created by Maroun Abi Ramia on 1/18/16.
//  Copyright © 2016 Maroun Abi Ramia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameHeaders.h"
#import "Wall.h"

@interface Walls : NSObject
- (instancetype)initWithScene:(SKScene *)scene  atCount:(int)count;
- (void)remove_walls;
@end
