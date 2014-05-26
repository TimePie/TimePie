//
//  StatsLine.m
//  TimePie
//
//  Created by 黄泽彪 on 14-4-24.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import "StatsLine.h"

@implementation StatsLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //FILL TOP
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
//        CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
//        CGContextSetAlpha(ctx, self.topAlpha);
//        CGContextBeginPath(ctx);
//        CGContextMoveToPoint(ctx, round(self.firstPoint.x), self.firstPoint.y);
//        CGContextAddLineToPoint(ctx, round(self.secondPoint.x), self.secondPoint.y);
//        CGContextAddLineToPoint(ctx, round(self.secondPoint.x), self.frame.origin.y);
//        CGContextAddLineToPoint(ctx, round(self.firstPoint.x), self.frame.origin.x);
//        CGContextClosePath(ctx);
//            CGContextDrawPath(ctx, kCGPathFill);
    
    
    
    CGPoint leftBottom = CGPointMake(0, self.frame.size.height);
    CGPoint rightBottom = CGPointMake(self.frame.size.width, self.frame.size.height);
    
    UIBezierPath *path1;
    if (self.isCurveLine) {
        //曲线
        //LINE GRAPH
        path1 = [UIBezierPath bezierPath];
        
        [path1 setLineWidth:self.lineWidth];
        //[path1 moveToPoint:self.firstPoint];
        //[path1 addLineToPoint:self.secondPoint];
        
        
        NSInteger granularity = 100;
        
        NSMutableArray *addCurvePoints = [[NSMutableArray alloc] init];
        NSMutableArray *points = [self.allPointsInLines mutableCopy];
        
        // Add control points to make the math make sense
        [points insertObject:points[0] atIndex:0];
        [points addObject:[points lastObject]];
        
        //UIBezierPath *lineGraph = [UIBezierPath bezierPath];
        
        [path1 moveToPoint:[points[self.currentIndex+1] CGPointValue]];
        
        NSUInteger index = self.currentIndex+1;
        if(index < points.count - 2)
        {
            [addCurvePoints addObject:points[index]];
            
            CGPoint p0 = [(NSValue *)points[index - 1] CGPointValue];
            CGPoint p1 = [(NSValue *)points[index] CGPointValue];
            CGPoint p2 = [(NSValue *)points[index + 1] CGPointValue];
            CGPoint p3 = [(NSValue *)points[index + 2] CGPointValue];

            // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
            for (int i = 1; i < granularity; i++)
            {
                float t = (float) i * (1.0f / (float) granularity);
                float tt = t * t;
                float ttt = tt * t;
                
                CGPoint pi; // intermediate point
                pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
                pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
                
                [path1 addLineToPoint:pi];
                
                [addCurvePoints addObject:[NSValue valueWithCGPoint:pi]];
            }
            
            // Now add p2
            [path1 addLineToPoint:p2];
            [addCurvePoints addObject:points[index + 1]];
        }
        
        CGContextSetFillColorWithColor(ctx, [self.bottomColor CGColor]);
        CGContextSetAlpha(ctx, self.bottomAlpha+0.3);
        CGContextBeginPath(ctx);
        
        CGContextMoveToPoint(ctx, round(self.firstPoint.x), self.firstPoint.y);
        for(int i = 1; i <addCurvePoints.count; i++)
        {
            CGPoint tempPoint = [(NSValue *)addCurvePoints[i] CGPointValue];
            CGContextAddLineToPoint(ctx, round(tempPoint.x), tempPoint.y);
            
        }
        //CGContextAddLineToPoint(ctx, round(self.secondPoint.x), self.secondPoint.y);
        CGContextAddLineToPoint(ctx, round(self.secondPoint.x), self.frame.size.height);
        CGContextAddLineToPoint(ctx, round(self.firstPoint.x), self.frame.size.height);
        
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFill);
    }
    else
    {
        //直线
        //FILL BOTOM
        CGContextSetFillColorWithColor(ctx, [self.bottomColor CGColor]);
        CGContextSetAlpha(ctx, self.bottomAlpha);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, round(self.firstPoint.x), self.firstPoint.y);
        CGContextAddLineToPoint(ctx, round(self.secondPoint.x), self.secondPoint.y);
        CGContextAddLineToPoint(ctx, round(self.secondPoint.x), self.frame.size.height);
        CGContextAddLineToPoint(ctx, round(self.firstPoint.x), self.frame.size.height);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFill);

        //LINE GRAPH
        path1 = [UIBezierPath bezierPath];
        [path1 setLineWidth:self.lineWidth];
        [path1 moveToPoint:self.firstPoint];
        [path1 addLineToPoint:self.secondPoint];
        
    }
    //CGPoint controlPoint = CGPointMake((self.firstPoint.x+self.secondPoint.x)/2, (self.firstPoint.y+self.secondPoint.y)/2);
    //[path1 addQuadCurveToPoint:self.secondPoint controlPoint:controlPoint];
    //path1.lineCapStyle = kCGLineCapRound;
    path1.lineJoinStyle = kCGLineJoinRound;
    [self.color set];
    [path1 strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
    
    //add vertical gray line
    if(!self.isCurveLine)
    {
        UIBezierPath *path2 = [UIBezierPath bezierPath];
        [path2 setLineWidth:0.2];
        [path2 moveToPoint:self.secondPoint];
        [path2 addLineToPoint:CGPointMake(self.secondPoint.x, self.frame.size.height)];
        
        path2.lineJoinStyle = kCGLineJoinRound;
        [[UIColor lightGrayColor] set];
        [path2 strokeWithBlendMode:kCGBlendModeNormal alpha:0.7];
    }
}


@end
