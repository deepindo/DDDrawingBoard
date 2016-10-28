//
//  ViewController.m
//  DrawingBoard
//
//  Created by deepindo on 16/8/5.
//  Copyright © 2016年 deepindo. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"
#import "PhotoView.h"


@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//绘画view
@property (weak, nonatomic) IBOutlet DrawView *drawView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

#pragma mark --items的点击事件方法
/**
 *  颜色选择
 */
- (IBAction)colorSelect:(UIButton *)sender
{
    _drawView.lineColor = sender.backgroundColor;
    
}

/**
 *  slider的value改变监听方法
 */
- (IBAction)valueChangeSlider:(UISlider *)sender
{
    _drawView.lineWidth = sender.value;
    
}

/**
 *  返回上一次的状态
 */
- (IBAction)backItem:(id)sender
{
    [_drawView backToLastState];
    
}

/**
 *  清屏item
 */
- (IBAction)cleanItem:(id)sender
{
    [_drawView cleanTheDrawingBoard];
    
}

/**
 *  擦除
 */
- (IBAction)eraserItem:(id)sender
{
    
    [_drawView eraserTheDrawingBoard];
    
}

/**
 保存当前截图
 */
- (IBAction)saveItem:(id)sender
{
    
    [_drawView saveCurrenCapture];
}

/**
 点击相册
 */
- (IBAction)album:(id)sender
{
    //实例化一个imagePicker
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    
    //设置图片的数据源类型
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    //设置当前控制器为imagePicker的代理对象
    imagePickerController.delegate = self;
    
    //跳转到imagePicker控制器
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}


#pragma mark --执行相册的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    NSLog(@"%@",info);
    
    //获取选中的照片
    UIImage *selectImage = info[@"UIImagePickerControllerOriginalImage"];
    
    
    //将图赋值给自定义photoView类
     PhotoView *photoView = [[PhotoView alloc]initWithFrame:_drawView.frame];
    
    //将选中的照片赋值
   photoView.image = selectImage;

    //将photoView添加到对应的控件
    [self.view addSubview:photoView];
    
    __weak PhotoView *weakPhotoView = photoView;
    
    photoView.tempBlock = ^(UIImage *clipImage){
        
        _drawView.image = clipImage;
        
       // __weak photoView;
        
        [weakPhotoView removeFromSuperview];
        
    
    };
//    [photoView removeFromSuperview];
    
    //拿到选中照片后,回到控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}



@end
