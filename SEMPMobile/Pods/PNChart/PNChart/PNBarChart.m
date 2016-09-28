//
//  PNBarChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNBarChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"

@interface PNBarChart () {
    NSMutableArray *_xChartLabels;
    NSMutableArray *_yChartLabels;
}

- (UIColor *)barColorAtIndex:(NSUInteger)index;

@property (nonatomic , strong)UIImageView * lineImage;
@end

@implementation PNBarChart

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self setupDefaultValues];
    }

    return self;
}

- (void)setupDefaultValues
{
    [super setupDefaultValues];
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds   = YES;
    _showLabel           = YES;
    _showYGridLines      = YES;
    _barBackgroundColor  = PNLightGrey;
    _labelTextColor      = [UIColor grayColor];
    _labelFont           = [UIFont systemFontOfSize:14.0f];
    _xChartLabels        = [NSMutableArray array];
    _yChartLabels        = [NSMutableArray array];
    _bars                = [NSMutableArray array];
    _xLabelSkip          = 1;
    // 原来4 改成5
    _yLabelSum           = 5;
    _labelMarginTop      = 0;
    _chartMarginLeft     = 25.0;
    _chartMarginRight    = 25.0;
    _chartMarginTop      = 25.0;
    _chartMarginBottom   = 25.0;
    _barRadius           = 2.0;
    _showChartBorder     = NO;
    _chartBorderColor    = PNLightGrey;
    _showLevelLine       = NO;
    _yChartLabelWidth    = 25;
    _rotateForXAxisText  = false;
    _isGradientShow      = YES;
    _isShowNumbers       = YES;
    _yLabelPrefix        = @"";
    _yLabelSuffix        = @"";
    _lineImage           = [[UIImageView alloc] init];
	_yLabelFormatter = ^(CGFloat yValue){
		return [NSString stringWithFormat:@"%1.f",yValue];
	};
}

- (void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
  //make the _yLabelSum value dependant of the distinct values of yValues to avoid duplicates on yAxis

  if (_showLabel) {
      
    [self __addYCoordinateLabelsValues];
      
      
  } else {
    [self processYMaxValue];
  }
}

- (void)processYMaxValue {
    NSArray *yAxisValues = _yLabels ? _yLabels : _yValues;
    
    _yLabelSum = _yLabels ? _yLabels.count - 1 :_yLabelSum;
    
    if (_yMaxValue) {
        _yValueMax = _yMaxValue;
    } else {
        [self getYValueMax:yAxisValues];
    }
    
  // 原来的
//    if (_yLabelSum==4) {
//        _yLabelSum = yAxisValues.count;
//        NSLog(@"-====_yLabelSum--%ld",_yLabelSum);
//
//        (_yLabelSum % 2 == 0) ? _yLabelSum : _yLabelSum++;
//        
//        NSLog(@"-===fff=_yLabelSum--%ld",_yLabelSum);
//
//    }
    // ylabel始终都是5个
}

#pragma mark - Private Method
#pragma mark - Add Y Label
- (void)__addYCoordinateLabelsValues{
    

  [self viewCleanupForCollection:_yChartLabels];

  [self processYMaxValue];

  float sectionHeight = (self.frame.size.height - _chartMarginTop - _chartMarginBottom - kXLabelHeight) / _yLabelSum;

  for (int i = 0; i <= _yLabelSum; i++) {
    NSString *labelText;

      
    if (_yLabels) {
      float yAsixValue = [_yLabels[_yLabels.count - i - 1] floatValue];
      labelText= _yLabelFormatter(yAsixValue);
    } else {
      labelText = _yLabelFormatter((float)_yValueMax *  (_yLabelSum - i) / (float)_yLabelSum );
    }

    PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:CGRectZero];
    label.textColor = _labelTextColor;
    [label setTextAlignment:NSTextAlignmentRight];
    label.font = _labelFont;
//    label.text = [NSString stringWithFormat:@"%@%@%@", _yLabelPrefix, labelText, _yLabelSuffix];
    label.text = [NSString stringWithFormat:@"%@%@", _yLabelPrefix, labelText];

    [self addSubview:label];
    CGRect rectLabel = [label.text boundingRectWithSize:CGSizeMake(_xLabelWidth*2, 80) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:label.font} context:nil];
      
      
    label.frame = (CGRect){0, sectionHeight * i + _chartMarginTop - kYLabelHeight/2.0, _yChartLabelWidth , kYLabelHeight};
      if (_yChartLabelWidth < rectLabel.size.width) {
         label.frame = (CGRect){0, sectionHeight * i + _chartMarginTop - kYLabelHeight/2.0, _yChartLabelWidth , kYLabelHeight * 2};
      }
    [_yChartLabels addObject:label];
      
  }
}

