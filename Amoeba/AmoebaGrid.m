//
//  AmoebaGrid.m
//  Amoeba
//
//  Created by Ryan Oaks on 6/26/11.
//  Copyright 2011 Gov. All rights reserved.
//

#import "AmoebaGrid.h"
#import "DebugConfig.h"

@implementation AmoebaGrid

#ifdef DBG
CCLabelTTF *_debugLife[GRID_WIDTH + 2][GRID_HEIGHT + 2];
#endif

BOOL _cumulativeMultiTransfer = NO;
float _cumulativeMultiTransferLife[GRID_WIDTH][GRID_HEIGHT];

BOOL _netMultiTransfer = NO;
float _netMultiTransferLife[GRID_WIDTH][GRID_HEIGHT][3];

- (AmoebaCell *)cellAtX:(int)x y:(int)y {
    if (x >= -1 && x < GRID_WIDTH + 1 && y >= -1 && y < GRID_HEIGHT + 1) {
        return _cells[x + 1][y + 1];
    }
    
    return nil;
}

- (AmoebaCell *)cellAt:(CGPoint)gridPosition {
    return [self cellAtX:(int)gridPosition.x y:(int)gridPosition.y];
}

- (BOOL)isInBounds:(CGPoint)gridPosition {
    return (gridPosition.x >= 0 && gridPosition.x < GRID_WIDTH && gridPosition.y >= 0 && gridPosition.y < GRID_HEIGHT);
}

- (CGPoint)worldToGridPos:(CGPoint)worldPosition {
    float scaleX = _cellWidth * 0.75;
    float scaleY = _cellHeight;
    
    int gridX = ((worldPosition.x - DEBUG_X_OFFSET) / scaleX) + 0.125;
    if (abs(gridX) % 2 == 0) {
        return ccp(gridX, ((worldPosition.y - DEBUG_Y_OFFSET) / scaleY) + 0.5);
    }
    
    return ccp(gridX, (worldPosition.y - DEBUG_Y_OFFSET) / scaleY);
}

- (id)initWithScreenWidth:(float)screenWidth screenHeight:(float)screenHeight {
    //if ((self = [super initWithColor:ccc4(25,25,25,255)])) { 
    if ((self = [super init])) {
        _cellWidth = (screenWidth / (GRID_WIDTH + 1)) * 1.39;
        // * 1.16 to get the hexagons to be equalateral
        // * 1.2 to account for the width lost from interlocking hexagons
        // 1.16 * 1.2 = 1.39
        _cellHeight = screenHeight / (GRID_HEIGHT - 1);
        
        for (int x = 0; x < GRID_WIDTH + 2; x++) {
            for (int y = 0; y < GRID_HEIGHT + 2; y++) {
                _cells[x][y] = [[AmoebaCell alloc] initWithPosition:ccp(x - 1, y - 1) life:0 width:_cellWidth height:_cellHeight];
                [self addChild: _cells[x][y]];
                [_cells[x][y] setColor:ccc3(255, 0, 255)];
                
#ifdef DBG
                _debugLife[x][y] = [CCLabelTTF labelWithString:@"1" fontName:@"Arial" fontSize:14];
                _debugLife[x][y].position =  _cells[x][y].position;
                _debugLife[x][y].scale = 1;
                [self addChild:_debugLife[x][y]];
#endif
            }
        }
        
        // Set all adjacent cells
        for (int x = -1; x < GRID_WIDTH + 1; x++) {
            for (int y = -1; y < GRID_HEIGHT + 1; y++) {
                if (abs(x) % 2 == 0) {
                    [[self cellAtX:x y:y] setAboveCell:[self cellAtX:x y:y + 1]];
                    [[self cellAtX:x y:y] setBelowCell:[self cellAtX:x y:y - 1]];
                    [[self cellAtX:x y:y] setAboveLeftCell:[self cellAtX:x - 1 y:y]];
                    [[self cellAtX:x y:y] setAboveRightCell:[self cellAtX:x + 1 y:y]];
                    [[self cellAtX:x y:y] setBelowLeftCell:[self cellAtX:x - 1 y:y - 1]];
                    [[self cellAtX:x y:y] setBelowRightCell:[self cellAtX:x + 1 y:y - 1]];
                }
                else {
                    [[self cellAtX:x y:y] setAboveCell:[self cellAtX:x y:y + 1]];
                    [[self cellAtX:x y:y] setBelowCell:[self cellAtX:x y:y - 1]];
                    [[self cellAtX:x y:y] setAboveLeftCell:[self cellAtX:x - 1 y:y + 1]];
                    [[self cellAtX:x y:y] setAboveRightCell:[self cellAtX:x + 1 y:y + 1]];
                    [[self cellAtX:x y:y] setBelowLeftCell:[self cellAtX:x - 1 y:y]];
                    [[self cellAtX:x y:y] setBelowRightCell:[self cellAtX:x + 1 y:y]];
                }
            }
        }
        
        _totalLife = 0;
    }
    
    return self;
}

