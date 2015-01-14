//
//  EditableView.m
//  AppSketch
//
//  Created by Oliver Rodden on 12/01/2015.
//  Copyright (c) 2015 Oliver Rodden. All rights reserved.
//

#import "EditableView.h"

@interface EditableView (){
    NSArray *editTools;
    UIView *positionHandle;
    UIButton *deleteBtn;
    UIButton *detailsBtn;
    UIView *scaleHandle;
    
    BOOL isPositioning;
    BOOL isScaling;
    CGPoint oldLocation;
}

@end

@implementation EditableView

-(id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        UITapGestureRecognizer *editMode = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClicked)];
        editMode.numberOfTapsRequired = 2;
        [self addGestureRecognizer:editMode];
        
        self.editable = YES;//+++ private? must be property
        isPositioning = NO;
        isScaling = NO;
                
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        self.imageView.layer.cornerRadius = 10.0;
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.titleLabel];
        
        //Add tools last for zpositioning
        positionHandle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
        positionHandle.backgroundColor = [UIColor colorWithRed:134.0/255.0 green:232.0/255.0 blue:124.0/255.0 alpha:1.0];
        positionHandle.layer.cornerRadius = 10.0;
        positionHandle.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        positionHandle.layer.borderWidth = 3.0;
        [self addSubview:positionHandle];
        
        deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 30.0, 0.0, 30.0, 30.0)];
        deleteBtn.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:90.0/255.0 blue:104.0/255.0 alpha:1.0];
        deleteBtn.layer.cornerRadius = 10.0;
        deleteBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        deleteBtn.layer.borderWidth = 3.0;
        [deleteBtn addTarget:self action:@selector(deleteBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        
        detailsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - 30.0, 30.0, 30.0)];
        detailsBtn.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:228.0/255.0 blue:90.0/255.0 alpha:1.0];
        detailsBtn.layer.cornerRadius = 10.0;
        detailsBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        detailsBtn.layer.borderWidth = 3.0;
        [detailsBtn addTarget:self action:@selector(detailsBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:detailsBtn];
        
        scaleHandle = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 30.0, self.frame.size.height - 30.0, 30.0, 30.0)];
        scaleHandle.backgroundColor = [UIColor colorWithRed:124.0/255.0 green:175.0/255.0 blue:232.0/255.0 alpha:1.0];
        scaleHandle.layer.cornerRadius = 10.0;
        scaleHandle.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        scaleHandle.layer.borderWidth = 3.0;
        [self addSubview:scaleHandle];
        
        editTools = [NSArray arrayWithObjects:positionHandle, deleteBtn, detailsBtn, scaleHandle, nil];
    }
    return self;
}

-(void)deleteBtnPressed{
    [self.delegate editableViewDeleteBtnPressed];
//    [self removeFromSuperview];//+++ Dirty
}

-(void)detailsBtnPressed{
    [self.delegate editableViewDetailsBtnPressed];
}

-(void)doubleClicked{
    self.editable = !self.editable;
}

-(void)setEditable:(BOOL)editable{
    self->_editable = editable;
    if (editable == YES) {
        for (UIView *tool in editTools) {
            tool.hidden = NO;
        }
        [self.delegate editableViewShouldBecomeEditable:self];
    }else{
        for (UIView *tool in editTools) {
            tool.hidden = YES;
        }
        [self.delegate editableViewShouldBecomeUneditable];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
    
    if (CGRectContainsPoint(positionHandle.frame, location)) {
        isPositioning = YES;
    }else if (CGRectContainsPoint(scaleHandle.frame, location)) {
        isScaling = YES;
    }
    oldLocation = location;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
    
    if (isPositioning) {
        location = [self.superview convertPoint:location fromView:self];
        self.frame = CGRectMake(location.x - positionHandle.frame.size.width/2, location.y - positionHandle.frame.size.height/2, self.frame.size.width, self.frame.size.height);
        positionHandle.frame = CGRectMake(0.0, 0.0, positionHandle.frame.size.width, positionHandle.frame.size.height);
    }else if (isScaling){
        CGPoint locationDifference = CGPointMake(location.x - oldLocation.x, location.y - oldLocation.y);
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width + locationDifference.x, self.frame.size.height + locationDifference.y);

        deleteBtn.frame = CGRectMake(self.frame.size.width - 30.0, 0.0, 30.0, 30.0);
        detailsBtn.frame = CGRectMake(0.0, self.frame.size.height - 30.0, 30.0, 30.0);
        scaleHandle.frame = CGRectMake(self.frame.size.width - 30.0, self.frame.size.height - 30.0, 30.0, 30.0);
        
        self.titleLabel.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
        self.imageView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    }
    oldLocation = location;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    isPositioning = NO;
    isScaling = NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
