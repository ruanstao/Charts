//
//  LineChartDataSet.h
//  Charts
//
//  Created by JJS-iMac on 15/7/14.
//  Copyright (c) 2015年 JJS-iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^clickIndex)(NSInteger index,CGPoint *point);

typedef NS_ENUM(NSUInteger, LineType) {
    Line_Price = 1,
    Line_Count,
};

@interface LineChartDataSet : NSObject

/**
 *  Line Data
 */
@property (nonatomic,strong) NSArray * pointArray;

/**
 *  Line Color
 */
@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *circleColor;
@property (nonatomic,strong) UIColor *circleHoleColor;
//@property (nonatomic,assign) CGFloat *circleRadius;

@property (nonatomic,assign) LineType lineType;
@property (nonatomic,assign) BOOL drawCirclesEnabled;
@property (nonatomic,assign) BOOL drawCurveEnabled;
@property (nonatomic,assign) BOOL drawCircleHoleEnabled;


@property (nonatomic, assign) BOOL isDrawFilledEnabled;

@end
