//
//  StatsLineGraphView.m
//  TimePie
//
//  Created by 黄泽彪 on 14-4-24.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//
#define circleSize 8
#define labelXaxisOffset 8
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define DOTS_TAG_PER_VIEW 100
#define SCALE_LINE_HEIGHT 24

#import "StatsLineGraphView.h"


@implementation StatsLineGraphView
{
    int numberOfXaxisPoints; // The number of Points in the Graph.
    float scaleRateForMonthType;
//int numberOfAllPointsInAGraph;
//StatsCircle *closestDot;
//int currentlyCloser;
}
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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    numberOfXaxisPoints = self.graphType;
    //numberOfAllPointsInAGraph= [self.delegate numberOfAllPoints];
    
    self.animationDelegate = [[StatsAnimations alloc] init];
    self.animationDelegate.delegate = self;
    
    //
    scaleRateForMonthType = 1;
    if(self.graphType == MonthType)
    {
        scaleRateForMonthType = 0.91;
    }
    //
    self.allDotsPositionOfAllLines = [[NSMutableArray alloc] init];
    //
    self.dotsArray = [[NSMutableArray alloc] init];
    //draw different item in one view
    for (int i=0; i<self.itemCount; i++) {
        [self drawGraph:i];
    }
    
    //绘制坐标轴
    [self drawXAxis];
    
    //draw horizontal line
    if (self.enableTouchReport == YES)
    {
        // Initialize the horizontal line that appears where the user touches the graph.
        self.horizontalLine = [[HorizontalScaleLineView alloc] initWithFrame:CGRectMake(0, 0,  self.viewForBaselineLayout.frame.size.width+circleSize/2,SCALE_LINE_HEIGHT)];
        
        self.horizontalLine.alpha = 0;
        [self addSubview:self.horizontalLine];
        
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
    [self drawDots:index];
    [self drawLines:index];
}

- (void)drawDots:(int) index
{
    NSMutableArray *currentLinesDots = [[NSMutableArray alloc] init];
    
    
    // draw dots
    float maxValue = [self maxValue]; // Biggest Y-axis value from all the points.
    //float minValue = [self minValue]; // Smallest Y-axis value from all the points.
    
    float positionOnXAxis; // The position on the X-axis of the point currently being created.
    float positionOnYAxis; // The position on the Y-axis of the point currently being created.
    
    float rate = (maxValue) / (self.viewForBaselineLayout.frame.size.height);
    
    for (int i = 0; i < numberOfXaxisPoints; i++)
    {
        // 反向获取数据
        // 数据按照   日期 降序排列
        // 取数据按照  日期 升序获取
        float dotValue = [self.delegate valueInArray:index ObjectAtIndex:numberOfXaxisPoints - 1 - i];
        
        positionOnXAxis = (self.viewForBaselineLayout.frame.size.width / (numberOfXaxisPoints - 1)) * i;
        
        positionOnYAxis = ((self.viewForBaselineLayout.frame.size.height) - ((dotValue * scaleRateForMonthType) / rate) - 4);
        
        StatsCircle *circleDot = [[StatsCircle alloc] initWithFrame:CGRectMake(positionOnXAxis, positionOnYAxis, circleSize, circleSize)];
        
        //circleDot.center = CGPointMake(positionOnXAxis, positionOnYAxis);
        
        //dot view tag
        //at most 99 dots per view
        circleDot.tag = i + index * DOTS_TAG_PER_VIEW;
        circleDot.alpha = 1;
        //circleDot.color = [self.colorsOfGraph objectAtIndex:index];
        circleDot.color = [self.delegate colorForItemWithIndex:index];
        
        [self addSubview:circleDot];
        
        [self.dotsArray addObject:circleDot];
        
        CGPoint tempPoint = CGPointMake(circleDot.center.x, circleDot.center.y);
        [currentLinesDots addObject:[NSValue valueWithCGPoint:tempPoint]];
        //[self.animationDelegate animationForDot:i circleDot:circleDot animationSpeed:self.animationGraphEntranceSpeed];
    }
    [self.allDotsPositionOfAllLines addObject:currentLinesDots];
}

