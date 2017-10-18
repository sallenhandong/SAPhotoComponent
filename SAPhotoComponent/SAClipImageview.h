//
//  SAClipImageview.h
//  mokaProject
//
//  Created by xiexing on 2017/9/13.
//  Copyright © 2017年 xiexing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAClipImageview : UIScrollView
@property (nonatomic,strong) UIImage *contentImage;
/**
 *  图片裁剪初始化
 *
 *  @param cropImage 需要裁剪的图片
 *  @param cropSize  裁剪框的size 目前裁剪框的宽度为屏幕宽度
 *
 *  @return return value description
 */
- (id)initWithCropImage:(UIImage*)cropImage cropSize:(CGSize)cropSize;

- (UIImage*)getCroppedImage;//获取裁剪后的图片

- (void)refreshImage:(UIImage*)cropImage;

- (void) actionRotate;//旋转

- (id)init __deprecated_msg("Use `- (id)initWithCropImage:(UIImage*)cropImage cropSize:(CGSize)cropSize`");
- (id)initWithFrame:(CGRect)frame __deprecated_msg("Use `- (id)initWithCropImage:(UIImage*)cropImage cropSize:(CGSize)cropSize`");
@end
