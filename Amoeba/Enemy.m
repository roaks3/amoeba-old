//
//  Enemy.m
//  Amoeba
//
//  Created by Ryan Oaks on 7/6/11.
//  Copyright 2011 Gov. All rights reserved.
//

#import "Enemy.h"
#import "DebugConfig.h"

#define ENEMY_SPRITE_WIDTH 50.0
#define ENEMY_SPRITE_HEIGHT 50.0

#define ENEMY_WIDTH 40.0
#define ENEMY_HEIGHT 40.0

#define ENEMY_SPEED 150


float _screenWidth;
float _screenHeight;

@implementation Enemy

- (void)updateCollisionBox {
    _collisionBox = CGRectMake(self.position.x - (ENEMY_WIDTH / 2), self.position.y - (ENEMY_HEIGHT / 2), ENEMY_WIDTH, ENEMY_HEIGHT);
}

- (id)initWithScreenWidth:(float)screenWidth screenHeight:(float)screenHeight {
    if ((self = [super initWithFile:@"microbes-dec-8-2010-80.png"])) {
		self.scaleX = ENEMY_WIDTH / ENEMY_SPRITE_WIDTH;
        self.scaleY = ENEMY_HEIGHT / ENEMY_SPRITE_HEIGHT;
        
        _screenWidth = screenWidth;
        _screenHeight = screenHeight;
        
        int wall = (int)(CCRANDOM_0_1() * 4.0);
        
        if ( wall == 1 ) {
            self.position = ccp(CCRANDOM_0_1() * _screenWidth + DEBUG_X_OFFSET, -0.1 * _screenHeight + DEBUG_Y_OFFSET);
        }
        else if ( wall == 2 ) {
            self.position = ccp(CCRANDOM_0_1() * _screenWidth + DEBUG_X_OFFSET, 1.1 * _screenHeight + DEBUG_Y_OFFSET);
        }
        else if ( wall == 3 ) {
            self.position = ccp(-0.1 * _screenWidth + DEBUG_X_OFFSET, CCRANDOM_0_1() * _screenHeight + DEBUG_Y_OFFSET);
        }
        else {
            self.position = ccp(1.1 * _screenWidth + DEBUG_X_OFFSET, CCRANDOM_0_1() * _screenHeight + DEBUG_Y_OFFSET);
        }
        
        [self updateCollisionBox];
        
        self.opacity = 255;
        _damagePerSecond = 300;
	}
    
	return self;
}

- (CGRect)collisionBox {
    return _collisionBox;
}

- (float)damagePerSecond {
    return _damagePerSecond;
}

- (void)update:(ccTime)dt {
    int centerX = _screenWidth / 2;
    int centerY = _screenHeight / 2;
    
    // MAKE SURE I DONT HIT MAX INT HERE
    self.rotation += 70 * dt;
    
    if (self.position.x > centerX + 10 || self.position.x < centerX - 10 || self.position.y > centerY + 10 || self.position.y < centerY - 10) {
        CGPoint toCenter = ccpNormalize(ccpSub(ccp(centerX, centerY), self.position));
        self.position = ccp(self.position.x + toCenter.x * dt * ENEMY_SPEED, self.position.y + toCenter.y * dt * ENEMY_SPEED);
        [self updateCollisionBox];
    }
}

@end
