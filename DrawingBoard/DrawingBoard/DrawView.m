//
//  DrawView.m
//  DrawingBoard
//
//  Created by deepindo on 16/8/5.
//  Copyright © 2016年 deepindo. All rights reserved.
//

#import "DrawView.h"
#import "DDBezierPath.h"




@interface DrawView ()

//定义一个全局的上下文
@property(nonatomic,strong)UIBezierPath *bezierPath;

//定义一个全局数组保存路径
@property(nonatomic,strong)NSMutableArray *pathArray;



@end

@implementation DrawView

#pragma mark --懒加载
-(NSMutableArray *)pathArray
{
    if (nil == _pathArray)
    {
        _pathArray = [NSMutableArray array];
    }
    return _pathArray;
}


#pragma mark --开始触控
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //实例化一个bezier对象
    DDBezierPath *bezierPath = [DDBezierPath bezierPath];
    _bezierPath = bezierPath;

    bezierPath.lineColor = _lineColor;
    
    bezierPath.lineWidth = _lineWidth ? _lineWidth : 1;
    [bezierPath setLineCapStyle:kCGLineCapRound];
    
    //获取touch
    UITouch *touch = touches.anyObject;
    
    //touchPoint
    CGPoint touchPoint = [touch locationInView:touch.view];
    
    
    //设置起点
    [bezierPath moveToPoint:touchPoint];
    
    [self.pathArray addObject:_bezierPath];
}

#pragma mark --触控移动中
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取touch
    UITouch *touch = touches.anyObject;
    
    //touchPoint
    CGPoint touchPoint = [touch locationInView:touch.view];
    
    
    //添加线
    [_bezierPath addLineToPoint:touchPoint];
    
    [self setNeedsDisplay];

}


#pragma mark --back的方法
-(void)backToLastState
{
    [self.pathArray removeLastObject];
    
    [self setNeedsDisplay];

}


#pragma mark --clean的方法
-(void)cleanTheDrawingBoard
{
    [self.pathArray removeAllObjects];
    
    [self setNeedsDisplay];
}


#pragma mark --eraser方法
-(void)eraserTheDrawingBoard
{
    _lineColor = self.backgroundColor;
    
    [self setNeedsDisplay];

}

#pragma mark --保存截图的方法
-(void)saveCurrenCapture
{

    //开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    
    //获取当前图片的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //截图
    [self.layer renderInContext:context];
    
    //获取图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();

    
    //关闭图片上下文
    UIGraphicsEndImageContext();
    
    //重绘
    [self setNeedsDisplay];
    
    
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(clipImage, nil, nil, nil);

}

-(void)setImage:(UIImage *)image
{
    //拿到photoView的截图,赋值
    _image = image;
    
    
 /**
    //开启图片上下
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    
    //获取图片上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [image drawAtPoint:CGPointZero];
    
    //结束图片上下文
    UIGraphicsEndImageContext();
   */
    
    //下面开始画图
    DDBezierPath *path = [DDBezierPath bezierPath];
    //    //整个photoView是一张图,且frame与drawView相同,所以从0点开始画
    //    [image drawAtPoint:CGPointZero];
    //    [path.fill];
    
    //为bezierPath的image属性赋值,和color一样,就可以带到数组去了
    path.image = image;
    
    
    //将图也要添加到数组
    [self.pathArray addObject:path];
    
    //重绘
    [self setNeedsDisplay];

}

#pragma mark --绘图
-(void)drawRect:(CGRect)rect
{
    for (DDBezierPath *Path in self.pathArray)
    {
        
        if (Path.image)
        {
            [Path.image drawAtPoint:CGPointZero];
            
            [self setNeedsDisplay];
        }
        else
        {
        
            [Path.lineColor set];
            
            [Path stroke];
        
        }
        //渲染
    }

}

@end
