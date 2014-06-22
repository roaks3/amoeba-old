//
//  AmoebaCell.h
//  Amoeba
//
//  Created by Ryan Oaks on 6/25/11.
//  Copyright 2011 Gov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface AmoebaCell : CCSprite {
    CGPoint _gridPosition;
    float _life;
    int _enclosedGroup;
    AmoebaCell *_aboveCell;
    AmoebaCell *_belowCell;
    AmoebaCell *_aboveLeftCell;
    AmoebaCell *_aboveRightCell;
    AmoebaCell *_belowLeftCell;
    AmoebaCell *_belowRightCell;
    ccColor3B _color;
}

- (id)initWithPosition:(CGPoint)gridPosition life:(float)life width:(float)cellWidth height:(float)cellHeight;

- (CGPoint)gridPosition;

- (float)life;
- (void)setLife:(float)life;
- (void)addLife:(float)life;
- (void)subLife:(float)life;

- (int)enclosedGroup;
- (void)resetEnclosedGroup;
- (void)addToEnclosedGroup:(int)enclosedGroup;

- (BOOL)isAmoebaPresent;
- (BOOL)isAdjacentToAmoeba;
- (BOOL)isEdgeOfAmoeba;
- (int)numEdges;

- (void)setAboveCell:(AmoebaCell *)aboveCell;
- (void)setBelowCell:(AmoebaCell *)belowCell;
- (void)setAboveLeftCell:(AmoebaCell *)leftCell;
- (void)setAboveRightCell:(AmoebaCell *)rightCell;
- (void)setBelowLeftCell:(AmoebaCell *)leftCell;
- (void)setBelowRightCell:(AmoebaCell *)rightCell;
- (AmoebaCell *)aboveCell;
- (AmoebaCell *)belowCell;
- (AmoebaCell *)aboveLeftCell;
- (AmoebaCell *)aboveRightCell;
- (AmoebaCell *)belowLeftCell;
- (AmoebaCell *)belowRightCell;
//- (AmoebaCell *[])adjacentCells;

- (void)setColor:(ccColor3B)color;
- (int)intensity;

- (void)draw;

@end