- (float)cellWidth {
    return _cellWidth;
}

- (float)cellHeight {
    return _cellHeight;
}

- (void)setLife:(float)life at:(CGPoint)gridPosition {
    if ([self isInBounds:gridPosition]) {
        if (_cumulativeMultiTransfer) {
            // Don't need to update total life because it's only transfers in this mode
            _cumulativeMultiTransferLife[(int)gridPosition.x][(int)gridPosition.y] = life;
        }
        else {
            _totalLife -= [[self cellAt:gridPosition] life];
            _totalLife += life;
            
            [[self cellAt:gridPosition] setLife:life];
        }
    }
}

- (void)addLife:(float)life at:(CGPoint)gridPosition {
    if ([self isInBounds:gridPosition]) {
        if (_cumulativeMultiTransfer) {
            // Don't need to update total life because it's only transfers in this mode
            _cumulativeMultiTransferLife[(int)gridPosition.x][(int)gridPosition.y] += life;
        }
        else {
            _totalLife += life;
            
            [[self cellAt:gridPosition] addLife:life];
        }
    }
}

- (void)subLife:(float)life at:(CGPoint)gridPosition {
    if ([self isInBounds:gridPosition]) {
        if (_cumulativeMultiTransfer) {
            // Don't need to update total life because it's only transfers in this mode
            _cumulativeMultiTransferLife[(int)gridPosition.x][(int)gridPosition.y] -= life;
            
            if (_cumulativeMultiTransferLife[(int)gridPosition.x][(int)gridPosition.y] < 0) {
                _cumulativeMultiTransferLife[(int)gridPosition.x][(int)gridPosition.y] = 0;
            }
        }
        else {
            if ([[self cellAt:gridPosition] life] < life) {
                _totalLife -= [[self cellAt:gridPosition] life];
            }
            else {
                _totalLife -= life;
            }
            
            [[self cellAt:gridPosition] subLife:life];
        }
    }
}

//CUMULATIVE TRANSFER

- (void)beginCumulativeMultiTransfer {
    for (int x=0; x < GRID_WIDTH; x++) {
        for (int y=0; y < GRID_HEIGHT; y++) {
            _cumulativeMultiTransferLife[x][y] = [[self cellAt:ccp(x, y)] life];
        }
    }
    
    _cumulativeMultiTransfer = YES;
}

- (void)commitCumulativeMultiTransfer {
    _cumulativeMultiTransfer = NO;
    
    for (int x=0; x < GRID_WIDTH; x++) {
        for (int y=0; y < GRID_HEIGHT; y++) {
            [self setLife:_cumulativeMultiTransferLife[x][y] at:ccp(x, y)];
        }
    }
}

//NET TRANSFER

- (void)beginNetMultiTransfer {
    for (int x=0; x < GRID_WIDTH; x++) {
        for (int y=0; y < GRID_HEIGHT; y++) {
            _netMultiTransferLife[x][y][0] = 0;
            _netMultiTransferLife[x][y][1] = 0;
            _netMultiTransferLife[x][y][2] = 0;
        }
    }
    
    _netMultiTransfer = YES;
}

- (void)commitNetMultiTransfer {
    _netMultiTransfer = NO;
    
    for (int x=0; x < GRID_WIDTH; x++) {
        for (int y=0; y < GRID_HEIGHT; y++) {
            CGPoint gridPosition = ccp(x, y);
            AmoebaCell *cell = [self cellAt:gridPosition];
            
            // MIGHT WANT TO USE SPECIAL CASE IF ALL 3 VALUES ADDED UP IS GREATER THAN LIFE
                // TRANSFER BASED ON PERCENTAGE
            
            if (_netMultiTransferLife[x][y][0] > 0) {
                [self transferLife:_netMultiTransferLife[x][y][0] from:gridPosition to:[[cell belowCell] gridPosition]];
            }
            else if (_netMultiTransferLife[x][y][0] < 0) {
                [self transferLife:(0 - _netMultiTransferLife[x][y][0]) from:gridPosition to:[[cell aboveCell] gridPosition]];
            }
            
            if (_netMultiTransferLife[x][y][1] > 0) {
                [self transferLife:_netMultiTransferLife[x][y][1] from:gridPosition to:[[cell aboveLeftCell] gridPosition]];
            }
            else if (_netMultiTransferLife[x][y][1] < 0) {
                [self transferLife:(0 - _netMultiTransferLife[x][y][1]) from:gridPosition to:[[cell belowRightCell] gridPosition]];
            }
            
            if (_netMultiTransferLife[x][y][2] > 0) {
                [self transferLife:_netMultiTransferLife[x][y][2] from:gridPosition to:[[cell aboveRightCell] gridPosition]];
            }
            else if (_netMultiTransferLife[x][y][2] < 0) {
                [self transferLife:(0 - _netMultiTransferLife[x][y][2]) from:gridPosition to:[[cell belowLeftCell] gridPosition]];
            }
        }
    }
}

