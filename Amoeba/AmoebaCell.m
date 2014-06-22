//
//  AmoebaCell.m
//  Amoeba
//
//  Created by Ryan Oaks on 6/25/11.
//  Copyright 2011 Gov. All rights reserved.
//

#import "AmoebaCell.h"
#import "DebugConfig.h"

#define SPRITE_WIDTH 20
#define SPRITE_HEIGHT 20

@implementation AmoebaCell

- (id)initWithPosition:(CGPoint)gridPosition life:(float)life width:(float)cellWidth height:(float)cellHeight {
	if ((self = [super initWithFile:@"cell0.PNG"])) {
		_gridPosition = gridPosition;
		_life = life;
        _enclosedGroup = -1;
        self.scaleX = cellWidth / SPRITE_WIDTH;
        self.scaleY = cellHeight / SPRITE_HEIGHT;
        
        self.position = ccp((((gridPosition.x * 0.75) + 0.25) * cellWidth) + DEBUG_X_OFFSET, (((gridPosition.y + (0.5 * ((int)abs(gridPosition.x) % 2))) * cellHeight)) + DEBUG_Y_OFFSET);
	}
    
	return self;
}

- (CGPoint)gridPosition {
    return _gridPosition;
}

- (float)life {
    return _life;
}

- (void)setLife:(float)life {
    _life = life;
}

- (void)addLife:(float)life {
    _life += life;
}

- (void)subLife:(float)life {
    _life -= life;
    
    if (_life < 0) {
        _life = 0;
    }
}

- (int)enclosedGroup {
    return _enclosedGroup;
}

- (void)resetEnclosedGroup {
    _enclosedGroup = -1;
}

- (void)addToEnclosedGroup:(int)enclosedGroup {
    _enclosedGroup = enclosedGroup;
    
    if (_aboveCell != nil && ![_aboveCell isAmoebaPresent] && [_aboveCell enclosedGroup] == -1) {
        [_aboveCell addToEnclosedGroup:enclosedGroup];
    }
    
    if (_belowCell != nil && ![_belowCell isAmoebaPresent] && [_belowCell enclosedGroup] == -1) {
        [_belowCell addToEnclosedGroup:enclosedGroup];
    }
    
    if (_aboveLeftCell != nil && ![_aboveLeftCell isAmoebaPresent] && [_aboveLeftCell enclosedGroup] == -1) {
        [_aboveLeftCell addToEnclosedGroup:enclosedGroup];
    }
    
    if (_aboveRightCell != nil && ![_aboveRightCell isAmoebaPresent] && [_aboveRightCell enclosedGroup] == -1) {
        [_aboveRightCell addToEnclosedGroup:enclosedGroup];
    }
    
    if (_belowLeftCell != nil && ![_belowLeftCell isAmoebaPresent] && [_belowLeftCell enclosedGroup] == -1) {
        [_belowLeftCell addToEnclosedGroup:enclosedGroup];
    }
    
    if (_belowRightCell != nil && ![_belowRightCell isAmoebaPresent] && [_belowRightCell enclosedGroup] == -1) {
        [_belowRightCell addToEnclosedGroup:enclosedGroup];
    }
}

- (BOOL)isAmoebaPresent {
    // TO TEST IF I WANT TO DRAW VERY LOW LIFE CELLS AT ALL (OR USE THEM FOR COLLISION)
    return _life >= 2;
    //return _life >= 1;
}

- (BOOL)isAdjacentToAmoeba {
    if ([self isAmoebaPresent]) {
        return YES;
    }
    
    if (_aboveCell != nil && [_aboveCell isAmoebaPresent]) {
        return YES;
    }
    
    if (_belowCell != nil && [_belowCell isAmoebaPresent]) {
        return YES;
    }
    
    if (_aboveLeftCell != nil && [_aboveLeftCell isAmoebaPresent]) {
        return YES;
    }
    
    if (_aboveRightCell != nil && [_aboveRightCell isAmoebaPresent]) {
        return YES;
    }
    
    if (_belowLeftCell != nil && [_belowLeftCell isAmoebaPresent]) {
        return YES;
    }
    
    if (_belowRightCell != nil && [_belowRightCell isAmoebaPresent]) {
        return YES;
    }
    
    return NO;
}

