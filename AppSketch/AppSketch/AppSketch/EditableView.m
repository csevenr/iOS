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
    UIView *scaleHandle;
    UIButton *deleteBtn;
}

@end

@implementation EditableView

-(id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
//        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(changeFrame:)];
//        [self addGestureRecognizer:pinch];

        UITapGestureRecognizer *editMode = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClicked)];
        editMode.numberOfTapsRequired = 2;
        [self addGestureRecognizer:editMode];
        
        positionHandle = [[UIView alloc] initWithFrame:CGRectMake(-15.0, -15.0, 30.0, 30.0)];
        positionHandle.backgroundColor = [UIColor colorWithRed:134.0/255.0 green:232.0/255.0 blue:124.0/255.0 alpha:1.0];
        positionHandle.layer.cornerRadius = 10.0;
        positionHandle.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        positionHandle.layer.borderWidth = 3.0;
        [self addSubview:positionHandle];
        
        scaleHandle = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 15.0, self.frame.size.height - 15.0, 30.0, 30.0)];
        scaleHandle.backgroundColor = [UIColor colorWithRed:124.0/255.0 green:175.0/255.0 blue:232.0/255.0 alpha:1.0];
        scaleHandle.layer.cornerRadius = 10.0;
        scaleHandle.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        scaleHandle.layer.borderWidth = 3.0;
        [self addSubview:scaleHandle];
        
        deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 15.0, -15.0, 30.0, 30.0)];
        deleteBtn.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:90.0/255.0 blue:104.0/255.0 alpha:1.0];
        deleteBtn.layer.cornerRadius = 10.0;
        deleteBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        deleteBtn.layer.borderWidth = 3.0;
        [deleteBtn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventAllEvents];
        [self addSubview:deleteBtn];
        
        editTools = [NSArray arrayWithObjects:positionHandle, scaleHandle, deleteBtn, nil];
    }
    return self;
}

-(void)clicked{
    NSLog(@"aa");
}

-(void)doubleClicked{
    self.editable = !self.editable;
}

-(void)setEditable:(BOOL)editable{
    self->_editable = editable;
    for (UIView *tool in editTools) {
        if (editable == YES) {
            tool.hidden = NO;
            self.layer.borderWidth = 1.0;
            self.layer.borderColor = [[UIColor blueColor] CGColor];
        }else{
            tool.hidden = YES;
            self.layer.borderWidth = 1.0;
            self.layer.borderColor = [[UIColor blackColor] CGColor];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"BEGAN");
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UITouch *touch = [[event allTouches]anyObject];
    CGPoint location = [touch locationInView:self];
    NSLog(@"%f, %f", location.x, location.y);
    NSLog(@"%f, %f", point.x, point.y);
    return [super hitTest:point withEvent:event];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
