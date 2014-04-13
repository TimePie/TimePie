//
//  BEMSimpleLineGraphView.m
//  SimpleLineGraph
//
//  Created by Bobo on 12/27/13.
//  Copyright (c) 2013 Boris Emorine. All rights reserved.
//

#define circleSize 8
#define labelXaxisOffset 8
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#import "BEMSimpleLineGraphView.h"

@implementation BEMSimpleLineGraphView

int numberOfXaxisPoints; // The number of Points in the Graph.
int numberOfAllPointsInAGraph;
BEMCircle *closestDot;
int currentlyCloser;

- (void)reloadGraph {
    [self setNeedsLayout];
}

- (void)commonInit {
    // Do not make any calls to "self" in this method. During this point self is unstable and will return nil. That is why ivars are used below.
    
    // Do any initialization that's common to both -initWithFrame: and -initWithCoder: in this method
    _labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    
    // DEFAULT VALUES
    _animationGraphEntranceSpeed = 5;
    _colorXaxisLabel = [UIColor blackColor];
    
    // Set the bottom color to the window's tint color (if no color is set)
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) _colorBottom = window.tintColor;
    else _colorBottom = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:243.0/255.0 alpha:0.2];
    
    _colorTop = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.0];
    _colorLine = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:243.0/255.0 alpha:1];
    _alphaTop = 1.0;
    _alphaBottom = 1.0;
    _alphaLine = 1.0;
    _widthLine = 1.0;
    _enableTouchReport = NO;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    numberOfXaxisPoints = [self.delegate numberOfXaxisPoints]; // The number of Points in the Graph.
    numberOfAllPointsInAGraph= [self.delegate numberOfAllPoints];
    
    
    self.animationDelegate = [[BEMAnimations alloc] init];
    self.animationDelegate.delegate = self;
    
    
    //draw different item in one view
    for (int i=0; i<self.itemCount; i++) {
        [self drawGraph:i];
    }
    
    [self drawXAxis];
    
    
    
    //TODO: change vertical to horizontal
    if (self.enableTouchReport == YES) {
        // Initialize the vertical gray line that appears where the user touches the graph.
        self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.viewForBaselineLayout.frame.size.height)];
        self.verticalLine.backgroundColor = [UIColor grayColor];
        self.verticalLine.alpha = 0;
        [self addSubview:self.verticalLine];
        
        UIView *panView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.viewForBaselineLayout.frame.size.width, self.viewForBaselineLayout.frame.size.height)];
        panView.backgroundColor = [UIColor clearColor];
        [self.viewForBaselineLayout addSubview:panView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGesture.delegate = self;
        [panGesture setMaximumNumberOfTouches:1];
        [panView addGestureRecognizer:panGesture];
    }
}

