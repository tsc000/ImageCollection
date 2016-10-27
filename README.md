# ImageCollection
    这是一个选择图片并展示的一个自定义ScrollView,有兴趣的可以看一下，因为这个功能在工程中很常用，就分享了一下。 有见解就加QQ 767616124


![演示](https://github.com/tsc000/ImageCollection/blob/master/ImageCollection/1.gif)
![演示](https://github.com/tsc000/ImageCollection/blob/master/ImageCollection/2.png)

# 使用提示

    //创建一个属性保存
    @property (weak, nonatomic) ImageCollection *scrollView;
    
     ImageCollection *scrollView = [ImageCollectionimageCollection:CGRectMake(0, 100,self.view.frame.size.width, 0) ColumnCount:4 LimitCount:9 Delegate:self];
    
    self.scrollView = scrollView;
    
####     重要的代理方法

#####   选择图片点击代理事件，内可弹出第三方相册或相机选择图片
- (void)chooseImages;

#####pragma mark 删除某个位置上的图片
- (void)deleteImageAtIndex:(NSInteger)index;

#####pragma mark 已选择图片的点击事件，内可调用第三方图片预览框架

- (void)imageAtIndex:(NSInteger)index Images:(NSArray *)images ImageViews:(NSArray *)imageViews;


最后将选择的图片 

    self.scrollView.images = @[eight1]; //第四步 传入图片