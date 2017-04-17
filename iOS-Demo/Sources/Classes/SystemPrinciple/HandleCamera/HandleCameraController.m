//
//  HandleCameraController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/17.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "HandleCameraController.h"

#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>

@interface HandleCameraController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic, strong)AVCaptureDevice *device;
@property(nonatomic, strong)AVCaptureDeviceInput *input;
@property(nonatomic, strong)AVCaptureMetadataOutput *output;
@property(nonatomic, strong)AVCaptureStillImageOutput *imageOutput;
@property (nonatomic, strong)AVCaptureVideoDataOutput *videoDataOutput;
@property(nonatomic, strong)AVCaptureSession *session;

@property(nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic, strong)UIImageView *capturedImageView;

@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;

@end

@implementation HandleCameraController
{
    GLKView *_glkView;
    CIContext *_cicontext;
    
    CIFilter *_filter;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)initializeBaseData
{
    
}

- (void)initializeUIComponents
{
    if ([self canUseCamera])
    {
        [self setupCamera];
        [self setupUIComponents];
    }
}

- (void)setupCamera
{
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _input = [[AVCaptureDeviceInput alloc] initWithDevice:_device error:nil];
    _output = [AVCaptureMetadataOutput new];
    _imageOutput = [AVCaptureStillImageOutput new];
    
    _videoDataOutput = [AVCaptureVideoDataOutput new];
    [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    [_videoDataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];

    
    _session = [AVCaptureSession new];
    if ([_session canSetSessionPreset:AVCaptureSessionPreset1280x720])
    {
        _session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    if ([_session canAddInput:_input])
    {
        [_session addInput:_input];
    }
    
    if ([_session canAddOutput:_imageOutput])
    {
        [_session addOutput:_imageOutput];
    }
    
    if ([_session canAddOutput:_videoDataOutput])
    {
        [_session addOutput:_videoDataOutput];
    }
    
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer.frame = CGRectMake(0.f, 0.f, kDeviceWidth, kDeviceHeight);
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:_previewLayer];
    
    
    // 至此，摄像头已经可以捕获，并生成预览，至于预览上的 UI 可以根据需要进行定制
    [_session startRunning];
    
    
    if ([_device lockForConfiguration:nil])
    {
        //自动闪光灯
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto])
        {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance])
        {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        
        //自动对焦
        if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
        {
            [_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        
        //自动曝光
        if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
        {
            [_device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }
        
        [_device unlockForConfiguration];
    }
}

- (void)setupUIComponents
{
    EAGLContext *context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _glkView = [[GLKView alloc]initWithFrame:CGRectMake(0.f, 36.f, 200.f, 316.f) context:context];
    [EAGLContext setCurrentContext:context];
    _glkView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_glkView];
    
    _cicontext = [CIContext contextWithEAGLContext:context];
    
    _filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    
    [self.view bringSubviewToFront:_glkView];
}

#pragma mark -- AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    if (_glkView.context != [EAGLContext currentContext])
    {
        [EAGLContext setCurrentContext:_glkView.context];
    }
    
    CVImageBufferRef imageRef = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *image = [CIImage imageWithCVImageBuffer:imageRef];
    
    
    [_filter setValue:image forKey:kCIInputImageKey];
    [_filter setValue:[CIColor colorWithRed:1.f green:0.7262f blue:0.1014f alpha:1.f] forKey:kCIInputColorKey];
    [_filter setValue:@0.5f forKey:kCIInputIntensityKey];
    
    
    [_glkView bindDrawable];
    [_cicontext drawImage:_filter.outputImage inRect:_filter.outputImage.extent fromRect:_filter.outputImage.extent];
    [_glkView display];
}

//
// 视频录制可以使用下面注释的这些代码
//
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
//{
//    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
//    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
//    _previewImageView.image = image;
//}
//
///**
// * 将CMSampleBufferRef转UIImage
// */
//- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
//{
//    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    // 锁定pixel buffer的基地址
//    CVPixelBufferLockBaseAddress(imageBuffer, 0);
//    // 得到pixel buffer的基地址
//    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
//    // 得到pixel buffer的行字节数
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//    // 得到pixel buffer的宽和高
//    size_t width = CVPixelBufferGetWidth(imageBuffer);
//    size_t height = CVPixelBufferGetHeight(imageBuffer);
//    // 创建一个依赖于设备的RGB颜色空间
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
//    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    // 根据这个位图context中的像素数据创建一个Quartz image对象
//    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
//    // 解锁pixel buffer
//    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
//    // 释放context和颜色空间
//    CGContextRelease(context); CGColorSpaceRelease(colorSpace);
//    // 用Quartz image创建一个UIImage对象image
//    UIImage *image = [UIImage imageWithCGImage:quartzImage];
//    // 释放Quartz image对象
//    CGImageRelease(quartzImage);
//    
//    return (image);
//}
//

/**
 * 获取摄像头权限
 */
- (BOOL)canUseCamera
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusDenied)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        
        return NO;
    }
    else
    {
        return YES;
    }
}



- (void)dealloc
{
    [_session stopRunning];
}

@end