-(void)updateChartData:(NSArray *)data{
    self.yValues = data;
    [self updateBar];
}

- (void)getYValueMax:(NSArray *)yLabels
{
    CGFloat max = [[yLabels valueForKeyPath:@"@max.floatValue"] floatValue];

    //ensure max is even
   _yValueMax = max ;
// 原来的
//    if (_yValueMax == 0) {
//        _yValueMax = _yMinValue;
//    }
    // 改动的
    if (_yValueMax < 5) {
        _yValueMax = 5.0f;
        if (_yValueMax == 0) {
        _yValueMax = _yMinValue;
            
        }
    }
}

- (void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;

    if (_xChartLabels) {
        [self viewCleanupForCollection:_xChartLabels];
    }else{
        _xChartLabels = [NSMutableArray new];
    }

	_xLabelWidth = (self.frame.size.width - _chartMarginLeft - _chartMarginRight) / [xLabels count];

    if (_showLabel) {
        int labelAddCount = 0;
        for (int index = 0; index < _xLabels.count; index++) {
            labelAddCount += 1;

            if (labelAddCount == _xLabelSkip) {
                NSString *labelText = [_xLabels[index] description];
                // 原来的
//                PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0, 0, _xLabelWidth, kXLabelHeight)];
                PNChartLabel * label = [[PNChartLabel alloc] init];
                
            
                label.font = _labelFont;
                label.textColor = _labelTextColor;

                [label setTextAlignment:NSTextAlignmentCenter];
                label.text = labelText;
                CGRect rectLabel = [label.text boundingRectWithSize:CGSizeMake(_xLabelWidth*2, 80) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:label.font} context:nil];
                
                
                label.frame =CGRectMake(0, 0, (NSInteger) rectLabel.size.width, rectLabel.size.height);
                
                

//                [label sizeToFit];
                CGFloat labelXPosition;
                if (_rotateForXAxisText){
                    label.transform = CGAffineTransformMakeRotation(M_PI / 4);
                    labelXPosition = (index *  _xLabelWidth + _chartMarginLeft + _xLabelWidth /1.5);
                }
                else{
                    labelXPosition = (index *  _xLabelWidth + _chartMarginLeft + _xLabelWidth /2.0 );
                }
                label.center = CGPointMake(labelXPosition,
                                           self.frame.size.height - kXLabelHeight - _chartMarginTop + label.frame.size.height /2.0 + _labelMarginTop);
                labelAddCount = 0;
                
                //label的倾斜角度 原来没有倾斜
                label.transform = CGAffineTransformMakeRotation(0.25);
                //  因为角度发生改变所以xy也发生改变，为了不使label位置变化，所以在旋转后重新赋值label的位置
                CGPoint rect = label.center;
                rect.x = label.center.x;
                label.center = rect;
                
                

                [_xChartLabels addObject:label];
                [self addSubview:label];
            }
        }
    }
}


- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
}

