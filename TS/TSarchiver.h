//
//  TSNet.h
//  TS
//
//  Created by shg on 2021/2/5.
//  Copyright © 2021 GR. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSarchiver : NSObject

+ (void)ar:(NSArray *)arr;
+ (NSArray<NSDictionary<NSString *,NSString *> *> *)uar:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
