//
//  PhotoView.m
//  DrawingBoard
//
//  Created by deepindo on 16/8/6.
//  Copyright © 2016年 deepindo. All rights reserved.
//

#import "PhotoView.h"

@interface PhotoView ()<UIGestureRecognizerDelegate>

@property(nonatomic,weak)UIImageView *imageView;

@end


@implementation PhotoView


//重写photoView的
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //实例化imageView
        UIImageView *imageView = [[UIImageView alloc]init];
        
        _imageView = imageView;
        
        [self addSubview:imageView];
        
        imageView.userInteractionEnabled = YES;
        
        
#pragma mark 添加手势
        //pan
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [imageView addGestureRecognizer:pan];
        
        
        //longPress
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress:)];
        
        [imageView addGestureRecognizer:longPress];
        
        //旋转
        UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotate:)];
        [imageView addGestureRecognizer:rotate];
        

        rotate.delegate = self;
            
        //缩放
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
        [imageView addGestureRecognizer:pinch];
        
    }
    return self;


}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;

}

//pan:拖拽
-(void)pan:(UIPanGestureRecognizer *)pan
{

    CGPoint panPoint = [pan locationInView:pan.view];
    
    //平移
    _imageView.transform = CGAffineTransformTranslate(_imageView.transform, panPoint.x, panPoint.y);
    
    //恢复
    [pan setTranslation:CGPointZero inView:pan.view];
    
    
}

//rotate:旋转
-(void)rotate:(UIRotationGestureRecognizer *)rotate
{
    _imageView.transform = CGAffineTransformRotate(_imageView.transform, rotate.rotation);
    
    //恢复为0
    rotate.rotation = 0;
    
}

//pinch:缩放
-(void)pinch:(UIPinchGestureRecognizer *)pinch
{
    _imageView.transform = CGAffineTransformScale(_imageView.transform, pinch.scale, pinch.scale);
    
    
    //恢复原倍数
    pinch.scale = 1;
    
    
}

//longpress:
-(void)longpress:(UILongPressGestureRecognizer *)longpress
{
    
    //长按的手势
    if (longpress.state == UIGestureRecognizerStateBegan) {
        
        //添加动画
        [UIView animateWithDuration:0.5 animations:^{
            
            _imageView.alpha = 0.5;
            
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                
                _imageView.alpha = 1;
                
            } completion:^(BOOL finished) {
                
                //开启图片上下文
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
                
                //获取图片上下文
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                
                //截图
                [self.layer renderInContext:context];
                
                
                //获取图片
                UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
                
                
                //关闭图片上下文
                UIGraphicsEndImageContext();
                
                
                //将最终获取到的图传给drawView
                if (_tempBlock)
                {
                    _tempBlock(clipImage);
                }
                
            }];
        }];
        
    }

}




//重写image的setter方法
-(void)setImage:(UIImage *)image
{
    _image = image;
    
    _imageView.image = image;
    
    _imageView.frame = CGRectMake(0, 0,image.size.width ,image.size.height );
    
    _imageView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);//相对于自身

}

@end
