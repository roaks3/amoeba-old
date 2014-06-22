//
//  Amoeba.m
//  Amoeba
//
//  Created by Ryan Oaks on 9/4/11.
//  Copyright 2011 Gov. All rights reserved.
//

#import "Amoeba.h"

@implementation Amoeba

const int ENEMY_LIFE_GAIN = 150;
const int ENEMY_LIFE_GAIN_OUTER = 50;

ccTime _updateTime = 0;

float _screenWidth;
float _screenHeight;

- (void)initAmoebaLife {
    int startingLifeGrid[] = {
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 50, 50, 50,100,100,150,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 50,250,250, 50, 50, 50,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,250,200,250,250,200,200,150, 50,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,250,200,200,200,100,100,150, 50,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,100,200,150,150,150, 50, 50, 50,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,150,250,200,150, 50, 50, 50,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 
    };
    
    for (int x = 0; x < GRID_WIDTH; x++) {
        for (int y = 0; y < GRID_HEIGHT; y++) {
            [_grid setLife:startingLifeGrid[x + (y * GRID_WIDTH)] at:ccp(x, y)];
        }
    }
}

- (id)initWithScreenWidth:(float)screenWidth screenHeight:(float)screenHeight {
    if ((self = [super init])) {
        _screenWidth = screenWidth;
        _screenHeight = screenHeight;
        
        _grid = [[AmoebaGrid alloc] initWithScreenWidth:_screenWidth screenHeight:_screenHeight];
        [self addChild:_grid];
        
        //_color = ccc3(100, 0, 100);
        //_color = ccc3(255, 0, 255);
        
        [self initAmoebaLife];
    }
    
    return self;
}

- (BOOL)isTouching:(Enemy *)enemy {
    //think i want these to be on the small side
    int cellWidth = (int)[_grid cellWidth];
    int cellHeight = (int)[_grid cellHeight];
    
    /*float minX = [enemy collisionBox].origin.x;
    float minY = [enemy collisionBox].origin.y;
    float maxX = minX + [enemy collisionBox].size.width;
    float maxY = minY + [enemy collisionBox].size.height;*/
    
    float minX = [enemy collisionBox].origin.x - cellWidth;
    float minY = [enemy collisionBox].origin.y - cellHeight;
    float maxX = minX + [enemy collisionBox].size.width + (2 * cellWidth);
    float maxY = minY + [enemy collisionBox].size.height + (2 * cellHeight);
    
    for (float x = minX; x <= maxX; x += cellWidth) {
        for (float y = minY; y <= maxY; y += cellHeight) {
            CGPoint gridPos = [_grid worldToGridPos:ccp(x, y)];
            if ([[_grid cellAt:gridPos] isAmoebaPresent]) {
                return YES;
            }
        }
    }
    
    return NO;
    
    //return [[_grid cellAt:[_grid worldToGridPos:enemy.position]] isAdjacentToAmoeba];
}

- (void)onHit:(Enemy *)enemy forDuration:(ccTime)dt {
    if (enemy != nil) {
        /*CGPoint enemyGamePosition = [_grid worldToGridPos:enemy.position];
        AmoebaCell *enemyCell = [_grid cellAt:enemyGamePosition];
        
        [_grid setLife:0 at:enemyGamePosition];
        
        [_grid subLife:ENEMY_LIFE_DAMAGE at:[[enemyCell aboveCell] gridPosition]];
        [_grid subLife:ENEMY_LIFE_DAMAGE at:[[enemyCell aboveLeftCell] gridPosition]];
        [_grid subLife:ENEMY_LIFE_DAMAGE at:[[enemyCell aboveRightCell] gridPosition]];
        [_grid subLife:ENEMY_LIFE_DAMAGE at:[[enemyCell belowCell] gridPosition]];
        [_grid subLife:ENEMY_LIFE_DAMAGE at:[[enemyCell belowLeftCell] gridPosition]];
        [_grid subLife:ENEMY_LIFE_DAMAGE at:[[enemyCell belowRightCell] gridPosition]];*/
        
        //think i want these to be on the small side
        int cellWidth = (int)[_grid cellWidth];
        int cellHeight = (int)[_grid cellHeight];
        
        float minX = [enemy collisionBox].origin.x;
        float minY = [enemy collisionBox].origin.y;
        float maxX = minX + [enemy collisionBox].size.width;
        float maxY = minY + [enemy collisionBox].size.height;
        
        for (float x = minX; x <= maxX; x += cellWidth) {
            for (float y = minY; y <= maxY; y += cellHeight) {
                CGPoint gridPos = [_grid worldToGridPos:ccp(x, y)];
                [[_grid cellAt:gridPos] setLife:0];
            }
        }
        
        float minXDot = [enemy collisionBox].origin.x - cellWidth;
        float minYDot = [enemy collisionBox].origin.y - cellHeight;
        float maxXDot = minXDot + [enemy collisionBox].size.width + (2 * cellWidth);
        float maxYDot = minYDot + [enemy collisionBox].size.height + (2 * cellHeight);
        
        for (float x = minXDot; x <= maxXDot; x += cellWidth) {
            for (float y = minYDot; y <= maxYDot; y += cellHeight) {
                CGPoint gridPos = [_grid worldToGridPos:ccp(x, y)];
                [[_grid cellAt:gridPos] subLife:([enemy damagePerSecond] * dt)];
            }
        }
    }
}

