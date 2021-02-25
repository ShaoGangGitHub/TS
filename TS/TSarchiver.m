//
//  TSNet.m
//  TS
//
//  Created by shg on 2021/2/5.
//  Copyright © 2021 GR. All rights reserved.
//

#import "TSarchiver.h"

@implementation TSarchiver

+ (void)ar:(NSArray *)arr
{
//    NSError *err;
//    [NSKeyedArchiver archivedDataWithRootObject:arr requiringSecureCoding:YES error:&err];
//    if (err) {
//        NSLog(@"%@",err);
//    }
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"hisData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)uar:(NSArray *)arr
{
//    NSData *data = [NSData dataWithContentsOfFile:[self path]];
//    return [NSKeyedUnarchiver unarchivedObjectOfClass:arr.class fromData:data error:nil];
    NSArray *arrhis = [[NSUserDefaults standardUserDefaults] objectForKey:@"hisData"];
    return arrhis;
}

+ (NSString *)path
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docPath stringByAppendingPathComponent:@"data.archiver"];
    return path;
}

@end
