//
//  UIImage+SAExtension.h
//  mokaProject
//
//  Created by xiexing on 2017/9/13.
//  Copyright © 2017年 xiexing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SAExtension)
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;
- (UIImage*)resizedImageToSize:(CGSize)dstSize;
- (UIImage *)cropImage:(CGRect) rect;
- (UIImage *)fixOrientation;

//按比例缩放,size 是你要把图显示到 多大区域 CGSizeMake(300, 140)
-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

//指定宽度按比例缩放
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
@end