// Changed this so trampling enemies wasn't so easy, but it looks weird to have enemies alive on top of amoeba
// Will probably need to be fixed by enemies taking up more space, which will have to happen at some point anyway
- (BOOL)isSurrounding:(Enemy *)enemy {
    CGPoint enemyGamePosition = [_grid worldToGridPos:enemy.position];
    if ([_grid isInBounds:enemyGamePosition]) {
        //return [[_grid cellAt:enemyGamePosition] enclosedGroup] != -1 && [[_grid cellAt:enemyGamePosition] enclosedGroup] != 0;
        return [[_grid cellAt:enemyGamePosition] enclosedGroup] != 0;
    }
    
    return NO;
}

- (void)onSurround:(Enemy *)enemy {
    CGPoint enemyGamePosition = [_grid worldToGridPos:enemy.position];
    if ([_grid isInBounds:enemyGamePosition]) {
        AmoebaCell *enemyCell = [_grid cellAt:enemyGamePosition];
        
        [_grid addLife:ENEMY_LIFE_GAIN at:enemyGamePosition];
        
        [_grid addLife:ENEMY_LIFE_GAIN_OUTER at:[[enemyCell aboveCell] gridPosition]];
        [_grid addLife:ENEMY_LIFE_GAIN_OUTER at:[[enemyCell aboveLeftCell] gridPosition]];
        [_grid addLife:ENEMY_LIFE_GAIN_OUTER at:[[enemyCell aboveRightCell] gridPosition]];
        [_grid addLife:ENEMY_LIFE_GAIN_OUTER at:[[enemyCell belowCell] gridPosition]];
        [_grid addLife:ENEMY_LIFE_GAIN_OUTER at:[[enemyCell belowLeftCell] gridPosition]];
        [_grid addLife:ENEMY_LIFE_GAIN_OUTER at:[[enemyCell belowRightCell] gridPosition]];
    }
}

- (void)spreadLifeFrom:(CGPoint)prevGridPos to:(CGPoint)curGridPos {
    int transferLife = ceilf(([[_grid cellAt:prevGridPos] life] * 3.0f) / 4.0f);
    [_grid transferLife:transferLife from:prevGridPos to:curGridPos];
}

- (void)spreadLifeAreaFrom:(CGPoint)prevPos to:(CGPoint)curPos {
    CGPoint prevGridPos = [_grid worldToGridPos:prevPos];
    CGPoint curGridPos = [_grid worldToGridPos:curPos];
    
    AmoebaCell *prevCell = [_grid cellAt:prevGridPos];
    AmoebaCell *curCell = [_grid cellAt:curGridPos];
    
    [self spreadLifeFrom:[prevCell gridPosition] to:[curCell gridPosition]];
    [self spreadLifeFrom:[[prevCell aboveCell] gridPosition] to:[[curCell aboveCell] gridPosition]];
    [self spreadLifeFrom:[[prevCell aboveLeftCell] gridPosition] to:[[curCell aboveLeftCell] gridPosition]];
    [self spreadLifeFrom:[[prevCell aboveRightCell] gridPosition] to:[[curCell aboveRightCell] gridPosition]];
    [self spreadLifeFrom:[[prevCell belowCell] gridPosition] to:[[curCell belowCell] gridPosition]];
    [self spreadLifeFrom:[[prevCell belowLeftCell] gridPosition] to:[[curCell belowLeftCell] gridPosition]];
    [self spreadLifeFrom:[[prevCell belowRightCell] gridPosition] to:[[curCell belowRightCell] gridPosition]];
}

