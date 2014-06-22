//
//  Enemy.h
//  Amoeba
//
//  Created by Ryan Oaks on 7/6/11.
//  Copyright 2011 Gov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AmoebaCell.h"

@interface Enemy : CCSprite {
    CGRect _collisionBox;
    float _damagePerSecond;
}

- (id)initWithScreenWidth:(float)screenWidth screenHeight:(float)screenHeight;

- (CGRect)collisionBox;
- (float)damagePerSecond;

- (void)update:(ccTime)dt;

@end