- (void)drawLines:(int) index
{
    // draw lines
    float xDot1 = 0; // Postion on the X-axis of the first dot.
    float yDot1 = 0; // Postion on the Y-axis of the first dot.
    float xDot2 = 0; // Postion on the X-axis of the next dot.
    float yDot2 = 0; // Postion on the Y-axis of the next dot.
    
    for (int i = 0; i < numberOfXaxisPoints; i++)
    {
        UIView *currentDot;
        for (UIView *dot in [self.viewForBaselineLayout subviews])
        {
            int indexTag = i + index * DOTS_TAG_PER_VIEW;
            if (dot.tag == indexTag)
            {
                xDot1 = dot.center.x;
                yDot1 = dot.center.y;
                currentDot=dot;
            }
            else if (dot.tag == indexTag + 1)
            {
                xDot2 = dot.center.x;
                yDot2 = dot.center.y;
            }
        }
        
        //StatsLine *line = [[StatsLine alloc] initWithFrame:CGRectMake(0, 0, self.viewForBaselineLayout.frame.size.width+circleSize/2, self.viewForBaselineLayout.frame.size.height)];
        
        StatsLine *line = [[StatsLine alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width + circleSize / 2, self.frame.size.height)];
        line.opaque = NO;
        line.alpha = 0;
        line.backgroundColor = [UIColor clearColor];
        
        line.firstPoint = CGPointMake(xDot1, yDot1);
        line.secondPoint = CGPointMake(xDot2, yDot2);
        
        /**
         *  test for curve line drawing
         */
        line.allPointsInLines = [self.allDotsPositionOfAllLines objectAtIndex:index];
        line.currentIndex = i;
        if (self.graphType == MonthType)
        {
            line.isCurveLine = YES;
        }
        else
        {
            line.isCurveLine = NO;
        }
        //line.topColor = self.colorTop;
        line.color = [self.delegate colorForItemWithIndex:index];
        line.bottomColor = [self.delegate colorForItemWithIndex:index];
        //line.color = [self.colorsOfGraph objectAtIndex:index];
        //line.bottomColor = [self.colorsOfGraph objectAtIndex:index];
        //line.bottomColor =[line.bottomColor colorWithAlphaComponent:1];
        
        //line.topAlpha = self.alphaTop;
        line.bottomAlpha = self.alphaBottom;
        line.lineAlpha = self.alphaLine;
        line.lineWidth = self.widthLine;
        
        [self addSubview:line];
        //[self bringSubviewToFront:line];
        
        //set the dot on the line
        [currentDot removeFromSuperview];
        
        if(self.graphType != MonthType)
        {
            [self addSubview:currentDot];
        
            //generate a inner white dot on the current dot
            StatsCircle *innerCircleDot = [[StatsCircle alloc] initWithFrame:CGRectMake(currentDot.center.x-circleSize/4, currentDot.center.y-circleSize/4, circleSize/2, circleSize/2)];
            innerCircleDot.alpha = 1;
            innerCircleDot.color = [UIColor whiteColor];
            innerCircleDot.tag = -1;
            [self addSubview:innerCircleDot];
        }
        [self.animationDelegate animationForLine:i line:line animationSpeed:self.animationGraphEntranceSpeed];
    }
}
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer locationInView:self.viewForBaselineLayout];
    //horizontal line positon limitation
    CGFloat yPostion = translation.y;
    if(yPostion <= -4)
    {
        yPostion = -4;
    }
    if(yPostion > self.frame.size.height)
    {
        yPostion = self.frame.size.height;
    }
    
    yPostion = yPostion - SCALE_LINE_HEIGHT / 2;
    
    self.horizontalLine.frame=CGRectMake(0,yPostion, self.viewForBaselineLayout.frame.size.width + circleSize / 2, SCALE_LINE_HEIGHT);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.horizontalLine.alpha = 1;
    } completion:nil];
    
    
    //StatsCircle *closestDot = [self closestDotFromHorizontalLine:self.horizontalLine];
    
    self.horizontalLine.scaleLabel.text = [self calculScaleLabelText:self.horizontalLine.center.y];//
    
    // ON RELEASE
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        //        if ([self.delegate respondsToSelector:@selector(didReleaseGraphWithClosestIndex:)]) [self.delegate didReleaseGraphWithClosestIndex:(closestDot.tag - 100)];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //closestDot.alpha = 0;
            self.horizontalLine.alpha = 0;
        } completion:nil];
    }
}

- (NSString *)calculScaleLabelText:(float) yPosition  //(StatsCircle *) dot
{
    float maxValue = [self maxValue]; // Biggest Y-axis value from all the points.
    //float minValue = [self minValue]; // Smallest Y-axis value from all the points.
    float rate = (maxValue) / self.viewForBaselineLayout.frame.size.height;
    float realValue = (self.viewForBaselineLayout.frame.size.height - (yPosition + 4)) * rate / scaleRateForMonthType;
    float intValue = realValue;
    
    //区别秒分时
    if (intValue <= 60) {
        intValue = intValue >= 0 ? intValue : 0;
        return [NSString stringWithFormat:@"%.0fs",intValue];
    }
    else if(intValue > 60 && intValue < 3600)
    {
        float tempValue = intValue / 60;
        return [NSString stringWithFormat:@"%.1fm",tempValue];
    }
    else
    {
        float tempValue = intValue / 3600;
        return [NSString stringWithFormat:@"%.1fh",tempValue];
    }
}