- (void)updateBar
{

    //Add bars
    CGFloat chartCavanHeight = self.frame.size.height - _chartMarginTop - _chartMarginBottom - kXLabelHeight;
    NSInteger index = 0;

    for (NSNumber *valueString in _yValues) {

        PNBar *bar;

        if (_bars.count == _yValues.count) {
            bar = [_bars objectAtIndex:index];
        }else{
            CGFloat barWidth;
            CGFloat barXPosition;

            if (_barWidth) {
                barWidth = _barWidth;
                barXPosition = index *  _xLabelWidth + _chartMarginLeft + _xLabelWidth /2.0 - _barWidth /2.0;
            }else{
                barXPosition = index *  _xLabelWidth + _chartMarginLeft + _xLabelWidth * 0.25;
                if (_showLabel) {
                    barWidth = _xLabelWidth * 0.5;

                }
                else {
                    barWidth = _xLabelWidth * 0.6;

                }
            }

            bar = [[PNBar alloc] initWithFrame:CGRectMake(barXPosition, //Bar X position
                                                          self.frame.size.height - chartCavanHeight - kXLabelHeight - _chartMarginBottom + _chartMarginTop , //Bar Y position
                                                          barWidth, // Bar witdh
                                                          self.showLevelLine ? chartCavanHeight/2.0:chartCavanHeight)]; //Bar height

            //Change Bar Radius
            bar.barRadius = _barRadius;
            
            //Set Bar Animation
            bar.displayAnimated = self.displayAnimated;

            //Change Bar Background color
            bar.backgroundColor = _barBackgroundColor;
            //Bar StrokColor First
            if (self.strokeColor) {
                bar.barColor = self.strokeColor;
            }else{
                bar.barColor = [self barColorAtIndex:index];
            }
            
            if (self.labelTextColor) {
                bar.labelTextColor = self.labelTextColor;
            }

            // Add gradient
            if (self.isGradientShow) {
             bar.barColorGradientStart = bar.barColor;
            
            }

            //For Click Index
            bar.tag = index;

            [_bars addObject:bar];
            [self addSubview:bar];
        }

        //Height Of Bar
        float value = [valueString floatValue];
        float grade =fabsf((float)value / (float)_yValueMax);

        if (isnan(grade)) {
            grade = 0;
        }
        bar.maxDivisor = (float)_yValueMax;
        bar.grade = grade;
        bar.isShowNumber = self.isShowNumbers;
        CGRect originalFrame = bar.frame;
        NSString *currentNumber =  [NSString stringWithFormat:@"%f",value];

        if ([[currentNumber substringToIndex:1] isEqualToString:@"-"] && self.showLevelLine) {
        CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI);
        [bar setTransform:transform];
        originalFrame.origin.y = bar.frame.origin.y + bar.frame.size.height;
        bar.frame = originalFrame;
        bar.isNegative = YES;

      }
      index += 1;
    }
}

