//
//  VoiceEstimateViewController.h
//  Estimates
//
//  Created by Evan Rosenfeld on 12/11/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstimateInputMethod.h"

@interface VoiceEstimateViewController : UITableViewController<EstimateInputMethod>

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, weak) CustomerTableViewController *delegate;

@end