// Find which dot is currently the closest to the line
- (StatsCircle *)closestDotFromHorizontalLine:(UIView *)horizontalLine {
    int currentlyCloser = 10000;
    StatsCircle *resultDot;
    for (StatsCircle *dot in self.dotsArray)
    {
        if (YES)//dot.tag != -1)
        {
            
            if (pow(((dot.center.y) - (horizontalLine.frame.origin.y + SCALE_LINE_HEIGHT / 2)), 2) < currentlyCloser) {
                currentlyCloser = pow(((dot.center.y) - (horizontalLine.frame.origin.y + SCALE_LINE_HEIGHT / 2)), 2);
                resultDot = dot;
                
//                [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                    dot.s = 0;
//                } completion:nil];
            }
        }
    }
    
    return resultDot;
}

// Determines the biggest Y-axis value from all the points.
- (float)maxValue {
    return [self.delegate maxValueOfGraphType:self.graphType];
}

// Determines the smallest Y-axis value from all the points.
- (float)minValue {
    return [self.delegate minValueOfGraphType:self.graphType];
}


- (void)drawXAxis
{
    if (![self.delegate respondsToSelector:@selector(numberOfGapsBetweenLabels:)])
        return;
    
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[UILabel class]])
            [subview removeFromSuperview];
    }
    
    int numberOfGaps = [self.delegate numberOfGapsBetweenLabels:self.graphType];
    
    if (numberOfGaps < numberOfXaxisPoints -1)
    {
        //display the date label
        for (int i = 1; i <= (numberOfXaxisPoints/numberOfGaps); i++)
        {
            UILabel *labelXAxis = [[UILabel alloc] init];
            labelXAxis.text = [self.delegate labelOnXAxisForIndex:(i * numberOfGaps - 1) WithTimeRange:numberOfXaxisPoints];
            [labelXAxis sizeToFit];
            
            float offsetX = 4;
            
            float width = self.viewForBaselineLayout.frame.size.width;//-30;
            [labelXAxis setCenter:CGPointMake((width/((numberOfXaxisPoints-1)/numberOfGaps))*(i-1)+offsetX, self.frame.size.height + labelXaxisOffset+2)];
            //[labelXAxis setCenter:CGPointMake((width/(numberOfXaxisPoints-1))*(i*numberOfGaps - 1)+offsetX, self.frame.size.height + labelXaxisOffset+2)];
            
            labelXAxis.font = self.labelFont;
            
            if (i == 1)
            {
                [labelXAxis setCenter:CGPointMake((width/((numberOfXaxisPoints-1)/numberOfGaps))*(i-1)+16, self.frame.size.height + labelXaxisOffset+2)];
            }
            
            
            if(i == numberOfXaxisPoints / numberOfGaps)
            {
                [labelXAxis setCenter:CGPointMake((width/((numberOfXaxisPoints-1)/numberOfGaps))*(i-1)-10, self.frame.size.height + labelXaxisOffset+2)];
                labelXAxis.font = [UIFont fontWithName:@"Roboto-Medium" size:13];
            }
            
            labelXAxis.textAlignment = 1;
            labelXAxis.textColor = self.colorXaxisLabel;
            labelXAxis.backgroundColor = [UIColor clearColor];
            [self addSubview:labelXAxis];
        }
    }
    
    //
    //    if (numberOfGaps >= (numberOfXaxisPoints - 1))
    //    {
    //        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, self.frame.size.height - (labelXaxisOffset + 10), self.frame.size.width/2, 20)];
    //        firstLabel.text = [self.delegate labelOnXAxisForIndex:0 WithTimeRange:numberOfXaxisPoints];
    //        firstLabel.font = self.labelFont;
    //        firstLabel.textAlignment = 0;
    //        firstLabel.textColor = self.colorXaxisLabel;
    //        firstLabel.backgroundColor = [UIColor clearColor];
    //        [self addSubview:firstLabel];
    //
    //        UILabel *lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 3, self.frame.size.height - (labelXaxisOffset + 10), self.frame.size.width/2, 20)];
    //        lastLabel.text = [self.delegate labelOnXAxisForIndex:(numberOfXaxisPoints - 1) WithTimeRange:numberOfXaxisPoints];
    //        lastLabel.font = self.labelFont;
    //        lastLabel.textAlignment = 2;
    //        lastLabel.textColor = self.colorXaxisLabel;
    //        lastLabel.backgroundColor = [UIColor clearColor];
    //        [self addSubview:lastLabel];
    //    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
