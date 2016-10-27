//
//  ImageCollection.h
//  grid
//
//  Created by tsc on 16/7/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageCollectionDelegate <NSObject>

@optional

#pragma mark 选择图片点击代理事件
- (void)chooseImages;

#pragma mark 删除按钮点击代理事件
- (void)deleteImageAtIndex:(NSInteger)index;

#pragma mark 已有图片点击代理事件
/**
 *  已有图片点击代理事件
 *
 *  @param index      图片的位置
 *  @param images     所有展示的图片
 *  @param imageViews 展示图片的载体
 */
- (void)imageAtIndex:(NSInteger)index Images:(NSArray *)images ImageViews:(NSArray *)imageViews;

@end

@interface ImageCollection : UIScrollView

///自定义代理，ScrollView已经有delegate
@property (nonatomic, weak) id customDelegate;

///接收外界传过来的图片
@property (nonatomic, strong) NSArray *images;

///最多显示图片数量限制
@property (nonatomic, assign) NSInteger limitCount;

///每列显示图片数量
@property (nonatomic, assign) NSInteger columnCount;

///存储所有图片
@property (nonatomic, strong, readonly) NSMutableArray *imageArray;

+ (instancetype)imageCollection:(CGRect)frame ColumnCount:(NSInteger)column LimitCount:(NSInteger)limit Delegate:(id)delegate;

@end
