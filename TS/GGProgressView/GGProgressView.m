//
//  GGProgressView.m
//
//  Created by GG on 2016/10/20.
//  Copyright © 2016年 GG. All rights reserved.
//

#import "GGProgressView.h"
@interface GGProgressView()
{
    UIView *_progressView;
    float _progress;
    CGFloat _currentPro;
    UIView *_currentProView;
}

@end

@implementation GGProgressView

-(instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame progressViewStyle:GGProgressViewStyleDefault];
}

- (instancetype)initWithFrame:(CGRect)frame progressViewStyle:(GGProgressViewStyle)style
{
    if (self=[super initWithFrame:frame]) {
        _progressView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        _progress=0;
        self.progressViewStyle=style;
        [self addSubview:_progressView];
        _currentProView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        _currentPro=0;
        _currentProView.backgroundColor = [UIColor greenColor];
        [self addSubview:_currentProView];
    }
    return self;
}

- (void)layoutSubviews
{
    _progressView.frame = CGRectMake(0, 0, self.bounds.size.width*_progress, self.bounds.size.height);
    _currentProView.frame = CGRectMake(0, 0, self.bounds.size.width*_currentPro, self.bounds.size.height);
}

-(void)setProgressViewStyle:(GGProgressViewStyle)progressViewStyle
{
    _progressViewStyle=progressViewStyle;
    if (progressViewStyle==GGProgressViewStyleTrackFillet) {
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=self.bounds.size.height/2;
    }
    else if (progressViewStyle==GGProgressViewStyleAllFillet)
    {
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=self.bounds.size.height/2;
        _progressView.layer.cornerRadius=self.bounds.size.height/2;
    }
}

-(void)setTrackTintColor:(UIColor *)trackTintColor
{
    _trackTintColor=trackTintColor;
    if (self.trackImage) {
        
    }
    else
    {
        self.backgroundColor=trackTintColor;
    }
}
-(void)setProgress:(float)progress
{
    _progress=MIN(progress, 1);
    _progressView.frame=CGRectMake(0, 0, self.bounds.size.width*_progress, self.bounds.size.height);
}
- (void)setCurrentProgress:(CGFloat)currentProgress
{
    _currentPro = MIN(currentProgress, 1);
    _currentProView.frame = CGRectMake(0, 0, self.bounds.size.width*_currentPro, self.bounds.size.height);
}
-(float)progress
{
    return _progress;
}
-(void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor=progressTintColor;
    _progressView.backgroundColor=progressTintColor;
}
-(void)setTrackImage:(UIImage *)trackImage
{
    _trackImage=trackImage;
    if(self.isTile)
    {
        self.backgroundColor=[UIColor colorWithPatternImage:trackImage];
    }
    else
    {
        self.backgroundColor=[UIColor colorWithPatternImage:[self stretchableWithImage:trackImage]];
    }
}
-(void)setIsTile:(BOOL)isTile
{
    _isTile = isTile;
    if (self.progressImage) {
        [self setProgressImage:self.progressImage];
    }
    if (self.trackImage) {
        [self setTrackImage:self.trackImage];
    }
}
-(void)setProgressImage:(UIImage *)progressImage
{
    _progressImage = progressImage;
    if(self.isTile)
    {
        _progressView.backgroundColor=[UIColor colorWithPatternImage:progressImage];
    }
    else
    {
        _progressView.backgroundColor=[UIColor colorWithPatternImage:[self stretchableWithImage:progressImage]];
    }
}
- (UIImage *)stretchableWithImage:(UIImage *)image{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.f);
    [image drawInRect:self.bounds];
    UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return lastImage;
}
@end
