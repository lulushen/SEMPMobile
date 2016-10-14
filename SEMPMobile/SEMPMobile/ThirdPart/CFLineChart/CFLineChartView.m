//
//  CFLineChartView.m
//  CFLineChartDemo
//
//  Created by TheMoon on 16/3/24.
//  Copyright © 2016年 CFJ. All rights reserved.
//

#import "CFLineChartView.h"

static CGRect myFrame;
static int count;   // 点个数，x轴格子数
static int yCount;  // y轴格子数
static CGFloat everyX;  // x轴每个格子宽度
static CGFloat everyY;  // y轴每个格子高度
static CGFloat maxY;    // 最大的y值
static CGFloat allH;    // 整个图表高度
static CGFloat allW;    // 整个图表宽度
#define kMargin 30*KWidth6scale
@interface CFLineChartView ()

//@property (weak, nonatomic) IBOutlet UIView *bgView;

@end



@implementation CFLineChartView

+ (instancetype)lineChartViewWithFrame:(CGRect)frame{
   
    CFLineChartView *lineChartView = [[CFLineChartView alloc] init];
//    lineChartView.backgroundColor = [UIColor grayColor];
    lineChartView.frame = frame;
    
    myFrame = frame;

    return lineChartView;
}


#pragma mark - 计算

- (void)doWithCalculate{
    if (!self.xValues || !self.xValues.count || !self.yValues || !self.yValues.count) {
        return;
    }
    // 移除多余的值，计算点个数
    if (self.xValues.count > self.yValues.count) {
        NSMutableArray * xArr = [self.xValues mutableCopy];
        for (int i = 0; i < self.xValues.count - self.yValues.count; i++){
            [xArr removeLastObject];
        }
        self.xValues = [xArr mutableCopy];
    }else if (self.xValues.count < self.yValues.count){
        NSMutableArray * yArr = [self.yValues mutableCopy];
        for (int i = 0; i < self.yValues.count - self.xValues.count; i++){
            [yArr removeLastObject];
        }
        self.yValues = [yArr mutableCopy];
    }
    
    count = (int)self.xValues.count;
    
    everyX = (CGFloat)(CGRectGetWidth(myFrame) - kMargin * 2) / count;
    
    // y轴最多分5部分
    yCount = count <= 5 ? count : 5;
    
    everyY =  (CGRectGetHeight(myFrame) - kMargin * 2) / yCount;
    
    maxY = CGFLOAT_MIN;
    for (int i = 0; i < count; i ++) {
        if ([self.yValues[i] floatValue] > maxY) {
            maxY = [self.yValues[i] floatValue];
        }
    }
    
    allH = CGRectGetHeight(myFrame) - kMargin * 2;
    allW = CGRectGetWidth(myFrame) - kMargin * 2;
}

#pragma mark - 画X、Y轴
- (void)drawXYLine{
    
    UIBezierPath *path = [UIBezierPath bezierPath];

    [path moveToPoint:CGPointMake(kMargin, kMargin / 2.0 - 5)];
    
    [path addLineToPoint:CGPointMake(kMargin, CGRectGetHeight(myFrame) - kMargin)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)+ 5, CGRectGetHeight(myFrame) - kMargin)];
  
    
    // 加箭头
    [path moveToPoint:CGPointMake(kMargin - 5, kMargin/ 2.0 + 4)];
    [path addLineToPoint:CGPointMake(kMargin, kMargin / 2.0 - 4)];
    [path addLineToPoint:CGPointMake(kMargin + 5, kMargin/ 2.0 + 4)];
    
    [path moveToPoint:CGPointMake(CGRectGetWidth(myFrame) - 4, CGRectGetHeight(myFrame) - kMargin - 5)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame)  + 5, CGRectGetHeight(myFrame) - kMargin)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame) - 4, CGRectGetHeight(myFrame) - kMargin + 5)];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor grayColor].CGColor;
    // 起点与终点组成的面积颜色fillColor
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 1.0;
    [self.layer addSublayer:layer];
}

#pragma mark - 添加label
- (void)drawLabels{
    
    //Y轴
    for(int i = 0; i <= yCount; i ++){
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, kMargin  + everyY * i - everyY / 2, kMargin - 2, everyY)];
        lbl.textColor = [UIColor grayColor];
        lbl.font = [UIFont systemFontOfSize:11.0f];
        lbl.textAlignment = NSTextAlignmentRight;
        lbl.text = [NSString stringWithFormat:@"%d", (int)(maxY / yCount * (yCount - i)) ];
        UILabel *dianLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbl.frame) + 3, CGRectGetHeight(lbl.frame)/2.0, 2, 1)];
        dianLabel.backgroundColor = [UIColor grayColor];
        [lbl addSubview:dianLabel];
        [self addSubview:lbl];
    }
    
    // X轴
    for(int i = 1; i <= count; i ++){
     CGFloat width = everyX <= 80*KWidth6scale ? everyX: 80*KWidth6scale;
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(kMargin + everyX * i - 10 *KWidth6scale , CGRectGetHeight(myFrame) - kMargin, width, kMargin)];
        lbl.textColor = [UIColor grayColor];
        lbl.font = [UIFont systemFontOfSize:12];
        NSLog(@"-----%@",lbl);
        //lbl.backgroundColor = [UIColor brownColor];
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.text = [NSString stringWithFormat:@"%@", self.xValues[i - 1]];
        lbl.transform = CGAffineTransformMakeRotation(0.2);

        [self addSubview:lbl];
    }
    
}