/*- (void)condenseAmoebaForDuration:(ccTime)dt {
    if (_allowCondense && dt > 0) {
        int centerX = _screenWidth / 2;
        int centerY = _screenHeight / 2;
        
        [_grid beginMultiTransfer];
        
        for (int x=0; x < GRID_WIDTH; x++) {
            for (int y=0; y < GRID_HEIGHT; y++) {
                AmoebaCell *cell = [_grid cellAtX:x y:y];
                if ([cell life] > 0) {
                    CGPoint toCenter = ccpSub(ccp(centerX, centerY), cell.position);
                    float distToCenter = ccpLength(toCenter);
                    if (distToCenter > 100) {
                        // Using height as the move distance because width is subject to scaling
                        CGPoint moveVector = ccpMult(toCenter, ([_grid cellHeight] / distToCenter));
                        CGPoint destWorldPos = ccpAdd(cell.position, moveVector);
                        CGPoint destGridPos = [_grid worldToGridPos:destWorldPos];
                        
                        //[_grid transferLife:(dt * distToCenter / 125.0) from:[cell gridPosition] to:destGridPos];
                        //[_grid transferLife:(1.5 * dt) from:[cell gridPosition] to:destGridPos];
                        [_grid transferLife:((dt / 30.0) * (5.0)) from:[cell gridPosition] to:destGridPos];
                    }
                }
            }
        }
        
        [_grid commitMultiTransfer];
    }
}*/

- (void)condenseAmoebaForDuration2:(ccTime)dt {
    // Get collection of edge cells
    NSMutableSet *edgeCells = [[NSMutableSet alloc] init];
    for (int x1=0; x1 < GRID_WIDTH; x1++) {
        for (int y1=0; y1 < GRID_HEIGHT; y1++) {
            AmoebaCell *cell = [_grid cellAtX:x1 y:y1];
            if ([cell isEdgeOfAmoeba]) {
                [edgeCells addObject:cell];
            }
        }
    }
    
    if (_allowCondense && dt > 0) {
        for (int x1=0; x1 < GRID_WIDTH; x1++) {
            for (int y1=0; y1 < GRID_HEIGHT; y1++) {
                AmoebaCell *cell = [_grid cellAtX:x1 y:y1];
                // THIS ACTUALLY SEEMS OK, EXCEPT IF THE AMOEBA GETS SPREAD TOO THIN
                // MAYBE ALSO ADD SLIGHT PULL TO THE CENTER?
                if ([cell isEdgeOfAmoeba]) {
                //if ([cell life] > 125) {
                //if ([cell life] > 0) {
                    
                    [_grid beginCumulativeMultiTransfer];
                    
                    for (int x=0; x < GRID_WIDTH; x++) {
                        for (int y=0; y < GRID_HEIGHT; y++) {
                            AmoebaCell *otherCell = [_grid cellAtX:x y:y];
                            //if (cell != otherCell && [otherCell isEdgeOfAmoeba]) {
                            if (cell != otherCell && [otherCell life] > 0) {
                                CGPoint toCell = ccpSub(cell.position, otherCell.position);
                                float distBetween = ccpLength(toCell);
                                if (distBetween < 300) {
                                //if (distBetween > 300) {
                                    // Using height as the move distance because width is subject to scaling
                                    CGPoint moveVector = ccpMult(toCell, ([_grid cellHeight] / distBetween));
                                    CGPoint destWorldPos = ccpAdd(otherCell.position, moveVector);
                                    CGPoint destGridPos = [_grid worldToGridPos:destWorldPos];
                                    
                                    [_grid transferLife:(dt * distBetween * [cell life] * ([cell numEdges] / 3.0/* / [cell numEdges]*/) / (125.0 * 100.0 * 100.0)) from:[otherCell gridPosition] to:destGridPos];
                                    //[_grid transferLife:(1.5 * dt) from:[cell gridPosition] to:destGridPos];
                                    
                                    // EXPERIMENTING WITH NOTICABLE VALUES HERE
                                    //[_grid transferLife:((dt / 30.0) * (1.0 / 10.0)) from:[cell gridPosition] to:destGridPos];
                                }
                            }
                        }
                    }
                    
                    /*for (AmoebaCell *otherCell in edgeCells) {
                        if (cell != otherCell && [otherCell life] > 0) {
                            CGPoint toCell = ccpSub(cell.position, otherCell.position);
                            float distBetween = ccpLength(toCell);
                            if (distBetween > 300) {
                                // Using height as the move distance because width is subject to scaling
                                CGPoint moveVector = ccpMult(toCell, ([_grid cellHeight] / distBetween));
                                CGPoint destWorldPos = ccpAdd(otherCell.position, moveVector);
                                CGPoint destGridPos = [_grid worldToGridPos:destWorldPos];
                                
                                [_grid transferLife:(dt * distBetween * [cell life] / (125.0 * 100.0 * 100.0)) from:[otherCell gridPosition] to:destGridPos];
                                //[_grid transferLife:(1.5 * dt) from:[cell gridPosition] to:destGridPos];
                                
                                // EXPERIMENTING WITH NOTICABLE VALUES HERE
                                //[_grid transferLife:((dt / 30.0) * (1.0 / 10.0)) from:[cell gridPosition] to:destGridPos];
                            }
                        }
                    }*/
                    
                    [_grid commitCumulativeMultiTransfer];
                }
            }
        }
    }
}

