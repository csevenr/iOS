//
//  EasyScene.m
//  mindSphere
//
//  Created by Oliver Rodden on 22/11/2013.
//  Copyright (c) 2013 Oliver Rodden. All rights reserved.
//

#import "EasyScene.h"

@interface EasyScene (){
    ViewController *vc;
    NSMutableArray *pattern;
    NSMutableArray *guessedPattern;
    BOOL waiting;//a varible to see wether im waiting for user input or not
    SKSpriteNode *currentSprite;
    
}

@end

@implementation EasyScene

-(id)initWithSize:(CGSize)size viewController:(ViewController*)V{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        vc=V;
        
        self.backgroundColor = [SKColor greenColor];
        waiting=NO;
        guessedPattern=[NSMutableArray new];
        for (int i=0; i<4; i++) {
            NSNumber *zero = [NSNumber numberWithInt:0];
            [guessedPattern addObject:zero];
        }
        
        for (int i=0; i<4; i++) {
            SKSpriteNode *sprite = [SKSpriteNode new];
            //wont be colours will be sprites +++
            if (i==0)sprite.color=[SKColor blueColor];
            else if (i==1)sprite.color=[SKColor yellowColor];
            else if (i==2)sprite.color=[SKColor redColor];
            else if (i==3)sprite.color=[SKColor orangeColor];
            sprite.size=CGSizeMake(40.0, 40.0);
            sprite.name=[NSString stringWithFormat:@"%d",i];
            sprite.position=CGPointMake(30.0, 50.0*i+300);
            [self addChild:sprite];
        }
        SKSpriteNode *checkSprite = [[SKSpriteNode alloc]initWithColor:[SKColor blackColor] size:CGSizeMake(150.0, 50)];
        checkSprite.name=@"check";
        checkSprite.position=CGPointMake(CGRectGetMidX(self.frame), 30.0);
        [self addChild:checkSprite];
        
        SKSpriteNode *backBtn = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship.png"];
        if (!UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            backBtn.size = CGSizeMake(36.0, 26.0);
            backBtn.position = CGPointMake(26.0, 540.0);
        }else{
            backBtn.size = CGSizeMake(72.0, 52.0);
            backBtn.position = CGPointMake(94.0, 690.0);
        }
        backBtn.name = @"back";
        [self addChild:backBtn];
        [self generatePattern];
    }
    return self;
}

-(void)generatePattern{//generate the pattern for this game
    NSNumber *one = [NSNumber numberWithInt:(arc4random()%4)];
    NSNumber *two = [NSNumber numberWithInt:(arc4random()%4)];
    NSNumber *three = [NSNumber numberWithInt:(arc4random()%4)];
    NSNumber *four = [NSNumber numberWithInt:(arc4random()%4)];
    pattern = [[NSMutableArray alloc]initWithObjects:one,two,three,four,nil];
    //generate pattern animation
    waiting=YES;
}

/*----------------------------------------------------------
        REAL COMPLICATED IF STATEMENT HERE TO CHECK
 ----------------------------------------------------------*/

-(void)checkPattern{//check the pattern the user has guessed
    for (int i=0;i<4;i++) {
        NSNumber *check = [guessedPattern objectAtIndex:i];
        if ([check integerValue]==0) {
            NSLog(@"NOT ALL FILLED");
            return;
        }else if ([check integerValue]!=){
            
        }
    }
    waiting=NO;

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if (waiting) {
        if ([node.name isEqualToString:@"0"]||[node.name isEqualToString:@"1"]||[node.name isEqualToString:@"2"]||[node.name isEqualToString:@"3"]){
            SKSpriteNode *sprite = [SKSpriteNode new];
            if ([node.name intValue]==0)sprite.color=[SKColor blueColor];
            else if ([node.name intValue]==1)sprite.color=[SKColor yellowColor];
            else if ([node.name intValue]==2)sprite.color=[SKColor redColor];
            else if ([node.name intValue]==3)sprite.color=[SKColor orangeColor];
            sprite.size=CGSizeMake(60.0, 60.0);
            sprite.name=[NSString stringWithFormat:@"big%@",node.name];
            sprite.position=location;
            [self addChild:sprite];
            currentSprite=sprite;
        }else if ([node.name isEqualToString:@"big0"]||[node.name isEqualToString:@"big1"]||[node.name isEqualToString:@"big2"]||[node.name isEqualToString:@"big3"]){
            currentSprite=(SKSpriteNode*)node;
            currentSprite.size=CGSizeMake(60.0, 60.0);
        }else if ([node.name isEqualToString:@"check"]){
            [self checkPattern];
        }
    }else if ([node.name isEqualToString:@"back"]){
        [vc removeCurrentScene];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    if (currentSprite!=nil) {
        currentSprite.position=location;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (currentSprite.position.x<85.0) {
        [currentSprite removeFromParent];
    }else if (currentSprite.position.x>=85.0&&currentSprite.position.x<143.0){
        SKNode *node = [self nodeAtPoint:CGPointMake(104.0, 460.0)];//check if node already there
        if (node!=nil) {
            [node removeFromParent];//if so remove it
        }
        currentSprite.position=CGPointMake(104.0, 460.0);
    }else if (currentSprite.position.x>=143.0&&currentSprite.position.x<201.0){
        SKNode *node = [self nodeAtPoint:CGPointMake(172.0, 460.0)];
        if (node!=nil) {
            [node removeFromParent];
        }
        currentSprite.position=CGPointMake(172.0, 460.0);
    }else if (currentSprite.position.x>=201.0&&currentSprite.position.x<260.0){
        SKNode *node = [self nodeAtPoint:CGPointMake(230.0, 460.0)];
        if (node!=nil) {
            [node removeFromParent];
        }
        currentSprite.position=CGPointMake(230.0, 460.0);
    }else if (currentSprite.position.x>=260.0&&currentSprite.position.x<318.0){
        SKNode *node = [self nodeAtPoint:CGPointMake(289.0, 460.0)];
        if (node!=nil) {
            [node removeFromParent];
        }
        currentSprite.position=CGPointMake(289.0, 460.0);
    }
    currentSprite.size=CGSizeMake(40.0, 40.0);
    currentSprite=nil;
}

@end
