//
//  Amoeba.h
//  Amoeba
//
//  Created by Ryan Oaks on 9/4/11.
//  Copyright 2011 Gov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enemy.h"
#import "AmoebaGrid.h"

@interface Amoeba : CCLayer {
    AmoebaGrid *_grid;
    ccColor3B _color;
    BOOL _allowCondense;
}

- (id)initWithScreenWidth:(float)screenWidth screenHeight:(float)screenHeight;

- (BOOL)isTouching:(Enemy *)enemy;
- (void)onHit:(Enemy *)enemy forDuration:(ccTime)dt;
- (BOOL)isSurrounding:(Enemy *)enemy;
- (void)onSurround:(Enemy *)enemy;

- (void)spreadLifeAreaFrom:(CGPoint)prevPos to:(CGPoint)curPos;

- (void)condenseAmoebaForDuration:(ccTime)dt;
- (void)setAllowCondense:(BOOL)allowCondense;

- (float)totalLife;

- (void)update:(ccTime)dt;

@end
