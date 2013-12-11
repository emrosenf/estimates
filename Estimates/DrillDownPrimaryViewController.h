//
//  DrillDownPrimaryViewController.h
//  Estimates
//
//  Created by Evan Rosenfeld on 12/10/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstimateInputMethod.h"

@interface DrillDownPrimaryViewController : UITableViewController<EstimateInputMethod>

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, weak) CustomerTableViewController *delegate;

- (void) addItem:(NSDictionary *)item;

@end
