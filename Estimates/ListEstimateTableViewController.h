//
//  EstimateTableViewController.h
//  Estimates
//
//  Created by Evan Rosenfeld on 12/3/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerTableViewController.h"
#import "EstimateInputMethod.h"

@interface ListEstimateTableViewController : UITableViewController<EstimateInputMethod>

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, weak) CustomerTableViewController *delegate;

- (void) addLineItem:(NSDictionary *)lineItem;
@end
