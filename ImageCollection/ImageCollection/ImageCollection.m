//
//  ImageCollection.m
//  grid
//
//  Created by tsc on 16/7/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ImageCollection.h"

#define MARGIN (10) //边距
#define WIDTH (self.frame.size.width)

#define ImageCollectionResourceName(file) [@"ImageCollection.bundle" stringByAppendingPathComponent:file]

@interface ImageCollection()
{
    CGFloat _width;     //宽（宽高相等）
    NSInteger _oldLine; //添加图片之前的行数
}

///存储所有图片,外部有一个与其对应的只读imageArray
@property (nonatomic, strong) NSMutableArray *imageArray;

///存储所有图片和一个按钮
@property (nonatomic, strong) NSMutableArray *imageViewArray;

@end

@implementation ImageCollection

- (void)setImages:(NSArray *)images {
    _images = images;
    
    [self.imageArray removeAllObjects];
    
    NSInteger count = self.imageViewArray.count;
    
    for (NSInteger i = 0; i < count - 1; i ++) {
        [self.imageViewArray[0] removeFromSuperview];
        
        [self.imageViewArray removeObjectAtIndex:0];
    }

    //遍历传过来的图片数组，添加到imageArray里并创建imageView添加到scrollview内
    [_images enumerateObjectsUsingBlock:^(UIImage *  _Nonnull img, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [self.imageArray insertObject:img atIndex:self.imageArray.count];
        
        [self createImageViewWithIdx:self.imageArray.count - 1];
        
        //判断图片是否超过设定数量
        if (self.imageViewArray.count > self.limitCount) {
            
            UIButton *button = [self.imageViewArray lastObject];
            
            button.hidden = true;

            *stop = true;
        }
    }];
    
    UIButton *button = [self.imageViewArray lastObject];
    
    NSInteger line = (self.imageViewArray.count - 1) / self.columnCount; //整行
    
    NSInteger column = (self.imageViewArray.count - 1) % self.columnCount;
    
    button.frame = CGRectMake(column * (_width + MARGIN) + MARGIN, MARGIN + line * (_width + MARGIN), _width, _width);

    
    if (button.isHidden == true && (self.imageViewArray.count - 1) % self.columnCount == 0 ) {
        _oldLine = self.imageViewArray.count/ self.columnCount ;
    }
    else
        _oldLine = self.imageViewArray.count/ self.columnCount + (self.imageViewArray.count % self.columnCount ? 1 : 0) ;
    
    //改变scrollview的frame
    [UIView animateWithDuration:.1 animations:^{

        self.contentSize = CGSizeMake(self.contentSize.width, (_width + MARGIN) * (_oldLine ) + MARGIN);
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (_width + MARGIN) * _oldLine + MARGIN);

    }];
    
//    self.contentSize = CGSizeMake(self.contentSize.width, (_width + MARGIN) * _oldLine + MARGIN);
//    
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (_width + MARGIN) * _oldLine + MARGIN);
}

- (void)setColumnCount:(NSInteger)columnCount{
    _columnCount = columnCount;
    
    [self changeFrame];
}

+ (instancetype)imageCollection:(CGRect)frame ColumnCount:(NSInteger)column LimitCount:(NSInteger)limit Delegate:(id)delegate {
    
    return [[self alloc] initWithFrame:frame ColumnCount:column LimitCount:limit Delegate:delegate];

}

- (instancetype)initWithFrame:(CGRect)frame ColumnCount:(NSInteger)count LimitCount:(NSInteger)limit Delegate:(id)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.customDelegate = delegate;
        
        if (count == 0) { //每列显示数量设置默认值
            self.columnCount = 0;
        }
        else
            self.columnCount = count;
        
        self.limitCount = limit; //图片限制数量
        
        [self initial];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {

    }
    return self;
}

- (void)initial {

    self.imageArray = [NSMutableArray array];
    
    self.imageViewArray = [NSMutableArray array];
    
    _oldLine = 1;
    
    _width = (WIDTH - (self.columnCount + 1) * MARGIN)/ self.columnCount;//每个图片的宽和高
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, WIDTH, _width + MARGIN * 2);
    
    UIButton *button = [self createButtonWithFrame:CGRectMake(MARGIN, MARGIN, _width, _width)];
    
    [self addSubview:button];
    
    [self.imageViewArray addObject:button]; //无图片显示一个button
}

