//
//  EstimateViewSelectionController.h
//  Estimates
//
//  Created by Evan Rosenfeld on 12/10/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerTableViewController.h"

@interface EstimateViewSelectionController : UITableViewController

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, weak) CustomerTableViewController *delegate;

@end
