//
//  DrawView.h
//  DrawingBoard
//
//  Created by deepindo on 16/8/5.
//  Copyright © 2016年 deepindo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

//线宽
@property(nonatomic,assign)CGFloat lineWidth;


//线的颜色
@property(nonatomic,strong)UIColor *lineColor;


@property(nonatomic,strong)UIImage *image;


-(void)cleanTheDrawingBoard;

-(void)backToLastState;

-(void)eraserTheDrawingBoard;

-(void)saveCurrenCapture;



@end