// THIS VERSION WILL TRY TO AVERAGE THE TRANSFERS FROM A PARTICULAR CELL
- (void)condenseAmoebaForDuration3:(ccTime)dt {
    // Get collection of edge cells
    NSMutableSet *edgeCells = [[NSMutableSet alloc] init];
    for (int x1=0; x1 < GRID_WIDTH; x1++) {
        for (int y1=0; y1 < GRID_HEIGHT; y1++) {
            AmoebaCell *cell = [_grid cellAtX:x1 y:y1];
            if ([cell isEdgeOfAmoeba]) {
                [edgeCells addObject:cell];
            }
        }
    }
    
    if (_allowCondense && dt > 0) {
        [_grid beginCumulativeMultiTransfer];
        
        for (int x1=0; x1 < GRID_WIDTH; x1++) {
            for (int y1=0; y1 < GRID_HEIGHT; y1++) {
                AmoebaCell *cell = [_grid cellAtX:x1 y:y1];
                // NOW CALCULATE ALL OF THE INFLUENCE ON THIS CELL
                if ([cell isEdgeOfAmoeba]) {
                    //if ([cell life] > 125) {
                    //if ([cell life] > 0) {
                    
                    float top = 0;
                    float topLeft = 0;
                    float topRight = 0;
                    float bottom = 0;
                    float bottomLeft = 0;
                    float bottomRight = 0;
                    
                    for (int x=0; x < GRID_WIDTH; x++) {
                        for (int y=0; y < GRID_HEIGHT; y++) {
                            AmoebaCell *otherCell = [_grid cellAtX:x y:y];
                            if (cell != otherCell && [otherCell isEdgeOfAmoeba]) {
                                //if (cell != otherCell && [otherCell life] > 0) {
                                CGPoint toCell = ccpSub(cell.position, otherCell.position);
                                float distBetween = ccpLength(toCell);
                                if (distBetween < 300) {
                                //if (distBetween > 300) {
                                    // Using height as the move distance because width is subject to scaling
                                    CGPoint moveVector = ccpMult(toCell, ([_grid cellHeight] / distBetween));
                                    CGPoint destWorldPos = ccpAdd(otherCell.position, moveVector);
                                    CGPoint destGridPos = [_grid worldToGridPos:destWorldPos];
                                    
                                    [_grid transferLife:(dt * distBetween * [cell life] * (3.0 / [cell numEdges]) / (125.0 * 100.0 * 100.0)) from:[otherCell gridPosition] to:destGridPos];
                                    //[_grid transferLife:(1.5 * dt) from:[cell gridPosition] to:destGridPos];
                                }
                            }
                        }
                    }
                }
            }
        }
        
        [_grid commitCumulativeMultiTransfer];
    }
}

