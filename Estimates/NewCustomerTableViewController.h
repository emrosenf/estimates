//
//  NewCustomerTableViewController.h
//  Estimates
//
//  Created by Evan Rosenfeld on 12/3/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomersListViewController.h"

@interface NewCustomerTableViewController : UITableViewController

@property (nonatomic, weak) CustomersListViewController *delegate;

@end
