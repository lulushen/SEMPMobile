//
//  SDHuaBiView.m
//  SEMPMobile
//
//  Created by 上海数聚 on 16/7/18.
//  Copyright © 2016年 上海数聚. All rights reserved.
//

#import "SDHuaBiView.h"

@implementation SDHuaBiView{
    CGMutablePathRef path;//当前路径
    NSMutableArray *arr;//路径数组
    UIColor *_color;//当前路径颜色
    NSMutableArray *colors;//路径颜色数组
    NSMutableArray *fontSizes;//路径线宽数组
    UIView *selectView;//选项背景视图
    CGFloat _fontSize;//当前路径线宽
    //CGPoint sourceP;

}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        arr = [NSMutableArray arrayWithCapacity:1];

        _color = [UIColor blackColor];
        _fontSize = 1;
        
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_color setStroke];
    CGContextSetLineWidth(context, _fontSize);
    //CGContextSetRGBStrokeColor(context, <#CGFloat red#>, <#CGFloat green#>, <#CGFloat blue#>, 1.0)
    
    if (arr.count != 0) {//重绘数组中的线条
        for (int i = 0; i<arr.count; i++) {
            
            CGMutablePathRef p = (__bridge CGMutablePathRef)(arr[i]);
            CGContextAddPath(context, p);
            CGContextDrawPath(context, kCGPathStroke);
        }
    }
    if (path != nil) {//绘制当前线条
        //        [_color setStroke];
        //        CGContextSetLineWidth(context, _fontSize);
        
        CGContextAddPath(UIGraphicsGetCurrentContext(), path);
        CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathStroke);
        
    }
}
//触摸开始设置起始点
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    path = CGPathCreateMutable();
    
    CGPoint sourceP = [touch locationInView:self];
    CGPathMoveToPoint(path, NULL, sourceP.x, sourceP.y);
}
//移动画线
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    
    [self setNeedsDisplay];
    
    //添加到数组
    if (![arr containsObject:(__bridge id)(path)]) {
        [arr addObject:(__bridge id)(path)];
       
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //释放路径
    CGPathRelease(path);
    path = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
