//
//  CustomCameraController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/17.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "CustomCameraController.h"

#import <AVFoundation/AVFoundation.h>

@interface CustomCameraController ()

@property(nonatomic, strong)AVCaptureDevice *device;
@property(nonatomic, strong)AVCaptureDeviceInput *input;
@property(nonatomic, strong)AVCaptureMetadataOutput *output;
@property(nonatomic, strong)AVCaptureStillImageOutput *imageOutput;
@property(nonatomic, strong)AVCaptureSession *session;

@property(nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic, strong)UIImageView *capturedImageView;


@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *switchCameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *photographBtn;
@property (weak, nonatomic) IBOutlet UIButton *switchFlashBtn;

@property (nonatomic, strong)UIView *focusView;

@end

@implementation CustomCameraController

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
    [self.view bringSubviewToFront:_backBtn];
    [self.view bringSubviewToFront:_switchCameraBtn];
    [self.view bringSubviewToFront:_photographBtn];
    [self.view bringSubviewToFront:_switchFlashBtn];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, 30.f, 30.f)];
    _focusView.backgroundColor = [UIColor clearColor];
    _focusView.layer.borderWidth = 1.f;
    _focusView.layer.borderColor = [UIColor whiteColor].CGColor;
    _focusView.hidden = YES;
    [self.view addSubview:_focusView];
}

- (void)focusGesture:(UITapGestureRecognizer*)gesture
{
    CGSize size = self.view.bounds.size;
    CGPoint point = [gesture locationInView:gesture.view];
    CGPoint focusPoint = CGPointMake(point.y / size.height ,1.f - point.x / size.width);
    
    NSError *error = nil;
    if ([_device lockForConfiguration:&error])
    {
        if ([_device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
        {
            [_device setFocusPointOfInterest:focusPoint];
            [_device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([_device isExposureModeSupported:AVCaptureExposureModeAutoExpose ])
        {
            [_device setExposurePointOfInterest:focusPoint];
            [_device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [_device unlockForConfiguration];
        
        _focusView.hidden = NO;
        _focusView.center = point;
        
        [UIView animateWithDuration:0.22f animations:^{
            _focusView.transform = CGAffineTransformMakeScale(2.5f, 2.5f);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.33f animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
}


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


/**
 * 切换前/后摄像头
 */
- (IBAction)switchCaermaAction:(UIButton *)sender
{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    
    if (cameraCount > 1)
    {
        NSError *error;
        
        CATransition *animation = [CATransition animation];
        animation.duration = .5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"oglFlip";
        
        
        
        AVCaptureDevice *newCamera = nil;
        AVCaptureDevicePosition position = [[_input device] position];
        
        if (position == AVCaptureDevicePositionFront)
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
        }
        else
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }
        
        
        AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [_previewLayer addAnimation:animation forKey:nil];
        
        if (newInput)
        {
            [_session beginConfiguration];
            [_session removeInput:_input];
            
            if ([_session canAddInput:newInput])
            {
                [_session addInput:newInput];
                _input = newInput;
                
            }
            else
            {
                [_session addInput:_input];
            }
            
            [_session commitConfiguration];
        }
        else if (error)
        {
            NSLog(@"swtich carema failed, error = %@", error);
        }
        
    }
}


/**
 * 拍照
 */
- (IBAction)photographAction:(UIButton *)sender
{
    AVCaptureConnection * captureConnection = [_imageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (!captureConnection)
    {
        NSLog(@"photograph failed!");
        return ;
    }
    
    [_imageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        [_session stopRunning];
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);

        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCapturedImageView)];
        
        _capturedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, kDeviceWidth, kDeviceHeight)];
        _capturedImageView.layer.masksToBounds = YES;
        _capturedImageView.image = image;
        _capturedImageView.userInteractionEnabled = YES;
        _capturedImageView.contentMode = UIViewContentModeScaleToFill;
        [_capturedImageView addGestureRecognizer:tapGesture];
        [self.view insertSubview:_capturedImageView aboveSubview:_switchFlashBtn];
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)removeCapturedImageView
{
    [_capturedImageView removeFromSuperview];
    [_session startRunning];
}



/**
 * 打开/关闭闪光灯
 */
- (IBAction)switchFlashAction:(UIButton *)sender
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    
    if (captureDeviceClass)
    {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash])
        {
            [device lockForConfiguration:nil];
            
            if (sender.tag == 0)
            {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                sender.tag = 1;
            }
            else
            {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                sender.tag = 0;
            }
            [device unlockForConfiguration];
        }
    }
}


- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
    {
        if ( device.position == position )
        {
            return device;
        }
    }
    
    return nil;
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}





- (void)dealloc
{
    [_session stopRunning];
}

@end
