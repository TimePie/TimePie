//
//  StatsLineGraphView.h
//  TimePie
//
//  Created by 黄泽彪 on 14-4-24.
//  Copyright (c) 2014年 TimePieOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StatsCircle.h"
#import "StatsLine.h"
#import "StatsAnimations.h"
#import "GraphTypeEnum.h"

@protocol StatsLineGraphDelegate <NSObject>

@required

/** The number of points along the X-axis of the graph.
 *  @return Number of points.
 */
//- (int)numberOfXaxisPoints;

//the number of points drew in the graph
//- (int)numberOfAllPoints;

/** The vertical position for a point at given index. It corresponds to the Y-axis value of the Graph.
 *  @param index   The index from left to right of a given point (X-axis). The first value for the index is 0.
 *  @return        The Y-axis value at a given index.
 */
- (float)valueForIndex:(NSInteger)index;

- (float)valueInArray:(int) arrayIndex ObjectAtIndex:(int)index;

- (float)maxValueOfGraphType:(GraphType) type;
- (float)minValueOfGraphType:(GraphType) type;

@optional

//FOR GRAPH TO RESPOND TO TOUCH EVENTS//

/** Gets called when the user starts touching the graph. The property 'enableTouchReport' must be set to YES.
 *  @param index   The closest index (X-axis) from the location the user is currently touching.
 */
- (void)didTouchGraphWithClosestIndex:(int)index;

/** Gets called when the user stops touching the graph.
 *  @param index   The closest index (X-axis) from the location the user last touched.
 */
- (void)didReleaseGraphWithClosestIndex:(float)index;

//TO SET UP THE X-AXIS SCALE//

/** The number of free space between labels on the X-axis to avoid overlapping.
 
 * @discussion For example returning '1' would mean that half of the labels on the X-axis are not displayed: the first is not displayed, the second is, the third is not etc. Returning '0' would mean that all of the labels will be displayed. Finally, returning a value equal to the number of labels will only display the first and last label.
 
 * @return The number of labels to "jump" between each displayed label on the X-axis.
 */
- (int)numberOfGapsBetweenLabels:(GraphType) type;

/** The string to display on the label on the X-axis at a given index. Please note that the number of strings to be returned should be equal to the number of points in the Graph.
 @param index    The index from left to right of a given label on the X-axis. Is the same index as the one for the points. The first value for the index is 0. */
- (NSString *)labelOnXAxisForIndex:(NSInteger)index WithTimeRange:(int) range;

@end

@interface StatsLineGraphView : UIView <StatsAnimationsDelegate, UIGestureRecognizerDelegate>

@property (assign) IBOutlet id <StatsLineGraphDelegate> delegate;

@property (strong, nonatomic) StatsAnimations *animationDelegate;

//@property (strong, nonatomic) UIView *verticalLine;
@property (strong, nonatomic) UIView *horizontalLine;

@property (strong, nonatomic) UIFont *labelFont;

/// Reload the graph, all delegate methods are called again and the graph is reloaded. Similar to calling reloadData on a UITableView.
- (void)reloadGraph;

//PROPERTIES TO CUSTOMIZE THE GRAPH//

// Graph type
@property (nonatomic) GraphType graphType;

// Speed of the animation when the graph appears. From 0 to 10, 0 meaning no animation, 1 very slow and 10 very fast. Default value is 5.
@property (nonatomic) NSInteger animationGraphEntranceSpeed;

// If set to yes, the graph will respond to touch events. The 2 methods above should therefore be implemented. Default value is NO.
@property (nonatomic) BOOL enableTouchReport;

// Color of the bottom part of the graph (between the line and the X-axis).
@property (strong, nonatomic) UIColor *colorBottom;

// Alpha of the bottom part of the graph (between the line and the X-axis).
@property (nonatomic) float alphaBottom;

// Color of the top part of the graph (between the line and the top of the view the graph is drawn in).
@property (strong, nonatomic) UIColor *colorTop;

// Alpha of the top part of the graph (between the line and the top of the view the graph is drawn in).
@property (nonatomic) float alphaTop;

// Color of the line of the graph.
@property (strong, nonatomic) UIColor *colorLine;

// Alpha of the line of the graph.
@property (nonatomic) float alphaLine;

// Width of the line of the graph. Default value is 1.0.
@property (nonatomic) float widthLine;

// Color of the label's text displayed on the X-Axis.
@property (strong, nonatomic) UIColor *colorXaxisLabel;

@property (strong,nonatomic) NSMutableArray *colorsOfGraph;
//add
@property (nonatomic) NSInteger itemCount;

@property (nonatomic, strong) NSMutableArray *allDotsPositionOfAllLines;

@end
