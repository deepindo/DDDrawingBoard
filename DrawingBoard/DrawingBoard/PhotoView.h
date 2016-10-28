//
//  PhotoView.h
//  DrawingBoard
//
//  Created by deepindo on 16/8/6.
//  Copyright © 2016年 deepindo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoView : UIView

@property(nonatomic,strong)UIImage *image;


@property(nonatomic,copy)void(^tempBlock)(UIImage *);



@end
