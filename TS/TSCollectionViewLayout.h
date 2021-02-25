//
//  TSCollectionViewLayout.h
//  TS
//
//  Created by shg on 2021/2/23.
//  Copyright © 2021 GR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSCollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic,assign) CGFloat itemWith;
/**
 瀑布流布局方法

 @param itemWidth item 的宽度
@param itemHeightArray item 的高度数组
*/
- (void)flowLayoutWithItemWidth:(CGFloat)itemWidth itemHeightArray:(NSArray<NSNumber *> *)itemHeightArray;

@end

NS_ASSUME_NONNULL_END
