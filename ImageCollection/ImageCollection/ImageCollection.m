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

@interface ImageCollection()
{
    CGFloat _width;     //宽（宽高相等）
    NSInteger _oldLine; //添加图片之前的行数
}

//@property (nonatomic, assign) NSInteger columnCount;        //列数
@property (nonatomic, strong) NSMutableArray *imgArray;     //存储所有图片和一个按钮
@property (nonatomic, strong) NSMutableArray *imgViewArray; //存储所有图片

@end

@implementation ImageCollection

- (void)setImages:(NSArray *)images {
    _images = images;
    
    //遍历传过来的图片数组，添加到imgArray里并创建imageView添加到scrollview内
    [_images enumerateObjectsUsingBlock:^(UIImage *  _Nonnull img, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [self.imgArray insertObject:img atIndex:self.imgArray.count];
        
        [self createImageViewWithIdx:self.imgArray.count - 1];
        
        //判断图片是否超过设定数量
        if (self.imgViewArray.count > self.limitCount) {
            
            UIButton *button = [self.imgViewArray lastObject];
            
            [UIView animateWithDuration:.1 animations:^{
                button.hidden = true;
            }];
            
            *stop = true;
        }
    }];
    
    UIButton *button = [self.imgViewArray lastObject];
    
    NSInteger line = (self.imgViewArray.count - 1) / self.columnCount; //整行
    
    NSInteger column = (self.imgViewArray.count - 1) % self.columnCount;
    
    button.frame = CGRectMake(column * (_width + MARGIN) + MARGIN, MARGIN + line * (_width + MARGIN), _width, _width);
    
    //下面要判断达到限制的图片数量，加号按钮是否单独一行
    NSInteger currentLine = 0;
    if (button.isHidden == true && (self.imgViewArray.count - 1) % self.columnCount == 0 ) {
        currentLine = self.imgViewArray.count/ self.columnCount ;
    }
    else
        currentLine = self.imgViewArray.count/ self.columnCount + (self.imgViewArray.count % self.columnCount ? 1 : 0) ;
    
    //改变scrollview的frame
 
    [UIView animateWithDuration:.1 animations:^{

        self.contentSize = CGSizeMake(self.contentSize.width,  (_width + MARGIN) * (currentLine ) + MARGIN);
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.contentSize.height);

    }];

    //保存旧行数
    _oldLine = currentLine ;

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
        
        _width = (WIDTH - (self.columnCount + 1) * MARGIN)/ self.columnCount;//每个图片的宽和高
        
        _oldLine = 1;
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, WIDTH, _width + MARGIN * 2);
        
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

    self.imgArray = [NSMutableArray array];
    
    self.imgViewArray = [NSMutableArray array];
    
    UIButton *button = [self createButtonWithFrame:CGRectMake(MARGIN, MARGIN, _width, _width)];
    
    [self addSubview:button];
    
    [self.imgViewArray addObject:button]; //无图片显示一个button
}

- (UIImageView *)createImageViewWithIdx:(NSInteger )idx {
    
    NSInteger line = idx / self.columnCount;
    
    NSInteger column = idx % self.columnCount;
    
    CGRect frame = CGRectMake(column * (_width + MARGIN)+ MARGIN, MARGIN + line * (_width + MARGIN), _width, _width);
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    
    imgView.backgroundColor = [UIColor whiteColor];
    
    imgView.image = self.imgArray[idx];
    
    imgView.userInteractionEnabled = true;
    
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
    
    [self.imgViewArray insertObject:imgView atIndex:idx];
    
    return imgView;
}

//叉号按钮
- (UIButton *)createCrossButton{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(_width *0.7, 2, 20, 20);
    
    [btn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:@"closeax"] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(closeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

//加号按钮
- (UIButton *)createButtonWithFrame:(CGRect)frame{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = frame;

    [btn setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];

    return btn;
}

//加号按钮点击
- (void)buttonDidClick:(UIButton *)sender{
    
    if ([self.customDelegate respondsToSelector:@selector(plusClick)]) {
        
        [self.customDelegate performSelector:@selector(plusClick)];
    }
    
}

//叉号按钮点击
- (void)closeButtonDidClick:(UIButton *)sender{

    UIImageView *imgView = (UIImageView *)sender.superview;

    [self.imgViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj class] == [UIImageView class] && imgView == obj) {
            
            [self.imgViewArray removeObject:obj]; //移除控件
            
            [self.imgArray removeObjectAtIndex:idx];   //移除图片
            
            *stop = YES;
        }
    }];
    
    [imgView removeFromSuperview];
    
    [self changeFrame];
    
    if ([self.customDelegate respondsToSelector:@selector(crossClick)]) {
        
        [self.customDelegate performSelector:@selector(crossClick)];
    }

}

- (void)changeFrame {
    
    UIButton *button = [self.imgViewArray lastObject];

    if (button.isHidden == true && (self.imgViewArray.count - 1) % self.columnCount == 0 ) {
        _oldLine = self.imgViewArray.count/ self.columnCount ;
    }
    else
        _oldLine = self.imgViewArray.count/ self.columnCount + (self.imgViewArray.count % self.columnCount ? 1 : 0) ;

    _width = (WIDTH - (self.columnCount + 1) * MARGIN)/ self.columnCount;//每个图片的宽和高
    
    //更改所有控件的frame
    [self.imgViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIView *view = (UIView *)obj;
        
        NSInteger line = idx / self.columnCount;
        
        NSInteger column = idx % self.columnCount;
        
        view.frame = CGRectMake(column * (_width + MARGIN)+ MARGIN, MARGIN + line * (_width + MARGIN), _width, _width);
        
        //先查找最后一个按钮，然后判断是图片是否填满
        if (idx == self.imgViewArray.count - 1) {
            
            if (self.imgViewArray.count > self.limitCount) {
                view.hidden = true;
            }
            else
                view.hidden = false;
        }
        
    }];
    
    [UIView animateWithDuration:.1 animations:^{
        
        self.contentSize = CGSizeMake(self.contentSize.width, (_width + MARGIN) * _oldLine);
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (_width + MARGIN) * _oldLine + MARGIN);
        
    }];
}
@end
