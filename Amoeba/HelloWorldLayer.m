//
//  HelloWorldLayer.m
//  Amoeba
//
//  Created by Ryan Oaks on 6/17/11.
//  Copyright Gov 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "Amoeba.h"
#import "Enemy.h"

CCLabelTTF *_score;

Amoeba *_amoeba;
NSMutableArray *_enemies;

ccTime _timeSinceLastSpawn;
ccTime _timeSinceWaveStart;
ccTime _timeSinceLastTouch;
BOOL _isTouching;

const int RESPAWN_TIME = 2;
const int WAVE_TIME = 30;
const int WAVE_REST_TIME = 10;

float _screenWidth;
float _screenHeight;

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void) reset {
    // remove all enemies
    NSMutableArray *enemiesToDelete = [[NSMutableArray alloc] init];
    for (Enemy* enemy in _enemies) {
        if ( enemy != nil ) {
            [enemiesToDelete addObject:enemy];
        }
    }
    
    for (Enemy* enemy in enemiesToDelete) {
        if ( enemy != nil ) {
            [_enemies removeObject:enemy];
            [self removeChild:enemy cleanup:YES];
        }
    }
    [enemiesToDelete removeAllObjects];
    [enemiesToDelete dealloc];
    
    // make a new amoeba
    [self removeChild:_amoeba cleanup:YES];
    _amoeba = [[Amoeba alloc] initWithScreenWidth:_screenWidth screenHeight:_screenHeight];
    [self addChild:_amoeba];
    
    // Probably just move this into amoeba init
    [_amoeba setAllowCondense:YES];
    
    // reset timers
    _timeSinceLastSpawn = 0;
    _timeSinceWaveStart = 0;
    _timeSinceLastTouch = 0;
}

// on "init" you need to initialize your instance
-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        _screenWidth = size.width;
        _screenHeight = size.height;
        
        CCSprite * bg = [CCSprite spriteWithFile:@"bg2.png"];
        [bg setPosition:ccp(_screenWidth / 2, _screenHeight / 2)];
        [self addChild:bg z:0];
        
        _enemies = [[NSMutableArray alloc] init];
        
        _score = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", 0] fontName:@"Arial" fontSize:14];
        _score.position = ccp(60, 700);
        _score.scale = 2;
        [self addChild:_score];
        
        //schedule a repeating callback on every frame
        [self schedule:@selector(nextFrame:)];
        
        //register for touch events
        self.isTouchEnabled = YES;
        
        _isTouching = NO;
        
        [self reset];
	}
	return self;
}

-(void) draw {
    [_score setString:[NSString stringWithFormat:@"%d", (int)[_amoeba totalLife]]];
}

-(void) nextFrame:(ccTime)dt {
    if ([_amoeba totalLife] <= 400) {
        [self reset];
    }
    
    _timeSinceLastSpawn += dt;
    _timeSinceWaveStart += dt;
    _timeSinceLastTouch += dt;
    
    if (_timeSinceWaveStart <= WAVE_TIME) {
        if (_timeSinceLastSpawn >= RESPAWN_TIME) {
            // TEMPORARILY STOP SPAWNING ENEMIES
            Enemy *newEnemy = [[Enemy alloc] initWithScreenWidth:_screenWidth screenHeight:_screenHeight];
            [self addChild:newEnemy];
            [_enemies addObject:newEnemy];
            
            _timeSinceLastSpawn = 0;
        }
    }
    else if (_timeSinceWaveStart <= WAVE_TIME + WAVE_REST_TIME) {
        //do nothing
    }
    else {
        _timeSinceWaveStart = 0;
        _timeSinceLastSpawn = 0;
    }
    
    float duration = 2;
    float touchFactor = 50.0;
    
    float da = 30.0 * dt;
    // TEMPORARILY DISABLE FADE ON RELEASE
    /*if (_isTouching) {
        da = da / touchFactor;// 0.6 * dt
    }
    else if (_timeSinceLastTouch < duration) {
        //da = da * ((2.0 * _timeSinceLastTouch / 2.0) + 1) / 3.0;
        da = da * (((touchFactor - 1) * _timeSinceLastTouch / duration) + 1) / touchFactor;
    }*/
    
    //if (!_isTouching && _timeSinceLastTouch >= 1) {
    //    [_amoeba setAllowCondense:YES];
    //}
    
    [_amoeba condenseAmoebaForDuration:da];
    
    NSMutableArray *enemiesToDelete = [[NSMutableArray alloc] init];
    for (Enemy* enemy in _enemies) {
        if ( enemy != nil ) {
            if ([_amoeba isSurrounding:enemy]) {
                [_amoeba onSurround:enemy];
                
                [enemiesToDelete addObject:enemy];
            }
            else if ([_amoeba isTouching:enemy]) {
                [_amoeba onHit:enemy forDuration:dt];
            }
            else {
                [enemy update:dt];
            }
        }
    }
    
    for (Enemy* enemy in enemiesToDelete) {
        if ( enemy != nil ) {
            [_enemies removeObject:enemy];
            [self removeChild:enemy cleanup:YES];
        }
    }
    [enemiesToDelete removeAllObjects];
    [enemiesToDelete dealloc];
    
    [_amoeba update:dt];
}

-(void) registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    _isTouching = YES;
    return YES;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint prevLocation = [touch previousLocationInView:[touch view]];
    prevLocation = ccp(prevLocation.x, _screenHeight - prevLocation.y);
    
    CGPoint curLocation = [touch locationInView:[touch view]];
    curLocation = ccp(curLocation.x, _screenHeight - curLocation.y);
    
    if (!ccpFuzzyEqual(prevLocation, curLocation, 0.1)) {
        [_amoeba spreadLifeAreaFrom:prevLocation to:curLocation];
    }
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    _isTouching = NO;
    _timeSinceLastTouch = 0;
    //[cocosGuy stopAllActions];
    //[cocosGuy runAction:[CCMoveTo actionWithDuration:1 position:location]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc {
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