- (UIImageView *)createImageViewWithIdx:(NSInteger )idx {
    
    NSInteger line = idx / self.columnCount;
    
    NSInteger column = idx % self.columnCount;
    
    CGRect frame = CGRectMake(column * (_width + MARGIN)+ MARGIN, MARGIN + line * (_width + MARGIN), _width, _width);
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    
    imgView.backgroundColor = [UIColor whiteColor];
    
    imgView.image = self.imageArray[idx];
    
    imgView.userInteractionEnabled = true;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    
    [imgView addGestureRecognizer:tap];

    
    //添加叉号按钮
    UIButton *close = [self createCrossButton];
    
    [self addSubview:imgView];
    
    [imgView addSubview:close];
    
    close.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:close attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imgView attribute:NSLayoutAttributeTop multiplier:1 constant:2];
    
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:close attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:imgView attribute:NSLayoutAttributeRight multiplier:1 constant:-2];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:close attribute:NSLayoutAttributeWidth relatedBy:0 toItem:imgView attribute:NSLayoutAttributeWidth multiplier:0 constant:20];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:close attribute:NSLayoutAttributeHeight relatedBy:0 toItem:imgView attribute:NSLayoutAttributeHeight multiplier:0 constant:20];

    [imgView addConstraints: @[top,right,width,height]];
    
    [self.imageViewArray insertObject:imgView atIndex:idx];
    
    return imgView;
}

///创建叉号按钮
- (UIButton *)createCrossButton{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(_width *0.7, 2, 20, 20);
    
    [btn setImage:[UIImage imageNamed:ImageCollectionResourceName(@"close")] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:ImageCollectionResourceName(@"closeax")] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(closeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

//创建加号按钮
- (UIButton *)createButtonWithFrame:(CGRect)frame{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = frame;

    [btn setImage:[UIImage imageNamed:ImageCollectionResourceName(@"btn_addphoto")] forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];

    return btn;
}

//加号按钮点击
- (void)buttonDidClick:(UIButton *)sender{
    
    if ([self.customDelegate respondsToSelector:@selector(chooseImages)]) {
        
        [self.customDelegate performSelector:@selector(chooseImages)];
    }
    
}

//点击图片
- (void)handleTapGesture:(UITapGestureRecognizer *)tap{

    UIImageView *view = (UIImageView *)tap.view;
    
    NSInteger index = [self.imageViewArray indexOfObject:view];
    
    if ([self.customDelegate respondsToSelector:@selector(imageAtIndex:Images:ImageViews:)]) {
        
        [self.customDelegate imageAtIndex:index Images:self.images ImageViews:self.imageViewArray];
    }
}
    
//叉号按钮点击
- (void)closeButtonDidClick:(UIButton *)sender{

    UIImageView *imgView = (UIImageView *)sender.superview;

    __block NSInteger index = 0;
    
    [self.imageViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj class] == [UIImageView class] && imgView == obj) {
            
            [self.imageViewArray removeObject:obj]; //移除控件
            
            [self.imageArray removeObjectAtIndex:idx];   //移除图片
            
            index = idx;
            
            *stop = YES;
        }
    }];
    
    [imgView removeFromSuperview];
    
    [self changeFrame];
    
    if ([self.customDelegate respondsToSelector:@selector(deleteImageAtIndex:)]) {
        
        [self.customDelegate deleteImageAtIndex:index];
    }

}

- (void)changeFrame {

    _width = (WIDTH - (self.columnCount + 1) * MARGIN)/ self.columnCount;//每个图片的宽和高
    
    //更改所有控件的frame
    [self.imageViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIView *view = (UIView *)obj;
        
        NSInteger line = idx / self.columnCount;
        
        NSInteger column = idx % self.columnCount;
        
        view.frame = CGRectMake(column * (_width + MARGIN)+ MARGIN, MARGIN + line * (_width + MARGIN), _width, _width);
        
        //先查找最后一个按钮，然后判断是图片是否填满
        if (idx == self.imageViewArray.count - 1) {
            
            if (self.imageViewArray.count > self.limitCount) {
                view.hidden = true;
            }
            else
                view.hidden = false;
        }
        
    }];
    
    UIButton *button = [self.imageViewArray lastObject];
    
    if (button.isHidden == true && (self.imageViewArray.count - 1) % self.columnCount == 0 ) {
        _oldLine = self.imageViewArray.count/ self.columnCount ;
    }
    else
        _oldLine = self.imageViewArray.count/ self.columnCount + (self.imageViewArray.count % self.columnCount ? 1 : 0) ;
    
    [UIView animateWithDuration:.1 animations:^{
        
        self.contentSize = CGSizeMake(self.contentSize.width, (_width + MARGIN) * _oldLine + MARGIN);
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (_width + MARGIN) * _oldLine + MARGIN);
        
    }];

}

@end