- (void)strokeChart
{
    //Add Labels

    [self viewCleanupForCollection:_bars];


    //Update Bar

    [self updateBar];

    //Add chart border lines

    if (_showChartBorder) {
        _chartBottomLine = [CAShapeLayer layer];
        _chartBottomLine.lineCap      = kCALineCapButt;
        _chartBottomLine.fillColor    = [[UIColor whiteColor] CGColor];
        //原来是1
        _chartBottomLine.lineWidth    = 2.0;
        _chartBottomLine.strokeEnd    = 0.0;

        UIBezierPath *progressline = [UIBezierPath bezierPath];

        [progressline moveToPoint:CGPointMake(_chartMarginLeft, self.frame.size.height - kXLabelHeight - _chartMarginBottom + _chartMarginTop)];
        [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartMarginRight,  self.frame.size.height - kXLabelHeight - _chartMarginBottom + _chartMarginTop)];
       //原来是1
        [progressline setLineWidth:2.0];
        [progressline setLineCapStyle:kCGLineCapSquare];
        _chartBottomLine.path = progressline.CGPath;
        _chartBottomLine.strokeColor = [_chartBorderColor CGColor];
        // 原来1
        _chartBottomLine.strokeEnd = 1.0;

        [self.layer addSublayer:_chartBottomLine];

        //Add left Chart Line

        _chartLeftLine = [CAShapeLayer layer];
        _chartLeftLine.lineCap      = kCALineCapButt;
        _chartLeftLine.fillColor    = [[UIColor whiteColor] CGColor];
        //原来1
        _chartLeftLine.lineWidth    = 2.0;
        _chartLeftLine.strokeEnd    = 0.0;

        UIBezierPath *progressLeftline = [UIBezierPath bezierPath];

        [progressLeftline moveToPoint:CGPointMake(_chartMarginLeft, self.frame.size.height - kXLabelHeight - _chartMarginBottom + _chartMarginTop)];
        [progressLeftline addLineToPoint:CGPointMake(_chartMarginLeft,  _chartMarginTop)];

        [progressLeftline setLineWidth:1.0];
        [progressLeftline setLineCapStyle:kCGLineCapSquare];
        _chartLeftLine.path = progressLeftline.CGPath;
        _chartLeftLine.strokeColor = [_chartBorderColor CGColor];
        _chartLeftLine.strokeEnd = 1.0;

        [self addBorderAnimationIfNeeded];
        [self.layer addSublayer:_chartLeftLine];
     
    }

  // Add Level Separator Line
  if (_showLevelLine) {
    _chartLevelLine = [CAShapeLayer layer];
    _chartLevelLine.lineCap      = kCALineCapButt;
    _chartLevelLine.fillColor    = [[UIColor whiteColor] CGColor];
    _chartLevelLine.lineWidth    = 1.0;
    _chartLevelLine.strokeEnd    = 0.0;

    UIBezierPath *progressline = [UIBezierPath bezierPath];

    [progressline moveToPoint:CGPointMake(_chartMarginLeft, (self.frame.size.height - kXLabelHeight )/2.0)];
    [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartMarginLeft - _chartMarginRight,  (self.frame.size.height - kXLabelHeight )/2.0)];

    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
    _chartLevelLine.path = progressline.CGPath;

    _chartLevelLine.strokeColor = PNLightGrey.CGColor;
      
    [self addSeparatorAnimationIfNeeded];
    _chartLevelLine.strokeEnd = 1.0;

    [self.layer addSublayer:_chartLevelLine];
  } else {
    if (_chartLevelLine) {
      [_chartLevelLine removeFromSuperlayer];
      _chartLevelLine = nil;
    }
  }
}

- (void)addBorderAnimationIfNeeded
{
    if (self.displayAnimated) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue = @1.0f;
        [_chartBottomLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        CABasicAnimation *pathLeftAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathLeftAnimation.duration = 0.5;
        pathLeftAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathLeftAnimation.fromValue = @0.0f;
        pathLeftAnimation.toValue = @1.0f;
        [_chartLeftLine addAnimation:pathLeftAnimation forKey:@"strokeEndAnimation"];
    }
}

- (void)addSeparatorAnimationIfNeeded
{
    if (self.displayAnimated) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue = @1.0f;
        [_chartLevelLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    }
}

- (void)viewCleanupForCollection:(NSMutableArray *)array
{
    if (array.count) {
        [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [array removeAllObjects];
    }
}


#pragma mark - Class extension methods

- (UIColor *)barColorAtIndex:(NSUInteger)index
{
    if ([self.strokeColors count] == [self.yValues count]) {
        return self.strokeColors[index];
    }
    else {
        return self.strokeColor;
    }
}

#pragma mark - Touch detection

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    [self touchPoint:touches withEvent:event];
}

- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIView *subview = [self hitTest:touchPoint withEvent:nil];


    if ([subview isKindOfClass:[PNBar class]] && [self.delegate respondsToSelector:@selector(userClickedOnBarAtIndex:)]) {
        [self.delegate userClickedOnBarAtIndex:subview.tag];
        CGFloat chartCavanHeight = self.frame.size.height - _chartMarginTop - _chartMarginBottom;
        PNBar * bar = _bars[subview.tag];
        
        
        _lineImage.frame = CGRectMake(bar.frame.origin.x + bar.frame.size.width/2.0, _chartMarginTop, 2, chartCavanHeight - _chartMarginBottom - kYLabelHeight/2.0);
        
        _lineImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yline.png"]];
        [self addSubview:_lineImage];
        
    
    }
}
#warning ======添加的方法
#define IOS7_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGFloat yAxisOffset = 10.f;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    
    
    UIFont *font = [UIFont systemFontOfSize:11];
   
    // draw y unit
