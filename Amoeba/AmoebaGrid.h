//
//  AmoebaGrid.h
//  Amoeba
//
//  Created by Ryan Oaks on 6/26/11.
//  Copyright 2011 Gov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AmoebaCell.h"
#import "Enemy.h"

#define GRID_WIDTH 36
#define GRID_HEIGHT 21

@interface AmoebaGrid : CCLayerColor {
    AmoebaCell *_cells[GRID_WIDTH + 2][GRID_HEIGHT + 2];
    float _cellWidth;
    float _cellHeight;
    float _totalLife;
}

- (id)initWithScreenWidth:(float)screenWidth screenHeight:(float)screenHeight;

- (float)cellWidth;
- (float)cellHeight;

- (AmoebaCell *)cellAt:(CGPoint)gridPosition;
- (AmoebaCell *)cellAtX:(int)x y:(int)y;
- (BOOL)isInBounds:(CGPoint)gridPosition;

- (CGPoint)worldToGridPos:(CGPoint)worldPosition;

- (void)setLife:(float)life at:(CGPoint)gridPosition;
- (void)addLife:(float)life at:(CGPoint)gridPosition;
- (void)subLife:(float)life at:(CGPoint)gridPosition;
- (void)beginCumulativeMultiTransfer;
- (void)commitCumulativeMultiTransfer;
- (void)beginNetMultiTransfer;
- (void)commitNetMultiTransfer;
- (void)transferLife:(float)life from:(CGPoint)srcGridPosition to:(CGPoint)destGridPosition;
- (void)disperseCell:(AmoebaCell *)cell life:(float)life;

- (float)totalLife;

@end
