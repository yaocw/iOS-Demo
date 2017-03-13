//
//  BEMSimpleLineGraphController.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/9.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"
#import "StatsViewController.h"

@interface BEMSimpleLineGraphController : UIViewController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph;

@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;

@property (strong, nonatomic) IBOutlet UILabel *labelValues;
@property (strong, nonatomic) IBOutlet UILabel *labelDates;

@property (weak, nonatomic) IBOutlet UISegmentedControl *graphColorChoice;
@property (strong, nonatomic) IBOutlet UISegmentedControl *curveChoice;
@property (weak, nonatomic) IBOutlet UIStepper *graphObjectIncrement;

- (IBAction)refresh:(id)sender;
- (IBAction)addOrRemovePointFromGraph:(id)sender;

- (IBAction)displayStatistics:(id)sender;

@end
