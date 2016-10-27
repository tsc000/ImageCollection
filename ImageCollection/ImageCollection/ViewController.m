//
//  ViewController.m
//  ImageCollection
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "ImageCollection.h"

@interface ViewController ()
<
ImageCollectionDelegate //第二步遵守协议
>

@property (weak, nonatomic) ImageCollection *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //第一步创建对象
    ImageCollection *scrollView = [ImageCollection imageCollection:CGRectMake(0, 100, self.view.frame.size.width, 0) ColumnCount:4 LimitCount:9 Delegate:self];
    
    self.scrollView = scrollView;
    
    [self.view addSubview:scrollView];
    
    scrollView.backgroundColor = [UIColor blackColor];
}

//第三步 实现代理方法，

- (void)chooseImages {
    UIImage *eight1 = [UIImage imageNamed:@"2"];
    UIImage *eight = [UIImage imageNamed:@"23"];
    self.scrollView.images = @[eight1,eight,eight1,eight,eight1,eight,eight1]; //第四步 传入图片
}

- (void)imageAtIndex:(NSInteger)index Images:(NSArray *)images ImageViews:(NSArray *)imageViews {

}

- (void)deleteImageAtIndex:(NSInteger)index{
    
    
}

- (IBAction)five:(UIButton *)sender {
    
    switch (sender.tag) {
        case 3:
            self.scrollView.columnCount = sender.tag;
            break;
        case 4:
            self.scrollView.columnCount = sender.tag;
            break;
        case 5:
            self.scrollView.columnCount = sender.tag;
            break;
        case 6:
            self.scrollView.columnCount = sender.tag;
            break;
        default:
            break;
    }
    
}
@end
