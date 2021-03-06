//
//  Creature.m
//  GameOfLife
//
//  Created by Johnny Chen on 6/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Creature.h"

@implementation Creature
//self is that specific instance of the class
//instancetype and id are the same
- (instancetype)initCreature {
    // since we made Creature inherit from CCSprite, 'super' below refers to CCSprite
    //standard is self = [super init]
    self = [super initWithImageNamed:@"GameOfLifeAssets/Assets/bubble.png"];
    
    if (self) {
        self.isAlive = NO;
    }
    //or else self is nil
    //safety precaution
    
    return self;
}
/*
//getter
//self.isAlive = YES;
//[self setIsAlive: YES];
- (BOOL)isALive{
    return _isAlive;
}
//setter
- (void)setIsAlive{
    _isAlive = newState;
}
*/
- (void)setIsAlive:(BOOL)newState {
    //when you create an @property as we did in the .h, an instance variable with a leading underscore is automatically created for you
    _isAlive = newState;
    
    // 'visible' is a property of any class that inherits from CCNode. CCSprite is a subclass of CCNode, and Creature is a subclass of CCSprite, so Creatures have a visible property
    self.visible = _isAlive;
    
    //[self setVisible:_isAlive]
    
    /*
    Method/dot syntax vs variablename
    BOOL currentvisible;
    currentvisible = [self visible];
    currentvisible = self.visible;
    */
}

@end
