//
//  IftttJotController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/17.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "IftttJotController.h"

@import AssetsLibrary;
#import "Masonry.h"
#import "jot.h"

@interface IftttJotController () <JotViewControllerDelegate>

@property (nonatomic, strong) JotViewController *jotViewController;
@property (nonatomic, weak) IBOutlet UIButton *clearButton;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@property (nonatomic, weak) IBOutlet UIButton *toggleDrawingButton;

@end

@implementation IftttJotController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.jotViewController.state == JotViewStateText)
    {
        self.jotViewController.state = JotViewStateEditingText;
    }
}

- (void)initializeBaseData
{
    
}

- (void)initializeUIComponents
{
    _jotViewController = [JotViewController new];
    self.jotViewController.delegate = self;
    self.jotViewController.state = JotViewStateDrawing;
    self.jotViewController.textColor = [UIColor blackColor];
    self.jotViewController.font = [UIFont boldSystemFontOfSize:64.f];
    self.jotViewController.fontSize = 64.f;
    self.jotViewController.textEditingInsets = UIEdgeInsetsMake(12.f, 6.f, 0.f, 6.f);
    self.jotViewController.initialTextInsets = UIEdgeInsetsMake(6.f, 6.f, 6.f, 6.f);
    self.jotViewController.fitOriginalFontSizeToViewWidth = YES;
    self.jotViewController.textAlignment = NSTextAlignmentLeft;
    self.jotViewController.drawingColor = [UIColor cyanColor];
    
    
    self.jotViewController.view.frame = CGRectMake(0.f, 64.f, kDeviceWidth, kDeviceHeight - 130.f);
    [self.view addSubview:self.jotViewController.view];
}


#pragma mark - Actions

- (IBAction)clearButtonAction:(UIButton *)sender
{
    [self.jotViewController clearAll];
}

- (IBAction)saveButtonAction:(UIButton *)sender
{
    UIImage *drawnImage = [self.jotViewController renderImageWithScale:2.f
                                                               onColor:self.view.backgroundColor];
    
    [self.jotViewController clearAll];
    
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    [library writeImageToSavedPhotosAlbum:[drawnImage CGImage] orientation:(ALAssetOrientation)[drawnImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        if (error)
        {
            NSLog(@"Error saving photo: %@", error.localizedDescription);
        }
        else
        {
            NSLog(@"Saved photo to saved photos album.");
        }
    }];
}

- (IBAction)toggleDrawingButtonAction:(UIButton *)sender
{
    if (self.jotViewController.state == JotViewStateDrawing)
    {
        [self.toggleDrawingButton setTitle:@"Pen" forState:UIControlStateNormal];
        
        if (self.jotViewController.textString.length == 0)
        {
            self.jotViewController.state = JotViewStateEditingText;
        }
        else
        {
            self.jotViewController.state = JotViewStateText;
        }
        
    }
    else if (self.jotViewController.state == JotViewStateText)
    {
        self.jotViewController.state = JotViewStateDrawing;
        self.jotViewController.drawingColor = [UIColor colorWithRed:((double)arc4random()/UINT32_MAX) green:((double)arc4random()/UINT32_MAX) blue:((double)arc4random()/UINT32_MAX) alpha:1.0];
        [self.toggleDrawingButton setTitle:@"Txt" forState:UIControlStateNormal];
    }
}

#pragma mark - JotViewControllerDelegate

- (void)jotViewController:(JotViewController *)jotViewController isEditingText:(BOOL)isEditing
{
    self.clearButton.hidden = isEditing;
    self.saveButton.hidden = isEditing;
    self.toggleDrawingButton.hidden = isEditing;
}


@end