- (void)drawGraph:(int) index
{
    // CREATION OF THE DOTS
    
    float maxValue = [self maxValue]; // Biggest Y-axis value from all the points.
    float minValue = [self minValue]; // Smallest Y-axis value from all the points.
    
    float positionOnXAxis; // The position on the X-axis of the point currently being created.
    float positionOnYAxis; // The position on the Y-axis of the point currently being created.
    
//    for (UIView *subview in [self subviews]) {
//        if ([subview isKindOfClass:[BEMCircle class]])
//            [subview removeFromSuperview];
//    }
    
    for (int i = 0; i < numberOfXaxisPoints; i++) {
        
        float dotValue = [self.delegate valueInArray:index ObjectAtIndex:i];
        
        positionOnXAxis = (self.viewForBaselineLayout.frame.size.width/(numberOfXaxisPoints - 1))*i;
        positionOnYAxis = (self.viewForBaselineLayout.frame.size.height - 80) - ((dotValue - minValue) / ((maxValue - minValue) / (self.viewForBaselineLayout.frame.size.height - 80))) + 20;
        
        BEMCircle *circleDot = [[BEMCircle alloc] initWithFrame:CGRectMake(positionOnXAxis, positionOnYAxis, circleSize, circleSize)];
        
        //circleDot.center = CGPointMake(positionOnXAxis, positionOnYAxis);
        
        //dot view tag
        //at most 99 dots per view
        circleDot.tag = i+ index*100;
        circleDot.alpha = 1;
        circleDot.color = [self.colorsOfGraph objectAtIndex:index];
        
        [self addSubview:circleDot];
        
        
        
        //[self.animationDelegate animationForDot:i circleDot:circleDot animationSpeed:self.animationGraphEntranceSpeed];
        //[self sen]
    }
    
    // CREATION OF THE LINE AND BOTTOM AND TOP FILL
    
    float xDot1=0; // Postion on the X-axis of the first dot.
    float yDot1=0; // Postion on the Y-axis of the first dot.
    float xDot2=0; // Postion on the X-axis of the next dot.
    float yDot2=0; // Postion on the Y-axis of the next dot.
    
//    for (UIView *subview in [self subviews]) {
//        if ([subview isKindOfClass:[BEMLine class]])
//            [subview removeFromSuperview];
//    }
    
    for (int i = 0; i < numberOfXaxisPoints - 1; i++)
    {
        UIView *currentDot;
        for (UIView *dot in [self.viewForBaselineLayout subviews]) {
            if (dot.tag == i + index*100)  {
                xDot1 = dot.center.x;
                yDot1 = dot.center.y;
                currentDot=dot;
            } else if (dot.tag == i + index*100+1) {
                xDot2 = dot.center.x;
                yDot2 = dot.center.y;
            }
        }
        
        BEMLine *line = [[BEMLine alloc] initWithFrame:CGRectMake(0, 0, self.viewForBaselineLayout.frame.size.width, self.viewForBaselineLayout.frame.size.height)];
        line.opaque = NO;
        
        //line.tag = i + 1000;
        
        line.alpha = 0;
        line.backgroundColor = [UIColor clearColor];
        line.firstPoint = CGPointMake(xDot1, yDot1);
        line.secondPoint = CGPointMake(xDot2, yDot2);
        line.topColor = self.colorTop;
        
        line.color = [self.colorsOfGraph objectAtIndex:index];
        line.bottomColor = [self.colorsOfGraph objectAtIndex:index];
        
        line.bottomColor =[line.bottomColor colorWithAlphaComponent:0.3];
        
        line.topAlpha = self.alphaTop;
        line.bottomAlpha = self.alphaBottom;
        line.lineAlpha = self.alphaLine;
        line.lineWidth = self.widthLine;
        [self addSubview:line];
        
        //set the dot on the line
        [currentDot removeFromSuperview];
        [self addSubview:currentDot];
        
        //generate a inner white dot on the current dot
        BEMCircle *innerCircleDot = [[BEMCircle alloc] initWithFrame:CGRectMake(currentDot.center.x-circleSize/4, currentDot.center.y-circleSize/4, circleSize/2, circleSize/2)];
        innerCircleDot.alpha = 1;
        //innerCircleDot.tag = 10000000;
        innerCircleDot.color = [UIColor whiteColor];
        [self addSubview:innerCircleDot];
        //[self sendSubviewToBack:line];
        
        [self.animationDelegate animationForLine:i line:line animationSpeed:self.animationGraphEntranceSpeed];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer locationInView:self.viewForBaselineLayout];
    
    self.verticalLine.frame = CGRectMake(translation.x, 0, 1, self.viewForBaselineLayout.frame.size.height);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.verticalLine.alpha = 0.2;
    } completion:nil];
    
    closestDot = [self closestDotFromVerticalLine:self.verticalLine];
    closestDot.alpha = 0.8;
    
    if (closestDot.tag > 99 && closestDot.tag < 1000) {
        if ([self.delegate respondsToSelector:@selector(didTouchGraphWithClosestIndex:)])  [self.delegate didTouchGraphWithClosestIndex:((int)closestDot.tag - 100)];
    }
    
    // ON RELEASE
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(didReleaseGraphWithClosestIndex:)]) [self.delegate didReleaseGraphWithClosestIndex:(closestDot.tag - 100)];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            closestDot.alpha = 0;
            self.verticalLine.alpha = 0;
        } completion:nil];
    }
}