//    if ([self.yUnit length]) {
//        CGFloat height = [PNBarChart sizeOfString:self.yUnit withWidth:30.f font:font].height;
//        
//        CGRect drawRect = CGRectMake(_chartMarginLeft + 10 + 5, 0, 30.f, height);
//        //原来的[self drawTextInContext:ctx text:self.yUnit inRect:drawRect font:font];
//        //改变的
//        [self drawTextInContext:ctx text:self.yUnit inRect:drawRect font:font color:_yUnitColor];
//        
//    }
//    
    // draw x unit
//    if ([self.xUnit length]) {
//        CGFloat height = [PNBarChart sizeOfString:self.xUnit withWidth:30.f font:font].height;
//        CGRect drawRect = CGRectMake(CGRectGetWidth(rect) - _chartMarginLeft + 5, _chartMarginBottom + _chartCavanHeight - height / 2, 25.f, height);
//        //原来的 [self drawTextInContext:ctx text:self.xUnit inRect:drawRect font:font];
//        // 改变的
//        [self drawTextInContext:ctx text:self.xUnit inRect:drawRect font:font color:_xUnitColor];
//    }
    CGFloat chartCavanHeight = self.frame.size.height - _chartMarginTop - _chartMarginBottom - kXLabelHeight;
    if (self.showYGridLines) {
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
//        CGFloat yAxisOffset = _showLabel ? 10.f : 0.0f;
        CGPoint point;
        // 有改动－－原来的是         CGFloat yStepHeight = _chartCavanHeight / _yLabelNum;
        
        CGFloat yStepHeight = (chartCavanHeight) / _yLabelSum;
        if (self.yGridLinesColor) {
            CGContextSetStrokeColorWithColor(ctx, self.yGridLinesColor.CGColor);
        } else {
            CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
        }
        // 有改动－－原来是 i < _yLabelNum
        for (NSUInteger i = 0; i < _yLabelSum + 1; i++) {
            if (i!=0) {
                point = CGPointMake(_chartMarginLeft, (chartCavanHeight - i * yStepHeight) + kYLabelHeight/2.0);
                CGContextMoveToPoint(ctx, point.x, point.y);
                // add dotted style grid
                CGFloat dash[] = {6, 5};
                // dot diameter is 20 points
                CGContextSetLineWidth(ctx, 1);
                CGContextSetLineCap(ctx, kCGLineCapRound);
                CGContextSetLineDash(ctx, 0.0, dash, 2);
                CGContextAddLineToPoint(ctx,self.frame.size.width - _chartMarginRight , point.y);
                CGContextStrokePath(ctx);
            }
 
        }
        
    }
   
}

#pragma mark - tools

+ (CGSize)sizeOfString:(NSString *)text withWidth:(float)width font:(UIFont *)font {
    CGSize size = CGSizeMake(width, MAXFLOAT);
    
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        size = [text boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:tdic
                                  context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    }
    
    return size;
}
- (void)drawTextInContext:(CGContextRef)ctx text:(NSString *)text inRect:(CGRect)rect font:(UIFont *)font color : (UIColor*)color{
    if (IOS7_OR_LATER) {
        NSMutableParagraphStyle *priceParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        priceParagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        priceParagraphStyle.alignment = NSTextAlignmentLeft;
        
        [text drawInRect:rect
          withAttributes:@{NSParagraphStyleAttributeName : priceParagraphStyle, NSForegroundColorAttributeName: color, NSFontAttributeName : font}];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [text drawInRect:rect
                withFont:font
           lineBreakMode:NSLineBreakByTruncatingTail
               alignment:NSTextAlignmentLeft];
#pragma clang diagnostic pop
    }
    
}


@end