// THIS FUNCTION MAY BE TEMPORARY
- (BOOL)isEdgeOfAmoeba {
    if (![self isAmoebaPresent]) {
        return NO;
    }
    
    if (_aboveCell == nil || ![_aboveCell isAmoebaPresent]) {
        return YES;
    }
    
    if (_belowCell == nil || ![_belowCell isAmoebaPresent]) {
        return YES;
    }
    
    if (_aboveLeftCell == nil || ![_aboveLeftCell isAmoebaPresent]) {
        return YES;
    }
    
    if (_aboveRightCell == nil || ![_aboveRightCell isAmoebaPresent]) {
        return YES;
    }
    
    if (_belowLeftCell == nil || ![_belowLeftCell isAmoebaPresent]) {
        return YES;
    }
    
    if (_belowRightCell == nil || ![_belowRightCell isAmoebaPresent]) {
        return YES;
    }
    
    return NO;
}

- (int)numEdges {
    if (![self isAmoebaPresent]) {
        return 0;
    }
    
    int numEdges = 0;
    if (_aboveCell == nil || ![_aboveCell isAmoebaPresent]) {
        numEdges++;
    }
    
    if (_belowCell == nil || ![_belowCell isAmoebaPresent]) {
        numEdges++;
    }
    
    if (_aboveLeftCell == nil || ![_aboveLeftCell isAmoebaPresent]) {
        numEdges++;
    }
    
    if (_aboveRightCell == nil || ![_aboveRightCell isAmoebaPresent]) {
        numEdges++;
    }
    
    if (_belowLeftCell == nil || ![_belowLeftCell isAmoebaPresent]) {
        numEdges++;
    }
    
    if (_belowRightCell == nil || ![_belowRightCell isAmoebaPresent]) {
        numEdges++;
    }
    
    return numEdges;
}

- (void)setAboveCell:(AmoebaCell *)aboveCell {
    _aboveCell = aboveCell;
}

- (void)setBelowCell:(AmoebaCell *)belowCell {
    _belowCell = belowCell;
}

- (void)setAboveLeftCell:(AmoebaCell *)aboveLeftCell {
    _aboveLeftCell = aboveLeftCell;
}

- (void)setAboveRightCell:(AmoebaCell *)aboveRightCell {
    _aboveRightCell = aboveRightCell;
}

- (void)setBelowLeftCell:(AmoebaCell *)belowLeftCell {
    _belowLeftCell = belowLeftCell;
}

- (void)setBelowRightCell:(AmoebaCell *)belowRightCell {
    _belowRightCell = belowRightCell;
}

- (AmoebaCell *)aboveCell {
    return _aboveCell;
}

- (AmoebaCell *)belowCell {
    return _belowCell;
}

- (AmoebaCell *)aboveLeftCell {
    return _aboveLeftCell;
}

- (AmoebaCell *)aboveRightCell {
    return _aboveRightCell;
}

- (AmoebaCell *)belowLeftCell {
    return _belowLeftCell;
}

- (AmoebaCell *)belowRightCell {
    return _belowRightCell;
}

- (void)setColor:(ccColor3B)color {
    _color = color;
}

- (void)setColor {
    int green = 255;
    int red = 255;
    
    if (_life > 125) {
        red = MIN(255, MAX(0, (255 - _life) * 2));
    }
    else {
        green = MIN(255, MAX(0, _life * 2));
    }
    
    _color = ccc3(red, green, 0);
}

// CHANGE TO STATIC?
- (ccColor3B)colorFadeFrom:(int)intensity1 to:(int)intensity2 and:(int)intensity3 {
    int intensityAvg = MIN(255, (intensity1 + intensity2 + intensity3) / 3.0);
    
    int green = 255;
    int red = 255;
    
    if (intensityAvg > 125) {
        red = MIN(255, MAX(0, (255 - intensityAvg) * 2));
    }
    else {
        green = MIN(255, MAX(0, intensityAvg * 2));
    }
    
    return ccc3(red, green, 0);
}

