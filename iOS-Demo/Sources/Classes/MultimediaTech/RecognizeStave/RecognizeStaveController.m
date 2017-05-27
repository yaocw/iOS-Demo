//
//  RecognizeStaveController.m
//  iOS-Demo
//
//  Created by yaochaowen on 2017/5/27.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "RecognizeStaveController.h"
#import "StaveView.h"

@interface RecognizeStaveController ()

@property (weak, nonatomic) IBOutlet StaveView *staveView;
@property (weak, nonatomic) IBOutlet UILabel *noteLevelLabel;

@end

@implementation RecognizeStaveController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeUIComponents];
}

- (void)initializeUIComponents
{
    [self nextNoteAction:nil];
}

- (IBAction)nextNoteAction:(id)sender
{
    NSInteger noteLevel = kGetRandomIntWithLimit(0, 29);
    NSString *noteLevelText;
    
    switch (noteLevel % 7) {
        case 0:
        {
            noteLevelText = @"Si";
            break;
        }
            
        case 1:
        {
            noteLevelText = @"Do";
            break;
        }
            
        case 2:
        {
            noteLevelText = @"Re";
            break;
        }
            
        case 3:
        {
            noteLevelText = @"Mi";
            break;
        }
            
        case 4:
        {
            noteLevelText = @"Fa";
            break;
        }
            
        case 5:
        {
            noteLevelText = @"Sol";
            break;
        }
            
        case 6:
        {
            noteLevelText = @"La";
            break;
        }
        default:
            break;
    }
    _noteLevelLabel.text = noteLevelText;
    
    
    _staveView.noteLevel = noteLevel;
    [_staveView setNeedsDisplay];
}

@end
