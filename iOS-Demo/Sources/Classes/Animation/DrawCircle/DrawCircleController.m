//
//  DrawCircleController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/27.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "DrawCircleController.h"
#import "Helper.h"

#define AngleToRadian(angle) (M_PI/180.0f)*angle

#define mCenterPoint CGPointMake(_mainView.bounds.size.width / 2.0f, _mainView.bounds.size.height / 2.0f)
#define mRadius 100.0f

@interface DrawCircleController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation DrawCircleController
{
    UILabel *_progressLabel;
    UIImageView *_imageView;
    
    NSTimer *_timer;
    CGFloat _currentAngle;
    CAShapeLayer *_mainLayer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self lanchAnimationWithSegmentedIndex:0];
}


/**
 * 简单的方法（无锯齿）
 **/
- (void)drawCircle
{
    switch (_segmentedControl.selectedSegmentIndex)
    {
        case 0:
        {
            
            _currentAngle += (M_PI / 180.0f);
            _progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(_currentAngle * (100.0f / (2 * M_PI)))];
            
            if (_currentAngle >  (2 * M_PI))
            {
                [_timer invalidate];
                return;
            }
            
            UIBezierPath *arcPath = [UIBezierPath new];
            [arcPath addArcWithCenter:mCenterPoint radius:mRadius startAngle:0 endAngle:_currentAngle clockwise:YES];
            
            
            CGPoint circlePoint;
            if ((_currentAngle + (M_PI / 2.0f)) > 2 * M_PI)
            {
                circlePoint = [self getCirclePointWithAngle:_currentAngle - (1.5f * M_PI)];
            }
            else
            {
                circlePoint = [self getCirclePointWithAngle:_currentAngle + (M_PI / 2.0f)];
            }
            
            [arcPath addArcWithCenter:circlePoint radius:5.0f startAngle:0 endAngle:2 * M_PI clockwise:YES];
            
            
            _mainLayer.path = arcPath.CGPath;
            
            break;
        }
            
        case 1:
        {
            _currentAngle += (M_PI / 180.0f);
            _progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(_currentAngle * (100.0f / (2 * M_PI)))];
            
            if (_currentAngle >  (2 * M_PI))
            {
                [_timer invalidate];
                return;
            }
            
            
            UIGraphicsBeginImageContext(_imageView.bounds.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineWidth(context, 5.0f);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
            CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
            
            
            CGPoint circlePoint;
            if ((_currentAngle + (M_PI / 2.0f)) > 2 * M_PI)
            {
                circlePoint = [self getCirclePointWithAngle:_currentAngle - (1.5f * M_PI)];
            }
            else
            {
                circlePoint = [self getCirclePointWithAngle:_currentAngle + (M_PI / 2.0f)];
            }
            
            
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);
            CGMutablePathRef littleCirclePath = CGPathCreateMutable();
            CGPathMoveToPoint(littleCirclePath, &transform, circlePoint.x, circlePoint.y);
            CGPathAddArc(littleCirclePath, &transform, circlePoint.x, circlePoint.y, 8.0f, 0, 2 * M_PI, 0);
            CGContextAddPath(context, littleCirclePath);
            
            CGContextFillPath(context);
            
            
            UIBezierPath *arcPath = [UIBezierPath new];
            [arcPath addArcWithCenter:mCenterPoint radius:mRadius startAngle:0 endAngle:_currentAngle clockwise:YES];
            
            CGContextAddPath(context, arcPath.CGPath);
            
            CGContextStrokePath(context);
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            _imageView.image = image;

            
            break;
        }
         
        case 2:
        {
            _currentAngle += (M_PI / 180.0f);
            _progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(_currentAngle * (100.0f / (2 * M_PI)))];
            
            if (_currentAngle >  (2 * M_PI))
            {
                [_timer invalidate];
                return;
            }
            
            
            UIGraphicsBeginImageContext(_imageView.bounds.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineWidth(context, 5.0f);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
            CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
            
            
            CGPoint circlePoint;
            if ((_currentAngle + (M_PI / 2.0f)) > 2 * M_PI)
            {
                circlePoint = [self getCirclePointWithAngle:_currentAngle - (1.5f * M_PI)];
            }
            else
            {
                circlePoint = [self getCirclePointWithAngle:_currentAngle + (M_PI / 2.0f)];
            }
            
            
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);
            CGMutablePathRef littleCirclePath = CGPathCreateMutable();
            CGPathMoveToPoint(littleCirclePath, &transform, circlePoint.x, circlePoint.y);
            CGPathAddArc(littleCirclePath, &transform, circlePoint.x, circlePoint.y, 8.0f, 0, 2 * M_PI, 0);
            CGContextAddPath(context, littleCirclePath);
            
            CGContextFillPath(context);
            
            
            
            CGMutablePathRef bigCirclePath = CGPathCreateMutable();
            CGPathAddArc(bigCirclePath, &transform, mCenterPoint.x, mCenterPoint.y, mRadius, 0, _currentAngle, 0);
            CGContextAddPath(context, bigCirclePath);
            
            CGContextStrokePath(context);
            
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            _imageView.image = image;
            
            break;
        }
            
        default:
            break;
    }
    
    
}