- (int)intensity {
    if ([self isAmoebaPresent]) {
        //return MAX(50, _life);
        return _life;
    }
    
    return 0;
    
    // MAY WANT TO MAKE THIS A DISCRETE FUNCTION INSTEAD OF CONTINUOUS (BUT STILL BLEND IN DRAW)
    
    //REWRITTEN TO BE DARKER
    /*if ([self isAmoebaPresent]) {
        int intensity = ((int)_life / 2) + 125;
        //intensity = (intensity / 30) * 30;
        return MAX(50, intensity);
        //return _life;
    }
    
    return 0;*/
}

// USE TRIANGLE FAN FROM BOTTOM RIGHT
/*- (void)draw {
    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
    if ([self isAdjacentToAmoeba]) {
        [self setColor];
        int aboveIntensity = 0;
        int belowIntensity = 0;
        int aboveLeftIntensity = 0;
        int aboveRightIntensity = 0;
        int belowLeftIntensity = 0;
        int belowRightIntensity = 0;
        
        // OPACITY VALUES
        int aboveOpacity = 0;
        int belowOpacity = 0;
        int aboveLeftOpacity = 0;
        int aboveRightOpacity = 0;
        int belowLeftOpacity = 0;
        int belowRightOpacity = 0;
        
        if (_aboveCell != nil) {
            aboveIntensity = MIN(255, [_aboveCell intensity]);
            if (aboveIntensity > 0) {
                aboveOpacity = 255;
            }
        }
        
        if (_belowCell != nil) {
            belowIntensity = MIN(255, [_belowCell intensity]);
            if (belowIntensity > 0) {
                belowOpacity = 255;
            }
        }
        
        if (_aboveLeftCell != nil) {
            aboveLeftIntensity = MIN(255, [_aboveLeftCell intensity]);
            if (aboveLeftIntensity > 0) {
                aboveLeftOpacity = 255;
            }
        }
        
        if (_aboveRightCell != nil) {
            aboveRightIntensity = MIN(255, [_aboveRightCell intensity]);
            if (aboveRightIntensity > 0) {
                aboveRightOpacity = 255;
            }
        }
        
        if (_belowLeftCell != nil) {
            belowLeftIntensity = MIN(255, [_belowLeftCell intensity]);
            if (belowLeftIntensity > 0) {
                belowLeftOpacity = 255;
            }
        }
        
        if (_belowRightCell != nil) {
            belowRightIntensity = MIN(255, [_belowRightCell intensity]);
            if (belowRightIntensity > 0) {
                belowRightOpacity = 255;
            }
        }
        
        static const GLfloat vertices[] = {
            SPRITE_WIDTH / 4, 0, 
            (SPRITE_WIDTH * 3) / 4, 0, 
            SPRITE_WIDTH, SPRITE_HEIGHT / 2, 
            (SPRITE_WIDTH * 3) / 4, SPRITE_HEIGHT, 
            SPRITE_WIDTH / 4, SPRITE_HEIGHT, 
            0, SPRITE_HEIGHT / 2
        };
        
        int intensity = MIN(255, [self intensity]);
        
        //int bottomLeftAvg = MIN(255, (belowIntensity + belowLeftIntensity + intensity) / 3.0);
        //int bottomRightAvg = MIN(255, (belowIntensity + belowRightIntensity + intensity) / 3.0);
        //int rightAvg = MIN(255, (belowRightIntensity + aboveRightIntensity + intensity) / 3.0);
        //int topRightAvg = MIN(255, (aboveIntensity + aboveRightIntensity + intensity) / 3.0);
        //int topLeftAvg = MIN(255, (aboveIntensity + aboveLeftIntensity + intensity) / 3.0);
        //int leftAvg = MIN(255, (aboveLeftIntensity + belowLeftIntensity + intensity) / 3.0);
        
        // MAKE MOST CELLS HAVE HIGH OPACITY
        int opac = (intensity > 0) ? 255 : 0;
        int bottomLeftAvg = MIN(255, (belowOpacity + belowLeftOpacity + opac) / 3.0);
        int bottomRightAvg = MIN(255, (belowOpacity + belowRightOpacity + opac) / 3.0);
        int rightAvg = MIN(255, (belowRightOpacity + aboveRightOpacity + opac) / 3.0);
        int topRightAvg = MIN(255, (aboveOpacity + aboveRightOpacity + opac) / 3.0);
        int topLeftAvg = MIN(255, (aboveOpacity + aboveLeftOpacity + opac) / 3.0);
        int leftAvg = MIN(255, (aboveLeftOpacity + belowLeftOpacity + opac) / 3.0);
        
        // HIGHLIGHT HIGH LIFE CELLS
        //if (_life > 200) {
        //    bottomLeftAvg = MIN(255, intensity);
        //    bottomRightAvg = MIN(255, intensity);
        //    rightAvg = MIN(255, intensity);
        //    topRightAvg = MIN(255, intensity);
        //    topLeftAvg = MIN(255, intensity);
        //    leftAvg = MIN(255, intensity);
        //}
        
        // HIGHLIGHT EDGE CELLS
        //if ([self isEdgeOfAmoeba]) {
        //    bottomLeftAvg = 255;
        //    bottomRightAvg = 255;
        //    rightAvg = 255;
        //    topRightAvg = 255;
        //    topLeftAvg = 255;
        //    leftAvg = 255;
        //}
        
        // NO COLOR FADE
        //GLubyte squareColors[] = {
        //    _color.r, _color.g, _color.b, bottomLeftAvg, 
        //    _color.r, _color.g, _color.b, bottomRightAvg, 
        //    _color.r, _color.g, _color.b, rightAvg, 
        //    _color.r, _color.g, _color.b, topRightAvg, 
        //    _color.r, _color.g, _color.b, topLeftAvg, 
        //    _color.r, _color.g, _color.b, leftAvg
        //};
        
        // FADE COLORS
        ccColor3B bottomLeftColor = [self colorFadeFrom:belowIntensity to:belowLeftIntensity and:intensity];
        ccColor3B bottomRightColor = [self colorFadeFrom:belowIntensity to:belowRightIntensity and:intensity];
        ccColor3B rightColor = [self colorFadeFrom:aboveRightIntensity to:belowRightIntensity and:intensity];
        ccColor3B topRightColor = [self colorFadeFrom:aboveRightIntensity to:aboveIntensity and:intensity];
        ccColor3B topLeftColor = [self colorFadeFrom:aboveLeftIntensity to:aboveIntensity and:intensity];
        ccColor3B leftColor = [self colorFadeFrom:aboveLeftIntensity to:belowLeftIntensity and:intensity];
        
        GLubyte squareColors[] = {
            bottomLeftColor.r, bottomLeftColor.g, bottomLeftColor.b, bottomLeftAvg, 
            bottomRightColor.r, bottomRightColor.g, bottomRightColor.b, bottomRightAvg, 
            rightColor.r, rightColor.g, rightColor.b, rightAvg, 
            topRightColor.r, topRightColor.g, topRightColor.b, topRightAvg, 
            topLeftColor.r, topLeftColor.g, topLeftColor.b, topLeftAvg, 
            leftColor.r, leftColor.g, leftColor.b, leftAvg
        };
        
        // NO OPACITY FADE
        //GLubyte squareColors[] = {
        //    bottomLeftColor.r, bottomLeftColor.g, bottomLeftColor.b, 255, 
        //    bottomRightColor.r, bottomRightColor.g, bottomRightColor.b, 255, 
        //    rightColor.r, rightColor.g, rightColor.b, 255, 
        //    topRightColor.r, topRightColor.g, topRightColor.b, 255, 
        //    topLeftColor.r, topLeftColor.g, topLeftColor.b, 255, 
        //    leftColor.r, leftColor.g, leftColor.b, 255
        //};
        
        // HIGH LIFE USES WHITE COLOR
        //int bottomLeftAvg = (belowLife + belowLeftLife + life) / 3.0;
        //int bottomRightAvg = (belowLife + belowRightLife + life) / 3.0;
        //int rightAvg = (belowRightLife + aboveRightLife + life) / 3.0;
        //int topRightAvg = (aboveLife + aboveRightLife + life) / 3.0;
        //int topLeftAvg = (aboveLife + aboveLeftLife + life) / 3.0;
        //int leftAvg = (aboveLeftLife + belowLeftLife + life) / 3.0;
        //
        //GLubyte squareColors[] = {
        //    MIN(255, bottomLeftAvg), MIN(155, MAX(0, (bottomLeftAvg - 255) / 4)), MIN(155, MAX(0, (bottomLeftAvg - 255) / 4)), 255, 
        //    MIN(255, bottomRightAvg), MIN(155, MAX(0, (bottomRightAvg - 255) / 4)), MIN(155, MAX(0, (bottomRightAvg - 255) / 4)), 255, 
        //    MIN(255, rightAvg), MIN(155, MAX(0, (rightAvg - 255) / 4)), MIN(155, MAX(0, (rightAvg - 255) / 4)), 255, 
        //    MIN(255, topRightAvg), MIN(155, MAX(0, (topRightAvg - 255) / 4)), MIN(155, MAX(0, (topRightAvg - 255) / 4)), 255, 
        //    MIN(255, topLeftAvg), MIN(155, MAX(0, (topLeftAvg - 255) / 4)), MIN(155, MAX(0, (topLeftAvg - 255) / 4)), 255, 
        //    MIN(255, leftAvg), MIN(155, MAX(0, (leftAvg - 255) / 4)), MIN(155, MAX(0, (leftAvg - 255) / 4)), 255
        //};
        
        // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
        
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        glDisable(GL_TEXTURE_2D);
        
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
        glVertexPointer(2, GL_FLOAT, 0, vertices);
        glDrawArrays(GL_TRIANGLE_FAN, 0, 6);
        
        glEnable(GL_TEXTURE_2D);
        
        // DRAW OUTLINE
        //ccDrawPoly(vertices, 6, YES);
        
        // DRAW EDGE
        //glColor4ub(255, 255, 255, 255);
        //glLineWidth(4);
        //
        //if ([self isAmoebaPresent]) {
        //    if (_aboveCell == nil || ![_aboveCell isAmoebaPresent]) {
        //        ccDrawLine(ccp(vertices[6], vertices[7]), ccp(vertices[8], vertices[9])); //top
        //    }
        //    
        //    if (_belowCell == nil || ![_belowCell isAmoebaPresent]) {
        //        ccDrawLine(ccp(vertices[0], vertices[1]), ccp(vertices[2], vertices[3])); //bottom
        //    }
        //    
        //    if (_aboveLeftCell == nil || ![_aboveLeftCell isAmoebaPresent]) {
        //        ccDrawLine(ccp(vertices[8], vertices[9]), ccp(vertices[10], vertices[11])); //topleft
        //    }
        //    
        //    if (_aboveRightCell == nil || ![_aboveRightCell isAmoebaPresent]) {
        //        ccDrawLine(ccp(vertices[4], vertices[5]), ccp(vertices[6], vertices[7])); //topright
        //    }
        //    
        //    if (_belowLeftCell == nil || ![_belowLeftCell isAmoebaPresent]) {
        //        ccDrawLine(ccp(vertices[10], vertices[11]), ccp(vertices[0], vertices[1])); //bottomleft
        //    }
        //    
        //    if (_belowRightCell == nil || ![_belowRightCell isAmoebaPresent]) {
        //        ccDrawLine(ccp(vertices[2], vertices[3]), ccp(vertices[4], vertices[5])); //bottomright
        //    }
        //}
    }
}*/