// No need to worry about the total life here because the same amount is subtracted and then added to another cell
// REFACTOR!!!!!!!
- (void)transferLife:(float)life from:(CGPoint)srcGridPosition to:(CGPoint)destGridPosition {
    if ([self isInBounds:srcGridPosition] && [self isInBounds:destGridPosition]) {
        float transferLife = 0;
        if (_cumulativeMultiTransfer) {
            transferLife = MIN(life, _cumulativeMultiTransferLife[(int)srcGridPosition.x][(int)srcGridPosition.y]);
            
            [self subLife:transferLife at:srcGridPosition];
            [self addLife:transferLife at:destGridPosition];
        }
        else if (_netMultiTransfer) {
            // Use raw life since if it's too high, it will be averaged out elsewhere
            transferLife = life;
            
            AmoebaCell *srcCell = [self cellAt:srcGridPosition];
            AmoebaCell *destCell = [self cellAt:destGridPosition];
            
            if ([srcCell belowCell] == destCell) {
                _netMultiTransferLife[(int)srcGridPosition.x][(int)srcGridPosition.y][0] += transferLife;
            }
            else if ([srcCell aboveCell] == destCell) {
                _netMultiTransferLife[(int)srcGridPosition.x][(int)srcGridPosition.y][0] -= transferLife;
            }
            else if ([srcCell aboveLeftCell] == destCell) {
                _netMultiTransferLife[(int)srcGridPosition.x][(int)srcGridPosition.y][1] += transferLife;
            }
            else if ([srcCell belowRightCell] == destCell) {
                _netMultiTransferLife[(int)srcGridPosition.x][(int)srcGridPosition.y][1] -= transferLife;
            }
            else if ([srcCell aboveRightCell] == destCell) {
                _netMultiTransferLife[(int)srcGridPosition.x][(int)srcGridPosition.y][2] += transferLife;
            }
            else if ([srcCell belowLeftCell] == destCell) {
                _netMultiTransferLife[(int)srcGridPosition.x][(int)srcGridPosition.y][2] -= transferLife;
            }
        }
        else {
            transferLife = MIN(life, [[self cellAt:srcGridPosition] life]);
            
            [self subLife:transferLife at:srcGridPosition];
            [self addLife:transferLife at:destGridPosition];
        }
    }
}

- (void)disperseCell:(AmoebaCell *)cell life:(float)life {
    if (![cell isAmoebaPresent]) {
        return;
    }
    
    float giveAmount = MIN(life, [cell life]) / (float)(6 - [cell numEdges]);
    
    if ([cell aboveCell] != nil && [[cell aboveCell] isAmoebaPresent]) {
        [self transferLife:giveAmount from:[cell gridPosition] to:[[cell aboveCell] gridPosition]];
    }
    
    if ([cell belowCell] != nil && [[cell belowCell] isAmoebaPresent]) {
        [self transferLife:giveAmount from:[cell gridPosition] to:[[cell belowCell] gridPosition]];
    }
    
    if ([cell aboveLeftCell] != nil && [[cell aboveLeftCell] isAmoebaPresent]) {
        [self transferLife:giveAmount from:[cell gridPosition] to:[[cell aboveLeftCell] gridPosition]];
    }
    
    if ([cell aboveRightCell] != nil && [[cell aboveRightCell] isAmoebaPresent]) {
        [self transferLife:giveAmount from:[cell gridPosition] to:[[cell aboveRightCell] gridPosition]];
    }
    
    if ([cell belowLeftCell] != nil && [[cell belowLeftCell] isAmoebaPresent]) {
        [self transferLife:giveAmount from:[cell gridPosition] to:[[cell belowLeftCell] gridPosition]];
    }
    
    if ([cell belowRightCell] != nil && [[cell belowRightCell] isAmoebaPresent]) {
        [self transferLife:giveAmount from:[cell gridPosition] to:[[cell belowRightCell] gridPosition]];
    }
}

- (float)totalLife {
    return _totalLife;
}

-(void)draw {
#ifdef DBG
    for (int x=0; x < GRID_WIDTH + 2; x++) {
        for (int y=0; y < GRID_HEIGHT + 2; y++) {
            [_debugLife[x][y] setString:[NSString stringWithFormat:@"%d", (int)([_cells[x][y] life])]];
        }
    }
#endif
}

@end