#pragma mark - 画网格
- (void)drawLines{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 横线
    for (int i = 0; i < yCount; i ++) {
        [path moveToPoint:CGPointMake(kMargin , kMargin + everyY * i)];
        [path addLineToPoint:CGPointMake(kMargin + allW ,  kMargin + everyY * i)];
    }
    // 竖线
    for (int i = 1; i <= count; i ++) {
        [path moveToPoint:CGPointMake(kMargin + everyX * i, kMargin)];
        [path addLineToPoint:CGPointMake( kMargin + everyX * i,  kMargin + allH)];
    }
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor grayColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 0.5;
    [self.layer addSublayer:layer];
    
}


#pragma mark - 画点
- (void)drawPointsWithPointType:(PointType)pointType yValues:(NSMutableArray *)yValues{
    // 画点
    switch (pointType) {
        case PointType_Rect:
            
            for (int i = 0; i < count; i ++) {
                CGPoint point = CGPointMake(kMargin + everyX * (i + 1) , kMargin + (1 - [yValues[i] floatValue] / maxY ) * allH);
                CAShapeLayer *layer = [[CAShapeLayer alloc] init];
                layer.frame = CGRectMake(point.x - 2, point.y - 2, 4, 4);
                layer.backgroundColor = MoreButtonColor.CGColor;
                [self.layer addSublayer:layer];
            }
            break;
            
        case PointType_Circel:
            for (int i = 0; i < count; i ++) {
                CGPoint point = CGPointMake(kMargin + everyX * (i + 1) , kMargin + (1 - [yValues[i] floatValue] / maxY ) * allH);
                
                UIBezierPath *path = [UIBezierPath
                                      
                                      //    方法1                          bezierPathWithArcCenter:point radius:2.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
                                      
                                      //    方法2
                                      bezierPathWithRoundedRect:CGRectMake(point.x - 2, point.y - 2, 4, 4) cornerRadius:2];
                
                
                CAShapeLayer *layer = [CAShapeLayer layer];
                layer.path = path.CGPath;
                layer.strokeColor = MoreButtonColor.CGColor;
                //如果填充颜色相当于实心圆
                layer.fillColor = MoreButtonColor.CGColor;
                [self.layer addSublayer:layer];
            }

            break;
    }
}

#pragma mark - 画柱状图
- (void)drawPillarYvalues:(NSMutableArray*)yValue{
    
    for (int i = 0; i < count; i ++) {
      
        CGPoint point = CGPointMake(kMargin + everyX * (i + 1), kMargin + (1 - [yValue[i] floatValue] / maxY) * allH);
        
        
        CGFloat width = everyX <= 20*KWidth6scale ? 10*KWidth6scale: 20*KWidth6scale;
        
        CGRect rect = CGRectMake(point.x - width / 2, point.y, width, (CGRectGetHeight(myFrame) -  kMargin - point.y));
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.fillColor = [UIColor orangeColor].CGColor;
        
        [self.layer addSublayer:layer];

    }
    
}

#pragma mark - 画折线\曲线
- (void)drawFoldLineWithLineChartType:(LineChartType)type Yvalues:(NSMutableArray*)yValue{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // CGFloat allH = CGRectGetHeight(myFrame) - kMargin * 2;
    
    [path moveToPoint:CGPointMake(kMargin + everyX, kMargin + (1 - [yValue.firstObject floatValue] / maxY) * allH)];
    switch (type) {
        case LineChartType_Straight:
            for (int i = 1; i < count; i ++) {
                [path addLineToPoint:CGPointMake(kMargin + everyX * (i + 1), kMargin + (1 - [yValue[i] floatValue] / maxY) * allH)];
            }
            break;
        case LineChartType_Curve:
            
            for (int i = 1; i < count; i ++) {
        
                CGPoint prePoint = CGPointMake(kMargin + everyX * i, kMargin + (1 - [yValue[i-1] floatValue] / maxY) * allH);
                
                CGPoint nowPoint = CGPointMake(kMargin + everyX * (i + 1), kMargin + (1 - [yValue[i] floatValue] / maxY) * allH);
                
                // 两个控制点的两个x中点为X值，preY、nowY为Y值；
                
                [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            }
            break;
        
    }
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = MoreButtonColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:layer];
    
    // 画点
    [self drawPointsWithPointType:1 yValues:yValue];
}


#pragma mark - 显示数据
- (void)drawValues{
    for (int i = 0; i < count; i ++) {
        CGPoint nowPoint = CGPointMake(kMargin + everyX * (i + 1), kMargin + (1 - [self.yValues[i] floatValue] / maxY) * allH);
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(nowPoint.x - everyX/2.0-5, nowPoint.y - 20, everyX+10, 20)];
        lbl.textColor = [UIColor grayColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = [NSString stringWithFormat:@"%@",self.yValues[i]];
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.adjustsFontSizeToFitWidth = YES;
        [self addSubview:lbl];
    }
    
}

#pragma mark - 整合 画图表
- (void)drawChartWithLineChartType:(LineChartType)lineType pointType:(PointType) pointType{
    
    // 计算赋值
    [self doWithCalculate];
    
    NSArray *layers = [self.layer.sublayers mutableCopy];
    for (CAShapeLayer *layer in layers) {
        [layer removeFromSuperlayer];
    }

    
    // 画网格线
    if (self.isShowLine) {
         [self drawLines];
    }
    
    // 画X、Y轴
    [self drawXYLine];
    
    // 添加文字
    [self drawLabels];
    

    // 显示数据
    if(self.isShowValue){
        [self drawValues];
    }
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   
}

@end