// USE TRIANGLE FAN FROM CENTER
- (void)draw {
    // TO TEST IF I WANT TO DRAW VERY LOW LIFE CELLS AT ALL (OR USE THEM FOR COLLISION)
    //if ([self life] > 10) {
    if ([self isAdjacentToAmoeba]) {
        [self setColor];
        int aboveIntensity = 0;
        int belowIntensity = 0;
        int aboveLeftIntensity = 0;
        int aboveRightIntensity = 0;
        int belowLeftIntensity = 0;
        int belowRightIntensity = 0;
        
        // OPACITY VALUES
        int aboveOpacity = 0;
        int belowOpacity = 0;
        int aboveLeftOpacity = 0;
        int aboveRightOpacity = 0;
        int belowLeftOpacity = 0;
        int belowRightOpacity = 0;
        
        if (_aboveCell != nil) {
            aboveIntensity = MIN(255, [_aboveCell intensity]);
            if (aboveIntensity > 0) {
                aboveOpacity = 255;
            }
        }
        
        if (_belowCell != nil) {
            belowIntensity = MIN(255, [_belowCell intensity]);
            if (belowIntensity > 0) {
                belowOpacity = 255;
            }
        }
        
        if (_aboveLeftCell != nil) {
            aboveLeftIntensity = MIN(255, [_aboveLeftCell intensity]);
            if (aboveLeftIntensity > 0) {
                aboveLeftOpacity = 255;
            }
        }
        
        if (_aboveRightCell != nil) {
            aboveRightIntensity = MIN(255, [_aboveRightCell intensity]);
            if (aboveRightIntensity > 0) {
                aboveRightOpacity = 255;
            }
        }
        
        if (_belowLeftCell != nil) {
            belowLeftIntensity = MIN(255, [_belowLeftCell intensity]);
            if (belowLeftIntensity > 0) {
                belowLeftOpacity = 255;
            }
        }
        
        if (_belowRightCell != nil) {
            belowRightIntensity = MIN(255, [_belowRightCell intensity]);
            if (belowRightIntensity > 0) {
                belowRightOpacity = 255;
            }
        }
        
        static const GLfloat vertices[] = {
            SPRITE_WIDTH / 2, SPRITE_HEIGHT / 2, 
            SPRITE_WIDTH / 4, 0, 
            (SPRITE_WIDTH * 3) / 4, 0, 
            SPRITE_WIDTH, SPRITE_HEIGHT / 2, 
            (SPRITE_WIDTH * 3) / 4, SPRITE_HEIGHT, 
            SPRITE_WIDTH / 4, SPRITE_HEIGHT, 
            0, SPRITE_HEIGHT / 2, 
            SPRITE_WIDTH / 4, 0, 
        };
        
        int intensity = MIN(255, [self intensity]);
        
        // MAKE MOST CELLS HAVE HIGH OPACITY
        int opac = (intensity > 0) ? 255 : 0;
        int bottomLeftAvg = MIN(255, (belowOpacity + belowLeftOpacity + opac) / 3.0);
        int bottomRightAvg = MIN(255, (belowOpacity + belowRightOpacity + opac) / 3.0);
        int rightAvg = MIN(255, (belowRightOpacity + aboveRightOpacity + opac) / 3.0);
        int topRightAvg = MIN(255, (aboveOpacity + aboveRightOpacity + opac) / 3.0);
        int topLeftAvg = MIN(255, (aboveOpacity + aboveLeftOpacity + opac) / 3.0);
        int leftAvg = MIN(255, (aboveLeftOpacity + belowLeftOpacity + opac) / 3.0);
        
        // HIGHLIGHT HIGH LIFE CELLS
        //if (_life > 200) {
        //    bottomLeftAvg = MIN(255, intensity);
        //    bottomRightAvg = MIN(255, intensity);
        //    rightAvg = MIN(255, intensity);
        //    topRightAvg = MIN(255, intensity);
        //    topLeftAvg = MIN(255, intensity);
        //    leftAvg = MIN(255, intensity);
        //}
        
        // HIGHLIGHT EDGE CELLS
        //if ([self isEdgeOfAmoeba]) {
        //    bottomLeftAvg = 255;
        //    bottomRightAvg = 255;
        //    rightAvg = 255;
        //    topRightAvg = 255;
        //    topLeftAvg = 255;
        //    leftAvg = 255;
        //}
        
        // NO COLOR FADE
        //GLubyte squareColors[] = {
        //    _color.r, _color.g, _color.b, bottomLeftAvg, 
        //    _color.r, _color.g, _color.b, bottomRightAvg, 
        //    _color.r, _color.g, _color.b, rightAvg, 
        //    _color.r, _color.g, _color.b, topRightAvg, 
        //    _color.r, _color.g, _color.b, topLeftAvg, 
        //    _color.r, _color.g, _color.b, leftAvg
        //};
        
        // FADE COLORS
        ccColor3B thisColor = [self colorFadeFrom:intensity to:intensity and:intensity];
        ccColor3B bottomLeftColor = [self colorFadeFrom:belowIntensity to:belowLeftIntensity and:intensity];
        ccColor3B bottomRightColor = [self colorFadeFrom:belowIntensity to:belowRightIntensity and:intensity];
        ccColor3B rightColor = [self colorFadeFrom:aboveRightIntensity to:belowRightIntensity and:intensity];
        ccColor3B topRightColor = [self colorFadeFrom:aboveRightIntensity to:aboveIntensity and:intensity];
        ccColor3B topLeftColor = [self colorFadeFrom:aboveLeftIntensity to:aboveIntensity and:intensity];
        ccColor3B leftColor = [self colorFadeFrom:aboveLeftIntensity to:belowLeftIntensity and:intensity];
        
        GLubyte squareColors[] = {
            thisColor.r, thisColor.g, thisColor.b, opac, 
            bottomLeftColor.r, bottomLeftColor.g, bottomLeftColor.b, bottomLeftAvg, 
            bottomRightColor.r, bottomRightColor.g, bottomRightColor.b, bottomRightAvg, 
            rightColor.r, rightColor.g, rightColor.b, rightAvg, 
            topRightColor.r, topRightColor.g, topRightColor.b, topRightAvg, 
            topLeftColor.r, topLeftColor.g, topLeftColor.b, topLeftAvg, 
            leftColor.r, leftColor.g, leftColor.b, leftAvg, 
            bottomLeftColor.r, bottomLeftColor.g, bottomLeftColor.b, bottomLeftAvg
        };
        
        // NO OPACITY FADE
        //GLubyte squareColors[] = {
        //    thisColor.r, thisColor.g, thisColor.b, 255, 
        //    bottomLeftColor.r, bottomLeftColor.g, bottomLeftColor.b, 255, 
        //    bottomRightColor.r, bottomRightColor.g, bottomRightColor.b, 255, 
        //    rightColor.r, rightColor.g, rightColor.b, 255, 
        //    topRightColor.r, topRightColor.g, topRightColor.b, 255, 
        //    topLeftColor.r, topLeftColor.g, topLeftColor.b, 255, 
        //    leftColor.r, leftColor.g, leftColor.b, 255
        //    bottomLeftColor.r, bottomLeftColor.g, bottomLeftColor.b, 255, 
        //};
        
        // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
        
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        glDisable(GL_TEXTURE_2D);
        glDisable(GL_TEXTURE_COORD_ARRAY);
        
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
        glVertexPointer(2, GL_FLOAT, 0, vertices);
        glDrawArrays(GL_TRIANGLE_FAN, 0, 8);
        
        glEnable(GL_TEXTURE_COORD_ARRAY);
        glEnable(GL_TEXTURE_2D);
        
        // DRAW EDGE
        /*glColor4ub(255, 255, 255, 255);
        glLineWidth(4);
        
        if ([self isAmoebaPresent]) {
            if (_aboveCell == nil || ![_aboveCell isAmoebaPresent]) {
                ccDrawLine(ccp(vertices[8], vertices[9]), ccp(vertices[10], vertices[11])); //top
            }
            
            if (_belowCell == nil || ![_belowCell isAmoebaPresent]) {
                ccDrawLine(ccp(vertices[2], vertices[3]), ccp(vertices[4], vertices[5])); //bottom
            }
            
            if (_aboveLeftCell == nil || ![_aboveLeftCell isAmoebaPresent]) {
                ccDrawLine(ccp(vertices[10], vertices[11]), ccp(vertices[12], vertices[13])); //topleft
            }
            
            if (_aboveRightCell == nil || ![_aboveRightCell isAmoebaPresent]) {
                ccDrawLine(ccp(vertices[6], vertices[7]), ccp(vertices[8], vertices[9])); //topright
            }
            
            if (_belowLeftCell == nil || ![_belowLeftCell isAmoebaPresent]) {
                ccDrawLine(ccp(vertices[12], vertices[13]), ccp(vertices[2], vertices[3])); //bottomleft
            }
            
            if (_belowRightCell == nil || ![_belowRightCell isAmoebaPresent]) {
                ccDrawLine(ccp(vertices[4], vertices[5]), ccp(vertices[6], vertices[7])); //bottomright
            }
        }*/
    }
}

@end