// Find which dot is currently the closest to the vertical line
- (BEMCircle *)closestDotFromVerticalLine:(UIView *)verticalLine {
    currentlyCloser = 1000;
    
    for (BEMCircle *dot in self.subviews) {
        
        if (dot.tag > 99 && dot.tag < 1000) {
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                dot.alpha = 0;
            } completion:nil];
            
            if (pow(((dot.center.x) - verticalLine.frame.origin.x), 2) < currentlyCloser) {
                currentlyCloser = pow(((dot.center.x) - verticalLine.frame.origin.x), 2);
                closestDot = dot;
            }
        }
    }
    
    return closestDot;
}

// Determines the biggest Y-axis value from all the points.
- (float)maxValue {
//    float dotValue;
//    float maxValue = 0;
//    
//    for (int i = 0; i < numberOfAllPointsInAGraph; i++) {
//        dotValue = [self.delegate valueForIndex:i];
//        
//        if (dotValue > maxValue) {
//            maxValue = dotValue;
//        }
//    }
    
    return [self.delegate maxValueOfGraphType:1];
}

// Determines the smallest Y-axis value from all the points.
- (float)minValue {
//    float dotValue;
//    float minValue = INFINITY;
//    
//    for (int i = 0; i < numberOfAllPointsInAGraph; i++) {
//        dotValue = [self.delegate valueForIndex:i];
//        
//        if (dotValue < minValue) {
//            minValue = dotValue;
//        }
//    }
//    
    return [self.delegate minValueOfGraphType:1];
}


- (void)drawXAxis {
    if (![self.delegate respondsToSelector:@selector(numberOfGapsBetweenLabels)]) return;
    
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[UILabel class]])
            [subview removeFromSuperview];
    }
    
    int numberOfGaps = [self.delegate numberOfGapsBetweenLabels] ;//+ 1;
    
    if (numberOfGaps >= (numberOfXaxisPoints - 1)) {
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, self.frame.size.height - (labelXaxisOffset + 10), self.frame.size.width/2, 20)];
        firstLabel.text = [self.delegate labelOnXAxisForIndex:0];
        firstLabel.font = self.labelFont;
        firstLabel.textAlignment = 0;
        firstLabel.textColor = self.colorXaxisLabel;
        firstLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:firstLabel];
        
        UILabel *lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 3, self.frame.size.height - (labelXaxisOffset + 10), self.frame.size.width/2, 20)];
        lastLabel.text = [self.delegate labelOnXAxisForIndex:(numberOfXaxisPoints - 1)];
        lastLabel.font = self.labelFont;
        lastLabel.textAlignment = 2;
        lastLabel.textColor = self.colorXaxisLabel;
        lastLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:lastLabel];
    } else {
        for (int i = 1; i <= (numberOfXaxisPoints/numberOfGaps); i++) {
            UILabel *labelXAxis = [[UILabel alloc] init];
            labelXAxis.text = [self.delegate labelOnXAxisForIndex:(i * numberOfGaps - 1)];
            [labelXAxis sizeToFit];
            [labelXAxis setCenter:CGPointMake((self.viewForBaselineLayout.frame.size.width/(numberOfXaxisPoints-1))*(i*numberOfGaps - 1), self.frame.size.height + labelXaxisOffset+5)];
            labelXAxis.font = self.labelFont;
            
            labelXAxis.textAlignment = 1;
            labelXAxis.textColor = self.colorXaxisLabel;
            labelXAxis.backgroundColor = [UIColor clearColor];
            [self addSubview:labelXAxis];
        }
    }
}

@end