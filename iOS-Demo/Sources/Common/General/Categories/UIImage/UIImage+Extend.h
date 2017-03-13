//
//  UIImage+Extend.h
//  CDHN
//
//  Created by muxi on 14-10-14.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)

/**
 *  拉伸图片:自定义比例
 */
- (UIImage *)resizeWithleftCap:(CGFloat)leftCap topCap:(CGFloat)topCap;


/**
 *  拉伸图片
 */
- (UIImage *)resizeImage;



/**
 *  保存相册
 *
 *  @param completeBlock 成功回调
 *  @param completeBlock 出错回调
 */
-(void)savedPhotosAlbum:(void(^)())completeBlock failBlock:(void(^)())failBlock;


/**
 *  改变图片为指定的size
 *
 *  @param newSize 指定大小
 *
 *  @return 新图片
 */
- (UIImage*)scaledToSize:(CGSize)newSize;


/**
 *  拉伸图片
 *
 *  @param imageName 要拉伸的图片
 *
 *  @return 拉伸后的图片
 */
+(UIImage*)resizableImageNamed:(NSString*)imageName;


/**
 *  将当前图片转换成指定大小的缩略图
 *
 *  @param thumbnailSize 缩略图大小
 *
 *  @return 缩略图
 */
- (UIImage *)convertToThumbnailWithSize:(CGSize)thumbnailSize;


/**
 *  获取高斯模糊照片
 */
- (UIImage *)getGaussBlurImageWithRadius:(CGFloat)radius;

/**
 *  压缩为固定宽度的图片
 *
 *  @param width 宽度
 *
 *  @return 压缩图
 */
-(UIImage*)imageWithMaxWidth:(CGFloat)width;

@end
