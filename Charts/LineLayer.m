//
//  LineLayer.m
//  Charts
//
//  Created by RuanSTao on 15/7/17.
//  Copyright (c) 2015年 JJS-iMac. All rights reserved.
//

#import "LineLayer.h"
#import "ChartsView.h"
@interface LineLayer()
{
    CAGradientLayer *_gradientLayer;
}
@end

@implementation LineLayer

- (void) initWithSet:(LineChartDataSet *)lineSet
{
//    CAShapeLayer *self = [[CAShapeLayer alloc] init];
    self.fillColor = [UIColor clearColor].CGColor;
    self.strokeColor = lineSet.lineColor.CGColor;
    self.lineWidth = 1;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [lineSet.pointArray enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger idx, BOOL *stop) {
        CGPoint unTransformPoint = [value CGPointValue];
        CGPoint point = [self transformPoint:unTransformPoint];
        NSLog(@"x = %f , y = %f",point.x,point.y);
        CGFloat intensity = 0.3; //幅度
        
        if (idx == 0) {
            [path moveToPoint:point];
        }else if(idx == lineSet.pointArray.count - 1){
            CGPoint prevUnTransformPoint = [lineSet.pointArray[idx - 1] CGPointValue];
//            CGPoint prev = CGPointMake(prevUnTransformPoint.x * self.lineInterval , prevUnTransformPoint.y * Define_ChartsHeight);
            CGPoint prev = [self transformPoint:prevUnTransformPoint];
            CGFloat prevDx = (point.x - prev.x ) * intensity;
            CGFloat prevDy = (point.y - prev.y) * intensity;
            [path addQuadCurveToPoint:point controlPoint:CGPointMake(prev.x + prevDx, prev.y + prevDy)];
        }else{
            if (lineSet.drawCurveEnabled) {
                CGPoint prevUnTransformPoint = [lineSet.pointArray[idx - 1] CGPointValue];
//                CGPoint prev = CGPointMake(prevUnTransformPoint.x * self.lineInterval , prevUnTransformPoint.y * Define_ChartsHeight);
                CGPoint prev = [self transformPoint:prevUnTransformPoint];
                CGPoint nextUnTransformPoint = [lineSet.pointArray[idx + 1] CGPointValue];
//                CGPoint next = CGPointMake(nextUnTransformPoint.x * self.lineInterval , nextUnTransformPoint.y * Define_ChartsHeight);
                CGPoint next = [self transformPoint:nextUnTransformPoint];
                
                CGFloat prevDx = (point.x - prev.x ) * intensity;
                CGFloat prevDy = (point.y - prev.y) * intensity;
                CGFloat curDx = (next.x - point.x) * intensity;
                CGFloat curDy = (next.y - point.y) * intensity;
                [path addCurveToPoint:point controlPoint1:CGPointMake(prev.x + prevDx, prev.y + prevDy) controlPoint2:CGPointMake(point.x - curDx, point.y - curDy)];
                
            }else{
                [path addLineToPoint:point];
            }
        }
    }];
    if (lineSet.isDrawFilledEnabled) {
        if (_gradientLayer == nil) {
            _gradientLayer = [[CAGradientLayer alloc] init];
            [self setMask:_gradientLayer];
        }
        _gradientLayer.colors = @[(id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor];
        _gradientLayer.locations = @[@0.6,@1];
        //
        CGPoint firstPoint = [self transformPoint:[lineSet.pointArray.firstObject CGPointValue]];
        CGPoint lastPoint = [self transformPoint:[lineSet.pointArray.lastObject CGPointValue]];
        CGPoint maxPoint = [self maxHeightPoint:lineSet.pointArray];
        _gradientLayer.frame = CGRectMake(firstPoint.x, maxPoint.y, lastPoint.x, Define_TitleHeight + Define_ChartsHeight - maxPoint.y);
        
        
        [path addLineToPoint:CGPointMake(lastPoint.x, Define_TitleHeight + Define_ChartsHeight)];
        [path addLineToPoint:CGPointMake(firstPoint.x, Define_TitleHeight + Define_ChartsHeight)];
        [path closePath];
        self.fillColor = [[lineSet.lineColor colorWithAlphaComponent:0.2] CGColor];
        
    }
    self.path = path.CGPath;
//    [self.chartScrollView.layer addSublayer:layer];
}

- (CGPoint) transformPoint:(CGPoint) unTransformPoint
{
    CGFloat y = Define_ChartsHeight * 4.0f / 5.0f * unTransformPoint.y + Define_ChartsHeight / 5.0f + Define_TitleHeight;
    return CGPointMake(Define_X_PushOff + unTransformPoint.x * self.lineInterval , y);
}

- (CGPoint)maxHeightPoint:(NSArray *) dataArr
{
    __block CGPoint maxHeightPoint = CGPointZero;
    [dataArr enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL *stop) {
        CGPoint point = [obj CGPointValue];
        if (maxHeightPoint.y > point.y) {
            maxHeightPoint = point;
        }
    }];
    return maxHeightPoint;
}
@end