-(CGPoint)getCirclePointWithAngle:(CGFloat)angle
{
    float radius = mRadius;
    int index = (angle)/M_PI_2;
    float needAngle = angle - index * M_PI_2;
    float x = 0,y = 0;
    switch (index) {
        case 0:
            x = radius + sinf(needAngle)*radius;
            y = radius - cosf(needAngle)*radius;
            break;
        case 1:
            x = radius + cosf(needAngle)*radius;
            y = radius + sinf(needAngle)*radius;
            break;
        case 2:
            x = radius - sinf(needAngle)*radius;
            y = radius + cosf(needAngle)*radius;
            break;
        case 3:
            x = radius - cosf(needAngle)*radius;
            y = radius - sinf(needAngle)*radius;
            break;
            
        default:
            break;
    }
    
    return CGPointMake(mCenterPoint.x - mRadius + x, mCenterPoint.y - mRadius + y);
}



#pragma mark -- Actions

- (IBAction)valueDidChange:(UISegmentedControl *)sender
{
    [self lanchAnimationWithSegmentedIndex:sender.selectedSegmentIndex];
}

- (void)lanchAnimationWithSegmentedIndex:(NSInteger)index
{
    [self resetAnimationConfigure];
    
    switch (index)
    {
        case 0:
        {
            _mainLayer = [CAShapeLayer layer];
            _mainLayer.frame = _mainView.bounds;
            _mainLayer.strokeColor = [UIColor blueColor].CGColor;
            _mainLayer.lineWidth = 5.0f;
            _mainLayer.lineCap = @"round";
            _mainLayer.lineJoin = @"round";
            _mainLayer.fillColor = [UIColor clearColor].CGColor;
            [_mainView.layer addSublayer:_mainLayer];
            
            
            
            _progressLabel = [UILabel new];
            _progressLabel.text = @"0%";
            _progressLabel.textAlignment = NSTextAlignmentCenter;
            _progressLabel.textColor = [UIColor blueColor];
            _progressLabel.font = [UIFont systemFontOfSize:20.0f];
            _progressLabel.layer.frame = _mainView.bounds;
            [_mainLayer addSublayer:_progressLabel.layer];
            
            
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(drawCircle) userInfo:nil repeats:YES];
            
            break;
        }
            
        case 1:
        {
            _imageView = [UIImageView new];
            _imageView.frame = _mainView.bounds;
            [_mainView addSubview:_imageView];
            
            
            _progressLabel = [UILabel new];
            _progressLabel.text = @"0%";
            _progressLabel.textAlignment = NSTextAlignmentCenter;
            _progressLabel.textColor = [UIColor blueColor];
            _progressLabel.font = [UIFont systemFontOfSize:20.0f];
            _progressLabel.bounds = CGRectMake(0, 0, 66.0f, 36.0f);
            _progressLabel.center = mCenterPoint;
            [_mainView addSubview:_progressLabel];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(drawCircle) userInfo:nil repeats:YES];

            break;
        }
            
        case 2:
        {
            _imageView = [UIImageView new];
            _imageView.frame = _mainView.bounds;
            [_mainView addSubview:_imageView];
            
            
            _progressLabel = [UILabel new];
            _progressLabel.text = @"0%";
            _progressLabel.textAlignment = NSTextAlignmentCenter;
            _progressLabel.textColor = [UIColor blueColor];
            _progressLabel.font = [UIFont systemFontOfSize:20.0f];
            _progressLabel.bounds = CGRectMake(0, 0, 66.0f, 36.0f);
            _progressLabel.center = mCenterPoint;
            [_mainView addSubview:_progressLabel];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(drawCircle) userInfo:nil repeats:YES];
            
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)refreshAction:(id)sender
{
    [self lanchAnimationWithSegmentedIndex:_segmentedControl.selectedSegmentIndex];
}

- (void)resetAnimationConfigure
{
    [_imageView removeFromSuperview];
    _imageView = nil;
    
    [_progressLabel removeFromSuperview];
    [_timer invalidate];
    
    [_mainLayer removeFromSuperlayer];
    _mainLayer = nil;
    
    _currentAngle = 0.0f;
}

@end
