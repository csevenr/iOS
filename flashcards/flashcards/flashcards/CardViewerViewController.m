//
//  ViewController.m
//  flashcards
//
//  Created by Oliver Rodden on 05/05/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "CardViewerViewController.h"

#import "Card+Helper.h"
#import "ModelHelper.h"

@interface CardViewerViewController (){
    CardView *currentCard;
    NSMutableArray *sortedCards;
}

@property(nonatomic)BOOL currentCardIsInEditMode;

@end

@implementation CardViewerViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]) {
        sortedCards = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedRight)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];

    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedLeft)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:left];
    
    self.currentCardIsInEditMode = NO;
    
    
}

-(void)setCurrentCardSet:(CardSet *)currentCardSet{
    self->_currentCardSet = currentCardSet;
    
    [self setTitle:self.currentCardSet.name];
    
    if ([self.currentCardSet.cards count] == 0) {
        [self addBtnPressed:nil];
    } else {
        sortedCards = [[CardSet getCardsFromSetWithName:self.currentCardSet.name] mutableCopy];

        Card *c = [sortedCards objectAtIndex:0];
//        Card *c = [Card getCardSetWithCardId:[NSString stringWithFormat:@"%@0", self.currentCardSet.name]];
        [self newCardWithData:c inPosition:2];
    }
}

-(void)setCurrentCardIsInEditMode:(BOOL)currentCardIsInEditMode{
    self->_currentCardIsInEditMode = currentCardIsInEditMode;
    
    [currentCard setIsInEditMode:NO];
}

-(void)swipedRight{
    if ([self.currentCardSet.cards count] > 1) {
        int index = (int)currentCard.cardId - 1;
        if (index < 0) {
            index = (int)[self.currentCardSet.cards count] - 1;
        }
        
        Card *c = [sortedCards objectAtIndex:index];
        [self newCardWithData:c inPosition:3];
    }
    
}

-(void)swipedLeft{
    if ([self.currentCardSet.cards count] > 1) {
        int index = (int)currentCard.cardId + 1;
        if (index >= (int)[self.currentCardSet.cards count]) {
            index = 0;
        }
        
        Card *c = [sortedCards objectAtIndex:index];
        [self newCardWithData:c inPosition:1];
    }
}

-(CardView *)newCardWithData:(Card *)card inPosition:(int)position{//postion: left = 1, centre = 2, right = 3
    CardView *newCard = [[[NSBundle mainBundle]
                          loadNibNamed:@"CardView"
                          owner:self options:nil]
                         firstObject];

    if (card != nil) {
        newCard.titleLbl.text = card.title;
        newCard.descLbl.text = card.desc;
        newCard.cardId = [sortedCards indexOfObject:card]; //card.cardId;
    }
    
    [self.view addSubview:newCard];
    
    [newCard setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    CGFloat left;
    CGFloat right;
    
    if (position == 1) {
        left = self.view.frame.size.width;
        right = -self.view.frame.size.width;
        currentCard.leftCardConstraint.constant -= self.view.frame.size.width;
        currentCard.rightCardConstraint.constant += self.view.frame.size.width;
    } else if (position == 2) {
        left = 34;
        right = 34;
    } else if (position == 3) {
        left = -self.view.frame.size.width;
        right = self.view.frame.size.width;
        currentCard.leftCardConstraint.constant -= -self.view.frame.size.width;
        currentCard.rightCardConstraint.constant += -self.view.frame.size.width;
    }
    
    NSLayoutConstraint *leftCardConstraint = [NSLayoutConstraint constraintWithItem:newCard
                                                                          attribute:NSLayoutAttributeLeading
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeLeadingMargin
                                                                         multiplier:1.0
                                                                           constant:left];//34
    leftCardConstraint.priority = 999;
    
    [self.view addConstraint: leftCardConstraint];
    [newCard setLeftCardConstraint:leftCardConstraint];
    
    NSLayoutConstraint *rightCardConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                           attribute:NSLayoutAttributeTrailingMargin
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:newCard
                                                                           attribute:NSLayoutAttributeTrailing
                                                                          multiplier:1.0
                                                                            constant:right];//34
    rightCardConstraint.priority = 999;
    
    [self.view addConstraint:rightCardConstraint];
    [newCard setRightCardConstraint:rightCardConstraint];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:newCard
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:-20]];
    
    [newCard layoutIfNeeded];
    
    leftCardConstraint.constant = 34;
    rightCardConstraint.constant = 34;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [currentCard layoutIfNeeded];
                         [newCard layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         currentCard = newCard;
                     }];
    return newCard;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addBtnPressed:(id)sender {
    CardView *card = [self newCardWithData:nil inPosition:1];
    [card setIsInEditMode:YES];
    self.currentCardIsInEditMode = YES;
    card.cardId = [sortedCards count];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnPressed)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

-(void)doneBtnPressed{
    self.currentCardIsInEditMode = NO;
    
    Card *newCard = [Card create];
    newCard.title = currentCard.titleLbl.text;
    newCard.desc = currentCard.descLbl.text;
    newCard.cardId = [NSString stringWithFormat:@"%@%lu", self.currentCardSet.name, (unsigned long)[self.currentCardSet.cards count]];
    
    [self.currentCardSet addCardsObject:newCard];
    
    [ModelHelper saveManagedObjectContext];
    
    [sortedCards addObject:newCard];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBtnPressed:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

@end
