//
//  ImageCollection.h
//  grid
//
//  Created by tsc on 16/7/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageCollectionDelegate <NSObject>

- (void)plusClick;

@optional
- (void)crossClick;

@end

@interface ImageCollection : UIScrollView

@property (nonatomic, weak) id customDelegate;          //自定义代理，ScrollView已经有delegate
@property (nonatomic, strong) NSArray *images;          //接收外界传过来的图片
@property (nonatomic, assign) NSInteger limitCount;     //最多显示图片数量限制
@property (nonatomic, assign) NSInteger columnCount;    //每列显示图片数量

+ (instancetype)imageCollection:(CGRect)frame ColumnCount:(NSInteger)column LimitCount:(NSInteger)limit Delegate:(id)delegate;

@end