// THIS VERSION WILL ONLY TRANSFER BASED ON ADJACENT CELLS
- (void)condenseAmoebaForDuration4:(ccTime)dt {
    // Get collection of edge cells
    if (_allowCondense && dt > 0) {
        int centerX = _screenWidth / 2;
        int centerY = _screenHeight / 2;
        
        [_grid beginNetMultiTransfer];
        
        for (int x1=0; x1 < GRID_WIDTH; x1++) {
            for (int y1=0; y1 < GRID_HEIGHT; y1++) {
                AmoebaCell *cell = [_grid cellAtX:x1 y:y1];
                // NOW CALCULATE ALL OF THE INFLUENCE ON THIS CELL
                if ([cell isEdgeOfAmoeba]) {
                    // GOOD
                    //[_grid disperseCell:cell life:dt * ([cell numEdges] / 6.0) * 0.1];
                    
                    [_grid disperseCell:cell life:dt * ([cell numEdges] / 6.0) * 0.1];
                    
                    //[cell giveToAdjacent:dt * ([cell numEdges] / 6.0) * (100.0 / (100.0 + [cell life]))];
                    //[_grid transferLife:(dt * [cell life] * (3.0 / [cell numEdges]) / (125.0 * 100.0 * 100.0)) from:[otherCell gridPosition] to:destGridPos];
                    //[_grid transferLife:(1.5 * dt) from:[cell gridPosition] to:destGridPos];
                    
                    /*CGPoint toCenter = ccpSub(ccp(centerX, centerY), cell.position);
                    float distToCenter = ccpLength(toCenter);
                    if (distToCenter > 100) {
                        // Using height as the move distance because width is subject to scaling
                        CGPoint moveVector = ccpMult(toCenter, ([_grid cellHeight] / distToCenter));
                        CGPoint destWorldPos = ccpAdd(cell.position, moveVector);
                        CGPoint destGridPos = [_grid worldToGridPos:destWorldPos];
                        
                        //[_grid transferLife:(dt * distToCenter / 125.0) from:[cell gridPosition] to:destGridPos];
                        //[_grid transferLife:(1.5 * dt) from:[cell gridPosition] to:destGridPos];
                        [_grid transferLife:(dt / 10.0) from:[cell gridPosition] to:destGridPos];
                    }*/
                }
            }
        }
        
        for (int x1=0; x1 < GRID_WIDTH; x1++) {
            for (int y1=0; y1 < GRID_HEIGHT; y1++) {
                AmoebaCell *cell = [_grid cellAtX:x1 y:y1];
                // NOW CALCULATE ALL OF THE INFLUENCE ON THIS CELL
                if ([cell isAmoebaPresent]) {
                    CGPoint toCenter = ccpSub(ccp(centerX, centerY), cell.position);
                    float distToCenter = ccpLength(toCenter);
                    if (distToCenter > 100) {
                        // Using height as the move distance because width is subject to scaling
                        CGPoint moveVector = ccpMult(toCenter, ([_grid cellHeight] / distToCenter));
                        CGPoint destWorldPos = ccpAdd(cell.position, moveVector);
                        CGPoint destGridPos = [_grid worldToGridPos:destWorldPos];
                        
                        //[_grid transferLife:(dt * distToCenter / 125.0) from:[cell gridPosition] to:destGridPos];
                        //[_grid transferLife:(1.5 * dt) from:[cell gridPosition] to:destGridPos];
                        // GOOD
                        //[_grid transferLife:(dt * ([cell numEdges] / 6.0) * 0.4) from:[cell gridPosition] to:destGridPos];
                        
                        //[_grid transferLife:(dt * ([cell numEdges] / 6.0) * 0.4 * (distToCenter / 100.0)) from:[cell gridPosition] to:destGridPos];
                        
                        //RANDOM TEST
                        [_grid transferLife:(dt * 0.2 * ([cell life] / 10.0)) from:[cell gridPosition] to:destGridPos];
                    }
                }
            }
        }
        
        [_grid commitNetMultiTransfer];
    }
}

