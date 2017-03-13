//
//  UIImage+Extend.m
//  CDHN
//
//  Created by muxi on 14-10-14.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import "UIImage+Extend.h"
//#import "CoreConst.h"
#import <objc/runtime.h>
#import <Accelerate/Accelerate.h>


static const void *CompleteBlockKey = &CompleteBlockKey;
static const void *FailBlockKey = &FailBlockKey;

@interface UIImage ()

@property (nonatomic,copy)  void(^CompleteBlock)();

@property (nonatomic,copy)  void(^FailBlock)();

@end


@implementation UIImage (Extend)

/**
 *  拉伸图片:自定义比例 
 */
- (UIImage *)resizeWithleftCap:(CGFloat)leftCap topCap:(CGFloat)topCap
{
    return [self stretchableImageWithLeftCapWidth:self.size.width * leftCap topCapHeight:self.size.height * topCap];
}

/**
 *   拉伸图片
 */
- (UIImage *)resizeImage
{
    return [self resizeWithleftCap:.5f topCap:.5f];
}




/**
 *  保存相册
 *
 *  @param completeBlock 成功回调
 *  @param completeBlock 出错回调
 */
-(void)savedPhotosAlbum:(void(^)())completeBlock failBlock:(void(^)())failBlock
{
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:),NULL);
    self.CompleteBlock = completeBlock;
    self.FailBlock = failBlock;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if(error == nil){
        if(self.CompleteBlock != nil) self.CompleteBlock();
    }else{
        if(self.FailBlock !=nil) self.FailBlock();
    }

}

//模拟成员变量
-(void (^)())FailBlock
{
    return objc_getAssociatedObject(self, FailBlockKey);
}
-(void)setFailBlock:(void (^)())FailBlock
{
    objc_setAssociatedObject(self, FailBlockKey, FailBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void (^)())CompleteBlock
{
    return objc_getAssociatedObject(self, CompleteBlockKey);
}

-(void)setCompleteBlock:(void (^)())CompleteBlock
{
    objc_setAssociatedObject(self, CompleteBlockKey, CompleteBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/**
 *  压缩图片
 */
- (UIImage*)scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//拉伸图片
+(UIImage*)resizableImageNamed:(NSString*)imageName
{
    UIImage *tmpImg = [UIImage imageNamed:imageName];
    CGFloat imgWidth = tmpImg.size.width;
    CGFloat imgHeight = tmpImg.size.height;
    return [tmpImg resizableImageWithCapInsets:UIEdgeInsetsMake(imgHeight/2, imgWidth/2, imgHeight/2, imgWidth/2) resizingMode:UIImageResizingModeStretch];
}


//生成缩略图
- (UIImage *)convertToThumbnailWithSize:(CGSize)thumbnailSize
{
    CGSize originSize = self.size;
    CGRect newRect = CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height);
    float ratio = MAX(newRect.size.width / originSize.width, newRect.size.height / originSize.height);
    
    CGRect projectRect;
    projectRect.size.width = ratio * originSize.width;
    projectRect.size.height = ratio * originSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:0];
    [path addClip];
    [self drawInRect:projectRect];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
}

- (UIImage *)getGaussBlurImageWithRadius:(CGFloat)radius
{
    if (radius <= 0)
    {
        return self;
    }
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@(radius) forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:[image extent]];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    
    return blurImage;
}

-(UIImage*)imageWithMaxWidth:(CGFloat)width
{
    CGFloat oldWidth = self.size.width;
    CGFloat oldHeight = self.size.height;
    CGFloat newWidth =  MIN(width, oldWidth);
    
    CGFloat newHeight = oldHeight *  newWidth/ oldWidth ;
    return [self scaledToSize:CGSizeMake(newWidth, newHeight)];
}

@end