// APPEARS TO BE PROBLEMS WITH (1) CELLS USING NET MULTI TRANSFER
- (void)condenseAmoebaForDuration:(ccTime)dt {
    // Get collection of edge cells
    if (_allowCondense && dt > 0) {
        int centerX = _screenWidth / 2;
        int centerY = _screenHeight / 2;
        
        [_grid beginNetMultiTransfer];
        
        for (int x1=0; x1 < GRID_WIDTH; x1++) {
            for (int y1=0; y1 < GRID_HEIGHT; y1++) {
                AmoebaCell *cell = [_grid cellAtX:x1 y:y1];
                // NOW CALCULATE ALL OF THE INFLUENCE ON THIS CELL
                //if ([cell isAmoebaPresent]) {
                if ([cell life] > 0) {
                    if ([cell isEdgeOfAmoeba]) {
                        [_grid disperseCell:cell life:dt * ([cell numEdges] / 6.0) * 0.1];
                        
                        // THIS ONE WOULD BE JUST FOR GETTING RID OF LOOSE CELLS
                        /*if ([cell numEdges] > 3) {
                            [_grid disperseCell:cell life:dt * ([cell numEdges] / 6.0)];
                        }*/
                    }
                    CGPoint toCenter = ccpSub(ccp(centerX, centerY), cell.position);
                    float distToCenter = ccpLength(toCenter);
                    if (distToCenter > 100) {
                        // Using height as the move distance because width is subject to scaling
                        CGPoint moveVector = ccpMult(toCenter, ([_grid cellHeight] / distToCenter));
                        CGPoint destWorldPos = ccpAdd(cell.position, moveVector);
                        CGPoint destGridPos = [_grid worldToGridPos:destWorldPos];
                        
                        //[_grid transferLife:(0.5 * dt) from:[cell gridPosition] to:destGridPos];
                        //[_grid transferLife:(1.5 * dt) from:[cell gridPosition] to:destGridPos];
                        // GOOD
                        //[_grid transferLife:(dt * ([cell numEdges] / 6.0) * 0.4) from:[cell gridPosition] to:destGridPos];
                        
                        //[_grid transferLife:(dt * ([cell numEdges] / 6.0) * 0.4 * (distToCenter / 100.0)) from:[cell gridPosition] to:destGridPos];
                        
                        //RANDOM TEST
                        [_grid transferLife:(dt * 0.2 * ([cell life] / 10.0) * 0.5 * (distToCenter / 100.0)) from:[cell gridPosition] to:destGridPos];
                    }
                }
            }
        }
        
        [_grid commitNetMultiTransfer];
    }
}

- (void)setAllowCondense:(BOOL)allowCondense {
    _allowCondense = allowCondense;
}

- (float)totalLife {
    //return [_grid totalLife];
    float totalLife = 0;
    for (int x=0; x < GRID_WIDTH; x++) {
        for (int y=0; y < GRID_HEIGHT; y++) {
            AmoebaCell *cell = [_grid cellAtX:x y:y];
            totalLife += [cell life];
        }
    }
    
    return totalLife;
}

-(void)changeColor:(int)dc {
    /*if (_color.r <= 0) {
        if (_color.g >= 255) {
            if (_color.b < 255) {
                _color.b += dc;
            }
            else {
                _color.g -= dc;
            }
        }
        else if (_color.g <= 0) {
            _color.r += dc;
        }
        else {
            _color.g -= dc;
        }
    }
    else if (_color.r >= 255) {
        if (_color.g <= 0) {
            if (_color.b > 0) {
                _color.b -= dc;
            }
            else {
                _color.g += dc;
            }
        }
        else if (_color.g >= 255) {
            _color.r -= dc;
        }
        else {
            _color.g += dc;
        }
    }
    else {
        if (_color.g <= 0) {
            _color.r += dc;
        }
        else {
            _color.r -= dc;
        }
    }*/
}

- (void)update:(ccTime)dt {
    for (int x=-1; x < GRID_WIDTH + 1; x++) {
        for (int y=-1; y < GRID_HEIGHT + 1; y++) {
            [[_grid cellAtX:x y:y] resetEnclosedGroup];
        }
    }
    
    int numGroups = 0;
    for (int x=-1; x < GRID_WIDTH + 1; x++) {
        for (int y=-1; y < GRID_HEIGHT + 1; y++) {
            if ([[_grid cellAtX:x y:y] enclosedGroup] == -1) {
                [[_grid cellAtX:x y:y] addToEnclosedGroup:numGroups];
                numGroups++;
            }
        }
    }
}

@end
